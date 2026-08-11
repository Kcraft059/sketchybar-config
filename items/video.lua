local mod = {}

function mod.setup(items, icons, palette) 
	mod.properties = {
		updates = true,	

		position = "right",
		padding_right = 0,

		icon = {
			string = icons.camera.inactive,
			padding_right = items.config.padding.outer - 2,
			color = palette.colors.red,
		},

		label = { drawing = false },
	}
	mod.icon = { 
		active = { string = icons.camera.active, color = palette.colors.cyan }, 
		inactive = { string = icons.camera.inactive, color = palette.colors.red }, 
	}
	mod.event = "camera_update"

	return mod
end

local function loadStream(event_name) 
	sbar.exec([[
    #SKETCHYBAR_CAMERA_STREAM#

    lastpid=$(cat ${TMPDIR}/sketchybar/camera_pids 2> /dev/null || echo 0);

    if ps -p $lastpid -o command= | grep '#SKETCHYBAR_CAMERA_STREAM#' > /dev/null; then 
      kill -9 $(pgrep -P $lastpid) $lastpid
    fi;
    
    mkdir -p ${TMPDIR}/sketchybar;
    echo $$ > ${TMPDIR}/sketchybar/camera_pids;

		/usr/bin/log stream --predicate '(eventMessage CONTAINS "AVCaptureSessionDidStartRunningNotification" || eventMessage CONTAINS "AVCaptureSessionDidStopRunningNotification")' | \
		while IFS= read -r line; do
			line=$(echo $line | sed "/^Filtering the log data/d")
			if echo $line | grep "AVCaptureSessionDidStartRunningNotification" >/dev/null; then
				sketchybar --trigger ]] .. event_name .. [[ "INFO=true"
			elif echo $line | grep "AVCaptureSessionDidStopRunningNotification" >/dev/null; then
				sketchybar --trigger ]] .. event_name .. [[ "INFO=false"
			fi
		done
	]], function (result,exit_code) 
		log("camera-stream","Exited with code: " .. exit_code)
	end)
end

local function updateState(state) 
	-- log("camera", state and "on" or "off")
  sequencedAnimation(mod.item, "tanh", 25, nil, { icon = state and mod.icon.active or mod.icon.inactive }, nil, true)
end

function mod.load()
	loadStream(mod.event)

	mod.item = sbar.add("item", mod.properties)
	mod.item:subscribe(mod.event, function (env) 
		updateState(env.INFO == "true")
	end)

	mod.item:subscribe("mouse.clicked", function (env) 
		sbar.exec(execs.menubar .. " item select " .. menu_items.video.app .. " " .. menu_items.video.id)
	end)

	return mod
end

return mod

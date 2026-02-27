-- Proof of concept
local event = sbar.add("event", "media-update")
local item = sbar.add("item", {position = "right"})

item:subscribe("media-update", function (env) 
  print(env.INFO, dump(env.INFO))
end)

-- spawn process
sbar.exec([[
#SKETCHYBAR_MEDIA_STREAM#

lastpid=$(cat ${TMPDIR}/sketchybar/pids 2> /dev/null || echo 0);

if ps -p $lastpid -o command= | grep '#SKETCHYBAR_MEDIA_STREAM#' > /dev/null; then 
  kill -9 $(pgrep -P $lastpid) $lastpid
fi;

mkdir -p ${TMPDIR}/sketchybar;
echo $$ > ${TMPDIR}/sketchybar/pids;

]] .. execs.media_control .. [[ stream | \
while IFS= read -r line; do 
  sketchybar --trigger media-update "INFO=$line"
done]])
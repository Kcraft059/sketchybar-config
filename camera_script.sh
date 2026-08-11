/usr/bin/log stream --predicate '(eventMessage CONTAINS "AVCaptureSessionDidStartRunningNotification" || eventMessage CONTAINS "AVCaptureSessionDidStopRunningNotification")' | \
while IFS= read -r line; do
	line=$(echo $line | sed "/^Filtering the log data/d")
	if echo $line | grep "AVCaptureSessionDidStartRunningNotification" >/dev/null; then
		echo started running
	elif echo $line | grep "AVCaptureSessionDidStopRunningNotification" >/dev/null; then
		echo stopped running
	fi
done

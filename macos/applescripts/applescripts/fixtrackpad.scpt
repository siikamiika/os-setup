open location "x-apple.systempreferences:com.apple.Trackpad-Settings.extension"

tell application "System Events" to tell its application process "System Settings"
	repeat until window "Trackpad" exists
	end repeat
	# Go to tab "More Gestures" (see Accessibility Inspector)
	click radio button 3 of tab group 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Trackpad" of application process "System Settings" of application "System Events"
	# Toggle pop-up button "Swipe between pages" between "Off" and "Swipe with Three Fingers"
	tell pop up button 1 of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Trackpad" of application process "System Settings" of application "System Events"
		click
		delay 0.2
		click menu item "Off" of menu 1
		click
		delay 0.2
		click menu item "Swipe with Three Fingers" of menu 1
	end tell
	# debug
	#get description of every UI element of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Trackpad" of application process "System Settings" of application "System Events"
end tell

delay 1
tell application "System Settings" to quit

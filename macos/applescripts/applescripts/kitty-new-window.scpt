tell application "System Events" to tell process "kitty"
	tell menu bar item 3 of menu bar 1
		click menu item "New OS Window" of menu 1
	end tell
	set frontmost to true
end tell

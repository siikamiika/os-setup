#!/bin/bash

echo "Configuring Rectangle"

KEY_H=4
KEY_L=37
KEY_LEFT=123
KEY_RIGHT=124
KEY_DOWN=125
KEY_UP=126
MOD_SHIFT=$((1 << 17))
MOD_CTRL=$((1 << 18))
MOD_OPTION=$((1 << 19))
MOD_CMD=$((1 << 20))
MOD_FN=$((1 << 23))

# starting point
defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1

# size
defaults write com.knollsoft.Rectangle larger -dict keyCode $KEY_L modifierFlags $(($MOD_CTRL | $MOD_CMD))
defaults write com.knollsoft.Rectangle smaller -dict keyCode $KEY_H modifierFlags $(($MOD_CTRL | $MOD_CMD))

# maximize
defaults write com.knollsoft.Rectangle maximize -dict keyCode $KEY_UP modifierFlags $MOD_CMD
defaults write com.knollsoft.Rectangle maximizeHeight -dict

# restore
defaults write com.knollsoft.Rectangle restore -dict keyCode $KEY_DOWN modifierFlags $MOD_CMD

# horizontal halves
defaults write com.knollsoft.Rectangle leftHalf -dict keyCode $KEY_LEFT modifierFlags $MOD_CMD
defaults write com.knollsoft.Rectangle rightHalf -dict keyCode $KEY_RIGHT modifierFlags $MOD_CMD

# vertical halves
defaults write com.knollsoft.Rectangle bottomHalf -dict
defaults write com.knollsoft.Rectangle topHalf -dict

# corners
defaults write com.knollsoft.Rectangle topLeft -dict
defaults write com.knollsoft.Rectangle topRight -dict
defaults write com.knollsoft.Rectangle bottomLeft -dict
defaults write com.knollsoft.Rectangle bottomRight -dict

# thirds
defaults write com.knollsoft.Rectangle centerThird -dict
defaults write com.knollsoft.Rectangle firstThird -dict
defaults write com.knollsoft.Rectangle firstTwoThirds -dict
defaults write com.knollsoft.Rectangle lastThird -dict
defaults write com.knollsoft.Rectangle lastTwoThirds -dict

# displays
defaults write com.knollsoft.Rectangle nextDisplay -dict
defaults write com.knollsoft.Rectangle previousDisplay -dict

# misc
defaults write com.knollsoft.Rectangle center -dict

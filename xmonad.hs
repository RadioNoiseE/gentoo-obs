import XMonad
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ conf

conf = def
     { terminal    = "alacritty"   -- Set the default terminal emulator to alacritty
     , modMask     = mod4Mask      -- Rebind Mod to the <meta> key
     , startupHook = xinit         -- Things to be started with XMonad
     , manageHook  = myManageHook  -- Match on certain windows
     }
  `additionalKeysP`
     [ ("M-S-z", spawn "xscreensaver-command -lock")  -- Lock the screen
     , ("M-C-s", unGrab *> spawn "scrot -s")          -- Screenshot functionality
     ]

xinit :: X ()
xinit = do
      spawnOnce "feh --bg-fill --no-fehbg ~/Pictures/IMG_6702.JPG"  -- Set background
      spawnOnce "picom -b"                                          -- Windows compositor
      spawnOnce "xscreensaver -no-splash"                           -- Fire up screensaver
      spawnOnce "fcitx"                                             -- Input method initialize

myXmobarPP :: PP
myXmobarPP = def
           { ppSep             = magenta " • "
           , ppTitleSanitize   = xmobarStrip
           , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
           , ppHidden          = white . wrap " " ""
           , ppHiddenNoWindows = lowWhite . wrap " " ""
           , ppUrgent          = red . wrap (yellow "!") (yellow "!")
           , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
           , ppExtras          = [logTitles formatFocused formatUnfocused]
           }
         where
           formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
           formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow
           ppWindow :: String -> String
           ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30
           blue, lowWhite, magenta, red, white, yellow :: String -> String
           magenta  = xmobarColor "#ff79c6" ""
           blue     = xmobarColor "#bd93f9" ""
           white    = xmobarColor "#f8f8f2" ""
           yellow   = xmobarColor "#f1fa8c" ""
           red      = xmobarColor "#ff5555" ""
           lowWhite = xmobarColor "#bbbbbb" ""

myManageHook :: ManageHook
myManageHook = composeAll
             [ isDialog           --> doFloat
             , className =? "mpv" --> doFloat
             ]

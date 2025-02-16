import XMonad

import XMonad.Util.EZConfig
import XMonad.Operations (unGrab)

-- Make xmonad ewmh compliant
import XMonad.Hooks.EwmhDesktops

-- Needed for compatibility with taffybar
import XMonad.Hooks.ManageDocks

-- Hook needed to interact with Xmobar
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

-- Allow us to create space for taffybar
import XMonad.Layout.Gaps
import XMonad.Layout.Minimize
import XMonad.Layout.BoringWindows

-- Allows parts of the startupHook to only run on session start
import XMonad.Util.SessionStart
import XMonad.Util.SpawnOnce (spawnOnce)

import XMonad.Hooks.TaffybarPagerHints (pagerHints)

main:: IO ()
main = xmonad $ docks $ ewmhFullscreen $ ewmh $ pagerHints $ def
    { modMask = mod4Mask  -- Rebind Mod to the Super key
      , terminal = myTerminal
      , layoutHook = myLayoutHook
        -- NOTE: Injected using nix strings.
      , focusedBorderColor = myFocusedBorderColor
      , normalBorderColor = myNormalBorderColor
      , startupHook = myStartupHook
    }
  -- Bind extra keys
  `additionalKeysP`
    [ ("M1-C-l", spawn "betterlockscreen --wall --blur -l") -- Ctrl+Alt+l locks
  --  , ("S-<Print>", unGrab *> spawn "scrot -s"        ) -- Shift+Print screen shots current window
    , ("C-M1-t"  , spawn myTerminal                   ) -- Ctrl+Alt+t spawns terminal
    , ("C-<Tab>", spawn "rofi -show drun -theme grid") -- Ctrl+Tab spawns rofi launcher
   -- , ("C-<Tab>", spawn "rofi -show emoji -theme grid") -- Ctrl+Tab spawn rofi emoji picker
    ]

myTerminal :: String
myTerminal = "kitty"

myLayoutHook =
  avoidStruts -- Do not cover up system bar etc.
  . minimize -- Allow minimizing windows
  . boringAuto -- Allow marking windows as boring, removing them from some cycle action
  $ tiled ||| Mirror tiled ||| Full
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes
    ratio   = 1/2    -- Default proportion of screen occupied by master pane

myStartupHook :: X()
myStartupHook =
  doOnce $ spawnOnce autostartEntrypoint

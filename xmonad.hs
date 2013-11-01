import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    safeSpawn "killall xmobar" []
    safeSpawn "killall trayer" []
    safeSpawn "trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --width 8 --transparent true --alpha 0 --tint 0x000000 --height 16 &" []
    xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"   
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook =  myLogHook xmproc
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot") ]


myLogHook h = dynamicLogWithPP $ xmobarPP 
	{ ppTitle = xmobarColor "green" "" . shorten 50
	, ppOutput = hPutStrLn h }

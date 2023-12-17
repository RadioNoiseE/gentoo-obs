Config { overrideRedirect = False
       , font     = "xft:iosevka-11.6:antialias=ture,notoSansMonoCJKjp-11.3"
       , additionalFonts = [ "xft:notoSansMonoCJKjp-11" ]
       , bgColor  = "#5f5f5f"
       , fgColor  = "#f8f8f2"
       , position = TopW L 100
       , commands = [ Run MultiCpu
                        [ "--template" , "Cpu: <total0>:<total1>%"
                        , "--Low"      , "50"
                        , "--High"     , "85"
                        , "--low"      , "white"
                        , "--normal"   , "lightblue"
                        , "--high"     , "red"
                        ] 10
                    , Run Alsa "default" "Master"
                        [ "--template", "<volumestatus>"
                        , "--suffix"  , "True"
                        , "--"
                        , "--on", ""
                        ]
                    , Run Battery
                        [ "--template" , "Batt: <acstatus>"
                        , "--Low"      , "10"
                        , "--High"     , "80"
                        , "--low"      , "red"
                        , "--normal"   , "lightblue"
                        , "--high"     , "white"
                        , "--"
                        , "-o"	, "<left>% (<timeleft>)"
                        , "-O"	, "<fc=#dAA520>Charging</fc>"
                        , "-i"	, "<fc=#006000>Charged</fc>"
                        ] 50
                    , Run DynNetwork
                        [ "--template" , "<dev>: <tx>:<rx>kB/s"
                        , "--Low"      , "1000"
                        , "--High"     , "5000"
                        , "--low"      , "white"
                        , "--normal"   , "lightblue"
                        , "--high"     , "lightblue"
                        ] 10
                    , Run Memory ["--template", "Mem: <usedratio>%"] 10
                    , Run Swap [] 10
                    , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                    , Run XMonadLog
                    ]
       , sepChar  = "%"
       , alignSep = "}{"
       , template = "%XMonadLog% }{ %alsa:default:Master% | %battery% | %multicpu% | %memory% | %swap% | %date% "
       }

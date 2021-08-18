@ECHO OFF
set yy=%date:~-4%
set dd=%date:~-7,2%
set mm=%date:~-10,2%

set hh=%time:~-11,2%
set mn=%time:~-8,2%
set ss=%time:~-5,2%

set dtstr=%yy%_%mm%_%dd%-%hh%_%mn%_%ss%
set fn=PKC_dkpg%dtstr%.tar.gz

if exist "..\mountPoint" (
    echo Found the mountPoint data
    echo To create a file named: %fn%
    tar -czvf %fn% "..\mountPoint"
    move %fn% "..\resources\"%fn%
)

::COPY %fn% ..\resources\%fn%
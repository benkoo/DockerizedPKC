@ECHO OFF
set w=5
set a=C
set b=:\Program Files\Docker
::set b=:\Videos
set c=%a%%b%
echo Try to find %c%
set found=false

for %%d in (H G F E D C ) do (
    if exist "%%d%b%" (
        echo Found the file: %%d%b%
        set found=true
        echo Will use docker-compose to launch PKC
        docker-compose down
        docker-compose up -d 
        echo %time%
        echo wait for a few seconds before launching the browser... 
        timeout %w% > NUL
        echo %time%
        start http://localhost:9352
        exit
    ) 
)

if %found%==false (
    echo Please install Docker Desktop for Windows
    echo (You might not have it installed at the X:%b% directory)
)
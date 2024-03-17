:: Startup Stuff
@echo off
for /f %%a in ('powershell Invoke-RestMethod api.ipify.org') do set local_ip=%%a
echo Public IP: %local_ip%  

set "ncat-file-ext=%random%"

:: Check for Args
if "%1"=="" goto normal-start
if "%1"=="--uninstall" goto delete-script
if "%1"=="--u" goto delete-script
if "%1"=="-u" goto delete-script

:: When the Script got Called Without any Args it starts here
:normal-start
    echo Starting Server...
    for /f "delims=" %%a in ('where ncat') do (
        set "where_output=%%a"
    )
    if not defined where_output (goto ncat-not-installed) else (goto libs-avaiable)

:ncat-not-installed
    echo It seems like NCat isnt installed. 
    echo.
    echo [1] Show NCat install options
    echo.
    echo [2] Show Information About NCat
    echo.
    echo [3] Cancel the Install and Delete The Script
    echo.
    choice /c 123 /m "Choose an Option from Above (1/2/3):"
    set _erl=%errorlevel%
    if %_erl%==3 cls & goto delete-script
    if %_erl%==2 cls & explorer https://nmap.org/ncat/
    if %_erl%==1 cls & goto ncat-install
    
:ncat-install
    echo Please choose an Install Method for NCat  
    echo.
    echo [1] Winget
    echo.
    echo [2] Scoop
    echo.
    echo [3] Choco
    echo.
    echo [4] Download .exe
    choice /c 123 /m "Choose an Option from Above (1/2/3):"
    set _erl=%errorlevel%
    if %_erl%==4 cls & explorer https://nmap.org/dist/nmap-7.94-setup.exe
    if %_erl%==3 cls & choco install nmap
    if %_erl%==2 cls & scoop install nmap 
    if %_erl%==1 cls & winget install Insecure.Nmap

:delete-script
set "verify=%random%"
echo Are you sure you want to delete the Script?
echo Please enter %verify% in the Field Below
set /p verifyans=Type %verify%:
if "%verifyans%"=="%verify%" (goto delete-script-confirmed) else (goto delete-script)

:delete-script-confirmed
echo Deleting Script...
timeout 3
cd %~dp0
cd ..
rm /s /q auth-example
echo Success.
echo Exiting...
exit

:libs-avaiable
echo Do you want to send a File or Listen for incoming Data
echo.
echo [1] Listen
echo.
echo [2] Send
echo.
choice /c 12 /m "Choose an Option from Above (1/2):"
set _erl=%errorlevel%
if %_erl%==2 cls & goto send-data
if %_erl%==1 cls & goto recive-data


:send-data
echo Do you want to enter a IP or search for a Client in you Local Network and send it there 
echo.
echo [1] Enter IP
echo.
echo [2] Search for Client
echo.
choice /c 12 /m "Choose an Option from Above (1/2):"
set _erl=%errorlevel%
if %_erl%==2 cls & goto search-client
if %_erl%==1 cls & goto enter-ip

:enter-ip
set /P ip-to-send=Please enter the IP:
goto what-to-send


:search-client
setlocal EnableDelayedExpansion
set counter=1
for /f "tokens=1" %%a in ('arp -a') do (
    for /f "delims=. tokens=1-4" %%b in ("%%a") do (
        set "ip=%%b.%%c.%%d.%%e"
        echo Checking IP: !ip!
        echo !ip! | findstr /r /b /c:"[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$"
        if !errorlevel! equ 0 (
            set "ip_address_!counter!=!ip!"
            set /a counter+=1
        )
    )
)

set /a num_ips=counter-1
echo Sending Auth-Message to IPs
for /l %%i in (1, 1, %num_ips%) do (
    echo Sending to IP: !ip_address_%%i!...
    echo %local_ip%% | ncat !ip_address_%%i! 56954
)

echo Messages Send...
endlocal
ncat -l 56954 
cd %temp%
ncat -l 56954 > auth-ncat-%ncat-file-ext%.txt
set /p ip-to-send=<auth-ncat-%ncat-file-ext%.txt
echo Recieved Answer from %ip-to-send%
timeout 2
cls

:what-to-send
echo Do you want to send a File or only Text?
echo.
echo [1] Text
echo.
echo [2] File
echo.
choice /c 12 /m "Choose an Option from Above (1/2):"
set _erl=%errorlevel%
if %_erl%==2 cls & goto send-file
if %_erl%==1 cls & goto send-text


:send-text
set /P text-to-send=Please enter the Text to Send Here:
echo %text-to-send% | ncat %ip-to-send% 56954
echo Data Was Send to %ip-to-send%
pause
exit

:send-file
set /P file-to-send=Please enter the Path to The File to Send Here:
ncat %ip-to-send% 56954 < %file-to-send%
echo File was send to %ip-to-send%
pause
exit

:recive-data
cd %~dp0
echo Listening on Port 56954 (IP: %local_ip%)
ncat -l 56954 > auth-ncat-%ncat-file-ext%.txt
set /p check-auth=<auth-ncat-%ncat-file-ext%.txt
echo %local_ip%% | ncat !check-auth! 56954
ncat -l 56954 
echo Data Recieved.
echo If it was a File you can find it %cd%
pause
exit 

:arg-help
echo Usage: main.bat [--remove]
echo.
echo Description: Listen on a Specific Port via NCat and Recive/Send Data Over it.
echo.              
echo.
echo Parameters: --uninstall Remove the Script from your System 
echo.       




::msg * /TIME:5 "Message Recived On Port 147"
::msg * /TIME:5 "Message Recived On Port 147"

::msg * /TIME:5 "Message Recived On Port 147"
::msg * /TIME:5 "Message Recived On Port 147"
::msg * /TIME:5 "Message Recived On Port 147"
::msg * /TIME:5 "Message Recived On Port 147"::msg * /TIME:5 "Message Recived On Port 147"
::msg * /TIME:5 "Message Recived On Port 147"

@echo off
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
set message=pirany-data-exchanger?
echo Sending Auth-Message to IPs
for /l %%i in (1, 1, %num_ips%) do (
    echo Sending to IP: !ip_address_%%i!...
    echo !message! | ncat !ip_address_%%i! 56954
)

echo Messages Send...
endlocal
ncat -l 56954 
cd %temp%
ncat -l 56954  > auth-ncat.txt
set /p recieved-data=<auth-ncat.txt


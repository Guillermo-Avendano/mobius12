
set PROJECT="%~d0%~p0\"

set GIT_REPOSITORY=mobius12

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%-%HH%:%Min%:%Sec%"

cd %PROJECT%

set MSG="Commit %GIT_REPOSITORY% %fullstamp%"

git status
git add -A
git commit -m %MSG%
git push -u origin main
pause
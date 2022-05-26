@echo off
:: Script to move files to numbered subfolders with n limit of files per folder
:: ex: movedown2.4.bat "C:\Source Folder" 50
:: It will move all files from Source Folder to subfolders with maximum of 50 files per subfolder
:: version 2.4
:: By Melo
:: melo@meloprofessional.com


setlocal enableextensions
setlocal enabledelayedexpansion

if not %3.==. goto syntax
if %2.==. goto syntax
:: Checks if %2 is a number:
SET "var="&for /f "delims=0123456789" %%i in ("%2") do set var=%%i
if defined var (goto syntax) 
if /i %1.==. goto syntax
if /i not exist %1 echo. & echo  The folder %1 does not exist... && echo  Folder paths must be typed between "quotes" if there's any empty space. && echo. && goto end

setlocal enableextensions
setlocal enabledelayedexpansion
:: Maximum amount of files per subfolder:
SET limit=%2
:: Initial counter (everytime counter is 1, a new subfolder is created):
SET n=1
:: Subfolder counter:
SET nf=0
::Retrieves the amount of files in the specified folder:
set count=0
for %%A in (%1%\*.*) do set /a count+=1
set folder=%1%
set divisaoquantidade=0
set quantidadedepastas=0
set RESULT=0
set COMPRIMENTO=0
SET STRLENGTH=
SET ADICIONARZERO=0
SET PREFIXO=
set /a divisaoquantidade=%count%/%limit%
echo divisao quantidade: %divisaoquantidade%
for /f "tokens=1,2 delims=." %%A in ("%divisaoquantidade%") do set "X=%%~A" & set "Y=%%~B0"
if %Y:~0,1% geq 5 set /a "X+=1"
set quantidadedepastas=%X%
ECHO %quantidadedepastas%> tempfile.txt
FOR %%? IN (tempfile.txt) DO ( SET /A COMPRIMENTO=%%~z? - 2 )
del tempfile.txt





  :: To set length manually uncomment above
rem set /a COMPRIMENTO=5




echo  Distributing %count% files in subfolders %folder% of up to !limit! files...


FOR %%f IN (%1%\*.*) DO (
  :: If counter is 1, create a new subfolder with name starting with "...":
  IF !n!==1 (
    SET /A nf+=1

ECHO !nf!> tempfile2.txt
FOR %%I IN (tempfile2.txt) DO ( SET /A STRLENGTH=%%~zI - 2 )
del tempfile2.txt
set /A ADICIONARZERO=%COMPRIMENTO%-!STRLENGTH!
if !ADICIONARZERO! geq 1 (
FOR /L %%N IN (1,1,!ADICIONARZERO!) DO (
SET "PREFIXO=0!PREFIXO!"
SET /A CONTADOR+=1
)
)


    MD %folder%"\Part "!PREFIXO!!nf!
  )
  :: Move files into subfolders with names starting with "...":
  MOVE /-Y "%%f" %folder%"\Part "!PREFIXO!!nf! > NUL
  :: Reset counter when a subfolder reaches the maximum file limit:
  IF !n!==!limit! (
    SET n=1
set PREFIXO=
  ) ELSE (
    SET /A n+=1
  )
)
SET limit=
SET n=
SET nf=
SET count=
set PREFIXO=
echo  Move finished successfully.
goto end

:syntax
echo.
echo  YOU TYPED: movedown %*
echo  SYNTAX: movedown ["full path"] (between quotes if there's any space) [n] (maximum number of files per subfolder)
echo.
:end
ENDLOCAL

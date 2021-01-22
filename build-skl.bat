cd src
rem pyinstaller skl.py --onefile --clean
pyinstaller skl.py --clean
rem copy dist\skl\skl.exe ..\..\skl.exe
pause

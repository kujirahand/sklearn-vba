echo "--- BUILD ---"
cd src
pyinstaller skl.py --clean --noconfirm
cp skl.bas src\dist\skl.bas
cp sample.xlsm src\dist\sample.xlsm
cp README.md src\dist\README.md
cp LICENSE src\dist\LICENSE
pause

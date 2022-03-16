del GameGrumpsJointJustice.love
del GameGrumpsJointJustice.exe
del windows\GameGrumpsJointJustice.exe
timeout /t 3
7z.exe a GameGrumpsJointJustice.zip .. -x!build -x!".git"
timeout /t 3
move .\GameGrumpsJointJustice.zip GameGrumpsJointJustice.love
timeout /t 3
call .\convert-love-to-exe.bat .\GameGrumpsJointJustice.love
timeout /t 3
move .\GameGrumpsJointJustice.exe windows
echo "Done! Make sure everything looks good"
pause
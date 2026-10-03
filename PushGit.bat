@echo off
setlocal enabledelayedexpansion

if not exist .git (
    git init
    set /p remote_url="Plak hier je GitHub repository URL: "
    git remote add origin !remote_url!
)

git branch -M main
git add .
git commit -m "Deploy Flappy Bird"
git push -u origin main --force
pause

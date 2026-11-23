@echo off
cd /d "%~dp0"
set "treasure_python=%LOCALAPPDATA%\Programs\Python\Python313\python.exe"
if not exist "%treasure_python%" set "treasure_python=python"
"%treasure_python%" -B -c "import tkinter, PIL.ImageTk" >nul 2>&1
if errorlevel 1 (
    echo Python with Tkinter and Pillow is required.
    echo Install Pillow with: python -m pip install Pillow
    pause
    exit /b 1
)
"%treasure_python%" -B editor.py
if errorlevel 1 pause

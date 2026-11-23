@echo off
cd /d "%~dp0"
where python >nul 2>&1
if errorlevel 1 (
    echo Python 3 is required.
    pause
    exit /b 1
)
python -c "import tkinter, PIL, lupa.lua52" >nul 2>&1
if errorlevel 1 (
    echo Python with Tkinter, Pillow and Lupa is required.
    echo Install dependencies with: python -m pip install Pillow lupa
    pause
    exit /b 1
)
python -B editor.py
if errorlevel 1 pause

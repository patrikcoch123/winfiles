#!/usr/bin/env pwsh.exe
#Requires -Version 5
#Requires -RunAsAdministrator
Set-StrictMode -Version 2.0

$computerDetails = Get-ComputerDetails

########  Theme Settings

$winkey = "HKCU:\Software\Microsoft\Windows\CurrentVersion"

# Turn on Dark mode for apps
Set-RegistryInt "$winkey\Themes\Personalize" "AppsUseLightTheme" 0

# Automatically set accent color from backgrouns
Set-RegistryInt "HKCU:\Control Panel\Desktop" "AutoColorization" 1

# Use accent color in start, taskbar, and action center
Set-RegistryInt "$winkey\Themes\Personalize" "ColorPrevalance" 1

# Use accent color in title bars
Set-RegistryInt "HKCU:\Software\Microsoft\Windows\DWM" "ColorPrevalance" 1

# Use transparency
Set-RegistryInt "$winkey\Themes\Personalize" "EnableTransparancy" 1

# Set wallpaper
$wallpaper = "$env:ProfilePath\winfiles\dotfiles\wallpapers\1920x1080\darkest-hour.jpg"
Set-RegistryInt "HKCU:\Control Panel\Desktop" "Wallpaper" $wallpaper

# Show the Windows version on the desktop
# Disabled for now
#Set-RegistryInt "HKCU:\Control Panel\Desktop" "PaintDesktopVersion" 1

########  Night Light Settings

$key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\" +
"DefaultAccount\Current\default$windows.data.bluelightreduction.settings\" +
"windows.data.bluelightreduction.settings"
$value = ([byte[]](0x43, 0x42, 0x01, 0x00, 0x0A, 0x02, 0x01, 0x00,
    0x2A, 0x06, 0xB1, 0x9E, 0xA8, 0xE7, 0x05, 0x2A))
Set-RegistryValue $key "Data" $value
$key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\" +
"DefaultAccount\Current\default$windows.data.bluelightreduction." +
"bluelightreductionstate\windows.data.bluelightreduction.bluelightreductionstate"
Set-RegistryValue $key "Data" $value

########  Screen Saver

if (-not ($computerDetails.IsVirtual)) {
    $key = "HKCU:\Control Panel\Desktop"
    # ScreenSaver settings
    Set-RegistryInt $key "ScreenSaveActive" 1
    Set-RegistryInt $key "ScreenSaverIsSecure" 1
    # 1800 = 30 minutes
    Set-RegistryInt $key "ScreenSaveTimeout" 1800
    Set-RegistryString $key "SCRNSAVE.EXE" "$env:SystemRoot\system32\scrnsave.scr"
}

########  Explorer Settings

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'

# Show file extensions
Set-RegistryInt "$key\Advanced" "HideFileExt" 0

# Show hidden files, folders, and drives
Set-RegistryInt "$key\Advanced" "Hidden" 1

# Disable showing protected OS files
Set-RegistryInt "$key\Advanced" "ShowSuperHidden" 0

# Show the full path in the title bar of explorer
Set-RegistryInt "$key\CabinetState" "FullPath" 1

# Turn off recent files in Quick Access
Set-RegistryInt "$key" "ShowRecent" 0

# Turn off frequent directories in Quick Access
Set-RegistryInt "$key" "ShowFrequent" 0

# Disable expanding to open folder (in the tree of paths, disables it tracking the main pain)
Set-RegistryInt "$key\Advanced" "NavPaneExpandToCurrentFolder" 0

# Launch explorer to "My PC", not Quick Access
Set-RegistryInt "$key\Advanced" "LaunchTo" 1

# Hide Ribbon in Explorer
Set-RegistryInt "$key\Ribbon" "MinimizedStateTabletModeOff" 1

# Run explorer sessions in separate processes
Set-RegistryInt "$key\Advanced" "SeparateProcess" 1

# Always show menus in explorer
Set-RegistryInt "$key\Advanced" "AlwaysShowMenus" 1

# Use "Peek" to preview desktop when hovered over bottom-right
Set-RegistryInt "$key\Advanced" "DisablePreviewDesktop" 0

# Turn off "Show sync provider notifications" (advertising)
Set-RegistryInt "$key\Advanced" "ShowSyncProviderNotifications" 0

# Turn off the Startup delay for Startup Apps
Set-RegistryInt "$key\Serialize" "StartupDelayInMSec" 0

########  Terminal (conhost) settings

$key = 'HKCU:\Console'

# Setup font for console
Set-RegistryString "$key" "FaceName" "__DefaultTTFont__"
#TBD -> Set-RegistryString "$key" "FaceName" "SourceCodePro NF"
Set-RegistryInt "$key" "FontSize" 1310720

# Console settings
Set-RegistryInt "$key" "ForceV2" 1
Set-RegistryInt "$key" "LineSelection" 1
Set-RegistryInt "$key" "FilterOnPaste" 1
Set-RegistryInt "$key" "LineWrap" 1
Set-RegistryInt "$key" "CtrlKeyShortcutsDisabled" 0
Set-RegistryInt "$key" "ExtendedEditKey" 0
Set-RegistryInt "$key" "TrimLeadingZeros" 0
Set-RegistryInt "$key" "WindowsAlpha" 243
Set-RegistryInt "$key" "InsertMode" 1
Set-RegistryInt "$key" "QuickEdit" 1
Set-RegistryInt "$key" "InterceptCopyPaste" 1
Set-RegistryInt "$key" "LineSelection" 1
Set-RegistryInt "$key" "TerminalScrolling" 0

# Block cursor, inverse color
Set-RegistryInt "$key" "CursorType" 4
Set-RegistryInt "$key" "CursorColor" 4294967295

Set-RegistryInt "$key" "HistoryBufferSize" 999
Set-RegistryInt "$key" "NumberOfHistoryBuffers" 4
Set-RegistryInt "$key" "HistoryNoDup" 1

# Powershell
#Set-RegistryString "$key\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" "FaceName" "SourceCodePro NF"
#Set-RegistryString "$key\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" "FaceName" "SourceCodePro NF"
Set-RegistryInt "$key\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" "FontSize" 1310720
Set-RegistryInt "$key\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" "FontSize" 1310720

Set-RegistryInt "$key\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" "QuickEdit" 1
Set-RegistryInt "$key\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" "QuickEdit" 1

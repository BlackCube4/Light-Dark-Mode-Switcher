uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
DllCall(SetPreferredAppMode, "int", 1) ; Dark
DllCall(FlushMenuThemes)

/*
    Wird aktiviert mit Win + Alt + D
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Singleinstance Force

RegRead,LightModeActive,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,SystemUsesLightTheme
If LightModeActive
	Menu, tray, Icon , Icons\Dark Small Icon.ico
else
	Menu, tray, Icon , Icons\Light Small Icon.ico
	
Menu, Tray, NoStandard
Menu, Tray, Add, Switch, Switch
Menu, Tray, Add, Switch Background Image, SwitchBackground
Menu, Tray, add, Exit, GuiClose
Menu, Tray, Default, Switch
Menu, Tray, Click, 2
return

GuiClose:
ExitApp
Return

#!d::
Switch:
RegRead,LightModeActive,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,SystemUsesLightTheme
 
If LightModeActive {
RegWrite,Reg_Dword,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,SystemUsesLightTheme,0 
RegWrite,Reg_Dword,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,AppsUseLightTheme,0
FileList := FileGetList(A_ScriptDir . "\Dark Wallpapers")
Random, RandomIndex, 1, FileList.MaxIndex()
RandomFile := FileList[RandomIndex]
DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, RandomFile, UInt, 1)
Menu, tray, Icon , Icons\Light Small Icon.ico
} 
Else
{ 
RegWrite,Reg_Dword,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,SystemUsesLightTheme,1 
RegWrite,Reg_Dword,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,AppsUseLightTheme,1
FileList := FileGetList(A_ScriptDir . "\Light Wallpapers")
Random, RandomIndex, 1, FileList.MaxIndex()
RandomFile := FileList[RandomIndex]
DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, RandomFile, UInt, 1)
Menu, tray, Icon , Icons\Dark Small Icon.ico
}
run,RUNDLL32.EXE USER32.DLL`, UpdatePerUserSystemParameters `,2 `,True
return

SwitchBackground:
FileList := FileGetList(A_ScriptDir . "\Dark Wallpapers")
FileList2 := FileGetList(A_ScriptDir . "\Light Wallpapers")
Loop % FileList2.Length()
    FileList.Push(FileList2[A_Index])
Random, RandomIndex, 1, FileList.MaxIndex()
RandomFile := FileList[RandomIndex]
DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, RandomFile, UInt, 1)
return

FileGetList(FolderPath) {
    OutputArray := []
    Loop, Files, %FolderPath%\*.*, F
        OutputArray.Push(A_LoopFilePath)
    Return OutputArray
}
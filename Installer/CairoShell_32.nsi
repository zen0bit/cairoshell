;--------------------------------
; CairoShell_32.nsi

!include "MUI.nsh"

; The name of the installer
Name "Cairo Desktop Environment"

; The file to write
OutFile "CairoSetup_32bit.exe"

; Use Unicode rather than ANSI
Unicode True

; The default installation directory
InstallDir "$PROGRAMFILES\Cairo Shell"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\CairoShell" "Install_Dir"
!define MUI_ABORTWARNING

; Minimum .NET Framework release (4.7.1)
!define MIN_FRA_RELEASE "461308"

;--------------------------------
; Pages

  !define MUI_ICON inst_icon.ico
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_RIGHT
  !define MUI_HEADERIMAGE_BITMAP header_img.bmp
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP left_img.bmp
  !define MUI_UNICON inst_icon.ico
  ;!define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_WELCOMEFINISHPAGE_BITMAP left_img.bmp
  !define MUI_WELCOMEPAGE_TEXT "$(PAGE_Welcome_Text)"
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !define MUI_FINISHPAGE_TITLE_3LINES
  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_TEXT "$(PAGE_Finish_RunText)"
  !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchCairo"
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
  
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !define MUI_FINISHPAGE_TITLE_3LINES
  !insertmacro MUI_UNPAGE_WELCOME
  !define MUI_UNCONFIRMPAGE_TEXT_TOP "$(PAGE_UnDir_TopText)"
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Components

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "French"

; The stuff to install
Section "$(SECT_cairo)" cairo

  SectionIn RO

  ; Check .NET version
  Call AbortIfBadFramework
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  Call AbortIfRunning
  
  ; Put file there
  DetailPrint "Installing Cairo files"
  File "..\Cairo Desktop\Build\x86\Release\CairoDesktop.exe"
  File "..\Cairo Desktop\Build\x86\Release\*.dll"

  CreateDirectory "$INSTDIR\Themes"
  File /r "..\Cairo Desktop\Build\x86\Release\Themes"

  ; Set shell context to All Users
  SetShellVarContext all

  ; Start menu shortcuts
  createShortCut "$SMPROGRAMS\Cairo Desktop.lnk" "$INSTDIR\CairoDesktop.exe"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\CairoShell "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "DisplayName" "Cairo Desktop Environment"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "DisplayIcon" '"$INSTDIR\RemoveCairo.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "DisplayVersion" "BUILD_VERSION"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "UninstallString" '"$INSTDIR\RemoveCairo.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "URLInfoAbout" "https://cairodesktop.com"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "Publisher" "Cairo Development Team"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell" "NoRepair" 1
  WriteUninstaller "RemoveCairo.exe"

  Return

SectionEnd

; Run at startup
Section /o "$(SECT_startupCU)" startupCU
  
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "CairoShell" "$INSTDIR\CairoDesktop.exe"
  
SectionEnd

; Replace explorer
Section /o "$(SECT_shellCU)" shellCU
  
  WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "Shell" "$INSTDIR\CairoDesktop.exe"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "CairoShell"
  
SectionEnd

  ;Language strings
  LangString PAGE_Welcome_Text ${LANG_ENGLISH} "This installer will guide you through the installation of Cairo.\r\n\r\nBefore installing, please ensure .NET Framework 4.7.1 or higher is installed, and that any running instance of Cairo is ended.\r\n\r\nClick Next to continue."
  LangString PAGE_Finish_RunText ${LANG_ENGLISH} "Start Cairo Desktop Environment"
  LangString PAGE_UnDir_TopText ${LANG_ENGLISH} "Please be sure that you have closed Cairo before uninstalling to ensure that all files are removed. All files in the directory below will be removed."
  LangString DLOG_RunningText ${LANG_ENGLISH} "Cairo is currently running. Please exit Cairo from the Cairo menu and run this installer again."
  LangString DLOG_RunningText2 ${LANG_ENGLISH} "Cairo is currently running. Please exit Cairo from the Cairo menu."
  LangString DLOG_DotNetText ${LANG_ENGLISH} "Cairo requires Microsoft .NET Framework 4.7.1 or higher. Please install this from the Microsoft web site and install Cairo again."
  LangString SECT_cairo ${LANG_ENGLISH} "Cairo Desktop (required)"
  LangString SECT_startupCU ${LANG_ENGLISH} "Run at startup (current user)"
  LangString SECT_shellCU ${LANG_ENGLISH} "Advanced: Disable Explorer (current user)"
  LangString DESC_cairo ${LANG_ENGLISH} "Installs Cairo and its required components."
  LangString DESC_startupCU ${LANG_ENGLISH} "Makes Cairo start up when you log in."
  LangString DESC_shellCU ${LANG_ENGLISH} "Run Cairo instead of Windows Explorer. Note: this also disables UWP/Windows Store apps and other features in Windows using that technology."

  LangString PAGE_Welcome_Text ${LANG_FRENCH} "Cet installateur va vous guider au long de l'installation de Cairo.\r\n\r\nAvant d'installer, veuillez vous assurer que le .NET Framework 4.7.1 ou plus r�cent est install�, et que vous avez quitt� toute instance de Cairo encore en cours de fonctionnement.\r\n\r\nCliquez sur Suivant pour continuer."
  LangString PAGE_Finish_RunText ${LANG_FRENCH} "D�marrer l'environnement de bureau Cairo"
  LangString PAGE_UnDir_TopText ${LANG_FRENCH} "Veuillez v�rifier que vous avez ferm� Cairo avant de le d�sinstaller pour assurer que tous les fichiers soient supprim�s. All files in the directory below will be removed."
  LangString DLOG_RunningText ${LANG_FRENCH} "Cairo est en cours de fonctionnement. Veuillez quitter Cairo depuis le menu Cairo et lancer de nouveau cet installateur."
  LangString DLOG_RunningText2 ${LANG_FRENCH} "Cairo est en cours de fonctionnement. Veuillez quitter Cairo depuis le menu Cairo."
  LangString DLOG_DotNetText ${LANG_FRENCH} "Cairo n�cessite le Microsoft .NET Framework 4.7.1 ou plus r�cent. Veuillez l'installer depuis le site web de Microsoft et installer de nouveau Cairo."
  LangString SECT_cairo ${LANG_FRENCH} "Bureau Cairo (requis)"
  LangString SECT_startupCU ${LANG_FRENCH} "Lancer au d�marrage (utilisateur actuel)"
  LangString SECT_shellCU ${LANG_FRENCH} "Utilisateurs avanc�s uniquement : remplacer l'Explorateur Windows (utilisateur actuel)"
  LangString DESC_cairo ${LANG_FRENCH} "Installer Cairo et ses composants requis."
  LangString DESC_startupCU ${LANG_FRENCH} "D�marrer Cairo lorsque vous vous connectez."
  LangString DESC_shellCU ${LANG_FRENCH} "Lancer Cairo au lieu de l'Explorateur Windows. Notez que cela d�sactive �galement de nombreuses fonctionnalit�s nouvelles dans Windows."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${cairo} $(DESC_cairo)
    !insertmacro MUI_DESCRIPTION_TEXT ${startupCU} $(DESC_startupCU)
    !insertmacro MUI_DESCRIPTION_TEXT ${shellCU} $(DESC_shellCU)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Uninstaller


Section "Uninstall"

  ; Set shell context to All Users
  SetShellVarContext all

  System::Call 'kernel32::OpenMutex(i 0x100000, b 0, t "CairoShell") i .R1'
  IntCmp $R1 0 notRunning
    System::Call 'kernel32::CloseHandle(i $R1)'
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(DLOG_RunningText)" /SD IDOK
    Quit
  
  notRunning:

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CairoShell"
  DeleteRegKey HKLM SOFTWARE\CairoShell
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "CairoShell"
  DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "Shell"

  ; Remove files and uninstaller. Includes historical files
  Delete "$SMPROGRAMS\Cairo Desktop.lnk"
  Delete "$INSTDIR\*.exe"
  Delete "$INSTDIR\*.xaml"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\*.config"
  Delete "$INSTDIR\Themes\*.xaml"

  ; Remove directories used
  RMDir "$INSTDIR\Themes"
  RMDir "$INSTDIR"

SectionEnd

;--------------------------------
; Functions

Function LaunchCairo
  IfFileExists "$WINDIR\explorer.exe" 0 std_exec
    Exec '"$WINDIR\explorer.exe" "$INSTDIR\CairoDesktop.exe"' ; use the shell to launch as current user (otherwise notification area breaks)
    goto end_launch
  std_exec:
    Exec '$INSTDIR\CairoDesktop.exe /restart=true'
  end_launch:
FunctionEnd

Function .onInit
  IfSilent +2
    SectionSetFlags ${startupCU} 1
FunctionEnd

Function .onInstSuccess
  IfSilent 0 +2
    Call LaunchCairo
FunctionEnd

Function AbortIfRunning
  DetailPrint "Checking if Cairo is currently running"
  StrCpy $R0 "0" ; current retry count

  IfSilent 0 +3
    StrCpy $R2 "10" ; 10 retries when running silent
    Goto check
  StrCpy $R2 "2" ; 2 retries when running normally

  check:
    System::Call 'kernel32::OpenMutex(i 0x100000, b 0, t "CairoShell") i .R1 ?e'
    IntCmp $R1 0 notRunning running running

  retry:
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(DLOG_RunningText2)" /SD IDOK
    IntOp $R0 $R0 + 1
    Sleep 1000
    Goto check

  running:
    System::Call 'kernel32::CloseHandle(i $R1)'
    IntCmp $R0 $R2 abort retry abort

  abort:
    MessageBox MB_OK|MB_ICONEXCLAMATION "$(DLOG_RunningText)"
    Quit

  notRunning:
FunctionEnd

; https://nsis.sourceforge.io/How_to_Detect_any_.NET_Framework
; Check .NET framework release version and quit if too old
Function AbortIfBadFramework
  DetailPrint "Checking currently installed .NET Framework version"
 
  ; Save the variables in case something else is using them
  Push $0
  Push $1
  Push $2
  Push $3
  Push $4
  Push $R1
  Push $R2
  Push $R3
  Push $R4
  Push $R5
  Push $R6
  Push $R7
  Push $R8
 
  ; Major
  StrCpy $R5 "0"
 
  ; Minor
  StrCpy $R6 "0"
 
  ; Build
  StrCpy $R7 "0"
 
  ; No Framework
  StrCpy $R8 "0.0.0"
 
  StrCpy $0 0
 
  loop:
 
  ; Get each sub key under "SOFTWARE\Microsoft\NET Framework Setup\NDP"
  EnumRegKey $1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP" $0
  StrCmp $1 "" done ;jump to end if no more registry keys
  IntOp $0 $0 + 1
  StrCpy $2 $1 1 ;Cut off the first character
  StrCpy $3 $1 "" 1 ;Remainder of string
 
  ; Loop if first character is not a 'v'
  StrCmpS $2 "v" start_parse loop
 
  ; Parse the string
  start_parse:
  StrCpy $R1 ""
  StrCpy $R2 ""
  StrCpy $R3 ""
  StrCpy $R4 $3
 
  StrCpy $4 1
 
  parse:
  StrCmp $3 "" parse_done ; If string is empty, we are finished
  StrCpy $2 $3 1 ; Cut off the first character
  StrCpy $3 $3 "" 1 ; Remainder of string
  StrCmp $2 "." is_dot not_dot ; Move to next part if it's a dot
 
  is_dot:
  IntOp $4 $4 + 1 ; Move to the next section
  goto parse ; Carry on parsing
 
  not_dot:
  IntCmp $4 1 major_ver
  IntCmp $4 2 minor_ver
  IntCmp $4 3 build_ver
  IntCmp $4 4 parse_done
 
  major_ver:
  StrCpy $R1 $R1$2
  goto parse ; Carry on parsing
 
  minor_ver:
  StrCpy $R2 $R2$2
  goto parse ; Carry on parsing
 
  build_ver:
  StrCpy $R3 $R3$2
  goto parse ; Carry on parsing
 
  parse_done:
 
  IntCmp $R1 $R5 this_major_same loop this_major_more
  this_major_more:
  StrCpy $R5 $R1
  StrCpy $R6 $R2
  StrCpy $R7 $R3
  StrCpy $R8 $R4
 
  goto loop
 
  this_major_same:
  IntCmp $R2 $R6 this_minor_same loop this_minor_more
  this_minor_more:
  StrCpy $R6 $R2
  StrCpy $R7 $R3
  StrCpy $R8 $R4
  goto loop
 
  this_minor_same:
  IntCmp R3 $R7 loop loop this_build_more
  this_build_more:
  StrCpy $R7 $R3
  StrCpy $R8 $R4
  goto loop
 
  done:
 
  ReadRegDWORD $R9 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" Release
  IntCmp $R9 ${MIN_FRA_RELEASE} end wrong_framework end
 
  wrong_framework:
  MessageBox MB_OK|MB_ICONSTOP "$(DLOG_DotNetText)"
  Quit
 
  end:
 
  ; Pop the variables we pushed earlier
  Pop $R8
  Pop $R7
  Pop $R6
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Pop $0
 
FunctionEnd
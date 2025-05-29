!include nsDialogs.nsh

XPStyle on

!macro customUnInstall
  ${ifNot} ${isUpdated}
    ; Define the process name of your Electron app
    StrCpy $0 "Tuna.exe"

    ; Check if the application is running
    nsExec::ExecToStack 'tasklist /FI "IMAGENAME eq $0" /NH'
    Pop $1

    StrCmp $1 "" notRunning

    ; If the app is running, notify the user and attempt to close it
    MessageBox MB_OK "Tuna is being uninstalled, force close app." IDOK forceClose

    forceClose:
      ; Attempt to kill the running application
      nsExec::ExecToStack 'taskkill /F /IM $0'
      Pop $1

      ; Proceed with uninstallation
      Goto continueUninstall

    notRunning:
      ; If the app is not running, proceed with uninstallation
      Goto continueUninstall

    continueUninstall:
      ; Proceed with uninstallation
      DeleteRegKey HKLM "Software\Tuna"
      RMDir /r "$INSTDIR"
      Delete "$INSTDIR\*.*"

      ; Clean up shortcuts and app data
      Delete "$DESKTOP\Tuna.lnk"
      Delete "$STARTMENU\Programs\Tuna.lnk"
      RMDir /r "$APPDATA\Tuna"
      RMDir /r "$LOCALAPPDATA\tuna-updater"

      ; Close the uninstaller
      Quit
  ${endIf}
!macroend
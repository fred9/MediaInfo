; Request application privileges for Windows Vista
RequestExecutionLevel admin

; Some defines
!define PRODUCT_NAME "MediaInfo"
!define PRODUCT_PUBLISHER "MediaArea.net"
!define PRODUCT_VERSION "0.7.18"
!define PRODUCT_VERSION4 "0.7.18.0"
!define PRODUCT_WEB_SITE "http://mediainfo.sourceforge.net"
!define COMPANY_REGISTRY "Software\MediaArea.net"
!define PRODUCT_REGISTRY "Software\MediaArea.net\MediaInfo"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\MediaInfo.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; Compression
SetCompressor /FINAL /SOLID lzma

; x64 stuff
!include "x64.nsh"

; MediaInfo stuff
!include "MediaInfo_Extensions.nsh"

; Modern UI
!include "MUI2.nsh"
!define MUI_ABORTWARNING
!define MUI_ICON "..\..\Source\Ressource\Image\MediaInfo_TinyOnly.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Installer pages
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\MediaInfo.exe"
!insertmacro MUI_PAGE_FINISH
; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "Albanian"
!insertmacro MUI_LANGUAGE "Belarusian"
!insertmacro MUI_LANGUAGE "Catalan"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Czech"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Farsi"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Greek"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "Hungarian"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Lithuanian"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "Swedish"
!insertmacro MUI_LANGUAGE "Thai"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Turkish"
!insertmacro MUI_RESERVEFILE_LANGDLL

; Info
VIProductVersion "${PRODUCT_VERSION4}"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}" 
VIAddVersionKey "Comments" "All about your audio and video files"
VIAddVersionKey "CompanyName" "MediaArea.net"
VIAddVersionKey "LegalTrademarks" "GPL license" 
VIAddVersionKey "LegalCopyright" "" 
VIAddVersionKey "FileDescription" "All about your audio and video files"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION}"
BrandingText " "

; Modern UI end

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "..\..\Release\MediaInfo_GUI_${PRODUCT_VERSION}_Windows_i386.exe"
InstallDir "$PROGRAMFILES\MediaInfo"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails nevershow
ShowUnInstDetails nevershow

Function .onInit
  ${If} ${RunningX64}
    MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 'You are trying to install the 32-bit version of ${PRODUCT_NAME} on 64-bit Windows.$\r$\nPlease download and use the 64-bit version instead.$\r$\nContinue with the installation of the 32-bit version?' IDYES noprob
  Quit
  noprob:
  ${Else}
  ${EndIf}
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "SectionPrincipale" SEC01
  SetOverwrite ifnewer
  SetOutPath "$INSTDIR"
  CreateDirectory "$SMPROGRAMS\MediaInfo"
  CreateShortCut "$SMPROGRAMS\MediaInfo\MediaInfo.lnk" "$INSTDIR\MediaInfo.exe" "" "" "" "" "" "MediaInfo ${PRODUCT_VERSION}"
  File "/oname=MediaInfo.exe" "..\..\Project\BCB\GUI\Release_Build\MediaInfo_GUI.exe"
  File "..\..\..\MediaInfoLib\Project\MSVC\ShellExtension\Win32\Release\MediaInfo_InfoTip.dll"
  File "..\..\..\MediaInfoLib\Project\MSVC2005\DLL\Win32\Release\MediaInfo.dll"
  File "/oname=History.txt" "..\..\History_GUI.txt"
  File "..\..\License.html"
  File  "/oname=ReadMe.txt""..\..\Release\ReadMe_GUI_Windows.txt"
  SetOverwrite try
  SetOutPath "$INSTDIR\Plugin\Custom"
  File "..\Ressource\Plugin\Custom\*.csv"
  SetOutPath "$INSTDIR\Plugin\Language"
  File "..\Ressource\Plugin\Language\*.csv"
  SetOutPath "$INSTDIR\Plugin\Sheet"
  File "..\Ressource\Plugin\Sheet\*.csv"
  SetOutPath "$INSTDIR\Plugin\Tree"
  File "..\Ressource\Plugin\Tree\*.csv"

  # Delete files that might be present from older installation
  Delete "$INSTDIR\History_GUI.txt"
  Delete "$INSTDIR\Licence.txt"
  Delete "$INSTDIR\Licence.html"
  Delete "$INSTDIR\License.txt"
  Delete "$INSTDIR\ReadMe_Windows.txt"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\MediaInfo\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url" "" "" "" "" "" "Website"
  CreateShortCut "$SMPROGRAMS\MediaInfo\Uninstall.lnk" "$INSTDIR\uninst.exe" "" "" "" "" "" "Uninstall MediaInfo"
  CreateShortCut "$SMPROGRAMS\MediaInfo\History.lnk" "$INSTDIR\History.txt" "" "" "" "" "" "History"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\MediaInfo.exe"
  ${If} ${RunningX64}
    DeleteRegValue HKLM "Software\MediaArea.net\MediaInfo" "DisplayName"
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name) (32-bit)"
  ${Else}
    WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  ${EndIf}
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\MediaInfo.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  Exec 'regsvr32 "$INSTDIR\MediaInfo_InfoTip.dll" /s'
  !insertmacro MediaInfo_Extensions_Install
SectionEnd


Section Uninstall
  !insertmacro MediaInfo_Extensions_Uninstall
  Exec 'regsvr32 "$INSTDIR\MediaInfo_InfoTip.dll" /u /s'
  Sleep 3000

  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\MediaInfo.exe"
  Delete "$INSTDIR\MediaInfo_InfoTip.dll"
  Delete "$INSTDIR\MediaInfo.dll"
  Delete "$INSTDIR\History.txt"
  Delete "$INSTDIR\License.html"
  Delete "$INSTDIR\ReadMe.txt"
  Delete "$INSTDIR\Plugin\MediaInfo.cfg"
  Delete "$INSTDIR\Plugin\Custom\*.csv"
  Delete "$INSTDIR\Plugin\Language\*.csv"
  Delete "$INSTDIR\Plugin\Sheet\*.csv"
  Delete "$INSTDIR\Plugin\Tree\*.csv"
  Delete "$SMPROGRAMS\MediaInfo\Uninstall.lnk"
  Delete "$SMPROGRAMS\MediaInfo\Website.lnk"
  Delete "$SMPROGRAMS\MediaInfo\MediaInfo.lnk"
  Delete "$SMPROGRAMS\MediaInfo\History.lnk"

  RMDir "$SMPROGRAMS\MediaInfo"
  RMDir "$INSTDIR\Plugin\Custom"
  RMDir "$INSTDIR\Plugin\Language"
  RMDir "$INSTDIR\Plugin\Sheet"
  RMDir "$INSTDIR\Plugin\Tree"
  RMDir "$INSTDIR\Plugin"
  RMDir "$INSTDIR"

  DeleteRegKey HKCR "SystemFileAssociations\.3gp\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.3gpp\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.aac\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ac3\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ape\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.asf\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.avi\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.bdmv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.clpi\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.divx\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.dpg\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.dts\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.dv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.dvr\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.dvr-m\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.eac3\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.evo\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.flac\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.flv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.gvi\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.h264\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ifo\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.isma\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ismv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.j2k\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.jp2\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m1s\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m1t\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m1v\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m2s\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m2t\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m2ts\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m2v\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m4a\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.m4v\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mac\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mka\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mks\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mkv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mod\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mov\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mp+\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mp2\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mp3\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mp4\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpc\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpe\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpeg\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpg\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpgv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpgx\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpls\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpm\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mpv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.mxf\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.oga\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ogg\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ogm\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ogv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.qt\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ra\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.rm\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.rmvb\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.smv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.swf\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.tp\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.trp\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.ts\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.tta\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.vob\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.w64\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.wav\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.wma\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.wmv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.wv\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\.wvc\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\audio\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\Directory.Audio\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\Directory.Video\Shell\MediaInfo"
  DeleteRegKey HKCR "SystemFileAssociations\video\Shell\MediaInfo"

  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.3gp\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.3gpp\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.aac\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ac3\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ape\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.asf\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.avi\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.bdmv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.clpi\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.divx\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.dpg\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.dts\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.dv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.dvr\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.dvr-m\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.eac3\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.evo\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.flac\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.flv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.gvi\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.h264\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ifo\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.isma\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ismv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.j2k\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.jp2\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m1s\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m1t\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m1v\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m2s\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m2t\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m2ts\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m2v\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m4a\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.m4v\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mac\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mka\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mks\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mkv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mod\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mov\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mp+\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mp2\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mp3\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mp4\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpc\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpe\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpeg\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpg\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpgv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpgx\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpls\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpm\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mpv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.mxf\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.oga\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ogg\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ogm\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ogv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.qt\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ra\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.rm\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.rmvb\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.smv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.swf\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.tp\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.trp\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.ts\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.tta\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.vob\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.w64\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.wav\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.wma\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.wmv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.wv\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\.wvc\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\audio\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\Directory.Audio\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\Directory.Video\Shell"
  DeleteRegKey /ifempty HKCR "SystemFileAssociations\video\Shell"

  ReadRegStr $1 HKCR ".mkv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mka" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mks" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ogg" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ogm" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".oga" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ogv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".wav" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".avi" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".divx" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpeg" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpg" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".dat" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpe" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpgx" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpm" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m1s" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m1t" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".vob" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m2s" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m2t" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ts" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".tp" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mp4" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m4a" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m4v" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpgv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m1v" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m2v" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mp2" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mp3" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpc" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mp+" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".asf" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".wmv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".wma" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mov" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".qt" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".rm" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".rmvb" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ra" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ifo" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ac3" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".dts" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".aac" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ape" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mac" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".flac" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".3gp" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".swf" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".flv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".m2ts" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".gvi" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".3gpp" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".evo" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".eac3" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".dv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".jp2" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".j2k" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".h264" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".dvr" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".dvr-ms" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mod" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".isma" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".ismv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".smv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".trp" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".tta" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".w64" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".wv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".wvc" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".bdmv" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mpls" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".clpi" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR ".mxf" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"
  ReadRegStr $1 HKCR "Folder" ""
  DeleteRegKey HKCR "$1\Shell\Media Info"
  DeleteRegKey HKCR "$1\Shell\MediaInfo"
  DeleteRegKey /ifempty HKCR "$1\Shell"
  DeleteRegKey /ifempty HKCR "$1"

  DeleteRegKey HKLM "${PRODUCT_REGISTRY}"
  DeleteRegKey /ifempty HKLM "${COMPANY_REGISTRY}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
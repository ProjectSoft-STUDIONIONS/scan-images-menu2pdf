#define MyAppVersion "2.9.3"
#define MyAppName "ConvertMenu2pdf"
#define MyAppPublisher "ProjectSoft © 2008 - all right reserved"
#define MyAppURL "https://github.com/ProjectSoft-STUDIONIONS/scan-images-menu2pdf"
#define MyAppExeName "programm.exe"      
#define MyAppTitle "Конвертирование отсканированных изображений меню в PDF файлы"
#define NodeVersion="v26.10.0"
#define NodeFile "node-v26.10.0-x64.msi"

[Setup]
AppId={{6366BCA4-F02D-4CFF-A3DA-F50CE9EF1162}
AppName={#MyAppTitle}
AppVersion={#MyAppVersion}
AppVerName={#MyAppTitle} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL=https://projectsoft.ru/
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}/releases/latest
AppCopyright={#MyAppPublisher}
VersionInfoVersion={#MyAppVersion}
DefaultDirName=c:\{#MyAppName}\
DisableDirPage=no
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE
PrivilegesRequired=admin
OutputDir=..\inno_setup
OutputBaseFilename=ConvertMenu2pdf_setup
SetupIconFile=..\app\favicon.ico
UninstallDisplayIcon={app}\bin\{#MyAppExeName},0
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[CustomMessages]
english.SetupNode=Install Node.js {#NodeVersion}
russian.SetupNode=Установить Node.js {#NodeVersion}
english.InstallNode=Installation Node.js {#NodeVersion}...
russian.InstallNode=Установка Node.js {#NodeVersion}...
english.Additionally=Additionally:
russian.Additionally=Дополнительно:

[Tasks]
Name: "installNode"; Description: "{cm:SetupNode}"; GroupDescription: "{cm:Additionally}"
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: ".\{#NodeFile}"; DestDir: "{tmp}"; Flags: deleteafterinstall
Source: "..\bin\{#MyAppExeName}"; DestDir: "{app}\bin\"; Flags: ignoreversion
Source: "..\index.js"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.de.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.en.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.ru.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\menu.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\package.json"; DestDir: "{app}"; Flags: ignoreversion 
Source: "..\modules\dialogs\*"; DestDir: "{app}\modules\dialogs"; Flags: ignoreversion
Source: "..\modules\dialogs\dist\*"; DestDir: "{app}\modules\dialogs\dist"; Flags: ignoreversion
Source: "..\modules\playbeep\*"; DestDir: "{app}\modules\playbeep"; Flags: ignoreversion
Source: "..\node_modules\*"; DestDir: "{app}\node_modules"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\.bin\*"; DestDir: "{app}\node_modules\.bin\"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; Node.js: тихий режим установки
Filename: "{sys}\msiexec.exe"; Parameters: "/i ""{tmp}\{#NodeFile}"" /quiet /norestart"; Tasks: installNode; StatusMsg: "{cm:InstallNode}"; Flags: waituntilterminated

[UninstallDelete]
Type: files; Name: "{app}\bin\*.*"
Type: files; Name: "{app}\modules\dialogs\dist\*.*"


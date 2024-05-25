#define MyAppVersion "2.8.4"
#define MyAppName "ConvertMenu2pdf"
#define MyAppPublisher "ProjectSoft © 2008 - all right reserved"
#define MyAppURL "https://github.com/ProjectSoft-STUDIONIONS/scan-images-menu2pdf"
#define MyAppExeName "programm.exe"      
#define MyAppTitle "Конвертирование отсканированных изображений меню в PDF файлы"

[Setup]
AppId={{6366BCA4-F02D-4CFF-A3DA-F50CE9EF1162}
AppName={#MyAppTitle}
AppVersion={#MyAppVersion}
AppVerName={#MyAppTitle} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL=https://projectsoft.ru/
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}/releases/latest
DefaultDirName=c:\{#MyAppName}\
DisableDirPage=no
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE.md
;PrivilegesRequired=lowest
OutputDir=..\inno_setup
OutputBaseFilename=ConvertMenu2pdf_setup
SetupIconFile=..\app\favicon.ico
UninstallDisplayIcon={app}\bin\{#MyAppExeName},0
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "..\bin\{#MyAppExeName}"; DestDir: "{app}\bin\"; Flags: ignoreversion
Source: "..\build.js"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\index.js"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.de.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.en.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.ru.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\menu.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\package.json"; DestDir: "{app}"; Flags: ignoreversion 
Source: "..\assets\*"; DestDir: "{app}\assets\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\modules\dialogs\*"; DestDir: "{app}\modules\dialogs"; Flags: ignoreversion
Source: "..\modules\dialogs\dist\*"; DestDir: "{app}\modules\dialogs\dist"; Flags: ignoreversion
Source: "..\modules\playbeep\*"; DestDir: "{app}\modules\playbeep"; Flags: ignoreversion
Source: "..\node_modules\@pdf-lib\*"; DestDir: "{app}\node_modules\@pdf-lib\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\ansi-regex\*"; DestDir: "{app}\node_modules\ansi-regex\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\cli-progress\*"; DestDir: "{app}\node_modules\cli-progress\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\colors\*"; DestDir: "{app}\node_modules\colors\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\emoji-regex\*"; DestDir: "{app}\node_modules\emoji-regex\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\is-fullwidth-code-point\*"; DestDir: "{app}\node_modules\is-fullwidth-code-point\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\pako\*"; DestDir: "{app}\node_modules\pako\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\pdf-lib\*"; DestDir: "{app}\node_modules\pdf-lib\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\string-width\*"; DestDir: "{app}\node_modules\string-width\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\strip-ansi\*"; DestDir: "{app}\node_modules\strip-ansi\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\tslib\*"; DestDir: "{app}\node_modules\tslib\"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\bin\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppTitle, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]                 
Type: files; Name: "{app}\bin\*.*"
Type: files; Name: "{app}\modules\dialogs\dist\*.*"


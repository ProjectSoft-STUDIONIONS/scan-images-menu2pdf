; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "CnvertMenu2pdf"
#define MyAppVersion "2.8.3"
#define MyAppPublisher "ProjectSoft � 2008 - all right reserved"
#define MyAppURL "https://github.com/ProjectSoft-STUDIONIONS/scan-images-menu2pdf"
#define MyAppExeName "programm.exe"      
#define MyAppTitle "��������������� ��������������� ����������� ���� � PDF �����"

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
; Uncomment the following line to run in non administrative install mode (install for current user only.)
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
Source: "..\bin\programm.ini"; DestDir: "{app}\bin\"; Flags: ignoreversion
Source: "..\.gitignore"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\build.js"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\index.js"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.de.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.en.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\language.ru.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\menu.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\package.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\package-lock.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\scan-images-menu2pdf.sublime-project"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\scan-images-menu2pdf.sublime-settings"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\app\*"; DestDir: "{app}\app\"; Flags: ignoreversion recursesubdirs createallsubdirs  
Source: "..\assets\*"; DestDir: "{app}\assets\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\modules\*"; DestDir: "{app}\modules\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\*"; DestDir: "{app}\node_modules\"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\bin\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppTitle, '&', '&&')}}"; Flags: nowait postinstall skipifsilent


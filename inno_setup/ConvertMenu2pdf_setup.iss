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
LicenseFile=..\LICENSE
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
; Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\menu.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\package.json"; DestDir: "{app}"; Flags: ignoreversion 
Source: "..\assets\*"; DestDir: "{app}\assets\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\modules\dialogs\*"; DestDir: "{app}\modules\dialogs"; Flags: ignoreversion
Source: "..\modules\dialogs\dist\*"; DestDir: "{app}\modules\dialogs\dist"; Flags: ignoreversion
Source: "..\modules\playbeep\*"; DestDir: "{app}\modules\playbeep"; Flags: ignoreversion
Source: "..\node_modules\@jimp\*"; DestDir: "{app}\node_modules\@jimp\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\@pdf-lib\*"; DestDir: "{app}\node_modules\@pdf-lib\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\ansi-regex\*"; DestDir: "{app}\node_modules\ansi-regex\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\any-base\*"; DestDir: "{app}\node_modules\any-base\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\base64-js\*"; DestDir: "{app}\node_modules\base64-js\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\bmp-js\*"; DestDir: "{app}\node_modules\bmp-js\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\buffer\*"; DestDir: "{app}\node_modules\buffer\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\buffer-equal\*"; DestDir: "{app}\node_modules\buffer-equal\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\centra\*"; DestDir: "{app}\node_modules\centra\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\cli-progress\*"; DestDir: "{app}\node_modules\cli-progress\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\colors\*"; DestDir: "{app}\node_modules\colors\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\core-js\*"; DestDir: "{app}\node_modules\core-js\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\dom-walk\*"; DestDir: "{app}\node_modules\dom-walk\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\emoji-regex\*"; DestDir: "{app}\node_modules\emoji-regex\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\exif-parser\*"; DestDir: "{app}\node_modules\exif-parser\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\file-type\*"; DestDir: "{app}\node_modules\file-type\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\follow-redirects\*"; DestDir: "{app}\node_modules\follow-redirects\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\global\*"; DestDir: "{app}\node_modules\global\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\ieee754\*"; DestDir: "{app}\node_modules\ieee754\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\is-fullwidth-code-point\*"; DestDir: "{app}\node_modules\is-fullwidth-code-point\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\is-function\*"; DestDir: "{app}\node_modules\is-function\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\jimp\*"; DestDir: "{app}\node_modules\jimp\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\jpeg-js\*"; DestDir: "{app}\node_modules\jpeg-js\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\load-bmfont\*"; DestDir: "{app}\node_modules\load-bmfont\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\mime\*"; DestDir: "{app}\node_modules\mime\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\min-document\*"; DestDir: "{app}\node_modules\min-document\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\minimist\*"; DestDir: "{app}\node_modules\minimist\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\mkdirp\*"; DestDir: "{app}\node_modules\mkdirp\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\omggif\*"; DestDir: "{app}\node_modules\omggif\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\pako\*"; DestDir: "{app}\node_modules\pako\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\parse-bmfont-ascii\*"; DestDir: "{app}\node_modules\parse-bmfont-ascii\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\parse-bmfont-binary\*"; DestDir: "{app}\node_modules\parse-bmfont-binary\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\parse-bmfont-xml\*"; DestDir: "{app}\node_modules\parse-bmfont-xml\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\parse-headers\*"; DestDir: "{app}\node_modules\parse-headers\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\pdf-lib\*"; DestDir: "{app}\node_modules\pdf-lib\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\phin\*"; DestDir: "{app}\node_modules\phin\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\pixelmatch\*"; DestDir: "{app}\node_modules\pixelmatch\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\pngjs\*"; DestDir: "{app}\node_modules\pngjs\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\process\*"; DestDir: "{app}\node_modules\process\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\regenerator-runtime\*"; DestDir: "{app}\node_modules\regenerator-runtime\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\resize-optimize-images\*"; DestDir: "{app}\node_modules\resize-optimize-images\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\sax\*"; DestDir: "{app}\node_modules\sax\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\string-width\*"; DestDir: "{app}\node_modules\string-width\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\strip-ansi\*"; DestDir: "{app}\node_modules\strip-ansi\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\timm\*"; DestDir: "{app}\node_modules\timm\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\tinycolor2\*"; DestDir: "{app}\node_modules\tinycolor2\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\tslib\*"; DestDir: "{app}\node_modules\tslib\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\utif\*"; DestDir: "{app}\node_modules\utif\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\xhr\*"; DestDir: "{app}\node_modules\xhr\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\xml-parse-from-string\*"; DestDir: "{app}\node_modules\xml-parse-from-string\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\xml2js\*"; DestDir: "{app}\node_modules\xml2js\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\xmlbuilder\*"; DestDir: "{app}\node_modules\xmlbuilder\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\xtend\*"; DestDir: "{app}\node_modules\xtend\"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\node_modules\.bin\*"; DestDir: "{app}\node_modules\.bin\"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\bin\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppTitle, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]                 
Type: files; Name: "{app}\bin\*.*"
Type: files; Name: "{app}\modules\dialogs\dist\*.*"


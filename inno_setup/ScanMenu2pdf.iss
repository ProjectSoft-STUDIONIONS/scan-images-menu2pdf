#include "version.iss"
#define MyAppName "ScanMenu2pdf"
#define MyAppPublisher "ProjectSoft © 2008 - all right reserved"
#define MyAppURL "https://github.com/ProjectSoft-STUDIONIONS/scan-images-menu2pdf"
#define MyAppExeName "scanmenu2pdf.exe"      
#define MyAppTitle "Конвертирование отсканированных изображений меню в PDF файлы"
#define NodeVersion="v26.13.1"
#define NodeFile "node-x64.msi"

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
DisableWelcomePage=no
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE
PrivilegesRequired=admin
OutputDir=..\inno_setup
OutputBaseFilename=ScanMenu2pdf
SetupIconFile=..\app\favicon.ico
UninstallDisplayIcon={app}\bin\{#MyAppExeName},0
Compression=lzma
SolidCompression=yes
WizardStyle=dark
WizardBackImageFile=matrix.png
WizardImageFile=image.png
WizardSmallImageFile=smal.png
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
SetupArchitecture=x64

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
english.MyAppTitle=Convert scanned menu images to PDF files
russian.MyAppTitle=Конвертирование отсканированных изображений меню в PDF файлы

[Tasks]
Name: "installNode"; Description: "{cm:SetupNode}"; GroupDescription: "{cm:Additionally}"
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "./{#NodeFile}"; DestDir: "{tmp}"; Flags: deleteafterinstall; Check: IsInstallNodeSelected
// Check параметр выбрана ли задача
Source: "../bin/{#MyAppExeName}"; DestDir: "{app}/bin/"; Flags: ignoreversion
Source: "../index.js"; DestDir: "{app}"; Flags: ignoreversion
Source: "../language.de.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "../language.en.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "../language.ru.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "../menu.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "../package.json"; DestDir: "{app}"; Flags: ignoreversion
// Все остальные файлы из modules и node_modules
#include "files.iss"

[Icons]
Name: "{autoprograms}\{cm:MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"
Name: "{autodesktop}\{cm:MyAppTitle}"; Filename: "{app}\bin\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; Node.js: тихий режим установки
Filename: "{sys}\msiexec.exe"; Parameters: "/i ""{tmp}\{#NodeFile}"" /quiet /norestart"; Tasks: installNode; StatusMsg: "{cm:InstallNode}"; Flags: waituntilterminated

[UninstallDelete]
; Удаление созданных программой файлов
Type: files; Name: "{app}/bin/*.*"
Type: files; Name: "{app}/modules/dialogs/dist/*.*"

[Code]
// Функция проверки, выбрана ли задача installNode
function IsInstallNodeSelected: Boolean;
begin
	Result := WizardIsTaskSelected('installNode');
end;

// Проверка: установлена ли Node.js.
// Официальный MSI-установщик Node.js пишет ключ в реестр — по нему и определяем
function IsNodeInstalled(): Boolean;
begin
	Result :=
		RegKeyExists(HKLM, 'SOFTWARE\Node.js') or
		RegKeyExists(HKLM, 'SOFTWARE\WOW6432Node\Node.js') or
		RegKeyExists(HKCU, 'SOFTWARE\Node.js');
end;

// Поиск задачи SetupNode в списке задач
function FindNodeTask(): Integer;
var
	I: Integer;
	Wanted: String;
begin
	Result := -1;
	Wanted := Trim(CustomMessage('SetupNode'));
	for I := 0 to WizardForm.TasksList.Items.Count - 1 do
	begin
		if Trim(WizardForm.TasksList.ItemCaption[I]) = Wanted then
		begin
			Result := I;
			Break;
		end;
	end;
end;

procedure CurPageChanged(CurPageID: Integer);
var
	Idx: Integer;
begin
	if CurPageID = wpSelectTasks then
	begin
		Idx := FindNodeTask();
		if Idx >= 0 then
		begin
			if IsNodeInstalled() then
			begin
				// Node есть: снимаем галочку, чекбокс остаётся доступным — установка по желанию
				WizardForm.TasksList.CheckItem(Idx, coUncheck);
				WizardForm.TasksList.ItemEnabled[Idx] := True;
			end
			else
			begin
				// Node нет: галочка стоит и снять её нельзя — без Node приложение бесполезно
				WizardForm.TasksList.CheckItem(Idx, coCheck);
				WizardForm.TasksList.ItemEnabled[Idx] := False;
			end;
		end;
	end;
end;



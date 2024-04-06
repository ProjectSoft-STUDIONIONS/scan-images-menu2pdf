program dialogs;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Vcl.Forms, Vcl.dialogs, System.SysUtils, Vcl.Controls,
  System.JSON, Windows, System.UITypes,
  Unit1 in 'Unit1.pas' {Form1};


function JsonToString(aJson: TJsonObject): string;
begin
  Result := aJson.ToString();
end;

function StringToJson(aString: string): TJsonObject;
begin
  Result := TJsonObject.ParseJSONValue(aString) as TJsonObject;
end;

(***************************

  Пограмма возвращает строку JSON
  typemenu        Индекс типа меню
  directory       Полный путь до директории с изображениями
  data            Значения даты и времени в формате UNIX
  error           Тип ошибки
  convert         Тип используемого конвертора
  Формат
  {"typemenu": "0", "directory": "C:\\Temp\\ScanDir", "data": "1702880641", "error": "0", "convert": "magick"}

  Индекс ошибок "error"
  0 - Ошибок нет
  1 - Программа запущена без параметров
  2 - Файл, переданный в параметре --typemenu, не существует
  3 - Программу завершил пользователь.

***************************)
var
  fileName, jsn  : string;
  versionApp     : string;
  i              : Integer;
  jo             : TJsonObject;
  Handle         : THandle;
begin
  SetConsoleOutputCP(CP_UTF8);
  Handle         := GetForegroundWindow;
  try
    if ParamCount > 0 then
    begin
      for i := 1 to ParamCount do
      begin
        if ParamStr(i) = '--typemenu' then
        begin
          fileName := ParamStr(i + 1);
          if (System.SysUtils.FileExists(fileName)) then
          begin
            try
              FindCmdLineSwitch('version', versionApp, True, [clstValueNextParam, clstValueAppended]);
              Application.Handle     := Handle;
              Form1                  := TForm1.Create(nil);
              if Length(versionApp) > 0 then
                versionApp := ' v' + versionApp
              else
                versionApp     := '1.0.0';
              Form1.VersionApp       := versionApp;
              Form1.fileName         := fileName;
              Form1.SendJSON(fileName);
              Form1.HandleNeeded;
              EnableWindow(Handle, False);
              if IsPositiveResult(Form1.ShowModal) then
              begin
                // Чтение JSON
                jo  := TJsonObject.Create();
                jo.AddPair(TJSONPair.Create('typemenu', IntToStr(Form1.typemenu)));
                jo.AddPair(TJSONPair.Create('directory', Form1.directory));
                jo.AddPair(TJSONPair.Create('data', IntToStr(Form1.intData)));
                jo.AddPair(TJSONPair.Create('index', Form1.index));
                jo.AddPair(TJSONPair.Create('convert', Form1.convert));
                jo.AddPair(TJSONPair.Create('error', '0'));
                jsn := jo.ToJSON();
                jo.Free;
                writeLn(jsn);
              end
              else
              begin
                writeLn('{"message": "Aborted by user", "error": "3"}');
              end;
            finally
              Form1.Free;
            end;
            break;
          end
          else
          begin
            writeLn('{"message": "File '+fileName+' does not exist", "error": "2"}');
            break;
          end;
        end;
      end;
    end
    else
    begin
      writeLn('{"message": "Launched without parameters", "error": "1"}');
    end;
  finally
    EnableWindow(Handle, True);
    SetForegroundWindow(Handle);
  end;
end.

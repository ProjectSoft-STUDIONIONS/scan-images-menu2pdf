program dialogs;

{$APPTYPE CONSOLE}

uses
  Vcl.Forms, Vcl.dialogs, System.SysUtils, Vcl.Controls,
  System.JSON, Windows,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

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
  Формат
  {"typemenu": "0", "directory": "C:\\Temp\\ScanDir", "data": "1702880641", "error": "0"}

  Индекс ошибок "error"
  0 - Ошибок нет
  1 - Программа запущена без параметров
  2 - Файл, переданный в параметре --typemenu, не существует
  3 - Программу завершил пользователь.

***************************)
var
  fileName, jsn: string;
  i: Integer;
  jo: TJsonObject;
  Handle: THandle;
begin
  SetConsoleOutputCP(CP_UTF8);
  Handle := GetForegroundWindow;
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
  if ParamCount > 0 then
  begin
    for i := 1 to ParamCount do
    begin
      if ParamStr(i) = '--typemenu' then
      begin
        fileName := ParamStr(i + 1);
        if (System.SysUtils.FileExists(fileName)) then
        begin
          Form1 := TForm1.Create(nil);
          Form1.HandleNeeded;
          SetWindowLongPtr(Form1.Handle, GWLP_HWNDPARENT, Handle);
          Form1.fileName := fileName;
          Form1.SendJSON(fileName);
          if Form1.ShowModal = mrOk then
          begin
            // Чтение JSON
            jo := TJsonObject.Create();
            jo.AddPair(TJSONPair.Create('typemenu', IntToStr(Form1.typemenu)));
            jo.AddPair(TJSONPair.Create('directory', Form1.directory));
            jo.AddPair(TJSONPair.Create('data', IntToStr(Form1.intData)));
            jo.AddPair(TJSONPair.Create('index', Form1.index));
            jo.AddPair(TJSONPair.Create('error', '0'));
            jsn := jo.ToJSON();
            writeLn(jsn);
            jo.Free;
          end
          else
          begin
            writeLn('{"error": 3}');
          end;
          Form1.Free;
          break;
        end
        else
        begin
          writeLn('{"error": 2}');
          Form1.Free;
          break;
        end;
      end;
    end;
  end
  else
  begin
    writeLn('{"error": 1}');
  end;

end.

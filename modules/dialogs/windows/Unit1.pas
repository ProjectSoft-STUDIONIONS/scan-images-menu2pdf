unit Unit1;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, System.Generics.Collections,
    System.JSON, System.IOUtils, Vcl.Graphics, FileCtrl, IniFiles,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DateUtils, Vcl.WinXCalendars,
    Vcl.ComCtrls,
    Vcl.StdCtrls, Vcl.Grids, Vcl.Samples.Calendar, Vcl.Buttons,
    System.ImageList,  ShlObj,
    Vcl.ImgList, Vcl.ExtCtrls;

// Продумать локализацию
// Основные переменные здесь

type
    TForm1 = class(TForm)
        Calendar1: TCalendar;
        MonthBox: TComboBox;
        YearBox: TComboBox;
        ImageList1: TImageList;
        DateLabel: TLabel;
        DirectoryLabel: TLabel;
        MenuLabel: TLabel;
        GroupBox1: TGroupBox;
        TypeMenuBox: TComboBox;
        DialogButton: TButton;
        StartButton: TButton;
        Panel1: TPanel;
        Panel2: TPanel;
        Panel3: TPanel;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        GroupBox2: TGroupBox;
        Panel4: TScrollBox;
        ComboTypeConvert: TComboBox;
        LabelTypeConvert: TLabel;
        procedure FormCreate(Sender: TObject);
        procedure MonthBoxChange(Sender: TObject);
        procedure Calendar1Change(Sender: TObject);
        procedure DialogButtonClick(Sender: TObject);
        procedure TypeMenuBoxChange(Sender: TObject);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure FormShow(Sender: TObject);
        procedure SendJSON(FName: string);
        procedure SendJSON_type(FName: string; indx: integer);
        procedure CheckBox1Click(Sender: TObject);
        procedure Panel4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
        procedure Panel4MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
        procedure ComboTypeConvertChange(Sender: TObject);
    private
        { Private declarations }
        // Lang
        StrSelectDir: string;
        StrError: string;
        StrWarning: string;
        StrErrorTypeMenu: string;
        StrErrorDate: string;
        StrErrorSelectDir: string;
        StrUserAbort: string;
        StrErrorReadFile: string;
        GroupBox1Str: string;
        Label1Str: string;
        Label2Str: string;
        Label3Str: string;
        StartButtonStr: string;
        CalendarStr: string;
        MenuGenerate: string;
        TypeConvert: string;
        FileJSON: string;
        procedure LoadProject;
    public
        { Public declarations }
        fileName: string;
        directory: string;
        typemenu: integer;
        data: string;
        intData: integer;
        appPath: string;
        index: string;
        convert: string;
    end;

var
    Form1: TForm1;

implementation

{$R *.dfm}


function BrowseCallbackProc(hwnd: HWND; MessageID: UINT; lParam: LPARAM; lpData: LPARAM): Integer; stdcall;
var
    DirName:  array[0..MAX_PATH] of Char;
    pIDL   :  pItemIDList;
begin
  case  MessageID    of
    BFFM_INITIALIZED: SendMessage(hwnd, BFFM_SETSELECTION, 1, lpData);
    BFFM_SELCHANGED : begin
                         pIDL := Pointer(lParam);
                         if  Assigned(PIDL) then
                         begin
                           SHGetPathFromIDList(pIDL, DirName);
                           if System.SysUtils.DirectoryExists(DirName) then
                              SendMessage(hwnd, BFFM_ENABLEOK, 0, 1) //enable the ok button
                           else
                              SendMessage(hwnd, BFFM_ENABLEOK, 0, 0);
                         end
                         else
                           SendMessage(hwnd, BFFM_ENABLEOK, 0, 0);
                      end;
  end;

  Result := 0;
end;

function SelectFolderDialogExt(Handle: Integer; Title: string; var SelectedFolder: string): Boolean;
var
  ItemIDList: PItemIDList;
  JtemIDList: PItemIDList;
  DialogInfo: TBrowseInfo;
  Path: PWideChar;
begin
  Result := False;
  Path   := StrAlloc(MAX_PATH);
  SHGetSpecialFolderLocation(Handle, CSIDL_DRIVES, JtemIDList);
  with DialogInfo do
  begin
    pidlRoot      := JtemIDList;
    ulFlags       := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE or BIF_EDITBOX;
    hwndOwner     := GetActiveWindow;
    SHGetSpecialFolderLocation(hwndOwner, CSIDL_DRIVES, JtemIDList);
    pszDisplayName:= StrAlloc(MAX_PATH);
    lpszTitle     := PChar(Title);
    lpfn          := @BrowseCallbackProc;
    lParam        := LongInt(PChar(SelectedFolder));
  end;

  ItemIDList := SHBrowseForFolder(DialogInfo);

  if (ItemIDList <> nil) then
    if SHGetPathFromIDList(ItemIDList, Path) then
    begin
      SelectedFolder := Path;
      Result         := True;
    end;
end;

function ReadFromFile(fileName: string; Encoding: TEncoding): WideString;
Var
    List: TStrings;
begin
    Result := '';
    fileName := trim(fileName);
    if FileExists(fileName) then
    begin
        List := TStringList.Create;
        TRY
            List.LoadFromFile(fileName, Encoding);
            Result := List.Text;
        FINALLY
            FreeAndNil(List);
        END;
    end;
end;

function GetLocaleInformation(Flag: Integer): string;
var
    pcLCA: array [0..20] of Char;
begin
    if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, Flag, pcLCA, 19) <= 0 then
        pcLCA[0] := #0;
    Result := LowerCase(pcLCA);
end;

function ArrayToStr2(str: TStrings; R: Char): string;
begin
    str.Delimiter := R;
    result := str.DelimitedText;
end;

procedure TForm1.LoadProject;
var
    lang: string;
    ini: TIniFile;
    iniFile: string;
    i: integer;
begin
    appPath := ExtractFilePath(Application.ExeName);
    // Обычный ini файл локализации.
    // В GroupBox указано название КАЛЕНДАРЬ + локализация в скобках
    // Это имя файла, которое нужно использовать в своей локализации.
    lang := GetLocaleInformation(LOCALE_SENGLANGUAGE);
	  // Локализация по дефолту русская
    iniFile := TPath.Combine(appPath, lang + '.ini');
    ini := TIniFile.Create(iniFile);
	  // Если определённой секции с ключём нет, то устанавливаем дефолтное значение
	  // Читаем файл локализации.
    GroupBox1Str          := ini.ReadString('Lang', 'GroupBox1Str', 'КАЛЕНДАРЬ');
    StrWarning            := ini.ReadString('Lang', 'StrWarning', 'Внимание');
    StrError              := ini.ReadString('Lang', 'StrError', 'Ошибка');
    StrSelectDir          := ini.ReadString('Lang', 'StrSelectDir', 'Выбор директории с изображениями');
    StrErrorTypeMenu      := ini.ReadString('Lang', 'StrErrorTypeMenu', 'Не выбран тип меню');
    StrErrorDate          := ini.ReadString('Lang', 'StrErrorDate', 'Не выбрана дата');
    StrErrorSelectDir     := ini.ReadString('Lang', 'StrErrorSelectDir', 'Не выбрана директория');
    StrUserAbort          := ini.ReadString('Lang', 'StrUserAbort', 'Прервано пользователем');
    StrErrorReadFile      := ini.ReadString('Lang', 'StrErrorReadFile', 'Ошибка чтения файла');
    Label1Str             := ini.ReadString('Lang', 'Label1Str', 'Выбранная дата');
    Label2Str             := ini.ReadString('Lang', 'Label2Str', 'Выбранная директория');
    Label3Str             := ini.ReadString('Lang', 'Label3Str', 'Тип меню');
    StartButtonStr        := ini.ReadString('Lang', 'StartButtonStr', 'Запуск программы');
    CalendarStr           := ini.ReadString('Lang', 'CalendarStr', 'Запуск программы');
    MenuGenerate          := ini.ReadString('Lang', 'MenuGenerate', 'Меню для генерации');
    TypeConvert           := ini.ReadString('Lang', 'TypeConvert', 'Тип конвертора');
	  // Пишем назад прочтённые данные
    ini.WriteString('Lang', 'StrSelectDir', StrSelectDir);
    ini.WriteString('Lang', 'StrError', StrError);
    ini.WriteString('Lang', 'StrWarning', StrWarning);
    ini.WriteString('Lang', 'StrErrorTypeMenu', StrErrorTypeMenu);
    ini.WriteString('Lang', 'StrErrorDate', StrErrorDate);
    ini.WriteString('Lang', 'StrErrorSelectDir', StrErrorSelectDir);
    ini.WriteString('Lang', 'StrUserAbort', StrUserAbort);
    ini.WriteString('Lang', 'StrErrorReadFile', StrErrorReadFile);
    ini.WriteString('Lang', 'GroupBox1Str', GroupBox1Str);
    ini.WriteString('Lang', 'Label1Str', Label1Str);
    ini.WriteString('Lang', 'Label2Str', Label2Str);
    ini.WriteString('Lang', 'Label3Str', Label3Str);
    ini.WriteString('Lang', 'StartButtonStr', StartButtonStr);
    ini.WriteString('Lang', 'CalendarStr', CalendarStr);
    ini.WriteString('Lang', 'MenuGenerate', MenuGenerate);
    ini.WriteString('Lang', 'TypeConvert', TypeConvert);
    ini.Free;

    typemenu := -1;
    data := '';
    directory := '';
	  // Мелкие настройки программы.
	  // Они только для удобства использования программы
    iniFile := TPath.Combine(appPath, 'settings.ini');
    ini := TIniFile.Create(iniFile);
    directory := ini.ReadString('Directory', 'SelectDir', '');
    i := ini.ReadInteger('TypeConvert', 'Type', 0);
    if not System.SysUtils.DirectoryExists(directory) then
    begin
        directory := '';
        ini.WriteString('Directory', 'SelectDir', directory);
    end;
    if i >= ComboTypeConvert.Items.Count then
    begin
        i := 0;
    end;
    if i < 0 then
    begin
      i := 0;
    end;
    ComboTypeConvert.ItemIndex := i;
    ini.WriteInteger('TypeConvert', 'Type', i);
    ini.Free;
    convert := ComboTypeConvert.Items[ComboTypeConvert.ItemIndex];
    // Локаль
	  // Устанавливаем локальные значения в контроллах программы
    GroupBox1.Caption           := GroupBox1Str + ' (' + lang + ')';
    Label1.Caption              := Label1Str;
    Label2.Caption              := Label2Str;
    Label3.Caption              := Label3Str;
    DialogButton.Caption        := StrSelectDir;
    StartButton.Caption         := StartButtonStr;
    GroupBox2.Caption           := MenuGenerate;
    LabelTypeConvert.Caption    := TypeConvert;
    // End Локаль
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    years: String;
    Year: integer;
    yearmin: integer;
    yearmax: integer;
    Month: integer;
begin
	  // Загружаем локаль
    LoadProject;
	  // Получаем значение даты
    Year    := YearOF(now);
    Month   := MonthOf(now);
    years   := IntToStr(Year);
    // Построение списка лет
    yearmin := Year - 3;
    yearmax := Year + 4;
    while yearmin <> yearmax do
    begin
        YearBox.Items.Add(IntToStr(yearmin));
        yearmin := yearmin + 1;
        Application.ProcessMessages;
    end;
    YearBox.ItemIndex := YearBox.Items.IndexOf(IntToStr(Year));
    // Построение списка месяцев
    MonthBox.Items.Clear;
    var LMonthNames := TFormatSettings.Create.LongMonthNames;
    for var LMonthName in LMonthNames do
    begin
      MonthBox.Items.Add(LMonthName);
    end;
    MonthBox.ItemIndex := Month - 1;
	  // Устанавливаем текущую дату календарю
    Calendar1.Day := DayOf(now);
    Calendar1.Month := MonthOf(now);
    Calendar1.Year := YearOF(now);
    data := IntToStr(Calendar1.Day).PadLeft(2, '0') + '.' +
      IntToStr(Calendar1.Month).PadLeft(2, '0') + '.' + IntToStr(Calendar1.Year)
      .PadLeft(4, '0');
	  // Выводим дату в контроллах
    DateLabel.Caption := data;
    DateLabel.Hint := data;
	  // Выводим директорию в контроллах
    DirectoryLabel.Caption := directory;
    DirectoryLabel.Hint := directory;
    var dt := Calendar1.CalendarDate;
    intData := DateTimeToUnix(dt);
    convert := ComboTypeConvert.Items[ComboTypeConvert.ItemIndex];
end;

// Событие на комбобоксе месяцев
procedure TForm1.MonthBoxChange(Sender: TObject);
begin
    Refresh;
    Calendar1.Month := MonthBox.ItemIndex + 1;
    Calendar1.Year := StrToInt(YearBox.Items[YearBox.ItemIndex]);
end;

// Событие на типе меню
procedure TForm1.TypeMenuBoxChange(Sender: TObject);
begin
    MenuLabel.Caption := TypeMenuBox.Items[TypeMenuBox.ItemIndex];
    MenuLabel.Hint := TypeMenuBox.Items[TypeMenuBox.ItemIndex];
    typemenu := TypeMenuBox.ItemIndex;
    SendJSON_type(FileJSON, typemenu);
end;

// Событие на календаре
procedure TForm1.Calendar1Change(Sender: TObject);
var
    dt: TDateTime;
begin
    data := IntToStr(Calendar1.Day).PadLeft(2, '0') + '.' +
      IntToStr(Calendar1.Month).PadLeft(2, '0') + '.' + IntToStr(Calendar1.Year)
      .PadLeft(4, '0');
    DateLabel.Caption := data;
    DateLabel.Hint := data;
    dt := Calendar1.CalendarDate;
    intData := DateTimeToUnix(dt);
end;

// Событие выбора итоговых меню
procedure TForm1.CheckBox1Click(Sender: TObject);
var
    i: integer;
    strList: TStringList;
begin
    {******
      Здесь код
    ******}
    strList := TStringList.Create;
    for i := 0 to Panel4.ComponentCount-1 do
    begin
       if Panel4.Components[i] is TCheckBox then
       begin
         {****}
         if((Panel4.Components[i] as TCheckBox).Checked) then
         begin
           strList.Add(IntToStr(i));
         end;
       end;
    end;
    index := ArrayToStr2(strList, ',');
    strList.Destroy;
end;

procedure TForm1.ComboTypeConvertChange(Sender: TObject);
var
    ini: TIniFile;
    iniFile: string;
begin
    appPath := ExtractFilePath(Application.ExeName);
    iniFile := TPath.Combine(appPath, 'settings.ini');
    ini := TIniFile.Create(iniFile);
    ini.WriteInteger('TypeConvert', 'Type', ComboTypeConvert.ItemIndex);
    ini.Free;
    convert := ComboTypeConvert.Items[ComboTypeConvert.ItemIndex];
end;

procedure TForm1.DialogButtonClick(Sender: TObject);
var
    ini: TIniFile;
    iniFile: string;
begin
    iniFile := TPath.Combine(appPath, 'settings.ini');
    ini := TIniFile.Create(iniFile);
    if SelectFolderDialogExt(Handle, StrSelectDir, directory) then
    begin
        ini.WriteString('Directory', 'SelectDir', directory);
    end;
    ini.WriteInteger('TypeConvert', 'Type', ComboTypeConvert.ItemIndex);
    ini.Free;
    DirectoryLabel.Caption := directory;
    DirectoryLabel.Hint := directory;
    convert := ComboTypeConvert.Items[ComboTypeConvert.ItemIndex];
    // Выносим форму на передний план
    SetForegroundWindow(Handle);
end;

// Событие закрытия окна
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
    i: integer;
    strList: TStringList;
begin
    strList := TStringList.Create;
    for i := 0 to Panel4.ComponentCount-1 do
    begin
       if Panel4.Components[i] is TCheckBox then
       begin
         {****}
         if((Panel4.Components[i] as TCheckBox).Checked) then
         begin
           strList.Add(IntToStr(i));
         end;
       end;
    end;
    index := ArrayToStr2(strList, ',');
    convert := ComboTypeConvert.Items[ComboTypeConvert.ItemIndex];
    strList.Destroy;
    // ShowMessage(index);
    if not(Form1.ModalResult = mrCancel) then
    begin
        if (MenuLabel.Caption = '') then
        begin
            MessageBox(Handle,
              PChar(StrErrorTypeMenu.PadRight(100, ' ')),
              PChar(StrError), MB_ICONSTOP);
            CanClose := False;
            Exit;
        end;
        if (DateLabel.Caption = '') then
        begin
            MessageBox(Handle,
              PChar(StrErrorDate.PadRight(100, ' ')),
              PChar(StrError), MB_ICONSTOP);
            CanClose := False;
            Exit;
        end;
        if (DirectoryLabel.Caption = '') then
        begin
            MessageBox(Handle,
              PChar(StrErrorSelectDir.PadRight(100, ' ')),
              PChar(StrError), MB_ICONSTOP);
            CanClose := False;
            Exit;
        end;
    end;
    if (Form1.ModalResult = mrCancel) then
    begin
        Form1.Visible := False;
        if (MessageBox(Handle,
          PChar(StrUserAbort.PadRight(100, ' ')),
          PChar(StrWarning), MB_ICONASTERISK + MB_OKCANCEL) = mrOk) then
        begin
            CanClose := True;
        end
        else
        begin
            Form1.Visible := True;
            CanClose := False;
        end;
    end;
end;

// Чтение JSON файла
procedure TForm1.SendJSON(FName: string);
var
    JsonArray: TJSONArray;
    ArrayElement, RowValue: TJSonValue;
begin
    // Чтение JSON файла
    fileName := FName;
    FileJSON := FName;
    if (System.SysUtils.FileExists(fileName)) then
    begin
        TypeMenuBox.Items.Clear;
        try
            try
                JsonArray := TJSonObject.ParseJSONValue
                  (ReadFromFile(fileName, TEncoding.UTF8)) as TJSONArray;
                for ArrayElement in JsonArray do
                begin
                    RowValue := (ArrayElement as TJSonObject).GetValue('name');
                    TypeMenuBox.Items.Add(RowValue.Value);
                end;
                if (TypeMenuBox.Items.Count > 0) then
                begin
                    TypeMenuBox.ItemIndex := 0;
                    MenuLabel.Caption := TypeMenuBox.Items
                      [TypeMenuBox.ItemIndex];
                    MenuLabel.Hint := TypeMenuBox.Items[TypeMenuBox.ItemIndex];
                    typemenu := TypeMenuBox.ItemIndex;
                    SendJSON_type(FileJSON, typemenu);
                end;
            except
                MessageBox(Handle, PChar(StrErrorReadFile + ' "' + fileName +
                  '"'), PChar(StrError), MB_ICONSTOP);
            end;
        finally
            //
        end;
    end;
    // выносим форму на передний план
    SetForegroundWindow(Handle);
end;

// Чтение типов меню из JSON файла. Построение чекбоксов
procedure TForm1.SendJSON_type(FName: string; indx: integer);
var
    JsonArray, tmpArr: TJSONArray;
    RowValue, JsonVal: TJSonValue;
    tmpObj: TJSONObject;
    i, k: integer;
    strList: TStringList;
begin
    strList := TStringList.Create;
    // Очищаем всю панель
    i := 0;
    k := 0;
    while i < Panel4.ComponentCount do
    begin
    if Panel4.Components[i] is TCheckBox then
    begin
      (Panel4.Components[i] as TCheckBox).OnClick := nil;
      Panel4.Components[i].Destroy;
    end
    else
      inc(i);
    end;
    // Чтение JSON файла
    fileName := FName;
    if (System.SysUtils.FileExists(fileName)) then
    begin
      {********
      Код здесь
      ********}
      JsonArray := TJSonObject.ParseJSONValue(ReadFromFile(fileName, TEncoding.UTF8)) as TJSONArray;
      tmpObj := JsonArray.Items[indx] as TJSONObject;
      tmpArr := tmpObj.Get('items').JsonValue as TJSONArray;
      for RowValue in tmpArr do
      begin
        k := k + 1;
        JsonVal := (RowValue as TJSONObject).GetValue('title');
        var c: TCheckBox;
        c := TCheckBox.Create(Panel4);
        c.Parent := Panel4;
        c.Name := 'Ch' + IntToStr(k);
        c.Caption := JsonVal.Value;
        c.Hint := c.Caption;
        c.Top := (k - 1) * (c.Height);
        c.Left := 10;
        c.Width := Panel4.Width - 20;
        c.Checked := True;
        c.Cursor := crHandPoint;
        c.OnClick := CheckBox1Click;
        c.Align := alTop;
        c.ShowHint := True;
        c.Margins.Left :=10;
        c.Margins.Right := 10;
        c.TabOrder := k + 5;
        strList.Add(IntToStr(k - 1));
      end;
      ComboTypeConvert.TabOrder := k + 6;
      DialogButton.TabOrder := k + 7;
      StartButton.TabOrder := k + 8;
    end;
    index := ArrayToStr2(strList, ',');
    strList.Destroy;
    // ShowMessage(index);
end;

// Появление формы.
procedure TForm1.FormShow(Sender: TObject);
begin
    // выносим форму на передний план
    SetForegroundWindow(Handle);
end;

procedure TForm1.Panel4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    Panel4.SetFocus;
end;

procedure TForm1.Panel4MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
    Panel4.SetFocus;
    Panel4.VertScrollBar.Position:=
    Panel4.VertScrollBar.Position-WheelDelta div 10;
end;

end.

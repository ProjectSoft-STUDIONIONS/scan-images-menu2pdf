program playbeep;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Winapi.Windows;
  
var
  tone     : integer;
  duration : integer;
begin
  tone     := 1760;
  duration := 500;
  try
    if ParamCount > 0 then
    begin
      var i: integer;
      i := 1;
      while i <= ParamCount do
      begin
        if i=1 then
          tone     := strtoint(ParamStr(i));
        if i=2 then
          duration := strtoint(ParamStr(i));
        inc(i);
      end;
    end;
    Beep(tone, duration);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

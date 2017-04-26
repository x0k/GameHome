unit uRegFont;

interface

uses
  System.SysUtils, System.Types, Dialogs;

function RegisterFont(AFileName, AFontName: String): Boolean;
function PSSHGetSpecialFolderPath(hWnd: THandle; aCSIDL: integer): string;

const
  CKey = '\Software\Microsoft\Windows NT\CurrentVersion\Fonts';

implementation

uses
  System.Win.Registry, Winapi.Windows, ShlObj, System.IOUtils;

function RegisterFont(AFileName, AFontName: String): Boolean;
var
  reg: TRegIniFile;
  fPath: String;
  LFileName: String;
begin
  Result := False;
  if not FileExists(AFileName) or Result then
    Exit;

  reg := TRegIniFile.Create('');
  reg.RootKey := HKEY_LOCAL_MACHINE;
  if reg.OpenKey(CKey, False) then
  begin
    if not reg.ValueExists(AFontName) then
      reg.WriteString(CKey, AFontName, ExtractFileName(AFileName));

    fPath := PSSHGetSpecialFolderPath(0, CSIDL_FONTS);
    LFileName := System.IOUtils.TPath.Combine(fPath, ExtractFileName(AFileName));

    // копируем фай шрифта
    if not FileExists(LFileName) then
    begin
      TFile.Copy(AFileName, LFileName);
      Result := FileExists(LFileName);
    end else
      Result := True;
  end;
end;

function PSSHGetSpecialFolderPath(hWnd: THandle; aCSIDL: integer): string;
var
  buffer: array[0..MAX_PATH*2] of Char;
begin
  if not SHGetSpecialFolderPath(hWnd, buffer, aCSIDL, false) then
    result := EmptyStr
  else
    result := string(buffer);
end;

end.

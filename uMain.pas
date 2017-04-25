unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    playBtn: TButton;
    Img: TImage;
    GroupBox1: TGroupBox;
    godMode: TCheckBox;
    debugMode: TCheckBox;
    Bar: TProgressBar;
    procedure playBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ExecAndWait(const FileName, Params: String; const WinState: Word);
    procedure WMCopyData(var M: TWMCopyData); message WM_COPYDATA;
  end;

  Comands = (open, setCount, upCount, cclose);

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.IOUtils;

function WinExec(const ACmdLine: String; const ACmdShow: UINT = SW_SHOWNORMAL): boolean;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  CmdLine: String;
begin
  Assert(ACmdLine <> '');

  CmdLine := ACmdLine;
  UniqueString(CmdLine);

  FillChar(SI, SizeOf(SI), 0);
  FillChar(PI, SizeOf(PI), 0);
  SI.cb := SizeOf(SI);
  SI.dwFlags := STARTF_USESHOWWINDOW;
  SI.wShowWindow := ACmdShow;

  SetLastError(ERROR_INVALID_PARAMETER);
  {$WARN SYMBOL_PLATFORM OFF}
  result:=Win32Check(CreateProcess(nil, PChar(CmdLine), nil, nil, False, CREATE_DEFAULT_ERROR_MODE {$IFDEF UNICODE}or CREATE_UNICODE_ENVIRONMENT{$ENDIF}, nil, nil, SI, PI));
  {$WARN SYMBOL_PLATFORM ON}
  CloseHandle(PI.hThread);
  CloseHandle(PI.hProcess);
end;

procedure TMainForm.ExecAndWait(const FileName, Params: String; const WinState: Word);
var
  CmdLine: String;
begin
  CmdLine := '"' + Filename + '"' + Params;
  if winExec(cmdLine) then
  begin
      playBtn.Enabled:=false;
      playBtn.Caption:='Запущено';
  end;
end;

procedure TMainForm.playBtnClick(Sender: TObject);
var
  path, p: string;
begin
  path:=TPath.Combine(TPath.GetLibraryPath, 'GHome.exe');
  if godMode.Checked then
    p:=p+' /god';
  if DebugMode.Checked then
    p:=p+' /debug';
  p:=p+' '+Cardinal(Handle).ToString;
  if TFile.Exists(path) then
    ExecAndWait(path, p, SW_SHOWNORMAL)
  else
    showMessage('Файл не найден: '+path);
end;

procedure TMainForm.WMCopyData(var M: TWMCopyData);
begin
  case Comands(M.CopyDataStruct.dwData) of
    open:playBtn.Caption:=PChar(M.CopyDataStruct.lpData);
    setCount: Bar.Max:=Byte.Parse(PChar(M.CopyDataStruct.lpData));
    upCount:begin
      Bar.Position:=Bar.Position+1;
      playBtn.Caption:=PChar(M.CopyDataStruct.lpData)
    end;
    cclose:begin
      Bar.Position:=0;
      playBtn.Enabled:=true;
      playBtn.Caption:='Запустить';
    end;
    else begin
      M.Result:=0;
      exit;
    end;
  end;
  M.Result:=1;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  p: string;
begin
  p:=TPath.Combine(TPath.GetLibraryPath, TPath.Combine('t', 'font.ttf'));
  if AddFontResource(PChar(p))>0 then
    sendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0)
  else
    showMessage('Ошибка при загрузке шрифта: '+p);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  RemoveFontResource(PChar(TPath.Combine(TPath.GetLibraryPath,TPath.Combine('t', 'font.ttf'))));
  sendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

end.

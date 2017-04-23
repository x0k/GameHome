unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    playBtn: TButton;
    Img: TImage;
    GroupBox1: TGroupBox;
    godMode: TCheckBox;
    debugMode: TCheckBox;
    procedure playBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ExecAndWait(const FileName, Params: String; const WinState: Word);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.IOUtils;

procedure TMainForm.ExecAndWait(const FileName, Params: String; const WinState: Word);
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: String;
begin
  { Помещаем имя файла между кавычками, с соблюдением всех пробелов в именах Win9x }
  playBtn.Enabled:=false;
  playBtn.Caption:='Запущено';
  CmdLine := '"' + Filename + '"' + Params;
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WinState;
  end;
  { Ожидаем завершения приложения }
  if CreateProcess(nil, PChar(CmdLine), nil, nil, false,  CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, PChar(ExtractFilePath(Filename)), StartInfo, ProcInfo) then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Free the Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
    playBtn.Enabled:=true;
    playBtn.Caption:='Запустить';
  end;
  Application.Restore;
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
  if TFile.Exists(path) then
    ExecAndWait(path, p, SW_SHOWNORMAL)
  else
    showMessage('Файл не найден: '+path);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  p: string;
begin
  p:=TPath.Combine(TPath.GetLibraryPath,TPath.Combine('t', 'font.ttf'));
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

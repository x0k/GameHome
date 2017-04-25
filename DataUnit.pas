unit DataUnit;

interface

uses
  System.Classes, System.ImageList,
  FMX.Controls, FMX.ImgList, FMX.Types, FGX.ApplicationEvents,
  DesignManager, ImageManager, TextManager, SoundManager, GameData, BarUnit;

type
  TDataForm = class(TDataModule)
    Museum: TImageList;
    Backgrounds: TImageList;
    Icons: TImageList;
    Sequence: TImageList;
    Other: TImageList;
    Images: TImageList;
    winMuseum: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  end;

  Comands = (open, setCount, upCount, close);

var
  godMode, dbgMode: boolean;
  DataForm: TDataForm;
  {$IFDEF DEBUG}
  Debug: TStrings;
  {$ENDIF}
  Styles:TStyleBook;
  DM: TDesignManager;
  IM: TImageManager;
  TM: TTextManager;
  SM: TSoundManager;
  GD: TGameData;
  Bar: TBar;

  {$IFDEF DEBUG}
  procedure addD(const u, m: string); overload;
  procedure addD(ct: TObject; const m:string); overload
  procedure addD(ct: TFmxObject; const m: string); overload;
  {$ENDIF}

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.SysUtils,
  FMX.Ani, FMX.Forms, FMX.Platform.Win, FMX.Dialogs,
  windows, Messages,
  Forms, GameForms, ResourcesManager;

var
  m: boolean;
  hdl: Cardinal;
  msg: TCopyDataStruct;

{$IFDEF DEBUG}
procedure addD(const u, m: string);
begin
  Debug.Add('Unit: '+u+' [Method: '+m+']');
end;

procedure addD(ct: TObject; const m:string);
begin
  Debug.Add('Unit: '+ct.UnitName+' {Class: '+ct.ClassName+'} [Method: '+m+']');
end;

procedure addD(ct: TFmxObject; const m: string);
begin
  Debug.Add('Unit: '+ct.UnitName+' {Class: '+ct.ClassName+'} (Name: '+ct.Name+') [Method: '+m+']')
end;
{$ENDIF}

procedure sendMsg(const cmd: Comands; const s: string = String.Empty);
begin
  if m then exit;
  msg.dwData:=ord(cmd);
  msg.cbData:=sizeOf(s)*Length(s);
  GetMem(msg.lpData, msg.cbData);
  try
    StrPCopy(msg.lpData, s);
    SendMessage(hdl, WM_COPYDATA, FMX.Platform.Win.ApplicationHWND, Integer(@msg));
  finally
    FreeMem(msg.lpData, msg.cbData);
  end;
end;

procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  godMode:=FindCmdLineSwitch('god');
  dbgMode:=FindCmdLineSwitch('debug');
  hdl:=0;
  m:=not ((ParamCount>0) and Cardinal.TryParse(ParamStr(ParamCount), hdl));
  if not m then hdl:=Cardinal.Parse(ParamStr(ParamCount));
  {$IFDEF DEBUG}
  Debug:=TStringList.Create;
  addD(self, 'Create DataForm');
  {$ENDIF}
  sendMsg(open, ('Initialization'));
  Bar:=TBar.create(self);
  DM:=TDesignManager.create;
  IM:=TImageManager.Create;
  GD:=TGameData.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create(name);
  initForms;
  {$IFDEF DEBUG}
  addD(self, 'Initialization (load imgs)');
  {$ENDIF}
  if not dbgMode then
  begin
    sendMsg(setCount, (5).ToString);
    IM.add(rMuseum);
    sendMsg(upCount, 'Loading: Museum');
    IM.add(rWinMuseum);
    sendMsg(upCount, 'Loading: Sequences');
  end else sendMsg(setCount, (3).ToString);
  IM.add(rSequences);
  sendMsg(upCount, 'Loading: Images');
  IM.add(rImages);
  sendMsg(upCount, 'Loading: Other');
  IM.add(rOther);
  sendMsg(upCount, 'Done.');
end;

procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  GD.LoadSavedRamp;
  freeForms;
  Bar.Free;
  DM.Free;
  IM.Free;
  GD.Free;
  SM.Free;
  TM.Free;
  sendMsg(close, 'Done.');
  {$IFDEF DEBUG}
  addD(self, 'Destroy');
  Debug.SaveToFile('Debug.txt');
  Debug.Free;
  {$ENDIF}
end;

end.

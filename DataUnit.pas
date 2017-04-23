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
    fgApplicationEvents1: TfgApplicationEvents;
    winMuseum: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure fgApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  end;

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
  FMX.Ani, FMX.Forms,
  windows, Messages,
  Forms, GameForms, ResourcesManager, MainUnit;

var
  ld: boolean;
  t: string;

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

procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  godMode:=FindCmdLineSwitch('god');
  dbgMode:=FindCmdLineSwitch('debug');
  {$IFDEF DEBUG}
  Debug:=TStringList.Create;
  addD(self, 'Create DataForm');
  {$ENDIF}
  Bar:=TBar.create(self);
  DM:=TDesignManager.create;
  IM:=TImageManager.Create;
  GD:=TGameData.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create(name);
  t:=TM.Forms['MainForm'].Names[1];
  initForms;
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
  {$IFDEF DEBUG}
  addD(self, 'Destroy');
  Debug.SaveToFile('Debug.txt');
  Debug.Free;
  {$ENDIF}
end;

procedure TDataForm.fgApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  if not ld then
  begin
    {$IFDEF DEBUG}
    addD(self, 'Initialization (load imgs)');
    {$ENDIF}
    if not dbgMode then
    begin
      IM.add(rMuseum);
      IM.add(rWinMuseum);
    end;
    IM.add(rSequences);
    IM.add(rImages);
    IM.add(rOther);
    TAnimator.AnimateFloatWait(MainForm.Text6, 'opacity', 0);
    MainForm.text6.Text:=t;
    TAnimator.AnimateFloat(MainForm.Text6, 'opacity', 1, 1);
    TAnimator.AnimateFloat(MainForm.centerLayout, 'opacity', 1, 1);
    ld:=true;
  end;
end;

end.

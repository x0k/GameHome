unit DataUnit;

interface

uses
  System.Classes, System.ImageList,
  FMX.Controls, FMX.ImgList, FMX.Types;

type
  TDataForm = class(TDataModule)
    Museum: TImageList;
    Backgrounds: TImageList;
    Icons: TImageList;
    Sequence: TImageList;
    Other: TImageList;
    Images: TImageList;
    winMuseum: TImageList;
    Switchers: TImageList;
    StyleBook1: TStyleBook;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  end;

var
  godMode, dbgMode: boolean;
  DataForm: TDataForm;
  Styles:TStyleBook;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.SysUtils,
  FMX.Ani, FMX.Forms, FMX.Dialogs,
  GameForms, ImageManager, GameData, BarUnit, DesignManager, TextManager, SoundManager, ResourcesManager, winMessages;

procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  godMode:=FindCmdLineSwitch('god');
  dbgMode:=FindCmdLineSwitch('debug');
  setHandle;
  sendMsg(cOpen, 'Initialization');
  DM:=TDesignManager.create;
  IM:=TImageManager.Create;
  GD:=TGameData.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create;
  Bar:=TBar.create(self);
  initForms;
  if not dbgMode then
  begin
    sendMsg(cSetCount, (6).ToString);
    IM.add(rMuseum);
    sendMsg(cUpCount, 'Loading: Museum');
    IM.add(rWinMuseum);
    sendMsg(cUpCount, 'Loading: Sequences');
  end else sendMsg(cSetCount, (4).ToString);
  IM.add(rSequences);
  sendMsg(cUpCount, 'Loading: Switchers');
  IM.add(rSwitchers);
  sendMsg(cUpCount, 'Loading: Images');
  IM.add(rImages);
  sendMsg(cUpCount, 'Loading: Other');
  IM.add(rOther);
  sendMsg(cUpCount, 'Done.');
end;

procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  GD.LoadSavedRamp;
  freeForms;
  DM.Free;
  IM.Free;
  GD.Free;
  SM.Free;
  TM.Free;
  Bar.Free;
  sendMsg(cClose, 'Done.');
end;

end.

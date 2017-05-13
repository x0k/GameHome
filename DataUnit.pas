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
    Switchers: TImageList;
    progress: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  end;

var
  DataForm: TDataForm;
  Styles:TStyleBook;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.SysUtils, System.IOUtils, windows,
  FMX.Ani, FMX.Forms, FMX.Dialogs, FMX.Styles,
  ImageManager, GameData, DesignManager, TextManager, SoundManager, ResourcesManager, winMessages;

const
  fName = 'TkachenkoSketch4F.ttf';

procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  setHandle;
  sendMsg(cOpen, 'Initialization');
  initPath;
  GD:=TGameData.Create;
  DM:=TDesignManager.create;
  IM:=TImageManager.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create;
  //initForms;
  sendMsg(cSetCount, (6).ToString);
  //IM.add(rMuseum);
  sendMsg(cUpCount, 'Loading: Sequences');
  IM.add(rSequences);
  sendMsg(cUpCount, 'Loading: Switchers');
  IM.add(rSwitchers);
  sendMsg(cUpCount, 'Loading: Images');
  IM.add(rImages);
  sendMsg(cUpCount, 'Loading: Other');
  IM.add(rOther);
  {$IFDEF RELEASE}
  TStyleManager.SetStyleFromFile(pathResource(rStyle));
  {$ENDIF}
  sendMsg(cUpCount, 'Done.');
end;

procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  GD.LoadSavedRamp;
  //freeForms;
  DM.Free;
  IM.Free;
  GD.Free;
  SM.Free;
  TM.Free;
  RemoveFontResourceEx(PChar(TPath.Combine(getPath(pTexts),  fName)), FR_NOT_ENUM, nil);
  sendMsg(cClose, 'Done.');
end;

end.

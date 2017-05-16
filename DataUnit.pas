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
  ImageManager, GameData, DesignManager, TextManager, SoundManager, ResourcesManager, winMessages, uLoading;

const
  fName = 'TkachenkoSketch4F.ttf';

procedure TDataForm.DataModuleCreate(Sender: TObject);
var
  f: TLoadingForm;
begin
  f:=TLoadingForm.Create(self);
  f.Show;
  try
    f.setCount(6, 'Initialization');
    GD:=TGameData.Create;
    DM:=TDesignManager.Create;
    IM:=TImageManager.Create;
    SM:=TSoundManager.Create;
    TM:=TTextManager.Create;
    f.up('Loading: Museum');
    IM.add(rMuseum);
    f.up('Loading: Sequences');
    IM.add(rSequences);
    f.up('Loading: Switchers');
    IM.add(rSwitchers);
    f.up('Loading: Images');
    IM.add(rImages);
    f.up('Loading: Other');
    IM.add(rOther);
  finally
    f.Close;
  end;
end;

procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  GD.LoadSavedRamp;
  DM.Free;
  IM.Free;
  GD.Free;
  SM.Free;
  TM.Free;
  RemoveFontResourceEx(PChar(TPath.Combine(getPath(pTexts),  fName)), FR_NOT_ENUM, nil);
  sendMsg(cClose, 'Done.');
end;

end.

unit DataUnit;

interface

uses
  System.Classes, System.ImageList,
  FMX.Controls, FMX.ImgList, FMX.Types, FGX.ApplicationEvents,
  ImageManager, TextManager, SoundManager, GameData, BarUnit;

type

  TDataForm = class(TDataModule)
    Museum: TImageList;
    Backgrounds: TImageList;
    Icons: TImageList;
    Sequence: TImageList;
    Other: TImageList;
    Images: TImageList;
    fgApplicationEvents1: TfgApplicationEvents;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure fgApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  end;

var
  DataForm: TDataForm;
  Styles:TStyleBook;
  IM: TImageManager;
  TM: TTextManager;
  SM: TSoundManager;
  GD: TGameData;
  Bar: TBar;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  FMX.Ani,
  windows, Messages,
  Forms, GameForms, ResourcesManager, MainUnit;

var
  ld: boolean;
  t: string;

procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  Bar:=TBar.create(self);
  Bar.setDots;

  IM:=TImageManager.Create;
  GD:=TGameData.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create;
  t:=TM.Forms['MainForm'].Names[1];
  initForms;
end;

procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  RemoveFontResource(PChar(ResourcesManager.getPath(pTexts)+'font.ttf'));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  GD.LoadSavedRamp;
end;

procedure TDataForm.fgApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  if not ld then
  begin
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

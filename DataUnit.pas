unit DataUnit;

interface

uses
  System.Classes, System.ImageList,
  FMX.Controls, FMX.ImgList, FMX.Types, FGX.ApplicationEvents;

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

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  FMX.Ani,
  Forms, ResourcesManager, MainUnit;

var
  ld: boolean;
  t: string;

procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  initForms;
  t:=TM.Forms['MainForm'].Names[1];
end;

procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  destroyForms;
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

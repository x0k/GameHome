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
  Forms;

procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  initForms;
end;

procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  destroyForms;
end;

end.

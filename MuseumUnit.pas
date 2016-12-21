unit MuseumUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit,
  FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation, FGX.FlipView,
  System.Math.Vectors, FMX.Controls3D, FMX.Objects3D, FMX.Layouts,FMX.Filter.Effects,
  BarUnit;

type
  TMuseumForm = class(TForm)
    Slider: TfgFlipView;
    Bar: TBar;
    procedure SliderImageClick(Sender: TObject;
      const AFlipView: TfgCustomFlipView; const AImageIndex: Integer);
    procedure SliderStartChanging(Sender: TObject; const NewItemIndex: Integer);
    procedure FormCreate(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
    procedure BarNextBtnClick(Sender: TObject);
  private
    M:TImageManager;
  public
    { Public declarations }
  end;
const
  nLogo = 'Museum';
  IMG_COUNT = 15;
var
  MuseumForm: TMuseumForm;

implementation

{$R *.fmx}

procedure TMuseumForm.BarBackBtnClick(Sender: TObject);
begin
  MuseumForm.Release;
end;

procedure TMuseumForm.SliderImageClick(Sender: TObject;
  const AFlipView: TfgCustomFlipView; const AImageIndex: Integer);
begin
  Slider.GoToNext();
end;

procedure TMuseumForm.SliderStartChanging(Sender: TObject;
  const NewItemIndex: Integer);
begin
  Bar.DrawPanel(nLogo,NewItemIndex);
end;

procedure TMuseumForm.BarNextBtnClick(Sender: TObject);
begin
  Slider.GoToNext();
end;

procedure TMuseumForm.FormCreate(Sender: TObject);
var
  i:byte;
begin
  M:=TImageManager.Create('Museum',['museum']);
  if M=nil then
      Raise Exception.create('Ошибка при загрузке изображений');
  for i:=1 to IMG_COUNT do
    Slider.Images.AddImage(M.GetBitmap(0,'M'+i.ToString),'M'+i.ToString);
  Bar.Load(nLogo,self.Name);
end;

end.

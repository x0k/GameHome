unit MuseumUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit,
  FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation, FGX.FlipView,
  BarUnit;

type
  TMuseumForm = class(TBarForm)
    Slider: TfgFlipView;
    procedure SliderImageClick(Sender: TObject; const AFlipView: TfgCustomFlipView; const AImageIndex: Integer);
    procedure SliderStartChanging(Sender: TObject; const NewItemIndex: Integer);
  protected
    loaded:boolean;
    procedure onShowGForm; override;
    procedure onCloseGForm; override;
  end;
const
  IMG_COUNT = 15;
var
  MuseumForm: TMuseumForm;

implementation

{$R *.fmx}

procedure TMuseumForm.SliderImageClick(Sender: TObject;
  const AFlipView: TfgCustomFlipView; const AImageIndex: Integer);
begin
  Slider.GoToNext();
end;

procedure TMuseumForm.SliderStartChanging(Sender: TObject;
  const NewItemIndex: Integer);
begin
  SetDescription(NewItemIndex,Bar.SubText);
end;

procedure TMuseumForm.onShowGForm;
var
 i:byte;
begin
  IM.add(eResource.rMuseum);
  for i:=1 to IMG_COUNT do
    Slider.Images.AddImage(IM.GetBitmap('M'+i.ToString),'M'+i.ToString);
end;

procedure TMuseumForm.onCloseGForm;
begin
  Slider.Images.Clear;
  IM.clear;
end;

end.

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
    { Private declarations }
  public
    { Public declarations }
  end;

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
  Bar.DrawPanel(1,NewItemIndex);
end;

procedure TMuseumForm.BarNextBtnClick(Sender: TObject);
begin
  Slider.GoToNext();
end;

procedure TMuseumForm.FormCreate(Sender: TObject);
begin
  Bar.Load(1,self.Name);
end;

end.

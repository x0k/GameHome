unit SeazonUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.Ani, FMX.Effects, FMX.Filter.Effects, system.JSON, DataUnit;

type
  TSeazonForm = class(TGForm)
    Dec: TImage;
    Mart: TImage;
    Iul: TImage;
    Sent: TImage;
    Grid: TGridPanelLayout;
    b1: TBlurEffect;
    b2: TBlurEffect;
    b3: TBlurEffect;
    Blur: TBlurEffect;
    Tdec: TText;
    Tmart: TText;
    Tiul: TText;
    Tsent: TText;
    procedure DecClick(Sender: TObject);
    procedure MartClick(Sender: TObject);
  private
    procedure FShow; override;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TSeazonForm.FShow;
begin
  IM.SetImages(TImgs.Create(ISEQ,[],[Dec,Mart,Iul,Sent]));
end;

{procedure TSeazonForm.BarNextBtnClick(Sender: TObject);
begin
  PlaceForm.Show;
  SeazonForm.Close;
end;}

procedure TSeazonForm.DecClick(Sender: TObject);
begin
  SM.Play;
  Bar.DrawPanel(nLogo[0],(Sender as Timage).Tag);
end;

procedure TSeazonForm.MartClick(Sender: TObject);
begin
  Blur.Trigger:='IsVisible=false';
  b1.Trigger:='IsVisible=true';
  b2.Trigger:='IsVisible=true';
  b3.Trigger:='IsVisible=true';
  Dec.OnClick:=nil;Mart.OnClick:=nil;Iul.OnClick:=nil;Sent.OnClick:=nil;
  Bar.DrawPanel(nLogo[0],(Sender as Timage).Tag);
  GD.GetAwd(1);
  Bar.UpStatus(1);
  Bar.NextBtn.Opacity:=1;
  Bar.NextBtn.Enabled:=true;
end;

end.

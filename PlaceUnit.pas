unit PlaceUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, FMX.Effects,
  FMX.Layouts, FMX.TabControl, FMX.Filter.Effects, DataUnit;

type
  TPlaceForm = class(TGForm)
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Grid: TGridPanelLayout;
    forest: TImage;
    b1: TBlurEffect;
    Tfor: TText;
    River: TImage;
    b2: TBlurEffect;
    Tiul: TText;
    pole: TImage;
    b3: TBlurEffect;
    Tsent: TText;
    boloto: TImage;
    Blur: TBlurEffect;
    BG: TImage;
    Text: TMemo;
    place: TImage;
    Main1: TLayout;
    Tmart: TText;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure placeClick(Sender: TObject);
    procedure forestClick(Sender: TObject);
    procedure RiverClick(Sender: TObject);
    procedure BarNextBtnClick(Sender: TObject);
  private
    showed:boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TPlaceForm.FormShow(Sender: TObject);
begin
  if not showed then
  begin
    //Bar.Load(nLogo,self.Name);
    //Text.Lines.Assign(FD.SubTexts[5]);
    Bar.UpStatus(2);
    Bar.Draw(self.Width,self.Height);
    IM.SetImage(IBG,TImg.Create('Wall',BG),true);
    IM.SetImage(IOTH,TImg.Create('Place',place));
    IM.SetImages(TImgs.Create(ISEQ,[],[forest,boloto,river,pole]));
  end else Bar.pUpdate;
end;

procedure TPlaceForm.BarNextBtnClick(Sender: TObject);
begin
  //ToolsForm.Show;
  //PlaceForm.Close;
end;

procedure TPlaceForm.SpeedButton3Click(Sender: TObject);
begin
  //PlaceForm.Close;
end;

procedure TPlaceForm.forestClick(Sender: TObject);
begin
  SM.Play;
  //Bar.DrawPanel(nLogo,(Sender as Timage).Tag);
end;

procedure TPlaceForm.placeClick(Sender: TObject);
begin
  Tabs.Next();
end;

procedure TPlaceForm.RiverClick(Sender: TObject);
begin
  Blur.Trigger:='IsVisible=false';
  b1.Trigger:='IsVisible=true';
  b2.Trigger:='IsVisible=true';
  b3.Trigger:='IsVisible=true';
  Bar.NextBtn.Opacity:=1;
  bar.NextBtn.Enabled:=true;
  forest.OnClick:=nil;boloto.OnClick:=nil;river.OnClick:=nil;pole.OnClick:=nil;
  //Bar.DrawPanel(nLogo,(Sender as Timage).Tag);
  GD.GetAwd(10);
  Bar.UpStatus(2);
end;

end.

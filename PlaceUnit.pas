unit PlaceUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, FMX.Effects,
  FMX.Layouts, FMX.TabControl, BarUnit,FMX.Filter.Effects;

type
  TPlaceForm = class(TForm)
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    BG2: TImage;
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
    Tmart: TText;
    BG1: TImage;
    Text: TMemo;
    place: TImage;
    Bar: TBar;
    Main1: TLayout;
    Main2: TLayout;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure placeClick(Sender: TObject);
    procedure forestClick(Sender: TObject);
    procedure RiverClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PlaceForm: TPlaceForm;

implementation

{$R *.fmx}

uses GameUnit, DataUnit;

procedure TPlaceForm.forestClick(Sender: TObject);
begin
  DataForm.Play;
  Bar.DrawPanel(1,(Sender as Timage).Tag);
end;

procedure TPlaceForm.FormActivate(Sender: TObject);
begin
  Bar.DrawProgress;
end;

procedure TPlaceForm.FormCreate(Sender: TObject);
begin
  Bar.Load(1,self.Name);
  DataForm.LoadImg(3,2,place);
  Text.Lines.Assign(PData.SubTexts[5]);
end;

procedure TPlaceForm.FormShow(Sender: TObject);
begin
  Lev[2]:=1;
  DataForm.Load(0);
  Bar.Draw(self.Width,self.Height);
  DataForm.LoadScaleImg(0,1,BG1);
  DataForm.LoadScaleImg(0,1,BG2);
  DataForm.LoadSeqImgs(1,4,[forest,boloto,river,pole]);
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
  forest.OnClick:=nil;boloto.OnClick:=nil;river.OnClick:=nil;pole.OnClick:=nil;
  Bar.DrawPanel(1,(Sender as Timage).Tag);
  vis[10]:=true;
  lev[2]:=2;
  Bar.DrawProgress;
  DataForm.Load(1);
  DataForm.Play;
end;

procedure TPlaceForm.SpeedButton3Click(Sender: TObject);
begin
  GameForm.FormActivate(TObject(self));
  PlaceForm.Release;
end;

end.

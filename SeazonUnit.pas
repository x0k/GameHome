unit SeazonUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  BarUnit, FMX.Ani, FMX.Effects, FMX.Filter.Effects, system.JSON;

type
  TSeazonForm = class(TForm)
    BG: TImage;
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
    Bar: TBar;
    Main: TLayout;
    procedure BackSBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DecClick(Sender: TObject);
    procedure MartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SeazonForm: TSeazonForm;

implementation

{$R *.fmx}

uses GameUnit, DataUnit;

procedure TSeazonForm.BackSBtnClick(Sender: TObject);
begin
  GameForm.FormActivate(TObject(self));
  SeazonForm.Release;
end;

procedure TSeazonForm.DecClick(Sender: TObject);
begin
  DataForm.Play;
  Bar.DrawPanel(1,(Sender as Timage).Tag);
end;

procedure TSeazonForm.FormActivate(Sender: TObject);
begin
  Bar.DrawProgress;
end;

procedure TSeazonForm.FormCreate(Sender: TObject);
begin
  Bar.Load(1,self.Name);
end;

procedure TSeazonForm.FormShow(Sender: TObject);
begin
  Lev[1]:=1;
  Bar.Draw(self.Width,self.Height);
  DataForm.Load(0);
  DataForm.LoadScaleImg(0,1,BG);
  DataForm.LoadSeqImgs(1,0,[Dec,Mart,Iul,Sent]);
end;

procedure TSeazonForm.MartClick(Sender: TObject);
begin
  Blur.Trigger:='IsVisible=false';
  b1.Trigger:='IsVisible=true';
  b2.Trigger:='IsVisible=true';
  b3.Trigger:='IsVisible=true';
  Dec.OnClick:=nil;Mart.OnClick:=nil;Iul.OnClick:=nil;Sent.OnClick:=nil;
  Bar.DrawPanel(1,(Sender as Timage).Tag);
  vis[1]:=true;
  lev[1]:=2;
  Bar.DrawProgress;
  DataForm.Load(1);
  DataForm.Play;
end;

end.

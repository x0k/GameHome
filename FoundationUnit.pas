unit FoundationUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Effects,
  FMX.Filter.Effects, BarUnit;

type
  TFoundationForm = class(TForm)
    BG: TImage;
    fon: TImage;
    Grid: TGridPanelLayout;
    Tsosn: TText;
    Tfor: TText;
    Tiul: TText;
    Tsent: TText;
    istone: TImage;
    istolb: TImage;
    iwood: TImage;
    inoth: TImage;
    Glow: TInnerGlowEffect;
    Bar: TBar;
    Main: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure istoneClick(Sender: TObject);
    procedure iwoodClick(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FoundationForm: TFoundationForm;
  Eff1:TGloomEffect;
implementation

{$R *.fmx}

uses DataUnit, GameUnit;

procedure TFoundationForm.BarBackBtnClick(Sender: TObject);
begin
  GameForm.Show;
  FoundationForm.Release;
end;

procedure TFoundationForm.FormActivate(Sender: TObject);
begin
  Bar.DrawProgress;
end;

procedure TFoundationForm.FormCreate(Sender: TObject);
begin
  Bar.Load(1,self.Name);
  DataForm.LoadImg(3,3,fon);
  DataForm.LoadSeqImgs(1,8,[istone,istolb,iwood,inoth]);
  Eff1:=TGloomEffect.Create(self);
end;

procedure TFoundationForm.FormShow(Sender: TObject);
begin
  Lev[6]:=1;
  DataForm.Load(0);
  Bar.Draw(self.Width,self.Height);
  DataForm.LoadScaleImg(0,1,BG);
end;

procedure TFoundationForm.istoneClick(Sender: TObject);
begin
  Eff1.Parent:=TFmxObject(sender);
  Eff1.UpdateParentEffects;
  Bar.DrawPanel(1,Timage(sender).Tag);
  DataForm.Play;
end;

procedure TFoundationForm.iwoodClick(Sender: TObject);
begin
  Eff1.Parent:=nil;
  Eff1.UpdateParentEffects;
  Glow.Enabled:=true;
  istone.OnClick:=nil;
  istolb.OnClick:=nil;
  inoth.OnClick:=nil;
  Bar.DrawPanel(1,Timage(sender).Tag);
  lev[6]:=2;
  vis[4]:=true;
  Bar.DrawProgress;
  DataForm.Load(1);
  DataForm.Play;
end;

end.

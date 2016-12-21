unit FoundationUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Effects,
  FMX.Filter.Effects, DataUnit;

type
  TFoundationForm = class(TGForm)
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
    Main: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure istoneClick(Sender: TObject);
    procedure iwoodClick(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
    procedure BarNextBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Eff1:TGloomEffect;

implementation

{$R *.fmx}

procedure TFoundationForm.BarBackBtnClick(Sender: TObject);
begin
  //GameForm.Show;
  //FoundationForm.Release;
end;

procedure TFoundationForm.BarNextBtnClick(Sender: TObject);
begin
  //MapForm.Show;
  //FoundationForm.Release;
end;

procedure TFoundationForm.FormActivate(Sender: TObject);
begin
  //Bar.DrawProgress;
end;

procedure TFoundationForm.FormCreate(Sender: TObject);
begin
  //Bar.Load(nLogo,self.Name);
  IM.SetImage(IOTH,TImg.Create('Fon',fon),false);
  //IM.SetImages(ISEQ,['Stone','Stolb','Wood','Nothing'],false,[istone,istolb,iwood,inoth]);
  Eff1:=TGloomEffect.Create(self);
end;

procedure TFoundationForm.FormShow(Sender: TObject);
begin
  GD.UpStatus(6);
  SM.LoadSound(0);
  Bar.Draw(self.Width,self.Height);
  IM.SetImage(IBG,TImg.Create('Wall',BG),true);
end;

procedure TFoundationForm.istoneClick(Sender: TObject);
begin
  Eff1.Parent:=TFmxObject(sender);
  Eff1.UpdateParentEffects;
  //Bar.DrawPanel(nLogo,Timage(sender).Tag);
  SM.Play;
end;

procedure TFoundationForm.iwoodClick(Sender: TObject);
begin
  Eff1.Parent:=nil;
  Eff1.UpdateParentEffects;
  Glow.Enabled:=true;
  istone.OnClick:=nil;
  istolb.OnClick:=nil;
  inoth.OnClick:=nil;
  //Bar.DrawPanel(nLogo,Timage(sender).Tag);
  GD.UpStatus(6);
  GD.GetAwd(3);
  //Bar.DrawProgress;
  Bar.NextBtn.Enabled:=true;
  Bar.NextBtn.Opacity:=1;
  SM.LoadSound(1);
  SM.Play;
end;

end.

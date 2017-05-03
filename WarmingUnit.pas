unit WarmingUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ImgList, DataUnit, FMX.TabControl, FMX.ani, system.Math,
  FMX.Effects, FMX.Filter.Effects,
  GameForms;

type
  TWarmingForm = class(TGTabForm)
    Main: TLayout;
    Home: TGlyph;
    Right: TLayout;
    a2: TGlyph;
    c2: TGlyph;
    a3: TGlyph;
    c3: TGlyph;
    b1: TGlyph;
    Left: TLayout;
    a1: TGlyph;
    b2: TGlyph;
    b3: TGlyph;
    b5: TGlyph;
    b4: TGlyph;
    c1: TGlyph;
    c4: TGlyph;
    Tabs: TTabControl;
    TabItem1: TTabItem;
    BG1: TGlyph;
    TabItem2: TTabItem;
    BG2: TGlyph;
    TabItem3: TTabItem;
    BG3: TGlyph;
    BG4: TGlyph;
    mox: TGlyph;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure addWin; override;
  public
    procedure click(Sender: TObject);
    procedure enter(Sender: TObject);
    procedure leave(Sender: TObject);
  end;

implementation

{$R *.fmx}

var
  w:single;
  c:TContrastEffect;
  inn:TInnerGlowEffect;
  wr: boolean;

procedure TWarmingForm.click(Sender: TObject);
begin
  inn.Parent:=nil;
  setText(TFmxObject(sender).Tag);
  c.Parent:=TFmxObject(sender);

  if TFmxObject(sender).Tag=1 then win
    else wr:=true;
end;

procedure TWarmingForm.enter(Sender: TObject);
begin
  inn.Parent:=TFmxObject(sender);
  TGlyph(sender).UpdateEffects;
end;

procedure TWarmingForm.leave(Sender: TObject);
begin
  inn.Parent:=nil;
end;

procedure TWarmingForm.onFormCreate;
var
  g:TFmxObject;
  procedure setGl(g:TGlyph);
  begin
    g.OnClick:=click;
    g.OnMouseEnter:=enter;
    g.OnMouseLeave:=leave;
    g.HitTest:=true;
  end;
begin
  backgrounds:=[BG1, BG2, BG3, BG4];
  layouts:=[main, BG4];
  gTabs:=tabs;
  gTab:=0;
  wr:=false;

  c:=TContrastEffect.Create(self);
  inn:=TInnerGlowEffect.Create(self);
  for g in left.Children do
    setGl(g as TGlyph);
  for g in right.Children do
    setGl(g as TGlyph)
end;

procedure TWarmingForm.addShow;
begin
  w:=min(Main.Width/2, Main.Height);
  left.SetBounds(left.Position.X, left.Position.Y, w,w);
  left.Margins.Right:=w+20;
  right.SetBounds(right.Position.X, right.Position.Y, w,w);
  right.Margins.Left:=w+20;
end;

procedure TWarmingForm.addWin;
begin
  TAnimator.AnimateFloatWait(mox, 'opacity', 1);
  if not wr then setMedal(5);
  home.ImageIndex:=-1;
end;

procedure TWarmingForm.FormDestroy(Sender: TObject);
begin
  c.Free;
  inn.Free;
end;

end.

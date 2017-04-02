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
    main: TLayout;
    home: TGlyph;
    rigth: TLayout;
    a2: TGlyph;
    c2: TGlyph;
    a3: TGlyph;
    c3: TGlyph;
    b1: TGlyph;
    left: TLayout;
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

procedure TWarmingForm.click(Sender: TObject);
begin
  inn.Parent:=nil;
  setText(TFmxObject(sender).Tag);
  c.Parent:=TFmxObject(sender);

  if TFmxObject(sender).Tag=1 then win;
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

  c:=TContrastEffect.Create(self);
  inn:=TInnerGlowEffect.Create(self);
  w:=min((Screen.Width-220)/2, (Screen.Height-260));
  for g in left.Children do
    setGl(g as TGlyph);
  for g in rigth.Children do
    setGl(g as TGlyph)
end;

procedure TWarmingForm.addShow;
begin
  left.SetBounds(left.Position.X, left.Position.Y, w,w);
  left.Margins.Right:=w+20;
  rigth.SetBounds(rigth.Position.X, rigth.Position.Y, w,w);
  rigth.Margins.Left:=w+20;
end;

procedure TWarmingForm.addWin;
begin
  TAnimator.AnimateFloatWait(mox, 'opacity', 1);
  home.ImageIndex:=-1;
end;

end.

unit uWarming;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ImgList, FMX.TabControl,
  uTabFrame;

type
  TWarmingFrame = class(TTabFrame)
    TabItem1: TTabItem;
    BG1: TGlyph;
    Main: TLayout;
    Home: TGlyph;
    mox: TGlyph;
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
    c4: TGlyph;
    c1: TGlyph;
    b4: TGlyph;
    TabItem2: TTabItem;
    BG2: TGlyph;
    TabItem3: TTabItem;
    BG3: TGlyph;
    BG4: TGlyph;
  protected
    procedure onFCreate; override;
    procedure onFDestroy; override;
    procedure win; override;
  public
    procedure onFShow; override;
    procedure wclick(Sender: TObject);
    procedure wenter(Sender: TObject);
    procedure wleave(Sender: TObject);
  end;

implementation

{$R *.fmx}

uses
  System.Math,
  FMX.Ani, FMX.Effects, FMX.Filter.Effects;

var
  w:single;
  c: TContrastEffect;
  inn: TInnerGlowEffect;
  wr: boolean;

procedure TWarmingFrame.onFCreate;
var
  g:TFmxObject;
  procedure setGl(g:TGlyph);
  begin
    g.OnClick:=wclick;
    g.OnMouseEnter:=wenter;
    g.OnMouseLeave:=wleave;
    g.HitTest:=true;
  end;
begin
  backgrounds:=[BG1, BG2, BG3, BG4];
  layouts:=[main, BG4];
  gTab:=0;
  wr:=false;

  c:=TContrastEffect.Create(self);
  inn:=TInnerGlowEffect.Create(self);
  for g in left.Children do
    setGl(g as TGlyph);
  for g in right.Children do
    setGl(g as TGlyph)
end;

procedure TWarmingFrame.onFDestroy;
begin
  c.Free;
  inn.Free;
end;

procedure TWarmingFrame.wclick(Sender: TObject);
begin
  inn.Parent:=nil;
  setText(TFmxObject(sender).Tag);
  c.Parent:=TFmxObject(sender);

  if TFmxObject(sender).Tag=1 then win
    else wr:=true;
end;

procedure TWarmingFrame.wenter(Sender: TObject);
begin
  inn.Parent:=TFmxObject(sender);
  TGlyph(sender).UpdateEffects;
end;

procedure TWarmingFrame.wleave(Sender: TObject);
begin
  inn.Parent:=nil;
end;

procedure TWarmingFrame.onFShow;
begin
  w:=min(Main.Width/2, Main.Height);
  left.SetBounds(left.Position.X, left.Position.Y, w,w);
  left.Margins.Right:=w+20;
  right.SetBounds(right.Position.X, right.Position.Y, w,w);
  right.Margins.Left:=w+20;
  inherited;
end;

procedure TWarmingFrame.Win;
begin
  inherited;
  TAnimator.AnimateFloatWait(mox, 'opacity', 1);
  if not wr then setMedal(4);
  home.ImageIndex:=-1;
end;

end.

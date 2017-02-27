unit PlaceUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, FMX.Effects,
  FMX.Layouts, FMX.TabControl, FMX.Filter.Effects, DataUnit, FMX.ImgList, FMX.Ani;

type
  TPlaceForm = class(TGForm)
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Text: TMemo;
    BG: TGlyph;
    Main: TLayout;
    s0: TLayout;
    img0: TGlyph;
    t1: TText;
    ShadowEffect1: TShadowEffect;
    s1: TLayout;
    img1: TGlyph;
    Text1: TText;
    ShadowEffect2: TShadowEffect;
    s2: TLayout;
    img2: TGlyph;
    Text2: TText;
    ShadowEffect3: TShadowEffect;
    s3: TLayout;
    img3: TGlyph;
    Text3: TText;
    ShadowEffect4: TShadowEffect;
    mapstr: TGlyph;
    procedure s0Click(Sender: TObject);
  protected
    procedure gShow; override;
  public
    procedure GNext(Sender: TObject);override;
  end;

implementation

{$R *.fmx}

var
  w:single;
  shw:ShortInt;

procedure TPlaceForm.s0Click(Sender: TObject);
begin
  if shw>=0 then
  begin
    TAnimator.AnimateFloat(Main.Children[shw], 'width', w);
    TAnimator.AnimateFloat(Main, 'Position.X', 0);
    TAnimator.AnimateInt(Main.Children[shw].Children[0].Children[0], 'TextSettings.Font.Size', 40);
    shw:=-1;
  end else begin
    shw:=Main.Children.IndexOf(TFmxObject(sender));
    self.setDescription(TFmxObject(sender).Children[0].tag, Bar.SubText);

    TAnimator.AnimateFloat(Main, 'Position.X', -(2*w*TFmxObject(sender).Tag/3));
    TAnimator.AnimateFloat(TFmxObject(sender), 'width', 3*w);
    TAnimator.AnimateInt(TFmxObject(sender).Children[0].Children[0], 'TextSettings.Font.Size', 80);

    if TFmxObject(sender).Tag=2 then win;
  end;
end;

procedure TPlaceForm.gShow;
var
  img_w:single;
begin
  w:=Width/4;
  img_w:=Height/720*1082;

  s0.Width:=w;
  img0.Width:=img_w;

  s1.Width:=w;
  img1.Width:=img_w;

  s2.Width:=w;
  img2.Width:=img_w;

  s3.Width:=w;
  img3.Width:=img_w;
  shw:=-1;

  self.setDescription(5, Text);
  Bar.showNext;
end;

procedure TPlaceForm.GNext(Sender: TObject);
begin
  if Tabs.TabIndex<1 then
  begin
    Tabs.Next();
    Bar.hideNext;
  end else DataForm.ShowForm(level+1);
end;

end.

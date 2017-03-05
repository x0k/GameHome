unit PlaceUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts, FMX.TabControl, DataUnit, FMX.ImgList, FMX.Ani;

type
  TPlaceForm = class(TGForm)
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Text: TMemo;
    BG1: TGlyph;
    Main2: TLayout;
    s0: TLayout;
    img0: TGlyph;
    t1: TText;
    s1: TLayout;
    img1: TGlyph;
    Text1: TText;
    s2: TLayout;
    img2: TGlyph;
    Text2: TText;
    s3: TLayout;
    img3: TGlyph;
    Text3: TText;
    mapstr: TGlyph;
    Main1: TLayout;
    BG2: TGlyph;
    procedure s0Click(Sender: TObject);
    procedure s0MouseEnter(Sender: TObject);
  protected
    procedure gShow; override;
  public
    procedure hideAnimation; override;
    procedure showAnimation; override;
    procedure Next(Sender: TObject);override;
  end;



implementation

{$R *.fmx}

var
  w:single;
  shw,lst:ShortInt;

procedure TPlaceForm.showAnimation;
begin
  TAnimator.AnimateFloatWait(Main1, 'opacity', 1, 0.4);
end;

procedure TPlaceForm.hideAnimation;
begin
  TAnimator.AnimateFloat(Main1, 'opacity', 0, 0.3);
  TAnimator.AnimateFloatWait(Main2, 'opacity', 0, 0.3);
end;

procedure TPlaceForm.s0Click(Sender: TObject);
begin
  if shw>=0 then
  begin
    TAnimator.AnimateFloat(Main2.Children[shw], 'width', w);
    TAnimator.AnimateFloat(Main2, 'Position.X', 0);
    TAnimator.AnimateInt(Main2.Children[shw].Children[0].Children[0], 'TextSettings.Font.Size', 40);
    shw:=-1;
  end else begin
    shw:=Main2.Children.IndexOf(TFmxObject(sender));
    self.setDescription(TFmxObject(sender).Children[0].tag, Bar.SubText);

    TAnimator.AnimateFloat(Main2, 'Position.X', -(2*w*TFmxObject(sender).Tag/3));
    TAnimator.AnimateFloat(TFmxObject(sender), 'width', 3*w);
    TAnimator.AnimateInt(TFmxObject(sender).Children[0].Children[0], 'TextSettings.Font.Size', 80);

    if TFmxObject(sender).Tag=2 then win;
  end;
end;

procedure TPlaceForm.s0MouseEnter(Sender: TObject);
var
  id:shortint;
begin
  id:=main2.Children.IndexOf(TFmxObject(sender));
  if (shw<0)and(id<>lst) then
  begin
    TAnimator.AnimateInt(Main2.Children[lst].Children[0].Children[0], 'TextSettings.Font.Size', 40);
    TAnimator.AnimateFloat(Main2.Children[lst], 'width', w);

    TAnimator.AnimateInt(TFmxObject(sender).Children[0].Children[0], 'TextSettings.Font.Size', 52);
    TAnimator.AnimateFloat(Main2, 'Position.X', -(80*TFmxObject(sender).Tag/3));
    TAnimator.AnimateFloat(TFmxObject(sender), 'width', 80+w);
    lst:=id;
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

procedure TPlaceForm.Next(Sender: TObject);
begin
  if Tabs.TabIndex<1 then
  begin
    Tabs.Next();
    if status<2 then Bar.hideNext;
  end else begin
    hideAnimation;
    DataForm.ShowForm(level+1);
    free;
  end;
end;

end.

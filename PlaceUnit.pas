unit PlaceUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts, FMX.TabControl, DataUnit, FMX.ImgList, FMX.Ani,
  Forms;

type
  TPlaceForm = class(TGTabForm)
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
    procedure addShow; override;
    procedure onFormCreate; override;
  end;



implementation

{$R *.fmx}

var
  w:single;
  shw,lst:ShortInt;

procedure TPlaceForm.onFormCreate;
begin
  backgrounds:=[BG1, BG2];
  layouts:=[main1, main2];
  gTabs:=tabs;
  gTab:=0;
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
    setText(TFmxObject(sender).Children[0].tag);

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

procedure TPlaceForm.addShow;
begin
  fillFormByImgs([s0, s1, s2, s3]);

  shw:=-1;
  self.setItem(0, Text);
end;

end.

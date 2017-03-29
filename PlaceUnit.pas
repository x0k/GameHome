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
  public
    procedure isWin(id: byte);
  end;



implementation

{$R *.fmx}

uses
  FullScreenTabs;

var
  fTabs: FSTabs;

procedure TPlaceForm.onFormCreate;
begin
  backgrounds:=[BG1, BG2];
  layouts:=[main1, main2];
  gTabs:=tabs;
  gTab:=1;
  fTabs:=FSTabs.create(self, 4, main2);
  fTabs.showClick:=isWin;
end;

procedure TPlaceForm.isWin(id: Byte);
begin
  if id=2 then win;
end;

procedure TPlaceForm.s0Click(Sender: TObject);
begin
  fTabs.onClick(TFmxObject(sender).Tag);
end;

procedure TPlaceForm.s0MouseEnter(Sender: TObject);
begin
  fTabs.onEnter((TFmxObject(sender).Tag));
end;

procedure TPlaceForm.addShow;
begin
  self.setItem(0, Text);
  fTabs.setSize(true);
end;

end.

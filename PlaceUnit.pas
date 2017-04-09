unit PlaceUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts, FMX.TabControl, DataUnit, FMX.ImgList, FMX.Ani,
  GameForms;

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
    text0: TText;
    s1: TLayout;
    img1: TGlyph;
    Text1: TText;
    s2: TLayout;
    img2: TGlyph;
    Text2: TText;
    s3: TLayout;
    img3: TGlyph;
    Text3: TText;
    Map: TGlyph;
    Main1: TLayout;
    BG2: TGlyph;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
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
  fTabs:=FSTabs.create(self, main2, 2);
  setItem(0, Text0);
  setItem(1, Text1);
  setItem(2, Text2);
  setItem(3, Text3);
end;

procedure TPlaceForm.addShow;
begin
  fTabs.setSize(true, true);
end;

procedure TPlaceForm.FormDestroy(Sender: TObject);
begin
  fTabs.Free;
end;

end.

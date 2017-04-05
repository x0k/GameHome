unit FoundationUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Effects,
  FMX.Filter.Effects, DataUnit, FMX.ImgList, FMX.Ani,
  GameForms, FullScreenTabs;

type
  TFoundationForm = class(TGForm)
    BG: TGlyph;
    f0: TGlyph;
    f1: TGlyph;
    f2: TGlyph;
    f3: TGlyph;
    Main: TLayout;
    s0: TLayout;
    s1: TLayout;
    s2: TLayout;
    s3: TLayout;
    t0: TText;
    t1: TText;
    t2: TText;
    t3: TText;
    Home: TGlyph;
    Text: TText;
  protected
    procedure onFormCreate; override;
    procedure enter(tab: FSTab);
  end;

implementation

{$R *.fmx}

var
  Tabs: FSTabs;

procedure TFoundationForm.enter(tab: FSTab);
begin
  Text.Text:=tab.txt.Text;
end;

procedure TFoundationForm.onFormCreate;
begin
  backgrounds:=[BG, home];
  layouts:=[main, home];
  Tabs:=FSTabs.create(self, main, 2);
  Tabs.afterEnter:=enter;
  setItem(0, t0);
  setItem(1, t1);
  setItem(2, t2);
  setItem(3, t3);
  Tabs.setSize(false, false);
end;

end.

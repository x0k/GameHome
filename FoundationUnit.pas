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
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure enter(tab: FSTab);
    procedure isWin(tab: FSTab);
  end;

implementation

{$R *.fmx}

var
  Tabs: FSTabs;
  wr: boolean;

procedure TFoundationForm.enter(tab: FSTab);
begin
  Text.Text:=tab.txt.Text;
end;

procedure TFoundationForm.onFormCreate;
begin
  backgrounds:=[BG, home];
  layouts:=[main, home];
  Tabs:=FSTabs.create(self, main, 2);
  Tabs.afterClick:=isWin;
  Tabs.afterEnter:=enter;
  setItem(0, t0);
  setItem(1, t1);
  setItem(2, t2);
  setItem(3, t3);
  Tabs.setSize(false, false);
  wr:=false;
end;

procedure TFoundationForm.FormDestroy(Sender: TObject);
begin
  tabs.Free;
end;

procedure TFoundationForm.isWin(tab: FSTab);
begin
  if tab.layer.TabOrder=2 then
  begin
    win;
    if not wr then setMedal(3);
  end;
  wr:=true;
end;

end.

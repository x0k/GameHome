unit SeazonUnit;

interface

uses
  System.SysUtils, System.Types, System.Classes,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Ani, FMX.ImgList,
  GameForms, FullScreenTabs;

type
  TSeazonForm = class(TGForm)
    s0: TLayout;
    s1: TLayout;
    s2: TLayout;
    s3: TLayout;
    img0: TGlyph;
    img1: TGlyph;
    img2: TGlyph;
    img3: TGlyph;
    Main: TLayout;
    t0: TText;
    t1: TText;
    t2: TText;
    t3: TText;
    BG: TGlyph;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure isWin(tab: FSTab);
  end;

implementation

{$R *.fmx}

uses
  FMX.Dialogs;

var
  Tabs: FSTabs;
  first: boolean;

procedure TSeazonForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[Main];
  Tabs:=FSTabs.create(self, main, 1);
  Tabs.afterClick:=isWin;
  setItem(0, t0);
  setItem(1, t1);
  setItem(2, t2);
  setItem(3, t3);
  first:=true;
end;

procedure TSeazonForm.addShow;
begin
  Tabs.setSize(true, true);
end;

procedure TSeazonForm.FormDestroy(Sender: TObject);
begin
  Tabs.Free;
end;

procedure TSeazonForm.isWin(tab: FSTab);
begin
  if tab.layer.TabOrder=1 then
  begin
    win;
    if first then setMedal(1);
  end;
  first:=false;
end;

end.

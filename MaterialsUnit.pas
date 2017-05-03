unit MaterialsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, DataUnit, FMX.ImgList, FMX.Ani,
  GameForms, FullScreenTabs;

type
  TMaterialsForm = class(TGForm)
    T0: TText;
    T1: TText;
    T2: TText;
    T3: TText;
    Text: TMemo;
    BG: TGlyph;
    Trees: TGlyph;
    m0: TGlyph;
    m1: TGlyph;
    m2: TGlyph;
    m3: TGlyph;
    L0: TLayout;
    L1: TLayout;
    L2: TLayout;
    L3: TLayout;
    Main: TLayout;
    Top: TLayout;
    Grid: TLayout;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure isWin(tab: FSTab);
  end;

implementation

{$R *.fmx}

var
  tabs:FSTabs;
  a, b, wr: boolean;

procedure TMaterialsForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  tabs:=FSTabs.create(self, grid, 0);
  tabs.afterClick:=isWin;
  setItem(0, t0);
  setItem(1, t1);
  setItem(2, t2);
  setItem(3, t3);
  a:=false;
  b:=false;
  wr:=false;
end;

procedure TMaterialsForm.addShow;
begin
  tabs.setSize(false, true);
end;

procedure TMaterialsForm.isWin(tab: FSTab);
begin
  case tab.txt.Tag of
    1: a:=true;
    3: b:=true;
    else wr:=true;
  end;
  setText(tab.layer.TabOrder);
  if tab.img.ImageIndex mod 2=0 then tab.img.ImageIndex:=tab.img.ImageIndex+1;
  if a and b then
  begin
    win;
    if not wr then setMedal(2);
  end;
end;

procedure TMaterialsForm.FormDestroy(Sender: TObject);
begin
  tabs.Free;
end;

end.

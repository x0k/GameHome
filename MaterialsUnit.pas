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
  protected
    procedure onFormCreate; override;
    procedure isWin(tab: FSTab);
  end;

implementation

{$R *.fmx}

var
  tabs:FSTabs;
  a, b: boolean;

procedure TMaterialsForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  tabs:=FSTabs.create(self, grid, 0);
  setItem(0, t0);
  setItem(1, t1);
  setItem(2, t2);
  setItem(3, t3);
  tabs.setSize(true, true);
  tabs.afterClick:=isWin;
  a:=false;
  b:=false;
end;

procedure TMaterialsForm.isWin(tab: FSTab);
begin
  case tab.txt.Tag of
    1: a:=true;
    3: b:=true;
  end;
  setText(tab.layer.TabOrder);
  if tab.img.ImageIndex mod 2=0 then tab.img.ImageIndex:=tab.img.ImageIndex+1;
  if a and b then win;  
end;

end.

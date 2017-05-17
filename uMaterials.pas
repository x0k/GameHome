unit uMaterials;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.ImgList,
  uFrame, FullScreenTabs;

type
  TMaterialsFrame = class(TGFrame)
    Main: TLayout;
    Top: TLayout;
    Text: TMemo;
    Trees: TGlyph;
    Grid: TLayout;
    L0: TLayout;
    m0: TGlyph;
    T0: TText;
    L1: TLayout;
    m1: TGlyph;
    T1: TText;
    L2: TLayout;
    m2: TGlyph;
    T2: TText;
    L3: TLayout;
    m3: TGlyph;
    T3: TText;
    T0t: TText;
    T1t: TText;
    T2t: TText;
    T3t: TText;
  protected
    procedure onFCreate; override;
    procedure onFDestroy; override;
    procedure isWin(tab: FSTab);
  public
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

var
  tabs:FSTabs;
  a, b: boolean;

procedure TMaterialsFrame.onFCreate;
begin
  layouts:=[main];
  tabs:=FSTabs.create(self, grid, isWin);
  a:=false;
  b:=false;
end;

procedure TMaterialsFrame.onFShow;
begin
  tabs.setSize(false, true);
  inherited;
end;

procedure TMaterialsFrame.isWin(tab: FSTab);
begin
  case tab.txt.Tag of
    1:begin
      a:=true;
      if not b then clicks;
    end;
    3:begin
      b:=true;
      if not a then clicks;
    end;
    else wrong;
  end;
  setText(tab.layer.TabOrder);
  if tab.img.ImageIndex mod 2=0 then tab.img.ImageIndex:=tab.img.ImageIndex+1;
  if a and b then
  begin
    win;
    if not fail then setMedal(3);
  end;
end;

procedure TMaterialsFrame.onFDestroy;
begin
  tabs.Free;
end;

end.

unit uRoof;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.ImgList,
  uFrame, FullScreenTabs;

type
  TRoofFrame = class(TGFrame)
    Main: TLayout;
    Home: TGlyph;
    roof: TGlyph;
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
  protected
    procedure onFCreate; override;
    procedure onFDestroy; override;
    procedure win; override;
    procedure isWin(tab: FSTab);
  public
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

uses
  FMX.Ani;

var
  tabs:FSTabs;

procedure TRoofFrame.onFCreate;
begin
  layouts:=[main];
  tabs:=FSTabs.create(self, grid, isWin);
end;

procedure TRoofFrame.onFDestroy;
begin
  tabs.Free;
end;

procedure TRoofFrame.onFShow;
begin
  tabs.setSize(true, true);
  inherited;
end;

procedure TRoofFrame.isWin(tab: FSTab);
begin
  if tab.layer.TabOrder=2 then win;
end;

procedure TRoofFrame.Win;
begin
  inherited;
  TAnimator.AnimateFloatWait(roof, 'opacity', 1);
  setBonus(7);
  home.ImageIndex:=-1;
end;

end.

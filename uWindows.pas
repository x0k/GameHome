unit uWindows;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.ImgList,
  uFrame, FullScreenTabs;

type
  TWindowsFrame = class(TGFrame)
    Main: TLayout;
    Home: TGlyph;
    Window: TGlyph;
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
  wr: boolean;

procedure TWindowsFrame.onFCreate;
begin
  layouts:=[main];
  tabs:=FSTabs.create(self, grid, isWin);
  wr:=false;
end;

procedure TWindowsFrame.onFDestroy;
begin
  tabs.Free;
end;

procedure TWindowsFrame.Win;
begin
  inherited;
  TAnimator.AnimateFloatWait(window, 'opacity', 1);
  home.ImageIndex:=-1;
end;

procedure TWindowsFrame.onFShow;
begin
  tabs.setSize(false, true);
  inherited;
end;

procedure TWindowsFrame.isWin(tab: FSTab);
begin
  if tab.img.ImageIndex mod 2=0 then tab.img.ImageIndex:=tab.img.ImageIndex+1;
  if tab.txt.Tag=4 then
  begin
    win;
    if not wr then setMedal(5);
  end else wr:=true;
end;

end.

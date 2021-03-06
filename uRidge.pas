unit uRidge;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.ImgList, FMX.TabControl,
  uTabFrame, FullScreenTabs;

type
  TRidgeFrame = class(TTabFrame)
    TabItem1: TTabItem;
    Main1: TLayout;
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
    L4: TLayout;
    m4: TGlyph;
    T4: TText;
    Home: TGlyph;
    Ridge: TGlyph;
    TabItem2: TTabItem;
    Main2: TLayout;
    Decs: TLayout;
    S0: TLayout;
    D0: TGlyph;
    Text1: TText;
    Layout1: TLayout;
    Text4: TText;
    Glyph4: TGlyph;
    S1: TLayout;
    D1: TGlyph;
    Text2: TText;
    Layout2: TLayout;
    Text5: TText;
    Glyph1: TGlyph;
    S2: TLayout;
    D2: TGlyph;
    Text3: TText;
    Layout3: TLayout;
    Text6: TText;
    Glyph2: TGlyph;
    homeDecor: TGlyph;
  protected
    procedure onFCreate; override;
    procedure onFDestroy; override;
    procedure win; override;
    procedure isWin(tab: FSTab);
    procedure setDec(tab: FSTab);
  public
    procedure onFShow; override;
    procedure next; override;
  end;

implementation

{$R *.fmx}

uses
  FMX.Ani, DataUnit, gameUnit;

var
  rgs, dcs:FSTabs;

procedure TRidgeFrame.onFCreate;
begin
  layouts:=[main1, main2];
  rgs:=FSTabs.create(self, grid, isWin);
  dcs:=FSTabs.create(self, decs, setDec, nil, nil, false);
  gTab:=0;
  inherited;
end;

procedure TRidgeFrame.setDec(tab: FSTab);
begin
  clicks;
  if (Owner as TGameForm).medalsCount>=tab.txt.Tag then
  begin
    case tab.txt.Tag of
      5:homeDecor.ImageIndex:=23;
      8:homeDecor.ImageIndex:=24;
      11:homeDecor.ImageIndex:=25;
    end;
    setText(homeDecor.ImageIndex-17);
  end else setText(5);
end;

procedure TRidgeFrame.onFShow;
begin
  rgs.setSize(false, false);
  dcs.setSize(false, false);
  inherited;
end;

procedure TRidgeFrame.Win;
begin
  inherited;
  TAnimator.AnimateFloatWait(Ridge, 'opacity', 1);
  if not fail then setMedal(12);
  home.ImageIndex:=-1;
end;

procedure TRidgeFrame.onFDestroy;
begin
  rgs.Free;
end;

procedure TRidgeFrame.isWin(tab: FSTab);
begin
  if tab.img.ImageIndex mod 2=0 then tab.img.ImageIndex:=tab.img.ImageIndex+1;
  if tab.layer.TabOrder=0 then win
    else wrong;
end;

procedure TRidgeFrame.next;
var
  i: byte;
begin
  if gTabs.TabIndex=1 then
    for i:=0 to MDL_COUNT-1 do
      setMedal(i, false);
  inherited;
end;

end.

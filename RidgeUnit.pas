unit RidgeUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ImgList,
  GameForms, FullScreenTabs, FMX.TabControl;

type
  TRidgeForm = class(TGTabForm)
    BG1: TGlyph;
    Main1: TLayout;
    Grid: TLayout;
    L0: TLayout;
    m0: TGlyph;
    L1: TLayout;
    m1: TGlyph;
    T1: TText;
    L2: TLayout;
    m2: TGlyph;
    T2: TText;
    L3: TLayout;
    m3: TGlyph;
    T3: TText;
    T0: TText;
    L4: TLayout;
    m4: TGlyph;
    T4: TText;
    Home: TGlyph;
    Ridge: TGlyph;
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    BG2: TGlyph;
    Main2: TLayout;
    Decs: TLayout;
    S0: TLayout;
    D0: TGlyph;
    Text1: TText;
    S1: TLayout;
    D1: TGlyph;
    Text2: TText;
    S2: TLayout;
    D2: TGlyph;
    Text3: TText;
    homeDecor: TGlyph;
    Layout1: TLayout;
    Text4: TText;
    Glyph4: TGlyph;
    Layout2: TLayout;
    Text5: TText;
    Glyph1: TGlyph;
    Layout3: TLayout;
    Text6: TText;
    Glyph2: TGlyph;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure addWin; override;
    procedure isWin(tab: FSTab);
    procedure setDec(tab: FSTab);
  public
    procedure Next(Sender: TObject); override;
  end;

implementation

{$R *.fmx}

uses
  FMX.Ani, DataUnit, BarUnit;

var
  rgs, dcs:FSTabs;
  wr: boolean;

procedure TRidgeForm.onFormCreate;
begin
  backgrounds:=[BG1, BG2];
  layouts:=[main1, main2];
  rgs:=FSTabs.create(self, grid, 0);
  rgs.afterClick:=isWin;
  dcs:=FSTabs.create(self, decs, 0, false);
  dcs.afterClick:=setDec;
  gTabs:=tabs;
  gTab:=0;
  wr:=false;
end;

procedure TRidgeForm.setDec(tab: FSTab);
begin
  if medalCount>=tab.txt.Tag then
  begin
    homeDecor.ImageIndex:=22+tab.txt.Tag div 2;
    setItem(0, Bar.SubText)
  end else setItem(1, Bar.SubText);
end;

procedure TRidgeForm.addShow;
begin
  rgs.setSize(false, false);
  dcs.setSize(false, false);
end;

procedure TRidgeForm.addWin;
begin
  TAnimator.AnimateFloatWait(Ridge, 'opacity', 1);
  if not wr then setMedal(7);
  home.ImageIndex:=-1;
end;

procedure TRidgeForm.FormDestroy(Sender: TObject);
begin
  rgs.Free;
end;

procedure TRidgeForm.isWin(tab: FSTab);
begin
  if tab.img.ImageIndex mod 2=0 then tab.img.ImageIndex:=tab.img.ImageIndex+1;
  if tab.layer.TabOrder=0 then win else wr:=true;
end;

procedure TRidgeForm.Next(Sender: TObject);
var
  i: byte;
begin
  for i:=1 to (homeDecor.ImageIndex-22)*2 do
    setMedal(i, false);
  inherited;
end;

end.

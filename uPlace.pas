unit uPlace;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.Layouts, FMX.ImgList, FMX.TabControl,
  uTabFrame, FullScreenTabs;

type
  TPlaceFrame = class(TTabFrame)
    TabItem1: TTabItem;
    Main1: TLayout;
    Map: TGlyph;
    Text: TMemo;
    TabItem2: TTabItem;
    Main2: TLayout;
    s0: TLayout;
    img0: TGlyph;
    Text0: TText;
    s1: TLayout;
    img1: TGlyph;
    Text1: TText;
    s2: TLayout;
    img2: TGlyph;
    Text2: TText;
    s3: TLayout;
    img3: TGlyph;
    Text3: TText;
  protected
    procedure onFCreate; override;
    procedure onFDestroy; override;
  public
    procedure onFShow; override;
    procedure isWin(tab: FSTab);
  end;

implementation

{$R *.fmx}

var
  fTabs: FSTabs;

procedure TPlaceFrame.onFCreate;
begin
  layouts:=[main1, main2];
  gTab:=1;
  fTabs:=FSTabs.create(self, main2, isWin);
  inherited;
end;

procedure TPlaceFrame.onFDestroy;
begin
  fTabs.Free;
end;

procedure TPlaceFrame.onFShow;
begin
  fTabs.setSize(true, true);
  inherited;
end;

procedure TPlaceFrame.isWin(tab: FSTab);
begin
  if tab.layer.TabOrder=2 then
  begin
    win;
    setBonus(0);
  end else wrong;
end;

end.

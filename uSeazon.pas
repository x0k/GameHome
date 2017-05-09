unit uSeazon;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.ImgList,
  FullScreenTabs, uFrame;

type
  TSeazonFrame = class(TGFrame)
    Main: TLayout;
    s0: TLayout;
    img0: TGlyph;
    t0: TText;
    s1: TLayout;
    img1: TGlyph;
    t1: TText;
    s2: TLayout;
    img2: TGlyph;
    t2: TText;
    s3: TLayout;
    img3: TGlyph;
    t3: TText;
  protected
    procedure onFCreate; override;
    procedure onFDestroy; override;
  public
    procedure isWin(tab: FSTab);
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

uses
  FMX.Dialogs;

var
  Tabs: FSTabs;
  wr: boolean;

procedure TSeazonFrame.onFCreate;
begin
  layouts:=[Main];
  Tabs:=FSTabs.create(self, main, isWin);
  wr:=false;
end;

procedure TSeazonFrame.onFDestroy;
begin
  Tabs.Free;
end;

procedure TSeazonFrame.onFShow;
begin
  Tabs.setSize(true, true);
  inherited;
end;

procedure TSeazonFrame.isWin(tab: FSTab);
begin
  if tab.layer.TabOrder=1 then
  begin
    win;
    if not wr then setMedal(0);
  end;
  wr:=true;
end;

end.

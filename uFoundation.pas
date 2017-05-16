unit uFoundation;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.ImgList,
  uFrame, FullScreenTabs;

type
  TFoundationFrame = class(TGFrame)
    Home: TGlyph;
    Main: TLayout;
    s0: TLayout;
    f0: TGlyph;
    t0: TText;
    s1: TLayout;
    f1: TGlyph;
    t1: TText;
    s2: TLayout;
    f2: TGlyph;
    t2: TText;
    s3: TLayout;
    f3: TGlyph;
    t3: TText;
    Text: TText;
  protected
    procedure onFCreate; override;
    procedure onFDestroy; override;
    procedure enter(tab: FSTab);
    procedure isWin(tab: FSTab);
  public
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

var
  Tabs: FSTabs;

procedure TFoundationFrame.onFCreate;
begin
  backgrounds:=[home];
  layouts:=[main, home];
  Tabs:=FSTabs.create(self, main, isWin, enter);
  Tabs.setSize(false, false);
end;

procedure TFoundationFrame.onFDestroy;
begin
  tabs.Free;
end;

procedure TFoundationFrame.onFShow;
begin
  tabs.setSize(false, true);
  inherited;
end;

procedure TFoundationFrame.enter(tab: FSTab);
begin
  Text.Text:=tab.txt.Text;
end;

procedure TFoundationFrame.isWin(tab: FSTab);
begin
  if tab.layer.TabOrder=2 then
  begin
    win;
    if not fail then setMedal(5);
  end else wrong;
end;

end.

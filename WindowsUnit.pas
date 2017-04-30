unit WindowsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  DataUnit, FMX.Layouts, FMX.ImgList, FMX.Objects,
  GameForms, FullScreenTabs;

type
  TWindowsForm = class(TGForm)
    BG: TGlyph;
    Main: TLayout;
    Home: TGlyph;
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
    Window: TGlyph;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure addWin; override;
    procedure isWin(tab: FSTab);
  end;

var
  WindowsForm: TWindowsForm;

implementation

{$R *.fmx}

uses
  FMX.Ani;

var
  tabs:FSTabs;

procedure TWindowsForm.addWin;
begin
  TAnimator.AnimateFloatWait(window, 'opacity', 1);
  home.ImageIndex:=-1;
end;

procedure TWindowsForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  tabs:=FSTabs.create(self, grid, 3);
  tabs.afterClick:=isWin;
  setItem(0, t0);
  setItem(1, t1);
  setItem(2, t2);
  setItem(3, t3);
end;

procedure TWindowsForm.addShow;
begin
  tabs.setSize(false, true);
end;

procedure TWindowsForm.FormDestroy(Sender: TObject);
begin
  tabs.Free;
end;

procedure TWindowsForm.isWin(tab: FSTab);
begin
  if tab.img.ImageIndex mod 2=0 then tab.img.ImageIndex:=tab.img.ImageIndex+1;
  if tab.txt.Tag=4 then win;
end;

end.

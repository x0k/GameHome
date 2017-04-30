unit RidgeUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ImgList,
  GameForms, FullScreenTabs;

type
  TRidgeForm = class(TGForm)
    BG: TGlyph;
    Main: TLayout;
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
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure addWin; override;
    procedure isWin(tab: FSTab);
  end;

var
  RidgeForm: TRidgeForm;

implementation

{$R *.fmx}

uses
  FMX.Ani, DataUnit;

var
  Tabs:FSTabs;

procedure TRidgeForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  tabs:=FSTabs.create(self, grid, 0);
  tabs.afterClick:=isWin;
end;

procedure TRidgeForm.addShow;
begin
  tabs.setSize(false, true);
end;

procedure TRidgeForm.addWin;
begin
  TAnimator.AnimateFloatWait(Ridge, 'opacity', 1);
  home.ImageIndex:=-1;
end;

procedure TRidgeForm.FormDestroy(Sender: TObject);
begin
  tabs.Free;
end;

procedure TRidgeForm.isWin(tab: FSTab);
begin
  if tab.img.ImageIndex mod 2=0 then tab.img.ImageIndex:=tab.img.ImageIndex+1;
  if tab.layer.TabOrder=0 then win;
end;

end.

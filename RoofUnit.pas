unit RoofUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.ImgList,
  GameForms;

type
  TRoofForm = class(TGForm)
    BG: TGlyph;
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
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure addWin; override;
  end;

var
  RoofForm: TRoofForm;

implementation

{$R *.fmx}

uses
  FMX.Ani,
  FullScreenTabs, DataUnit;

var
  tabs:FSTabs;

procedure TRoofForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  tabs:=FSTabs.create(self, grid, 2);
end;

procedure TRoofForm.addShow;
begin
  tabs.setSize(true, true);
end;

procedure TRoofForm.addWin;
begin
  TAnimator.AnimateFloatWait(roof, 'opacity', 1);
  setBonus(8);
  home.ImageIndex:=-1;
end;

procedure TRoofForm.FormDestroy(Sender: TObject);
begin
  tabs.Free;
end;

end.

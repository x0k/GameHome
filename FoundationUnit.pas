unit FoundationUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Effects,
  FMX.Filter.Effects, DataUnit, FMX.ImgList, FMX.Ani,
  GameForms;

type
  TFoundationForm = class(TGForm)
    BG: TGlyph;
    f0: TGlyph;
    f1: TGlyph;
    f2: TGlyph;
    f3: TGlyph;
    Main: TLayout;
    s0: TLayout;
    s1: TLayout;
    s2: TLayout;
    s3: TLayout;
    t0: TText;
    t1: TText;
    t2: TText;
    t3: TText;
    home: TGlyph;
  protected
    procedure onFormCreate; override;
  end;

implementation

{$R *.fmx}

uses
  FullScreenTabs;

var
  Tabs: FSTabs;

procedure TFoundationForm.onFormCreate;
begin
  backgrounds:=[BG, home];
  layouts:=[main];
  Tabs:=FSTabs.create(self, main, 2);
  setItem(0, t0);
  setItem(1, t1);
  setItem(2, t2);
  setItem(3, t3);
  Tabs.setSize(false, true);
end;

end.

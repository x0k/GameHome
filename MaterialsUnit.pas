unit MaterialsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, DataUnit, FMX.ImgList, FMX.Ani;

type
  TMaterialsForm = class(TGForm)
    Main: TLayout;
    Grid: TGridPanelLayout;
    Tsosn: TText;
    Tfor: TText;
    Tiul: TText;
    Tsent: TText;
    Text: TMemo;
    BG: TGlyph;
    trees: TGlyph;
    m0: TGlyph;
    m1: TGlyph;
    m2: TGlyph;
    m3: TGlyph;
  protected
    procedure gShow; override;
    procedure click(Sender: TObject);
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

var
  a,b:boolean;

procedure TMaterialsForm.click(Sender: TObject);
var
  id:byte;
begin
  id:=TGlyph(sender).ImageIndex;
  case id of
    18:a:=true;
    22:b:=true;
  end;
  if id mod 2=0 then TGlyph(sender).ImageIndex:=id+1;
  self.setDescription(TGlyph(sender).Tag, Bar.SubText);
  if a and b then win;
end;

procedure TMaterialsForm.gShow;
begin
  self.setDescription(5, text);
  main.Height:=self.Height/2;

  m0.OnClick:=click;
  m0.HitTest:=true;
  m1.OnClick:=click;
  m1.HitTest:=true;
  m2.OnClick:=click;
  m2.HitTest:=true;
  m3.OnClick:=click;
  m3.HitTest:=true;
end;

end.

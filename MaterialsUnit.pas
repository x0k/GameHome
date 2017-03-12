unit MaterialsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, DataUnit, FMX.ImgList, FMX.Ani;

type
  TMaterialsForm = class(TGForm)
    T0: TText;
    T1: TText;
    T2: TText;
    T3: TText;
    Text: TMemo;
    BG: TGlyph;
    trees: TGlyph;
    m0: TGlyph;
    m1: TGlyph;
    m2: TGlyph;
    m3: TGlyph;
    L0: TLayout;
    L1: TLayout;
    L2: TLayout;
    L3: TLayout;
    main: TLayout;
    top: TLayout;
    grid: TLayout;
    procedure L0MouseEnter(Sender: TObject);
    procedure L0Click(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
  end;

implementation

{$R *.fmx}

var
  a,b:boolean;
  w:single;
  id:shortint;

procedure TMaterialsForm.onFormCreate;
var
  i:byte;
begin
  bgs:=[BG];
  lts:=[main];
  top.Height:=Screen.Height/2;
  text.Width:=Screen.Width/3;
  w:=Screen.Width/6;
  Grid.Width:=w*4;
  for i:=0 to 3 do
    (Grid.Children[i] as TLayout).Width:=w;
  id:=-1;
end;

procedure TMaterialsForm.addShow;
begin
  self.setDescription(5, text);
end;

procedure TMaterialsForm.L0Click(Sender: TObject);
var
  id:byte;
  G:TGlyph;
begin
  G:=TFmxObject(sender).Children[0] as TGlyph;
  id:=G.ImageIndex;
  case id of
    18:a:=true;
    22:b:=true;
  end;
  if id mod 2=0 then G.ImageIndex:=id+1;
  self.setDescription(G.Tag, Bar.SubText);
  if a and b then win;
end;

procedure TMaterialsForm.L0MouseEnter(Sender: TObject);
var
  last:shortint;
  procedure incAni(O:TFmxObject);
  begin
    TAnimator.AnimateFloat(O, 'Margins.Left', 40);
    TAnimator.AnimateFloat(O, 'Margins.Right', 40);
  end;
  procedure decAni(O:TFmxObject);
  begin
    TAnimator.AnimateFloat(O, 'Margins.Left', 60);
    TAnimator.AnimateFloat(O, 'Margins.Right', 60);
  end;
begin
  last:=id;
  id:=Grid.Children.IndexOf(Sender as TFmxObject);
  if (last>=0)and(id<>last) then decAni(Grid.Children.Items[last].Children[0]);
  incAni(TFmxObject(Sender).Children[0]);
end;

end.

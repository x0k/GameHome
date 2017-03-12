unit OmenUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit, system.Math,
  FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts,
  FMX.ImgList;

type
  TWalls = class(TGlyph)
  private
    points:array[0..4] of TPointF;
    circles:array[0..3] of TCircle;
  public
    procedure upPositions;
    constructor create(own:TComponent; p :TFmxObject);
  end;

  TOmenForm = class(TGForm)
    BG: TGlyph;
    main: TLayout;
    top: TLayout;
    Text: TMemo;
    grid: TLayout;
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
    left: TLayout;
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
  end;

var
  OmenForm: TOmenForm;

implementation

{$R *.fmx}

var
  w:single;
  walls:TWalls;

constructor TWalls.create(own:TComponent; p:TFmxObject);
var
  i:byte;
  k:single;
  function getPoint(id:byte):TPointF;
  begin
    case id of
      0:result:=TPointF.Create(39*k, 48*k);
      1:result:=TPointF.Create(327*k, 48*k);
      2:result:=TPointF.Create(39*k, 314*k);
      3:result:=TPointF.Create(327*k, 314*k);
    end;
  end;
begin
  inherited create(own);
  Images:=DataForm.getList(rImages);
  ImageIndex:=7;
  Align:=TAlignLayout.Center;
  Width:=min(Screen.Width*23/64-260, Screen.Height*3/5-240);
  Height:=Width;
  parent:=p;
  k:=width/360;
  for i:=0 to 3 do
  begin
    points[i]:=getPoint(i);
    circles[i]:=TCircle.Create(own);
    p.AddObject(circles[i]);
  end;
  points[4]:=TPointF.Create(25, 25);
end;

procedure TWalls.upPositions;
var
  i:byte;
begin
  for i:=0 to 3 do
    circles[i].Position.Point:=self.Position.Point+points[i]-points[4];
end;

procedure TOmenForm.onFormCreate;
var
  i:byte;
begin
  bgs:=[BG];
  lts:=[main];
  top.Height:=Screen.Height*3/5;
  text.Margins.Right:=Screen.Width*(9/64);
  text.Width:=Screen.Width/2-(20+text.Margins.Right);
  Walls:=TWalls.create(self, left);
  w:=Screen.Width/6;
  Grid.Width:=w*4;
  for i:=0 to 3 do
    (Grid.Children[i] as TLayout).Width:=w;
end;

procedure TOmenForm.addShow;
begin
  setDescription(6, Text);
  walls.upPositions;
end;

end.

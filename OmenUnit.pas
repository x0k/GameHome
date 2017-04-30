unit OmenUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit, system.Math,
  FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts,
  FMX.ImgList, FMX.ani,
  GameForms, FullScreenTabs;

type
  TWalls = class(TGlyph)
  private
    points:array[0..4] of TPointF;
    circles:array[0..3] of TGlyph;

    function findId(id:byte):ShortInt;
    procedure hideCir(i:byte;id:ShortInt=-1);
    procedure showCir(i,id:byte);
    procedure clear;
    procedure drop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure over(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
  public
    procedure upPositions(h:single);

    destructor Destroy; override;
    constructor create(own:TComponent; p :TFmxObject); reintroduce;
  end;

  TOmenForm = class(TGForm)
    BG: TGlyph;
    Main: TLayout;
    Top: TLayout;
    Text: TMemo;
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
    Left: TLayout;
    procedure FormDestroy(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure addWin; override;
    procedure enter(tab:FSTab);
  end;

implementation

{$R *.fmx}

uses
  ResourcesManager;

var
  t:boolean;
  walls:TWalls;
  tabs:FSTabs;

destructor TWalls.Destroy;
var
  g:TGlyph;
begin
  for g in circles do
    g.Free;
  inherited;
end;

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
  Images:=getImgList(rImages);
  ImageIndex:=7;
  Align:=TAlignLayout.Center;
  Width:=min(Screen.Width/2-140, Screen.Height*2/3-200);
  Height:=Width;
  parent:=p;
  k:=width/360;
  for i:=0 to 3 do
  begin
    points[i]:=getPoint(i);
    circles[i]:=TGlyph.Create(own);
    circles[i].Images:=getImgList(rSwitchers);
    circles[i].OnDragOver:=over;
    circles[i].OnDragDrop:=drop;
    circles[i].AutoHide:=false;
    circles[i].Visible:=true;
    circles[i].HitTest:=true;
    circles[i].Opacity:=0;
    circles[i].Tag:=i;
    p.AddObject(circles[i]);
  end;
end;

procedure TWalls.upPositions;
var
  i:byte;
begin
  points[4]:=TPointF.Create(h/2, h/2);
  for i:=0 to 3 do
  begin
    circles[i].Width:=h;
    circles[i].Height:=h;
    circles[i].Position.Point:=self.Position.Point+points[i]-points[4];
  end;
end;

procedure TWalls.clear;
var
  i:byte;
begin
  for i:=0 to 3 do
    hideCir(i);
end;

procedure TWalls.hideCir(i: Byte; id : ShortInt = -1);
begin
  TAnimator.AnimateFloatWait(circles[i], 'opacity', 0);
  circles[i].ImageIndex:=id;
end;

procedure TWalls.showCir(i: Byte; id: Byte);
begin
  circles[i].ImageIndex:=id;
  TAnimator.AnimateFloat(circles[i], 'opacity', 1);
end;

procedure TWalls.over(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
begin
  if (Data.Source is TLayout)and(TLayout(Data.Source).Children[0] is TGlyph) then
    Operation:=TDragOperation.Move;
end;

function TWalls.findId(id: Byte):ShortInt;
var
  i:byte;
begin
  result:=-1;
  for i:=0 to 3 do
    if circles[i].ImageIndex=id then
    begin
      result:=i;
      exit;
    end;
end;

procedure TWalls.drop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
var
  g:TGlyph;
  s,i:byte;
begin
  g:=TFmxObject(Data.Source).Children[0] as TGlyph;
  s:=TFmxObject(sender).Tag;
  if findId(g.ImageIndex)>=0 then
    hideCir(findId(g.ImageIndex));
  showCir(s, g.ImageIndex);
  if (circles[0].ImageIndex=9)and(circles[1].ImageIndex=11)and(circles[2].ImageIndex=10)and(circles[3].ImageIndex=8) then
    (Owner as TGForm).win
  else
  begin
    for i:=0 to 3 do
      if circles[i].ImageIndex=-1 then exit;
    clear;
  end;
end;

procedure TOmenForm.enter(tab: FSTab);
begin
  if not t then
    setText(tab.txt.Tag-1);
end;

procedure TOmenForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  Walls:=TWalls.create(self, left);
  tabs:=FSTabs.create(self, grid, 0);
  tabs.afterEnter:=enter;
end;

procedure TOmenForm.addShow;
begin
  tabs.setSize(false, true);
  walls.upPositions(min(m0.Height, m0.Width));
  t:=false;
end;

procedure TOmenForm.addWin;
begin
  t:=true;
  setText(5);
end;

procedure TOmenForm.FormDestroy(Sender: TObject);
begin
  walls.Free;
  tabs.Free;
end;

end.

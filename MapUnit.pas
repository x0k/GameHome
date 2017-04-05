unit MapUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, system.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, system.Math,
  FMX.Objects, BarUnit, FMX.Layouts, FMX.Ani, FMX.Effects, DataUnit, FMX.ImgList, System.UIConsts,
  GameForms;

type
  TMapForm = class(TGForm)
    Main: TLayout;
    BG: TGlyph;
    Map: TGlyph;
    brevno: TGlyph;
    Details: TFlowLayout;
    Right: TLayout;
    Path1: TPath;
    Path2: TPath;
    Path3: TPath;
    Path4: TPath;
    Path5: TPath;
    Path6: TPath;
    Path7: TPath;
    Path8: TPath;
    Path9: TPath;
    Path10: TPath;
    Path11: TPath;
    Path12: TPath;
    Path13: TPath;
    Path14: TPath;
    Path15: TPath;
    Path16: TPath;
    Path17: TPath;
    Path18: TPath;
    Path19: TPath;
    Wood: TLayout;
    shepka: TGlyph;
    sp: TPath;
    procedure Path1DragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
    procedure Path1DragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure addWin; override;
  end;

implementation

{$R *.fmx}

var
  w:single;
  c:byte;

procedure TMapForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  Details.Width:=Screen.Width/2;
  w:=min(Screen.Width/2, Screen.Height-240);
end;

procedure TMapForm.addShow;
var
  i,r:byte;
  c:TPath;
  s:TList<TPath>;
begin
  Map.SetBounds(Map.Position.X,Map.Position.Y, w-80,w-80);
  s:=TList<TPath>.Create;
  for i:=0 to 18 do
  begin
    Map.Children[i].Tag:=i;
    c:=Map.Children[i].clone(self) as Tpath;
    c.DragMode:=TDragMode.dmAutomatic;
    s.Add(c);
    (Map.Children[i] as TPath).Opacity:=0;
  end;
  s.Add(sp.Clone(self) as TPath);
  sp.DragMode:=TDragMode.dmManual;
  sp.Opacity:=0;
  repeat
    r:=random(s.Count);
    s.Items[r].Fill.Color:=changeHSL(TAlphaColorRec.Blue, (random(91)-45)/360, 0, 0);
    details.AddObject(s.Items[r]);
    s.Delete(r);
  until s.Count=0;
end;

procedure TMapForm.Path1DragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
begin
  if TFmxObject(sender).Tag=TPath(Data.Source).Tag then
  begin
    TPath(Data.Source).Destroy;
    TPath(sender).Fill.Color:=TPath(Data.Source).Fill.Color;
    if TFmxObject(sender).Tag<19 then
      TAnimator.AnimateFloat(TFmxObject(sender), 'opacity', 1, 1)
    else
      TAnimator.AnimateFloat(shepka, 'opacity', 1, 1);
    TFmxObject(sender).Tag:=TFmxObject(sender).Tag+20;
    inc(c);
    if c=20 then win;
  end else begin
    TPath(sender).Fill.Color:=TAlphaColorRec.Crimson;
    TAnimator.AnimateFloatWait(TFmxObject(sender), 'opacity', 1, 0.5);
    TAnimator.AnimateFloat(TFmxObject(sender), 'opacity', 0,  0.5);
  end;
end;

procedure TMapForm.Path1DragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
begin
  if (Data.Source is TPath)and(TFmxObject(sender).Tag<20) then
  begin
    TFmxObject(sender).BringToFront;
    Operation:=TDragOperation.Move;
  end;
end;

procedure TMapForm.addWin;
begin
  setText(1);
end;

end.

unit uTools;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ImgList,
  uFrame;

type
  TToolsFrame = class(TGFrame)
    tools: TGridLayout;
  protected
    procedure onFCreate; override;
    procedure onFDestroy; override;
    procedure win; override;
    procedure tclick(Sender: TObject);
    procedure tenter(Sender: TObject);
    procedure tleave(Sender: TObject);
  public
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

uses
  System.Generics.Collections,
  FMX.Effects, FMX.Ani,
  ResourcesManager;

var
  eff1, eff2: TInnerGlowEffect;
  a, b:boolean;

procedure TToolsFrame.Win;
begin
  inherited;
  a:=false;b:=false;
  if not fail then setMedal(2);
end;

procedure TToolsFrame.onFCreate;
begin
  eff1:=TInnerGlowEffect.Create(self);
  eff2:=TInnerGlowEffect.Create(self);
  layouts:=[tools];
end;

procedure TToolsFrame.tclick(Sender: TObject);
var
  id:byte;
begin
  id:=TGlyph(TFmxObject(sender).Children[0]).ImageIndex;
  case id of
    0:begin
      eff1.Parent:=TFmxObject(sender).Children[0];
      a:=true;
      if not b then clicks;
    end;
    1:begin
      eff2.Parent:=TFmxObject(sender).Children[0];
      b:=true;
      if not a then clicks;
    end;
    else wrong;
  end;
  setText(id);
  if a and b then win;
end;

procedure TToolsFrame.tenter(Sender: TObject);
begin
  TAnimator.AnimateFloat(sender as TFmxObject, 'RotationAngle', 20+random(20));
end;

procedure TToolsFrame.tleave(Sender: TObject);
begin
  TAnimator.AnimateFloat(sender as TFmxObject, 'RotationAngle', 0);
end;

procedure TToolsFrame.onFShow;
var
  L: TList<byte>;
  lt,lr:TLayout;
  G,C:TGlyph;
  i,k:byte;
begin
  l:=TList<byte>.create;
  tools.ItemWidth:=tools.Width/5-2;
  tools.ItemHeight:=tools.Height/2-2;
  lt:=TLayout.Create(self);
  lt.Align:=TAlignLayout.Client;
  G:=TGlyph.Create(self);
  G.Align:=TAlignLayout.Client;
  G.Images:=getImgList(rOther);
  G.Margins.Top:=20;
  G.Margins.Right:=20;
  G.Margins.Left:=20;
  G.Margins.Bottom:=20;
  for i:=0 to 9 do l.Add(i);
  while l.Count>0 do
  begin
    k:=random(l.Count);
    C:=G.Clone(self) as TGlyph;
    C.ImageIndex:=l[k];
    lr:=lt.Clone(self) as TLayout;
    lr.AddObject(C);
    lr.OnMouseEnter:=tenter;
    lr.OnMouseLeave:=tleave;
    lr.OnClick:=tclick;
    lr.HitTest:=true;
    tools.AddObject(lr);
    l.Remove(l[k]);
  end;
  l.Free;
  inherited;
end;

procedure TToolsFrame.onFDestroy;
begin
  eff1.Free;
  eff2.Free;
end;

end.

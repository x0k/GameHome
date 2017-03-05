unit ToolsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.Layouts, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, DataUnit,
  FMX.ImgList, system.Generics.Collections, FMX.ani;

type
  TToolsForm = class(TGForm)
    BG: TGlyph;
    tools: TGridLayout;
  protected
    procedure onCreateGForm; override;
    procedure gShow; override;
    procedure addWin; override;
    procedure click(Sender: TObject);
    procedure enter(Sender: TObject);
    procedure leave(Sender: TObject);
  public
    procedure hideAnimation; override;
    procedure showAnimation; override;
  end;

implementation

{$R *.fmx}

var
  glow, eff1, eff2:TInnerGlowEffect;
  a,b:boolean;

procedure TToolsForm.showAnimation;
begin
  TAnimator.AnimateFloatWait(tools, 'opacity', 1, 0.4);
end;

procedure TToolsForm.hideAnimation;
begin
  TAnimator.AnimateFloatWait(tools, 'opacity', 0, 0.3);
end;

procedure TToolsForm.addWin;
begin
  a:=false;b:=false;
end;

procedure TToolsForm.onCreateGForm;
begin
  glow:=TInnerGlowEffect.Create(self);
  glow.GlowColor:=TAlphaColorRec.Blue;
  eff1:=TInnerGlowEffect.Create(self);
  eff2:=TInnerGlowEffect.Create(self);
end;

procedure TToolsForm.click(Sender: TObject);
var
  id:byte;
begin
  id:=TGlyph(TFmxObject(sender).Children[0]).ImageIndex;
  case id of
    0:begin
      eff1.Parent:=TFmxObject(sender).Children[0];
      glow.Parent:=nil;
      a:=true;
    end;
    1:begin
      eff2.Parent:=TFmxObject(sender).Children[0];
      glow.Parent:=nil;
      b:=true;
    end;
    else glow.Parent:=TFmxObject(sender).Children[0];
  end;
  self.setDescription(id+1, Bar.SubText);
  if a and b then win;
end;

procedure TToolsForm.enter(Sender: TObject);
begin
  TAnimator.AnimateFloat(sender as TFmxObject,'RotationAngle', 20+random(20));
end;

procedure TToolsForm.leave(Sender: TObject);
begin
  TAnimator.AnimateFloat(sender as TFmxObject,'RotationAngle', 0);
end;

procedure TToolsForm.gShow;
var
  L:TList<byte>;
  lt,lr:TLayout;
  G,C:TGlyph;
  i,k:byte;
begin
  l:=TList<byte>.create;
  tools.ItemWidth:=tools.Width/5;
  tools.ItemHeight:=tools.Height/2;
  lt:=TLayout.Create(self);
  lt.Align:=TAlignLayout.Client;
  G:=TGlyph.Create(self);
  G.Align:=TAlignLayout.Client;
  G.Images:=DataForm.Other;
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
    lr.OnMouseEnter:=enter;
    lr.OnMouseLeave:=leave;
    lr.OnClick:=click;
    lr.HitTest:=true;
    tools.AddObject(lr);
    l.Remove(l[k]);
  end;
  l.Free;
end;


end.

unit ToolsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, DataUnit,
  FMX.ImgList, system.Generics.Collections;

type
  TToolsForm = class(TGForm)
    BG: TGlyph;
    tools: TGridLayout;
  protected
    procedure vCreate; override;
    procedure gShow; override;
    procedure aWin; override;
    procedure click(Sender: TObject);
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

var
  glow, eff1, eff2:TInnerGlowEffect;
  a,b:boolean;

procedure TToolsForm.aWin;
begin
  a:=false;b:=false;
end;

procedure TToolsForm.vCreate;
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
  id:=TGlyph(sender).ImageIndex;
  case id of
    0:begin
      eff1.Parent:=TFmxObject(sender);
      glow.Parent:=nil;
      a:=true;
    end;
    1:begin
      eff2.Parent:=TFmxObject(sender);
      glow.Parent:=nil;
      b:=true;
    end;
    else glow.Parent:=TFmxObject(sender);
  end;
  self.setDescription(id+1, Bar.SubText);
  if a and b then win;
end;

procedure TToolsForm.gShow;
var
  L:TList<byte>;
  G,C:TGlyph;
  i,k:byte;
begin
  l:=TList<byte>.create;
  tools.ItemWidth:=tools.Width/5;
  tools.ItemHeight:=tools.Height/2;
  G:=TGlyph.Create(self);
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
    C.HitTest:=true;
    C.OnClick:=click;
    tools.AddObject(C);
    l.Remove(l[k]);
  end;
  l.Free;
end;


end.

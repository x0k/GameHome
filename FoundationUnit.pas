unit FoundationUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Effects,
  FMX.Filter.Effects, DataUnit, FMX.ImgList, FMX.Ani;

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
    procedure s0MouseEnter(Sender: TObject);
  protected
    procedure onCreateGForm; override;
    procedure gShow; override;
  public
    { Public declarations }
  end;

var
  eff:TGloomEffect;

implementation

{$R *.fmx}
var
  w,p:single;
  shw, lst:ShortInt;

procedure TFoundationForm.s0MouseEnter(Sender: TObject);
var
  id:byte;
begin
  id:=main.Children.IndexOf(TFmxObject(sender));
  if (shw<0)and(id<>lst) then
  begin
    TAnimator.AnimateInt(Main.Children[lst].Children[0].Children[0], 'TextSettings.Font.Size', 30);
    //TAnimator.AnimateFloat(Main.Children[lst].Children[0].Children[0], 'opacity', 0);
    TAnimator.AnimateFloat(Main.Children[lst], 'width', w);

    TAnimator.AnimateInt(TFmxObject(sender).Children[0].Children[0], 'TextSettings.Font.Size', 50);
    //TAnimator.AnimateFloat(TFmxObject(sender).Children[0].Children[0], 'opacity', 1);
    TAnimator.AnimateFloat(Main, 'Position.X', p-(80*TFmxObject(sender).Tag/3));
    TAnimator.AnimateFloat(TFmxObject(sender), 'width', 80+w);
    lst:=id;
  end;
end;

procedure TFoundationForm.onCreateGForm;
begin
  eff:=TGloomEffect.Create(self);
end;

procedure TFoundationForm.gShow;
begin
  w:=main.Width/4;
  s0.Width:=w;
  s1.Width:=w;
  s2.Width:=w;
  s3.Width:=w;
  p:=main.Position.X;
  shw:=-1;
end;

end.

unit BarUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.ImageList,
  FMX.Types, FMX.Graphics, FMX.Forms, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Ani, FMX.Memo, FMX.ImgList,
  FMX.ScrollBox, FMX.Controls.Presentation, FMX.Controls;

type
  TBar = class(TFrame)
    SPanel: TPanel;
    NextBtn: TSpeedButton;
    BackBtn: TSpeedButton;
    SubName: TText;
    SubText: TMemo;
    logoLayout: TLayout;
    Logo: TGlyph;
    tools: TGlyph;
    woods: TGlyph;
    adws: TGridLayout;
    m0: TGlyph;
    m1: TGlyph;
    m2: TGlyph;
    m3: TGlyph;
    m4: TGlyph;
    m5: TGlyph;
    body: TGlyph;
    wh1: TGlyph;
    wh2: TGlyph;
    st1: TGlyph;
    st2: TGlyph;
    RBonus: TLayout;
    bonusBG: TRectangle;
    telega: TLayout;
    nextLayout: TLayout;
    SubLogo: TGlyph;
    backLayout: TLayout;
    Glyph1: TGlyph;
    progress: TLayout;
    Glyph2: TGlyph;
    Glyph3: TGlyph;
    Glyph4: TGlyph;
    Glyph5: TGlyph;
    Glyph6: TGlyph;
    Glyph7: TGlyph;
    Glyph8: TGlyph;
    Glyph9: TGlyph;
    Glyph10: TGlyph;
    Glyph11: TGlyph;
    Glyph12: TGlyph;
    Glyph13: TGlyph;
    Glyph14: TGlyph;
    Glyph15: TGlyph;
    ImageList1: TImageList;
    Glyph16: TGlyph;
    procedure RBonusMouseLeave(Sender: TObject);
    procedure logoLayoutClick(Sender: TObject);
  protected
    dots:TArray<TGlyph>;
    procedure showBonus(Sender: TObject);
  public
    procedure setDots;
    procedure setDot(i: byte; v: byte);
    procedure setShowBonus;
    procedure hideBonus;
    procedure showNext;
    procedure hideNext;

    property dotsStat[index: byte]: byte write setDot;
  end;

implementation

{$R *.fmx}

uses
  Forms;

const
  w = 360;

var
  open:boolean = false;

procedure TBar.setDots;
var
  f:TFmxObject;
begin
  setlength(dots, progress.Children.count);
  for f in  progress.Children do
    if f is TGlyph then
      dots[f.tag-1]:=f as TGlyph;
end;

procedure TBar.setDot;
begin
  if i<length(dots) then
    dots[i].imageIndex:=v;
end;

procedure TBar.setShowBonus;
begin
  NextBtn.OnClick:=showBonus;
end;

procedure TBar.hideBonus;
begin
  if open then showBonus(self);
end;

procedure TBar.showBonus(Sender: TObject);
begin
  if open then
  begin
    TAnimator.AnimateFloat(Rbonus, 'Position.X', (parent as TBarForm).Width);
    TAnimator.AnimateFloat(NextBtn, 'RotationAngle', 0);
  end else begin
    TAnimator.AnimateFloat(Rbonus, 'Position.X', (parent as TBarForm).Width-w);
    TAnimator.AnimateFloat(NextBtn, 'RotationAngle', 180);
  end;
  open:=not open;
end;

procedure TBar.logoLayoutClick(Sender: TObject);
begin
  if Assigned(parent) then
    (parent as TForm).close;
end;

procedure TBar.RBonusMouseLeave(Sender: TObject);
begin
  TAnimator.AnimateFloat(Rbonus, 'Position.X', (parent as TBarForm).Width);
  open:=false;
end;

procedure TBar.showNext;
begin
  NextBtn.Visible:=true;
  TAnimator.AnimateFloat(NextLayout, 'opacity', 1);
end;

procedure TBar.hideNext;
begin
  TAnimator.AnimateFloat(NextLayout, 'opacity', 0);
  NextBtn.Visible:=false;
end;

end.

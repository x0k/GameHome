unit BarUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Ani,
  FGX.Animations, FMX.ScrollBox, FMX.Memo, FMX.TabControl, FMX.ImgList;

type
  TBar = class(TFrame)
    SPanel: TPanel;
    NextBtn: TSpeedButton;
    BackBtn: TSpeedButton;
    SubPanel1: TGridPanelLayout;
    SubLogo: TImage;
    SubName: TText;
    SubText: TMemo;
    chip: TImage;
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
    procedure RBonusMouseLeave(Sender: TObject);
  protected
    procedure showBonus(Sender: TObject);
  public
    procedure setShowBonus;
    procedure showNext;
    procedure hideNext;
    procedure update;
  end;

implementation

{$R *.fmx}

uses GameUnit, DataUnit;

const
  w = 360;

var
  open:boolean = false;

procedure TBar.setShowBonus;
begin
  NextBtn.OnClick:=showBonus;
  showBonus(self);
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

procedure TBar.RBonusMouseLeave(Sender: TObject);
begin
  TAnimator.AnimateFloat(Rbonus, 'Position.X', (parent as TBarForm).Width);
  open:=false;
end;

procedure TBar.showNext;
begin
  NextBtn.Visible:=true;
  TAnimator.AnimateFloat(NextBtn, 'opacity', 1);
end;

procedure TBar.hideNext;
begin
  TAnimator.AnimateFloat(NextBtn, 'opacity', 0);
  NextBtn.Visible:=false;
end;

procedure TBar.update;
begin
  TM.LoadText(parent.Name);
  (parent as TBarForm).setText;
  BackBtn.OnClick:=(parent as TBarForm).closeByClick;
  RBonus.Position.X:=(parent as TBarForm).Width;
  open:=false;
  if parent is TGForm then
  begin
    NextBtn.OnClick:=(parent as TGForm).GNext;
    hideNext;
  end else begin
    NextBtn.Visible:=false;
  end;
end;

end.

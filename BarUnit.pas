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
    medal: TGlyph;
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
    shepa: TGlyph;
    progress: TLayout;
    imgs: TImageList;
    medalTxt: TText;
    coins: TLayout;
    bonusBtn: TButton;
    procedure RBonusMouseLeave(Sender: TObject);
    procedure logoLayoutClick(Sender: TObject);
  protected
    dots:TArray<TGlyph>;

    function getNxt: boolean;
    procedure setNxt(v: boolean);
  public
    procedure setDots(c: byte);
    procedure setDot(i: byte; v: byte);
    procedure hideBonus;
    procedure showBonus(Sender: TObject);

    function getBonus(id: byte): TGlyph;
    procedure setMedals(c: byte);

    property nxtBtn: boolean read getNxt write setNxt;
    property dotsStat[index: byte]: byte write setDot;
  end;

var
  Bar: TBar;

implementation

{$R *.fmx}

uses
  Forms, GameForms;

const
  w = 360;

var
  open:boolean = false;

procedure TBar.setDots;
var
  g, cl: TGlyph;
  i: byte;
begin
  for g in dots do
    g.Free;
  setlength(dots, c);
  g:=TGlyph.Create(self);
  with g do
  begin
    Align:=TAlignLayout.Right;
    Height:=30;
    Width:=30;
    Margins.Right:=10;
  end;
  for i:=c-1 downto 0 do
  begin
    cl:=g.Clone(self) as TGlyph;
    cl.Images:=imgs;
    cl.ImageIndex:=0;
    dots[i]:=cl;
    progress.AddObject(cl);
  end;
  g.Free;
end;

procedure TBar.setMedals(c: byte);
begin
  medalTxt.Text:='x'+c.ToString;
  coins.Visible:=c>0;
end;

procedure TBar.setDot;
begin
  if i<length(dots) then
    dots[i].imageIndex:=v;
end;

procedure TBar.hideBonus;
begin
  if open then showBonus(self);
end;

procedure TBar.showBonus(Sender: TObject);
begin
  if open then
    TAnimator.AnimateFloat(Rbonus, 'Position.X', (parent as TBarForm).Width)
  else
    TAnimator.AnimateFloat(Rbonus, 'Position.X', (parent as TBarForm).Width-w);
  open:=not open;
end;

procedure TBar.logoLayoutClick(Sender: TObject);
begin
  if Assigned(parent) then
  begin
    if (parent is TGForm)or(parent is TGTabForm) then
    begin
      if (parent as TGForm).clBlock then
        exit
      else
        (parent as TGForm).clBlock:=true;
    end;
    (parent as TForm).close;
  end;
end;

procedure TBar.RBonusMouseLeave(Sender: TObject);
begin
  TAnimator.AnimateFloat(Rbonus, 'Position.X', (parent as TBarForm).Width);
  open:=false;
end;

procedure TBar.setNxt(v: Boolean);
begin
  if v and not NextBtn.Visible then
  begin
    NextBtn.Visible:=true;
    TAnimator.AnimateFloat(NextLayout, 'opacity', 1);
  end
  else if not v and NextBtn.Visible then
  begin
    TAnimator.AnimateFloat(NextLayout, 'opacity', 0);
    NextBtn.Visible:=false;
  end;
end;

function TBar.getBonus(id: byte): TGlyph;
begin
  result:=nil;
  case id of
    1:result:=wh1;
    2:result:=tools;
    3:result:=woods;
    4:result:=shepa;
    5:result:=wh2;
    6:result:=body;
    7:result:=st1;
    8:result:=st2;
  end;
end;

function TBar.getNxt;
begin
  result:=NextBtn.Visible;
end;

end.

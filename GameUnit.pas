unit GameUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Layouts, FMX.Filter.Effects, FMX.ImgList, FMX.ani, System.ImageList,
  Forms, uFrame, FMX.Effects;

const
  LVL_COUNT = 15;
  MDL_COUNT = 13;

type
  TGameForm = class(TBarForm)
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    l4btn: TButton;
    l5btn: TButton;
    l7btn: TButton;
    l9btn: TButton;
    l8btn: TButton;
    l3btn: TButton;
    l6btn: TButton;
    l1btn: TButton;
    l2btn: TButton;
    l14btn: TButton;
    l13btn: TButton;
    l12btn: TButton;
    l11btn: TButton;
    l10btn: TButton;
    Btns: TLayout;
    Main1: TLayout;
    Main2: TLayout;
    BG: TGlyph;
    Alex: TGlyph;
    Home: TGlyph;
    Main3: TLayout;
    logoLayout: TLayout;
    topLogo: TGlyph;
    progress: TLayout;
    coins: TLayout;
    medal: TGlyph;
    medalTxt: TText;
    SPanel: TPanel;
    nextLayout: TLayout;
    NextBtn: TSpeedButton;
    SubName: TText;
    SubText: TMemo;
    SubLogo: TGlyph;
    backLayout: TLayout;
    BackBtn: TSpeedButton;
    Main: TLayout;
    dlgBG: TRectangle;
    yesBtn: TSpeedButton;
    modalDialog: TLayout;
    dlgBtns: TLayout;
    noBtn: TSpeedButton;
    dlgText: TText;
    ShadowEffect1: TShadowEffect;
    procedure l1btnClick(Sender: TObject);
    procedure logoLayoutClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure MainClick(Sender: TObject);
    procedure yesBtnClick(Sender: TObject);
  private
    frame: TGFrame;
    sts:TArray<byte>;//states
    mds:TArray<boolean>;//medals
    dots:TArray<TGlyph>;
    block, bonus, fr: boolean;

    function getStatus(id: byte): byte;
    procedure setStatus(id: byte; v: byte);
    procedure setMedal(id: byte; v: boolean);
    function getMdlCount: byte;

    procedure setBar;
    procedure setCaption(const t: string);
    procedure setLogo(const b: byte);
    procedure setText(const t: string);

    function getButton(tag: byte): TButton;
    procedure setBtn(v: boolean);

    procedure closeDlg;
  protected
    procedure onCreate; override;

  public
    procedure barShow(sender: TObject); override;
    procedure barClose(Sender: TObject; var  Action: TCloseAction); override;

    procedure nextFrame(id: byte);
    procedure setNext(id: byte);
    procedure setBack;
    procedure gameExit;

    property states[index: byte]: byte read getStatus write setStatus;
    property medals[index: byte]: boolean write setMedal;
    property medalsCount: byte read getMdlCount;

    property Caption: string write setCaption;
    property Logo: byte write setLogo;
    property Text: string write setText;

    property clBlock: boolean read block write block;
    property nxtBtn: boolean write setBtn;
  end;

var
  GameForm: TGameForm;

implementation

{$R *.fmx}

uses
  ImageManager, ResourcesManager, SoundManager;

procedure TGameForm.onCreate;
var
  g, cl: TGlyph;
  i: byte;

begin
  backgrounds:=[home, BG];
  layouts:=[main, modalDialog, main1, main2, main3];

  for i:=0 to Tabs.TabCount-1 do
    tabs.Tabs[i].DisableDisappear:=true;

  setlength(sts, LVL_COUNT);
  setLength(mds, MDL_COUNT);

  setLength(dots, LVL_COUNT);
  g:=TGlyph.Create(self);
  with g do
  begin
    Align:=TAlignLayout.Right;
    Height:=30;
    Width:=30;
    Margins.Right:=10;
  end;
  for i:=LVL_COUNT-1 downto 0 do
  begin
    cl:=g.Clone(self) as TGlyph;
    cl.Images:=getImgList(rProgress);
    cl.ImageIndex:=0;
    dots[i]:=cl;
    progress.AddObject(cl);
  end;
  g.Destroy;
end;

procedure TGameForm.barClose(Sender: TObject; var Action: TCloseAction);
begin
  if fr then
    Frame.Free;
  inherited;
end;

procedure TGameForm.setBar;
begin
  setCaption(fText.Names[Tabs.TabIndex]);
  setLogo(fText.Logos[Tabs.TabIndex]);
  setText(fText.TabTexts[Tabs.TabIndex]);
end;

procedure TGameForm.barShow(Sender: TObject);
var
  f: TFmxObject;
  i: byte;

  procedure PreloadContent(const Control: TControl);
  var
    I: Integer;
  begin
    if Control is TStyledControl then
      TStyledControl(Control).ApplyStyleLookup;
    for I := 0 to Control.ControlsCount - 1 do
      PreloadContent(Control.Controls[I]);
  end;

begin
  Tabs.TabIndex:=0;
  for i:=0 to LVL_COUNT-1 do
    states[i]:=0;
  for i:=0 to MDL_COUNT-1 do
    medals[i]:=false;
  for i:=0 to LVL_COUNT-1 do
    dots[i].ImageIndex:=0;
  {$IFDEF RELEASE}
  for f in Btns.Children do
    if (f is TButton) and (f.Tag<>0) then
      with f as TButton do
        Enabled:=false;
  {$ENDIF}
  block:=false;
  nxtBtn:=true;
  setBar;
  bonus:=false; fr:=false; main.HitTest:=false;
  modalDialog.Opacity:=0;
  modalDialog.Visible:=false;
  preloadContent(tabs);
  inherited;
end;

procedure TGameForm.gameExit;
begin
  close;
end;

function TGameForm.getButton(tag: byte): TButton;
var
  f: TFMXObject;
begin
  result:=nil;
  for f in Btns.Children do
    if (f is TButton) and (f.Tag=tag) then
    begin
      result:=F as TButton;
      exit;
    end;
end;

procedure TGameForm.setBtn(v: boolean);
var
  b: boolean;
begin
  b:=block;
  if not v and nextBtn.Visible then
  begin
    block:=true;
    TAnimator.AnimateFloat(nextLayout, 'opacity', 0);
    nextBtn.Visible:=false;
  end
  else if v and not nextBtn.Visible then
  begin
    block:=true;
    nextBtn.Visible:=true;
    TAnimator.AnimateFloat(nextLayout, 'opacity', 1);
  end;
  block:=b;
end;

procedure TGameForm.l1btnClick(Sender: TObject);
begin
  SM.play(sClick);
  nextFrame((Sender as TFmxObject).Tag);
  tabs.Next();
end;

procedure TGameForm.logoLayoutClick(Sender: TObject);
begin
  if block then exit;
  closeDlg;
end;

function TGameForm.getMdlCount: byte;
var
  b: boolean;
begin
  result:=0;
  for b in mds do
    if b then inc(result);
end;

procedure TGameForm.setMedal(id: byte; v: boolean);
var
  c:byte;
begin
  mds[id]:=v;
  c:=getMdlCount;
  medalTxt.Text:='x'+c.ToString;
  coins.Visible:=c>0;
end;

function TGameForm.getStatus(id: byte): byte;
begin
  result:=sts[id];
end;

procedure TGameForm.setStatus(id, v: byte);
begin
  sts[id]:=v;
  if (id<LVL_COUNT-2)and(v>1) then
    getButton(id+1).Enabled:=true;
  if v<2 then dots[id].ImageIndex:=v
    else begin
      dots[id].ImageIndex:=2;
      nxtBtn:=true;
    end;
end;

procedure TGameForm.setCaption(const t: string);
begin
  subName.Text:=t;
end;

procedure TGameForm.setLogo(const b: byte);
begin
  subLogo.ImageIndex:=b;
end;

procedure TGameForm.setText(const t: string);
begin
  if t='' then
    subText.Lines.Clear
  else
    subText.Text:=t;
end;

procedure TGameForm.nextFrame(id: Byte);
begin
  fr:=true;
  frame:=createFrame(id);
  main3.AddObject(frame);
  frame.onFShow;
end;

procedure TGameForm.setNext(id: byte);
begin
  frame.onFHide;
  frame.Destroy;
  fr:=false;
  nextFrame(id);
end;

procedure TGameForm.setBack;
begin
  tabs.Previous();
  frame.Free;
  fr:=false;
  setBar;
  block:=false;
end;

procedure TGameForm.NextBtnClick(Sender: TObject);
var
  i: byte;
begin
  if block then exit;
  SM.play(sClick);
  block:=true;
  try
    case Tabs.TabIndex of
      0:begin
        SM.play(sClick);
        Tabs.Next();
        setBar;
      end;
      1:begin
        SM.play(sClick);
        i:=0;
        while sts[i]>1 do inc(i);
        nextFrame(i);
        tabs.Next();
      end;
      2: frame.next;
    end;
  finally
    block:=false;
  end;
end;

procedure TGameForm.BackBtnClick(Sender: TObject);
begin
  if block then exit;
  case Tabs.TabIndex of
    0, 1: closeDlg;
    2: frame.back;
  end;
end;

procedure TGameForm.MainClick(Sender: TObject);
begin
  if block then exit;
  SM.play(sClick);
end;

procedure TGameForm.closeDlg;
begin
  SM.play(sClick);
  block:=true; main.HitTest:=true;
  modalDialog.Visible:=true;
  TAnimator.AnimateFloat(modalDialog, 'opacity', 1);
end;

procedure TGameForm.yesBtnClick(Sender: TObject);
begin
  case TFmxObject(sender).Tag of
    0:close;
    1:begin
      TAnimator.AnimateFloatWait(modalDialog, 'opacity', 0);
      modalDialog.Visible:=false;
      main.HitTest:=false;
      block:=false;
    end;
  end;
end;

end.

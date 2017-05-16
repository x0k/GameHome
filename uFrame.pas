unit uFrame;

interface

uses
  System.Classes,
  FMX.Forms, FMX.Controls, FMX.ImgList, FMX.Objects, FMX.TabControl,
  TextManager;

type
  TGFrame = class(TFrame)
  protected
    level: byte;
    fText: TFormText;
    backgrounds: TArray<TGlyph>;
    layouts: TArray<TControl>;
    fail: boolean;

    procedure setClBlock(v: boolean);
    function getClBlock: boolean;

    procedure win; virtual;
    procedure wrong; virtual;
    procedure clicks; virtual;

    procedure setMedal(id: byte; v: boolean = true);

    procedure onFCreate; virtual;
    procedure onFDestroy; virtual;

    procedure setBarEvents; virtual;
    procedure setBarText; virtual;

    property clBlock: boolean read getClBlock write setClBlock;
  public
    procedure setText(id: byte);
    procedure setTabText(id: byte);

    procedure onFShow; virtual;
    procedure onFHide; virtual;

    procedure next; virtual;
    procedure back; virtual;

    constructor Create(Lvl: byte); Reintroduce;
    destructor Destroy; override;
  end;

  function createFrame(id:byte): TGFrame;

implementation

{$R *.fmx}


uses
  FMX.Types, FMX.Memo, FMX.Graphics, FMX.Ani,
  GameUnit, DesignManager, ImageManager, SoundManager,
  uSeazon, uPlace, uTools, uMaterials, uTask, uFoundation, uMap, uOmen, uWarming, uMatrix, uWindows, uRoof, uRidge, uMoving, uEnd;

function createFrame(id:byte): TGFrame;
begin
  result:=nil;
  case id of
    0:result:=TSeazonFrame.Create(0);
    1:result:=TPlaceFrame.Create(1);
    2:result:=TToolsFrame.Create(2);
    3:result:=TMaterialsFrame.Create(3);
    4:result:=TTaskFrame.Create(4);
    5:result:=TFoundationFrame.Create(5);
    6:result:=TMapFrame.Create(6);
    7:result:=TOmenFrame.Create(7);
    8:result:=TWarmingFrame.Create(8);
    9:result:=TMatrixFrame.Create(9);
    10:result:=TWindowsFrame.Create(10);
    11:result:=TRoofFrame.Create(11);
    12:result:=TRidgeFrame.Create(12);
    13:result:=TMovingFrame.Create(13);
    14:result:=TEndFrame.Create(14);
  end;
end;

{ TGFrame }

constructor TGFrame.Create(Lvl: byte);
var
  i:byte;
  lts: TFormLayouts;

begin
  inherited create(GameForm);
  level:=lvl;
  fail:=false;

  if not TM.tryGetText(name, fText) then
    fText:=TFormText.getDefault;
  onFCreate;

  if length(backgrounds)>0 then
    for i:=0 to High(backgrounds) do
      IM.setSize(backgrounds[i], screen.Size);

  if (length(layouts)>0) and DM.tryGetFormLayouts(name, lts) then
  begin
    DM.setSz(TArray<TFmxObject>(layouts), lts);
    for i:=0 to High(layouts) do
      layouts[i].Opacity:=0;
  end;
end;

destructor TGFrame.Destroy;
begin
  onFDestroy;
  inherited;
end;

function TGFrame.getClBlock: boolean;
begin
  result:=(Owner as TGameForm).clBlock;
end;

procedure TGFrame.setClBlock;
begin
  (Owner as TGameForm).clBlock:=v;
end;

procedure TGFrame.next;
begin
  clBlock:=true;
  clicks;
  if (Owner as TGameForm).states[level]<2 then exit;
  if level<LVL_COUNT-1 then (Owner as TGameForm).setNext(level+1)
    else (Owner as TGameForm).gameExit;
end;

procedure TGFrame.back;
begin
  clBlock:=true;
  clicks;
  if (Owner as TGameForm).states[level]<2 then
    (Owner as TGameForm).states[level]:=0;
  (Owner as TGameForm).setBack;
end;

procedure TGFrame.onFCreate;
begin
end;

procedure TGFrame.onFDestroy;
begin
end;

procedure TGFrame.onFShow;
var
  i:byte;
begin
  setBarText;
  if length(layouts)>0 then
  begin
    for i:=1 to High(layouts) do
      TAnimator.AnimateFloat(layouts[i], 'opacity', 1, 0.5);
    TAnimator.AnimateFloatWait(layouts[0], 'opacity', 1, 0.5);
  end;
  if (Owner as TGameForm).states[level]<2 then (Owner as TGameForm).states[level]:=1;  
  clBlock:=false;
end;

procedure TGFrame.onFHide;
var
  i:byte;
begin
  if length(layouts)>0 then
  begin
    for i:=1 to High(layouts) do
      TAnimator.AnimateFloat(layouts[i], 'opacity', 0, 0.5);
    TAnimator.AnimateFloatWait(layouts[0], 'opacity', 0, 0.5);
  end;
end;

procedure TGFrame.setBarEvents;
begin

end;

procedure TGFrame.setBarText;
begin
  (Owner as TGameForm).Caption:=fText.Names[0];
  (Owner as TGameForm).Logo:=fText.Logos[0];
  (Owner as TGameForm).Text:=fText.TabTexts[0];
  (Owner as TGameForm).nxtBtn:=(Owner as TGameForm).states[level]=2;
end;

procedure TGFrame.setMedal(id: byte; v: boolean);
begin
  (Owner as TGameForm).medals[id]:=v;
end;

procedure TGFrame.setTabText(id: byte);
begin
  (Owner as TGameForm).Text:=fText.TabTexts[id]
end;

procedure TGFrame.setText(id: byte);
begin
  (Owner as TGameForm).Text:=fText.Texts[id]
end;

procedure TGFrame.win;
begin
  if (Owner as TGameForm).states[level]<2 then
  begin
    SM.Play(sAward);
    (Owner as TGameForm).states[level]:=2;
  end else SM.play(sClick);
end;

procedure TGFrame.wrong;
begin
  if (Owner as TGameForm).states[level]<2 then SM.Play(sWrong)
    else SM.play(sClick);
  fail:=true;
end;

procedure TGFrame.clicks;
begin
  SM.play(sClick);
end;

end.

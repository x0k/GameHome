unit Forms;

interface

uses
  System.UITypes, System.Classes, System.Generics.Collections,
  FMX.Forms, FMX.ImgList, FMX.Objects, FMX.Memo, FMX.Controls, FMX.Ani, FMX.Types, FMX.Layouts, FMX.TabControl,
  BarUnit, ImageManager, TextManager, SoundManager, GameData, ResourcesManager;

const
  AWD_COUNT = 17;
  LVL_COUNT = 14;

type
  TBarForm = class(TForm)
  protected
    FormText: TFormText;

    procedure setLogo(id: byte);
    procedure setCapt(id: byte);
    procedure fillBar(c:byte = 0; l:byte = 0; t:byte = 0);

    procedure onFormCreate; virtual;
    procedure afterFormCreate; virtual;

    procedure setBarEvents; virtual;
    procedure onFormShow; virtual;
    procedure onFormClose; virtual;
  public
    procedure setText(id: byte); overload;
    procedure setTabText(id: byte);
    procedure setItem(id: byte; text: TText); overload;
    procedure setItem(id: byte; memo: TMemo); overload;

    procedure onBarCreate(Sender:TObject);
    procedure onBarShow(Sender:TObject);
    procedure onBarClose(Sender: TObject; var Action: TCloseAction);

    procedure closeByClick(Sender:TObject);
    constructor Create(AOwner: TComponent); override;
  End;

  TMForm = class(TBarForm)
  protected
    imgs: TArray<TGlyph>;
    id: byte;
    count: byte;
    ani: boolean;

    procedure setBarEvents; override;
    procedure onFormShow; override;
    procedure onFormClose; override;
  public
    procedure showImg(i: Byte);
    procedure Next(Sender: TObject);
    procedure Back(Sender: TObject);

    constructor Create(AOwner: TComponent); override;
  end;

  TGForm = class(TBarForm)
  protected class var
    states:array[0..LVL_COUNT] of byte;
    //awards:array[1..AWD_COUNT] of boolean;
  protected
    level: byte;
    backgrounds: TArray<TGlyph>;
    layouts: TArray<TControl>;

    function getStatus:byte;
    procedure setStatus(s:byte);
    procedure upStatus;
    procedure gameExit;

    procedure addShow; virtual;
    procedure firstShow; virtual;
    procedure addWin; virtual;

    procedure afterFormCreate; override;
    procedure setBarEvents; override;
    procedure onFormShow; override;
    procedure onFormClose; override;
  public
    procedure win;

    procedure showAni; overload; virtual;
    procedure hideAni; overload; virtual;

    procedure showAni(f: TFmxObject); overload;
    procedure hideAni(f: TFmxObject); overload;

    procedure Next(Sender: TObject); virtual;
    procedure Back(Sender: TObject); virtual;

    property state:byte read getStatus write setStatus;

    constructor Create(Lvl:byte; Own:TComponent); reintroduce;
  end;

  TGTabForm = class(TGForm)
  protected
    gTabs:TTabControl;
    gTab:byte;

    procedure setBarEvents; override;
    procedure afterTabChange(newTab: byte); virtual;
  public
    procedure Next(Sender: TObject); override;
    procedure Back(Sender: TObject); override;
  end;

  procedure initForms;
  procedure showForm(id:byte);
  procedure destroyForms;

var
  IM: TImageManager;
  TM: TTextManager;
  SM: TSoundManager;
  GD: TGameData;
  Bar: TBar;

implementation

uses
  System.Types, System.SysUtils,
  FMX.Dialogs,
  windows, Messages,
  GameUnit, SeazonUnit, PlaceUnit, ToolsUnit, MaterialsUnit, TaskUnit, FoundationUnit, MapUnit, OmenUnit, WarmingUnit;

var
  GameForm: TGTabForm;

procedure initForms;
begin
  Bar:=TBar.create(nil);
  Bar.setDots;

  IM:=TImageManager.Create;
  GD:=TGameData.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create;

  GameForm:=TGameForm.Create(0, nil);
end;

function createForm(id:byte): TGForm;
begin
  case id of
    1:result:=TSeazonForm.Create(1, GameForm);
    2:result:=TPlaceForm.Create(2, GameForm);
    3:result:=TToolsForm.Create(3, GameForm);
    4:result:=TMaterialsForm.Create(4, GameForm);
    5:result:=TTaskForm.Create(5, GameForm);
    6:result:=TFoundationForm.Create(6, GameForm);
    7:result:=TMapForm.Create(7, GameForm);
    8:result:=TOmenForm.Create(8, GameForm);
    9:result:=TWarmingForm.Create(9, GameForm);
    else result:=GameForm;
  end;
end;

procedure showForm(id: byte);
begin
  createForm(id).show;
end;

procedure destroyForms;
begin
  //Bar.Destroy;
  RemoveFontResource(PChar(ResourcesManager.getPath(pTexts)+'font.ttf'));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  GD.LoadSavedRamp;
end;

  {TBarForm}

procedure TBarForm.SetLogo(id: byte);
begin
  Bar.SubLogo.imageIndex:=FormText.Logos[id];
end;

procedure TBarForm.setCapt(id :byte);
begin
  Bar.SubName.Text:=FormText.Names[id];
end;

procedure TBarForm.setText(id: byte);
var
  b: string;
begin
  b:=FormText.Texts[id];
  if length(b)=0 then
    Bar.SubText.Lines.Clear
  else
    Bar.SubText.Text:=b;
end;

procedure TBarForm.setTabText(id: byte);
var
  b: string;
begin
  b:=FormText.TabTexts[id];
  if length(b)=0 then
    Bar.SubText.Lines.Clear
  else
    Bar.SubText.Text:=b;
end;

procedure TBarForm.fillBar(c:byte = 0; l:byte = 0; t:byte = 0);
begin
  setCapt(c);
  setLogo(l);
  if self is TGTabForm then setTabText(t) else setText(t);
end;

procedure TBarForm.setItem(id: byte; text:TText);
begin
  text.text:=FormText.Items[id];
end;

procedure TBarForm.setItem(id: byte; memo: TMemo);
var
  b: string;
begin
  b:=FormText.Items[id];
  if length(b)=0 then
    memo.Lines.Clear
  else
    memo.Text:=b;
end;

procedure TBarForm.onFormCreate;
begin
end;

procedure TBarForm.afterFormCreate;
begin
end;

procedure TBarForm.onFormShow;
begin
end;

procedure TBarForm.onFormClose;
begin
end;

procedure TBarForm.onBarCreate(Sender: TObject);
begin
  onFormCreate;
  afterFormCreate;
end;

procedure TBarForm.setBarEvents;
begin
  with Bar do
  begin
    BackBtn.OnClick:=closeByClick;
    NextBtn.Visible:=false;
    progress.Visible:=false;
  end;
end;

procedure TBarForm.onBarShow(Sender: TObject);
begin
  fillBar;
  Bar.Parent:=self;
  Bar.RBonus.Position.X:=Width;
  setBarEvents;
  onFormShow;
end;

procedure TBarForm.onBarClose(Sender: TObject; var Action: TCloseAction);
begin
  Bar.Parent:=nil;
  onFormClose;
end;

procedure TBarForm.closeByClick(Sender: TObject);
begin
  close;
end;

constructor TBarForm.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  self.OnCreate:=onBarCreate;
  self.OnShow:=onBarShow;
  self.OnClose:=onBarClose;

  FormText:=TM.Forms[name];
end;

  {TMForm}

procedure TMForm.showImg(i: Byte);
begin
  imgs[i].BringToFront;
  setText(i);
  TAnimator.AnimateFloatWait(imgs[i], 'Opacity', 1, 0.6);
  ani:=false;
end;

procedure TMForm.Next(Sender: TObject);
var
  last: byte;
begin
  if not ani then
  begin
    ani:=true;
    last:=id;
    Bar.dotsStat[id]:=0;
    if id=count-1 then id:=0 else inc(id);
    Bar.dotsStat[id]:=1;
    showImg(id);
    imgs[last].Opacity:=0;
  end;
end;

procedure TMForm.Back(Sender: TObject);
var
  last: byte;
begin
  if not ani then
  begin
    ani:=true;
    last:=id;
    Bar.dotsStat[id]:=0;
    if id>0 then dec(id) else id:=count-1;
    Bar.dotsStat[id]:=1;
    showImg(id);
    imgs[last].Opacity:=0;
  end;
end;

procedure TMForm.setBarEvents;
begin
  with Bar do
  begin
    NextBtn.Visible:=true;
    progress.Visible:=true;
    NextBtn.OnClick:=(self as TMForm).Next;
    BackBtn.OnClick:=(self as TMForm).Back;
  end;
end;

procedure TMForm.onFormShow;
begin
  Bar.dotsStat[id]:=1;
end;

procedure TMForm.onFormClose;
begin
  Bar.dotsStat[id]:=0;
end;

constructor TMForm.Create(AOwner: TComponent);
var
  g,c:TGlyph;
  i:byte;
begin
  inherited create(AOwner);
  IM.add(rMuseum);
  count:=getImgList(rMuseum).Destination.Count;
  if count>0 then
  begin
    G:=TGlyph.Create(self);
    G.Images:=getImgList(rMuseum);
    G.Align:=TAlignLayout.Center;
    G.ImageIndex:=0;
    IM.setSize(G, Screen.Size);
    G.Opacity:=0;
    setlength(imgs, count);
    for i:=1 to count-1 do
    begin
      C:=G.Clone(self) as TGlyph;
      C.ImageIndex:=i;
      imgs[i]:=C;
    end;
    G.Opacity:=1;
    imgs[0]:=G;
  end;
end;

  {TGForm}

constructor TGForm.Create(Lvl:byte; Own:TComponent);
begin
  inherited Create(own);
  Level:=lvl;
end;

procedure TGForm.setStatus(s: Byte);
begin
  states[level]:=s;
  if s<2 then Bar.dotsStat[level]:=s
    else Bar.dotsStat[level]:=2;
end;

procedure TGForm.win;
begin
  upStatus;
  addWin;
end;

function TGForm.getStatus;
begin
  result:=states[level];
end;

procedure TGForm.upStatus;
begin
  if state<2 then state:=state+1;
  if state=2 then Bar.showNext;
end;

procedure TGForm.gameExit;
var
  i:byte;
begin
  GameForm.Hide;
  GameForm.gTabs.TabIndex:=0;
  for i:=0 to LVL_COUNT do
    states[i]:=0;
  if level>0 then self.Destroy;
end;

procedure TGForm.addShow;
begin
end;

procedure TGForm.firstShow;
begin
  //if Assigned(tbs) then tbs.TabIndex:=0;
  //lLogo:=0;lCapt:=0;lDesc:=0;
end;

procedure TGForm.addWin;
begin
end;

procedure TGForm.showAni;
var
  i:byte;
begin
  if length(layouts)>0 then
  begin
    for i:=1 to High(layouts) do
      TAnimator.AnimateFloat(layouts[i], 'opacity', 1, 0.5);
    TAnimator.AnimateFloatWait(layouts[0], 'opacity', 1, 0.5);
  end;
end;

procedure TGForm.hideAni;
var
  i:byte;
begin
  if length(layouts)>0 then
  begin
    for i:=1 to High(layouts) do
      TAnimator.AnimateFloat(layouts[i], 'opacity', 0, 0.4);
    TAnimator.AnimateFloatWait(layouts[0], 'opacity', 0, 0.4);
  end;
end;

procedure TGForm.showAni(f: TFmxObject);
begin
  TAnimator.AnimateFloat(f, 'opacity', 1);
end;

procedure TGForm.hideAni(f: TFmxObject);
begin
  TAnimator.AnimateFloat(f, 'opacity', 0);
end;

procedure TGForm.afterFormCreate;
var
  i:byte;
begin
  if length(backgrounds)>0 then
    for i:=0 to High(backgrounds) do
      IM.setSize(backgrounds[i], screen.Size);
  if length(layouts)>0 then
    for i:=0 to High(layouts) do
      layouts[i].Opacity:=0;
end;

procedure TGForm.setBarEvents;
begin
  with Bar do
  begin
    NextBtn.Visible:=true;
    progress.Visible:=true;
    NextBtn.OnClick:=(self as TGForm).Next;
    BackBtn.OnClick:=(self as TGForm).Back;
    if (self as TGForm).state<2 then hideNext
      else if not NextBtn.Visible then showNext;
  end;
end;

procedure TGForm.onFormShow;
begin
  addShow;
  if state=0 then
  begin
    firstShow;
    upStatus;
  end;
  showAni;
end;

procedure TGForm.onFormClose;
begin
  if level>0 then
  begin
    showForm(0);
    if state<2 then
      state:=0;
    Release;
  end else gameExit;
end;

procedure TGForm.Next;
begin
  hideAni;
  if Assigned(Bar.Parent) then Bar.Parent:=nil;
  if level<LVL_COUNT then
    showForm(level+1);
  if state<2 then
    state:=0;
  Destroy;
end;

procedure TGForm.Back;
begin
  hideAni;
  if Assigned(Bar.Parent) then Bar.Parent:=nil;
  if state<2 then
    state:=0;
  if level>0 then
  begin
    showForm(level-1);
    Destroy;
  end else gameExit;
end;

  {TGTabForm}

procedure TGTabForm.setBarEvents;
begin
  with Bar do
  begin
    NextBtn.Visible:=true;
    progress.Visible:=true;
    NextBtn.OnClick:=(self as TGForm).Next;
    BackBtn.OnClick:=(self as TGForm).Back;
    if (gTabs.TabIndex=gTab) and (state<2) then hideNext
      else if not NextBtn.Visible then showNext;
  end;
end;

procedure TGTabForm.afterTabChange(newTab: Byte);
begin
end;

procedure TGTabForm.next(Sender: TObject);
var
  ti: byte;
begin
  ti:=gTabs.tabIndex;
  if ti<gTabs.TabCount-1 then
  begin
    gTabs.Next;
    inc(ti);
    fillBar(ti, ti, ti);
    if (ti=gTab)and(state<2) then Bar.hideNext
      else if not Bar.NextBtn.Visible then Bar.showNext;
    afterTabChange(ti);
  end
  else
  begin
    hideAni;
    if Assigned(Bar.Parent) then Bar.Parent:=nil;
    if (level>0) and (level<LVL_COUNT-1) then
      showForm(level+1);
    destroy;
  end;
end;

procedure TGTabForm.back(Sender: TObject);
var
  ti: byte;
begin
  ti:=gTabs.tabIndex;
  if ti>0 then
  begin
    gTabs.Previous;
    dec(ti);
    fillBar(ti, ti, ti);
    if (ti=gTab)and(state<2) then Bar.hideNext
      else if not Bar.NextBtn.Visible then Bar.showNext;
    afterTabChange(ti);
  end
  else
  begin
    hideAni;
    if Assigned(Bar.Parent) then Bar.Parent:=nil;
    if level>0 then
    begin
      showForm(level-1);
      destroy;
    end else gameExit;
  end;
end;


end.

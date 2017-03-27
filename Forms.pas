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
    procedure setText(id: byte); overload;
    procedure setItem(id: byte; text: TText); overload;
    procedure setItem(id: byte; memo: TMemo); overload;

    procedure onFormCreate; virtual;
    procedure afterFormCreate; virtual;

    procedure onFormShow; virtual;
    procedure onFormClose; virtual;
  public
    procedure onBarCreate(Sender:TObject);
    procedure onBarShow(Sender:TObject);
    procedure onBarClose(Sender: TObject; var Action: TCloseAction);

    procedure closeByClick(Sender:TObject);
    constructor Create(AOwner: TComponent); override;
  End;

  TGForm = class(TBarForm)
  protected class var
    states:array[0..LVL_COUNT] of byte;
    //awards:array[1..AWD_COUNT] of boolean;
  protected
    level:byte;
    backgrounds:TArray<TGlyph>;
    layouts:TArray<TControl>;

    //Заполнение формы изображениями
    procedure fillFormByImgs(layouts:TArray<TLayout>);

    function getStatus:byte;
    procedure setStatus(s:byte);
    procedure upStatus;
    procedure clearData;

    procedure addShow; virtual;
    procedure firstShow; virtual;
    procedure addWin; virtual;

    procedure afterFormCreate; override;
    procedure onFormShow; override;
    procedure onFormClose; override;
  public
    procedure win;
    procedure setText(l, c, d: byte); overload;

    procedure showAni; overload; virtual;
    procedure hideAni; overload; virtual;

    procedure showAni(f: TFmxObject); overload;
    procedure hideAni(f: TFmxObject); overload;

    procedure Next(Sender: TObject); virtual;
    procedure Back(Sender: TObject); virtual;

    property lvl:byte read level;
    property state:byte read getStatus write setStatus;

    class function createForm(id:byte): TGForm;
    class procedure showForm(id:byte);
    constructor Create(Lvl:byte; Own:TComponent); reintroduce;
  end;

  TGTabForm = class(TGForm)
  protected
    gTabs:TTabControl;
    gTab:byte;
  public
    procedure Next(Sender: TObject); override;
    procedure Back(Sender: TObject); override;
  end;

  procedure initForms;
  procedure destroyForms;

var
  IM:TImageManager;
  TM:TTextManager;
  SM:TSoundManager;
  GD:TGameData;

implementation

uses
  System.Types, System.SysUtils,
  windows, Messages,
  GameUnit, SeazonUnit, PlaceUnit, ToolsUnit, MaterialsUnit, TaskUnit, FoundationUnit, MapUnit, OmenUnit, WarmingUnit;

var
  GameForm: TGForm;
  Bar: TBar;

procedure initForms;
begin
  Bar:=TBar.create(nil);
  IM:=TImageManager.Create;
  GD:=TGameData.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create;
  //
  IM.add(rSequences);
  IM.add(rImages);
  IM.add(rOther);
end;

procedure destroyForms;
begin
  Bar.Destroy;
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

procedure TBarForm.setItem(id: byte; text:TText);
begin
  text.text:=FormText.Items[id];
end;

procedure TBarForm.setItem(id: byte; memo: TMemo);
var
  b: string;
begin
  b:=FormText.Texts[id];
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

procedure TBarForm.onBarShow(Sender: TObject);
begin
  FormText:=TM.Forms[name];
  //setText;
  Bar.Parent:=self;
  //Bar.update;
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
end;

  {TGForm}

constructor TGForm.Create(Lvl:byte; Own:TComponent);
begin
  inherited Create(own);
  Level:=lvl;
end;

procedure TGForm.win;
begin
  upStatus;
  addWin;
end;

procedure TGForm.SetText(l, c, d: byte);
begin
  setLogo(l);
  setCapt(c);
  setText(d);
end;

procedure TGForm.setStatus(s: Byte);
begin
  states[level]:=s;
end;

function TGForm.getStatus;
begin
  result:=states[level];
end;

procedure TGForm.upStatus;
begin
  if states[level]<2 then inc(states[level]);
  if states[level]=2 then Bar.showNext;
  Bar.upProgress;
end;

procedure TGForm.clearData;
var
  i:byte;
begin
  for i:=0 to LVL_COUNT do

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

procedure TGForm.onFormShow;
begin
  addShow;
  if state=0 then
  begin
    firstShow;
    upStatus;
  end else Bar.upProgress;
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
  end;
end;

procedure TGForm.Next;
begin
  hideAni;
  if level<LVL_COUNT then
    showForm(level+1);
  if state<2 then
    state:=0;
  Destroy;
end;

procedure TGForm.Back;
begin
  hideAni;
  if level>0 then
    showForm(level-1);
  if state<2 then
    state:=0;
  Destroy;
end;

class function TGForm.createForm;
begin
  result:=GameForm;
  case id of
    0:if not Assigned(GameForm) then GameForm:=TGameForm.Create(0, nil);
    1:result:=TSeazonForm.Create(1, GameForm);
    2:result:=TPlaceForm.Create(2, GameForm);
    3:result:=TToolsForm.Create(3, GameForm);
    4:result:=TMaterialsForm.Create(4, GameForm);
    5:result:=TTaskForm.Create(5, GameForm);
    6:result:=TFoundationForm.Create(6, GameForm);
    7:result:=TMapForm.Create(7, GameForm);
    8:result:=TOmenForm.Create(8, GameForm);
    9:result:=TWarmingForm.Create(9, GameForm);
    else raise Exception.Create('Форма'+id.toString+'не существует');
  end;
end;

class procedure TGForm.showForm(id: byte);
begin
  createForm(id).show;
end;

procedure TGForm.fillFormByImgs(layouts:TArray<TLayout>);
var
  c:byte;
  w: single;
  s: TSizeF;
  l: TLayout;
  o: TFMXObject;

  procedure setFontSize(t: TText; s: TSizeF);
  begin
  end;

begin
  c:=Length(layouts);
  if c>0 then
  begin
    w:=Width/c;
    s:=TSizeF.Create(w, Height);
    for l in layouts do
    begin
      l.Width:=w;
      for o in l.children do
        if o is TGlyph then
          IM.setSize(o as TGlyph, s)
        else if o is TText then
          setFontSize(o as TText, s);
    end;
  end;
end;

  {TGTabForm}

procedure TGTabForm.next(Sender: TObject);
var
  ti: byte;
begin
  ti:=gTabs.tabIndex;
  if ti<gTabs.TabCount-1 then
  begin
    gTabs.Next;
    SetText(ti, ti, ti);
  end
  else
  begin
    hideAni;
    if (level>0) and (level<LVL_COUNT-1) then
      showForm(level+1);
    destroy;
  end;
  if (ti=gTab)and(state<2) then Bar.hideNext;
end;

procedure TGTabForm.back(Sender: TObject);
var
  ti: byte;
begin
  ti:=gTabs.tabIndex;
  if ti>0 then
  begin
    gTabs.Previous;
    SetText(ti, ti, ti);
  end
  else
  begin
    hideAni;
    if level>0 then
      showForm(level-1);
    destroy;
  end;
  if (ti=gTab)and(state<2) then Bar.hideNext;
end;


end.

unit GameForms;

interface

uses
  System.UITypes, System.Classes, System.Generics.Collections,
  FMX.Forms, FMX.ImgList, FMX.Objects, FMX.Memo, FMX.Controls, FMX.Ani, FMX.Types, FMX.Layouts, FMX.TabControl,
  BarUnit, Forms;

const
  AWD_COUNT = 17;
  LVL_COUNT = 14;

type
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
    procedure onFormClose(var Action: TCloseAction); override;
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

implementation

uses
  System.Types, System.SysUtils,
  FMX.Dialogs,
  DataUnit, DesignManager, GameUnit, SeazonUnit, PlaceUnit, ToolsUnit, MaterialsUnit, TaskUnit, FoundationUnit, MapUnit, OmenUnit, WarmingUnit;

var
  GameForm: TGTabForm;

procedure initForms;
begin
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
  if state=2 then Bar.nxtBtn:=true;
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
  w, h: single;

  function findByName(const name: string; const arr: TArray<TFmxObject>; var c: TControl):boolean;
  var
    i: byte;
  begin
    result:=false;
    if length(arr)=0 then exit;
    for i:=Low(arr) to High(arr) do
      if name = arr[i].Name then
      begin
        if arr[i] is TControl then
        begin
          c:=arr[i] as TControl;
          result:=true;
        end;
        exit;
      end;
  end;

  procedure setSz(const layouts: TArray<TFmxObject>;const setts: TArray<TFormLayout>);
  var
    i: byte;
    ct: TControl;
  begin
    for i:=0 to High(setts) do
      if findByName(setts[i].Name, layouts, ct) then
      begin
        if setts[i].pMargins then ct.Margins.Assign(TBounds.Create(
          TRectF.Create(setts[i].LayoutMargins[0]*w, setts[i].LayoutMargins[1]*h, setts[i].LayoutMargins[2]*w, setts[i].LayoutMargins[3]*h)
        ));
        if setts[i].pChildrens and (ct.ChildrenCount>0) then
          setSz(ct.Children.ToArray, setts[i].Childs);
      end;
  end;

begin
  if length(backgrounds)>0 then
    for i:=0 to High(backgrounds) do
      IM.setSize(backgrounds[i], screen.Size);
  if length(layouts)>0 then
  begin
    w:=Screen.Width/100;
    h:=Screen.Height/100;
    setSz(TArray<TFmxObject>(layouts), DM.Designs[name]);
    for i:=0 to High(layouts) do
      layouts[i].Opacity:=0;
  end;

end;

procedure TGForm.setBarEvents;
begin
  with Bar do
  begin
    progress.Visible:=true;
    NextBtn.OnClick:=(self as TGForm).Next;
    BackBtn.OnClick:=(self as TGForm).Back;
    Bar.nxtBtn:=self.state=2
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
    Action:=TCloseAction.caFree;
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
    progress.Visible:=true;
    NextBtn.OnClick:=(self as TGForm).Next;
    BackBtn.OnClick:=(self as TGForm).Back;
    Bar.nxtBtn:=(gTabs.TabIndex<>gTab) or (state=2);
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
    Bar.nxtBtn:=(ti<>gTab) or (state=2);
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
    Bar.nxtBtn:=(ti<>gTab) or (state=2);
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

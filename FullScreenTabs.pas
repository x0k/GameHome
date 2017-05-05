unit FullScreenTabs;

interface

uses
  System.Types, System.Generics.Collections,
  FMX.Layouts, FMX.ImgList, FMX.Objects, FMX.Types, FMX.Forms, FMX.Ani,
  GameForms;

type
  FSTab = class
  private
    layout: TLayout;
    image: TGlyph;
    text: TText;
  public
    property txt: TText read text;
    property img: TGlyph read image;
    property layer: TLayout read layout;

    constructor create(l: TLayout);
  end;

  idAct = procedure(tab: FSTab) of object;

  FSTabs = class
  private
    form: TGForm;
    main: TLayout;
    tabs: TList<FSTab>;
    shw, lst: ShortInt;
    xZero: single;
    widths:TArray<single>;
    sizes:TArray<single>;

    winId: byte;
    setTxt: boolean;
    txtAni: boolean;
    tbsAni: boolean;
    block: boolean;

    w, AddW, MaxW: single;
    s, AddS, MaxS: single;

  public
    afterClick: idAct;
    afterEnter: idAct;
    afterLeave: idAct;

    procedure setSize(img, txt: boolean);

    procedure onClick(sender: TObject);
    procedure onEnter(sender: TObject);
    procedure onLeave(sender: TObject);

    destructor Destroy; override;
    constructor create(fm: TGForm; m: TLayout; wId: byte; sTxt: boolean = true);
  end;

implementation

uses
  System.SysUtils,
  FMX.Dialogs,
  ImageManager, DesignManager;

constructor FSTab.create(l: TLayout);
var
  f, t: TFmxObject;
begin
  layout:=l;
  if l.ChildrenCount>0 then
  begin
    for f in l.Children do
      if f is TGlyph then
      begin
        image:=f as TGlyph;
        if f.ChildrenCount>0 then
          for t in f.Children do
            if t is TText then
              text:=t as TText;
      end else if f is TText then
        text:=f as TText;
  end;
end;

destructor FSTabs.destroy;
var
  t: FSTab;
begin
  for t in tabs do
    t.Free;
  tabs.Free;
  inherited;
end;

constructor FSTabs.create(fm: TGForm; m: TLayout; wId: byte; sTxt: boolean);
var
  f: TFmxObject;
  b: TBounds;
  lt: TFormLayout;
begin
  form:=fm;
  main:=m;
  setTxt:=sTxt;
  tabs:=TList<FSTab>.create;
  for f in m.Children do
    if f is TLayout then
      tabs.add(FSTab.create(f as TLayout));
  shw:=-1;
  winId:=wId;
  b:=nil;
  if DM.tryGetLayout(fm.Name, main.Name, lt) then
  begin
    sizes:= lt.TextSize;
    widths:= lt.TabWidth;
    b:= lt.LayoutMargins;
    tbsAni:= lt.Animation;
  end;
  if assigned(b) then xZero:=b.Left
    else xZero:=0;
  block:=false;
end;

procedure FSTabs.setSize(img, txt: Boolean);
var
  i, c: byte;
begin
  c:=tabs.Count;
  w:=Main.Width/tabs.Count;
  if length(widths)>0 then AddW:=widths[0]*w
    else AddW:=1.2*w;
  if length(widths)>1 then MaxW:=widths[1]*w
    else MaxW:=2*w;
  if length(sizes)>0 then s:=sizes[0]
    else s:=30;
  if length(sizes)>1 then AddS:=sizes[1]*S
    else AddS:=1.2*S;
  if length(sizes)>2 then MaxS:=sizes[2]*S
    else MaxS:=1.4*S;
  if tabs.Count>0 then
  begin
    for i:=0 to tabs.Count-1 do
    begin
      tabs[i].layout.Width:=main.Width/c;
      tabs[i].layout.Height:=main.Height;
      tabs[i].layout.HitTest:=true;
      tabs[i].layout.OnMouseEnter:=onEnter;
      tabs[i].layout.OnMouseLeave:=onLeave;
      tabs[i].layout.OnClick:=onClick;
      if img then IM.setSize(tabs[i].image, TSizeF.Create(tabs[i].layout.Width, tabs[i].layout.Height));
      if txt then tabs[i].text.TextSettings.Font.Size:=S;
    end;
    txtAni:=txt;
  end;
end;

procedure FSTabs.onClick;
var
  id, c: byte;
begin
  if block then exit;
  id:=TLayout(sender).TabOrder;
  c:=tabs.Count-1;
  if c>0 then
    if shw>=0 then
    begin
      if txtAni then TAnimator.AnimateFloat(tabs[shw].text, 'TextSettings.Font.Size', S);
      if tbsAni then
      begin
        TAnimator.AnimateFloat(tabs[shw].layout, 'width', w);
        TAnimator.AnimateFloat(Main, 'Position.X', xZero);
      end;
      shw:=-1;
    end
    else
    begin
      shw:=id;
      if setTxt then Form.setText(id);
      if txtAni then TAnimator.AnimateFloat(tabs[id].text, 'TextSettings.Font.Size', maxS);
      if tbsAni then
      begin
        TAnimator.AnimateFloat(Main, 'Position.X', xZero-((maxW-W)*id/c));
        TAnimator.AnimateFloat(tabs[id].layout, 'width', maxW);
      end;
      if Assigned(afterClick) then afterClick(tabs[id])
        else if id=winId then form.win;
    end;
end;

procedure FSTabs.onEnter;
var
  id, c: shortInt;
begin
  if block then exit;
  id:=TLayout(sender).TabOrder;
  c:=tabs.Count-1;
  if (shw<0)and(id<>lst)and(c>0) then
  begin
    block:=true;
    if txtAni then
    begin
      TAnimator.AnimateFloat(tabs[lst].text, 'TextSettings.Font.Size', S);
      TAnimator.AnimateFloat(tabs[id].text, 'TextSettings.Font.Size', addS);
    end;
    if tbsAni then
    begin
      tabs[lst].layout.StopPropertyAnimation('Width');
      TAnimator.AnimateFloat(tabs[lst].layout, 'width', W);
      Main.StopPropertyAnimation('Position.X');
      TAnimator.AnimateFloat(Main, 'Position.X', xZero-((addW-W)*id/c));
      TAnimator.AnimateFloat(tabs[id].layout, 'width', addW);
    end;
    if Assigned(afterEnter) then afterEnter(tabs[id]);
    lst:=id;
    block:=false;
  end;
end;

procedure FSTabs.onLeave(sender: TObject);
var
  id: byte;
begin
  if block then exit;
  id:=TLayout(sender).TabOrder;
  if (shw>=0)and(tabs.Count>1) then
  begin
    block:=true;
    if txtAni then TAnimator.AnimateFloat(tabs[shw].text, 'TextSettings.Font.Size', S);
    if tbsAni then
    begin
      TAnimator.AnimateFloat(Main, 'Position.X', xZero);
      TAnimator.AnimateFloatWait(tabs[shw].layout, 'width', w);
    end;
    if Assigned(afterLeave) then afterLeave(tabs[id]);
    shw:=-1;
    block:=false;
  end;
end;
end.

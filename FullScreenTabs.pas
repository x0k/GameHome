unit FullScreenTabs;

interface

uses
  System.Types, System.Generics.Collections,
  FMX.Layouts, FMX.ImgList, FMX.Objects, FMX.Types, FMX.Forms, FMX.Ani,
  GameForms, DataUnit;

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
    margins:TArray<single>;

    winId: byte;
    txtAni: boolean;

    function w: single;
    function AddW: single;
    function MaxW: single;

    function s: single;
    function AddS: single;
    function MaxS: single;

  public
    afterClick: idAct;
    afterEnter: idAct;

    procedure setSize(img, txt: boolean);

    procedure onClick(sender: TObject);
    procedure onEnter(sender: TObject);

    constructor create(fm: TGForm; m: TLayout; wId: byte);
  end;

implementation

uses
  System.SysUtils,
  FMX.Dialogs;

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

constructor FSTabs.create(fm: TGForm; m: TLayout; wId: byte);
var
  f: TFmxObject;
begin
  form:=fm;
  main:=m;
  tabs:=TList<FSTab>.create;
  for f in m.Children do
    if f is TLayout then
      tabs.add(FSTab.create(f as TLayout));
  shw:=-1;
  winId:=wId;
  sizes:=DM.getFormLayout(fm.Name, main.Name).Size;
  widths:=DM.getFormLayout(fm.Name, main.Name).Width;
  margins:=DM.getFormLayout(fm.Name, main.Name).LayoutMargins;
end;

function FSTabs.W;
begin
  result:=Main.Width/tabs.Count;
end;

function FSTabs.AddW;
begin
  if length(widths)>0 then
    result:=widths[0]*w
  else
    result:=1.2*w;
end;

function FSTabs.MaxW;
begin
  if length(widths)>1 then
    result:=widths[1]*w
  else
    result:=2*w;
end;

function FSTabs.S;
begin
  if length(sizes)>0 then
    result:=sizes[0]
  else
    result:=30;
end;

function FSTabs.AddS;
begin
  if length(sizes)>1 then
    result:=sizes[1]*S
  else
    result:=1.2*S;
end;

function FSTabs.MaxS;
begin
  if length(sizes)>2 then
    result:=sizes[2]*S
  else
    result:=1.4*S;
end;

procedure FSTabs.setSize(img, txt: Boolean);
var
  i, c: byte;
  w: single;
begin
  c:=tabs.Count;
  xZero:=0;
  w:=Screen.Width/100;
  xZero:=margins[0]*w;
  if tabs.Count>0 then
  begin
    for i:=0 to tabs.Count-1 do
    begin
      tabs[i].layout.Width:=main.Width/c;
      tabs[i].layout.Height:=main.Height;
      tabs[i].layout.HitTest:=true;
      tabs[i].layout.OnMouseEnter:=onEnter;
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
  id:=TLayout(sender).TabOrder;
  c:=tabs.Count-1;
  if (shw>=0)and(c>0) then
  begin
    if txtAni then TAnimator.AnimateFloat(tabs[shw].text, 'TextSettings.Font.Size', S);

    TAnimator.AnimateFloat(tabs[shw].layout, 'width', w);
    TAnimator.AnimateFloat(Main, 'Position.X', xZero);

    shw:=-1;
  end
  else
  begin
    shw:=id;
    Form.setText(tabs[id].text.Tag);
    if txtAni then TAnimator.AnimateFloat(tabs[id].text, 'TextSettings.Font.Size', maxS);

    TAnimator.AnimateFloat(Main, 'Position.X', xZero-((maxW-W)*id/c));
    TAnimator.AnimateFloat(tabs[id].layout, 'width', maxW);

    if Assigned(afterClick) then afterClick(tabs[id])
      else if tabs[id].text.Tag=winId then form.win;
  end;
end;

procedure FSTabs.onEnter;
var
  id, c: shortInt;
begin
  id:=TLayout(sender).TabOrder;
  c:=tabs.Count-1;
  if (shw<0)and(id<>lst)and(c>0) then
  begin
    if txtAni then
    begin
      TAnimator.AnimateFloat(tabs[lst].text, 'TextSettings.Font.Size', S);
      TAnimator.AnimateFloat(tabs[id].text, 'TextSettings.Font.Size', addS);
    end;

    TAnimator.AnimateFloat(tabs[lst].layout, 'width', W);
    TAnimator.AnimateFloat(Main, 'Position.X', xZero-((addW-W)*id/c));
    TAnimator.AnimateFloat(tabs[id].layout, 'width', addW);

    if Assigned(afterEnter) then afterEnter(tabs[id]);
    lst:=id;
  end;
end;

end.

unit FullScreenTabs;

interface

uses
  System.Types, System.Generics.Collections,
  FMX.Layouts, FMX.ImgList, FMX.Objects, FMX.Types, FMX.Forms, FMX.Ani,
  GameForms, DataUnit;

type
  idAct = procedure(id: byte) of object;

  FSTab = class
  private
    layout: TLayout;
    image: TGlyph;
    text: TText;
  public
    constructor create(l: TLayout);
  end;

  FSTabs = class
  private
    form: TGForm;
    main: TLayout;
    tabs: TList<FSTab>;
    shw, lst: ShortInt;
    w, addW, expW: single;//ширина вкладки, процент при наведении, процент при раскрытии
    normSize, entSize, maxSize: single;//размер текста, процент при наведении, процент при раскрытии
    winId:byte;
    txtAni: boolean;

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
  normSize:=30;entSize:=1.2; maxSize:=1.4;
  TM.Forms[fm.Name].TryGetTextSize(normSize, entSize, maxSize);
  addW:=1.2; expW:=2;
  TM.Forms[fm.Name].TryGetTabsWidth(addW, expW);
end;

procedure FSTabs.setSize(img, txt: Boolean);
var
  i, c: byte;
begin
  c:=tabs.Count;
  main.SetBounds(0, 0, Screen.Width, Screen.Height);
  w:=Screen.Width/c;
  if tabs.Count>0 then
  begin
    for i:=0 to tabs.Count-1 do
    begin
      tabs[i].layout.Width:=Screen.Width/c;
      tabs[i].layout.Height:=Screen.Height;
      tabs[i].layout.HitTest:=true;
      tabs[i].layout.OnMouseEnter:=onEnter;
      tabs[i].layout.OnClick:=onClick;
      if img then IM.setSize(tabs[i].image, TSizeF.Create(w, Screen.Height));
      if txt then tabs[i].text.TextSettings.Font.Size:=normSize;
    end;
    txtAni:=txt;
  end;
end;

procedure FSTabs.onClick;
var
  id, c: byte;
begin
  id:=TFmxObject(sender).Tag;
  c:=tabs.Count-1;
  if (shw>=0)and(c>0) then
  begin
    if txtAni then TAnimator.AnimateFloat(tabs[shw].text, 'TextSettings.Font.Size', normSize);

    TAnimator.AnimateFloat(tabs[shw].layout, 'width', w);
    TAnimator.AnimateFloat(Main, 'Position.X', 0);

    shw:=-1;
  end
  else
  begin
    shw:=id;
    Form.setText(tabs[id].text.Tag);
    if txtAni then TAnimator.AnimateFloat(tabs[id].text, 'TextSettings.Font.Size', maxSize*normSize);

    TAnimator.AnimateFloat(Main, 'Position.X', -((expW*w-w)*id/c));
    TAnimator.AnimateFloat(tabs[id].layout, 'width', expW*w);

    if Assigned(afterClick) then afterClick(id)
      else if id=winId then form.win;
  end;
end;

procedure FSTabs.onEnter;
var
  id, c: shortInt;
begin
  id:=TFmxObject(sender).Tag;
  c:=tabs.Count-1;
  if (shw<0)and(id<>lst)and(c>0) then
  begin
    if txtAni then
    begin
      TAnimator.AnimateFloat(tabs[lst].text, 'TextSettings.Font.Size', normSize);
      TAnimator.AnimateFloat(tabs[id].text, 'TextSettings.Font.Size', normSize*entSize);
    end;

    TAnimator.AnimateFloat(tabs[lst].layout, 'width', w);
    TAnimator.AnimateFloat(Main, 'Position.X', -((addW*w-w)*id/c));
    TAnimator.AnimateFloat(tabs[id].layout, 'width', addW*w);

    lst:=id;
  end;
end;

end.

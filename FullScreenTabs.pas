unit FullScreenTabs;

interface

uses
  System.Types,
  FMX.Layouts, FMX.ImgList, FMX.Objects, FMX.Types, FMX.Forms, FMX.Ani,
  Forms, ImageManager;

type
  shwClick = procedure(id: byte) of object;

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
    tabs: TArray<FSTab>;
    shw, lst: ShortInt;
    w: single;
  public
    showClick: shwClick;

    procedure setSize(img: boolean);
    procedure onClick(id: byte);
    procedure onEnter(id: ShortInt);

    constructor create(fm: TGForm; c:byte; m: TLayout);
  end;

implementation

const
  add = 80;

constructor FSTab.create(l: TLayout);
var
  f: TFmxObject;
begin
  layout:=l;
  for f in l.Children do
    if f is TGlyph then
      image:=f as TGlyph
    else if f is TText then
      text:=f as TText;
end;

constructor FSTabs.create(fm: TGForm; c:byte; m: TLayout);
var
  f: TFmxObject;
begin
  form:=fm;
  main:=m;
  setLength(tabs, c);
  for f in m.Children do
    if f is TLayout then
      tabs[f.Tag]:=FSTab.create(f as TLayout);
  shw:=-1;
end;

procedure FSTabs.setSize(img: Boolean);
var
  i, c: byte;
begin
  c:=length(tabs);
  main.SetBounds(0, 0, Screen.Width, Screen.Height);
  w:=Screen.Width/c;
  for i:=low(tabs) to high(tabs) do
  begin
    tabs[i].layout.Width:=Screen.Width/c;
    tabs[i].layout.Height:=Screen.Height;
    if img then IM.setSize(tabs[i].image, TSizeF.Create(w, Screen.Height))
  end;
end;

procedure FSTabs.onClick(id: Byte);
begin
  if shw>=0 then
  begin
    TAnimator.AnimateFloat(tabs[shw].layout, 'width', w);
    TAnimator.AnimateFloat(Main, 'Position.X', 0);
    TAnimator.AnimateInt(tabs[shw].text, 'TextSettings.Font.Size', 40);
    shw:=-1;
  end
  else
  begin
    shw:=id;
    Form.setText(tabs[id].text.Tag);

    TAnimator.AnimateFloat(Main, 'Position.X', -(2*w*id/3));
    TAnimator.AnimateFloat(tabs[id].layout, 'width', 3*w);
    TAnimator.AnimateInt(tabs[id].text, 'TextSettings.Font.Size', 80);

    if Assigned(showClick) then showClick(id);
  end;
end;

procedure FSTabs.onEnter(id: ShortInt);
begin
  if (shw<0)and(id<>lst) then
  begin
    TAnimator.AnimateInt(tabs[lst].text, 'TextSettings.Font.Size', 40);
    TAnimator.AnimateFloat(tabs[lst].layout, 'width', w);

    TAnimator.AnimateInt(tabs[id].text, 'TextSettings.Font.Size', 52);
    TAnimator.AnimateFloat(Main, 'Position.X', -(add*id/3));
    TAnimator.AnimateFloat(tabs[id].layout, 'width', add+w);
    lst:=id;
  end;
end;

end.

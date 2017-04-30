unit Forms;

interface

uses
  System.UITypes, System.Classes, System.Generics.Collections,
  FMX.Forms, FMX.ImgList, FMX.Objects, FMX.Memo, FMX.Controls, FMX.Ani, FMX.Types, FMX.Layouts, FMX.TabControl,
  BarUnit, ImageManager, TextManager, SoundManager, GameData, ResourcesManager;

type
  TBarForm = class(TForm)
  protected
    procedure setLogo(id: byte);
    procedure setCapt(id: byte);
    procedure fillBar(c:byte = 0; l:byte = 0; t:byte = 0);

    procedure onFormCreate; virtual;
    procedure afterFormCreate; virtual;

    procedure setBarEvents; virtual;
    procedure onFormShow; virtual;
    procedure onFormClose(var Action: TCloseAction); virtual;
  public
    procedure setText(id: byte); overload;
    procedure setTabText(id: byte);
    function getItem(id: byte): string;
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
    procedure onFormClose(var Action: TCloseAction); override;
  public
    procedure showImg(i: Byte);
    procedure Next(Sender: TObject);
    procedure Back(Sender: TObject);

    constructor Create(AOwner: TComponent; r: eResource); reintroduce;
  end;

implementation

uses
  System.Types, System.SysUtils,
  FMX.Dialogs,
  DataUnit;

  {TBarForm}

procedure TBarForm.SetLogo(id: byte);
begin
  Bar.SubLogo.imageIndex:=TM.Forms[name].Logos[id];
end;

procedure TBarForm.setCapt(id :byte);
begin
  Bar.SubName.Text:=TM.Forms[name].Names[id];
end;

procedure TBarForm.setText(id: byte);
var
  b: string;
begin
  b:=TM.Forms[name].Texts[id];
  if length(b)=0 then
    Bar.SubText.Lines.Clear
  else
    Bar.SubText.Text:=b;
end;

procedure TBarForm.setTabText(id: byte);
var
  b: string;
begin
  b:=TM.Forms[name].TabTexts[id];
  if length(b)=0 then
    Bar.SubText.Lines.Clear
  else
    Bar.SubText.Text:=b;
end;

procedure TBarForm.fillBar(c:byte = 0; l:byte = 0; t:byte = 0);
begin
  setCapt(c);
  setLogo(l);
  setTabText(t);
end;

function TBarForm.getItem(id: Byte): string;
begin
  result:=TM.Forms[name].Items[id];
end;

procedure TBarForm.setItem(id: byte; text:TText);
begin
  text.text:=TM.Forms[name].Items[id];
end;

procedure TBarForm.setItem(id: byte; memo: TMemo);
var
  b: string;
begin
  b:=TM.Forms[name].Items[id];
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
  onFormClose(Action);
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

  {TMForm}

procedure TMForm.showImg(i: Byte);
begin
  imgs[i].BringToFront;
  setTabText(i);
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
    Bar.nxtBtn:=true;
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

constructor TMForm.Create(AOwner: TComponent; r: eResource);
var
  g,c:TGlyph;
  i:byte;
begin
  inherited create(AOwner);
  count:=getImgList(r).Destination.Count;
  if count>0 then
  begin
    G:=TGlyph.Create(self);
    G.Images:=getImgList(r);
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

end.

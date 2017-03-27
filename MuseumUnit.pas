unit MuseumUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit,
  FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation,
  BarUnit, FMX.ImgList, FMX.Layouts, FMX.ani,
  Forms;

type
  TMuseumForm = class(TBarForm)
    frame: TLayout;
    main: TLayout;
    controls: TLayout;
    back: TLayout;
    next: TLayout;
    procedure backClick(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure onFormShow; override;
    procedure showImg(i:byte);
  end;

var
  MuseumForm: TMuseumForm;

implementation

{$R *.fmx}

uses
  ResourcesManager;

var
  imgs:TArray<TGlyph>;
  last,id:ShortInt;
  count:byte;
  ani:boolean;

procedure TMuseumForm.onFormCreate;
var
  g,c:TGlyph;
  i:byte;
begin
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
    for i:=0 to count-1 do
      main.AddObject(imgs[i]);
  end;
end;

procedure TMuseumForm.onFormShow;
begin
  if last<=0 then last:=-1;
  id:=0;
  showImg(id);
end;

procedure TMuseumForm.showImg(i: Byte);
begin
  imgs[i].BringToFront;
  setText(i);
  TAnimator.AnimateFloatWait(imgs[i], 'Opacity', 1, 0.6);
  if last>=0 then imgs[last].Opacity:=0;
  last:=id;
  ani:=false;
end;

procedure TMuseumForm.backClick(Sender: TObject);
begin
  if not ani then
  begin
    ani:=true;
    if 0=TFmxObject(sender).Tag then
    begin
      if id>0 then dec(id) else id:=count-1;
    end else begin
      if id=count-1 then id:=0 else inc(id);
    end;
    showImg(id);
  end;
end;

end.

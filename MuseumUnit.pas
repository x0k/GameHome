unit MuseumUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit,
  FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation, FMX.ImgList, FMX.Layouts, FMX.ani,
  Forms, FMX.Memo, FMX.ScrollBox;

type
  TMuseumForm = class(TBarForm)
    Main: TLayout;
    controls: TLayout;
    lBack: TLayout;
    lNext: TLayout;
    logoLayout: TLayout;
    Logo: TGlyph;
    SPanel: TPanel;
    nextLayout: TLayout;
    NextBtn: TSpeedButton;
    SubName: TText;
    SubText: TMemo;
    SubLogo: TGlyph;
    backLayout: TLayout;
    BackBtn: TSpeedButton;
    progress: TLayout;
    Img: TGlyph;
    procedure logoLayoutClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
  protected
    procedure onCreate; override;
  end;

var
  MuseumForm: TMuseumForm;

implementation

{$R *.fmx}

uses
  ResourcesManager;

var
  dots: TArray<TGlyph>;

procedure TMuseumForm.BackBtnClick(Sender: TObject);
begin
  dots[img.ImageIndex].ImageIndex:=0;
  if img.ImageIndex>0 then
    img.ImageIndex:=img.ImageIndex-1
  else
    img.ImageIndex:=img.Images.Count-1;
  setItem(img.ImageIndex, SubText);
  dots[img.ImageIndex].ImageIndex:=1;
end;

procedure TMuseumForm.NextBtnClick(Sender: TObject);
begin
  dots[img.ImageIndex].ImageIndex:=0;
  if img.ImageIndex<img.Images.Count-1 then
    img.ImageIndex:=img.ImageIndex+1
  else
    img.ImageIndex:=0;
  setItem(img.ImageIndex, SubText);
  dots[img.ImageIndex].ImageIndex:=1;
end;

procedure TMuseumForm.logoLayoutClick(Sender: TObject);
begin
  Close;
end;

procedure TMuseumForm.onCreate;
var
  g, cl: TGlyph;
  i: byte;
begin
  layouts:=[main];
  img.ImageIndex:=0;
  setItem(img.ImageIndex, SubText);
  setLength(dots, img.Images.Count);
    g:=TGlyph.Create(self);
  with g do
  begin
    Align:=TAlignLayout.Right;
    Height:=30;
    Width:=30;
    Margins.Right:=10;
  end;
  for i:=img.Images.Count-1 downto 0 do
  begin
    cl:=g.Clone(self) as TGlyph;
    cl.Images:=getImgList(rProgress);
    cl.ImageIndex:=0;
    dots[i]:=cl;
    progress.AddObject(cl);
  end;
  g.Free;
  dots[0].ImageIndex:=1;
end;

end.

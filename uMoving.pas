unit uMoving;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.ImgList,
  uFrame;

type
  TMovingFrame = class(TGFrame)
    Main: TLayout;
    Top: TLayout;
    Left: TGlyph;
    Right: TGlyph;
    Content: TGlyph;
    Grid: TScaledLayout;
    name0: TPanel;
    Text1: TText;
    name1: TPanel;
    Text2: TText;
    name2: TPanel;
    Text3: TText;
    name3: TPanel;
    Text4: TText;
    thing0: TPanel;
    Text5: TText;
    thing1: TPanel;
    Text6: TText;
    thing2: TPanel;
    Text7: TText;
    thing3: TPanel;
    Text8: TText;
    Images: TLayout;
    line1: TGlyph;
    line2: TGlyph;
    line3: TGlyph;
    line4: TGlyph;
    procedure Text1Click(Sender: TObject);
  protected
    procedure onFCreate; override;
  end;

implementation

{$R *.fmx}

uses
  DataUnit;

var
  nick, thing: TText;
  m: TArray<TGlyph>;
  c: byte;

procedure TMovingFrame.onFCreate;
begin
  layouts:=[Main];
  m:=[line1, line2, line3, line4];
  c:=0;
end;

procedure TMovingFrame.Text1Click(Sender: TObject);
var
  t: TText;

  procedure sel(var t: TText);
  begin
    t.TextSettings.Font.Style:= t.TextSettings.Font.Style + [TFontStyle.fsUnderline]
  end;

  procedure unsel(t: TText);
  begin
    t.TextSettings.Font.Style:= t.TextSettings.Font.Style - [TFontStyle.fsUnderline]
  end;

  procedure add(G: TGlyph);
  begin
    g.ImageIndex:=g.ImageIndex+1;
    inc(c);
    if c=4 then win;
  end;

begin
  if sender is TText then t:=sender as TText
    else exit;
  if t.Tag<10 then
  begin
    if Assigned(nick) then unsel(nick);
    nick:=t;
    sel(nick);
  end else
  begin
    if Assigned(thing) then unsel(thing);
    thing:=t;
    sel(thing);
  end;
  if Assigned(nick) and Assigned(thing) then
  begin
    if (nick.tag+10=thing.tag) and (m[nick.tag].ImageIndex mod 2=0) then add(m[nick.tag]);
    unsel(nick); unsel(thing);
    nick:=nil; thing:=nil;
  end;
end;

end.

unit MovingUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ImgList, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  GameForms;

type
  TMovingForm = class(TGForm)
    BG: TGlyph;
    Main: TLayout;
    Top: TLayout;
    Left: TGlyph;
    Right: TGlyph;
    Content: TGlyph;
    Grid: TScaledLayout;
    name0: TPanel;
    name1: TPanel;
    name2: TPanel;
    name3: TPanel;
    thing0: TPanel;
    thing1: TPanel;
    thing2: TPanel;
    thing3: TPanel;
    line1: TGlyph;
    line2: TGlyph;
    line3: TGlyph;
    line4: TGlyph;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    Text5: TText;
    Text6: TText;
    Text7: TText;
    Text8: TText;
    Images: TLayout;
    procedure Text1Click(Sender: TObject);
  protected
    procedure onFormCreate; override;
  end;

var
  MovingForm: TMovingForm;

implementation

{$R *.fmx}

uses
  DataUnit;

var
  nick, thing: TText;
  m: TArray<TGlyph>;
  c: byte;

procedure TMovingForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[Main];
  m:=[line1, line2, line3, line4];
  c:=0;
end;

procedure TMovingForm.Text1Click(Sender: TObject);
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

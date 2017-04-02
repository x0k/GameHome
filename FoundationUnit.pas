unit FoundationUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Effects,
  FMX.Filter.Effects, DataUnit, FMX.ImgList, FMX.Ani,
  GameForms;

type
  TFoundationForm = class(TGForm)
    BG: TGlyph;
    f0: TGlyph;
    f1: TGlyph;
    f2: TGlyph;
    f3: TGlyph;
    Main: TLayout;
    s0: TLayout;
    s1: TLayout;
    s2: TLayout;
    s3: TLayout;
    t0: TText;
    t1: TText;
    t2: TText;
    t3: TText;
    home: TGlyph;
    cont: TLayout;
    procedure s0MouseEnter(Sender: TObject);
    procedure s0Click(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
  end;

implementation

{$R *.fmx}

var
  w, p:single;
  lst:ShortInt;

procedure TFoundationForm.onFormCreate;
var
  i:byte;
begin
  backgrounds:=[BG];
  layouts:=[cont];
  w:=Screen.Width/5;
  main.Width:=w*4;
  for i:=0 to 3 do
  begin
    (Main.Children[i] as TLayout).Width:=w;
    (Main.Children[i].Children[0] as TGlyph).Height:=w+120;
  end;
end;

procedure TFoundationForm.s0Click(Sender: TObject);
  procedure wrongAni(O:TFmxObject);
  begin
    TAnimator.AnimateFloat(O, 'Margins.Left', 70);
    TAnimator.AnimateFloatWait(O, 'Margins.Right', 70);
    TAnimator.AnimateFloat(O, 'Margins.Left', 0);
    TAnimator.AnimateFloat(O, 'Margins.Right', 0);
  end;
  procedure winAni(O:TFmxObject);
  begin
    TAnimator.AnimateFloat(O, 'Margins.Left', -70);
    TAnimator.AnimateFloatWait(O, 'Margins.Right', -70);
    TAnimator.AnimateFloat(O, 'Margins.Left', 0);
    TAnimator.AnimateFloat(O, 'Margins.Right', 0);
  end;
begin
  self.setText(TFmxObject(sender).Children[0].Tag);
  if TFmxObject(sender).Tag=2 then
  begin
    win;
    winAni(TFmxObject(sender).Children[0]);
  end else wrongAni(TFmxObject(sender).Children[0]);
end;

procedure TFoundationForm.s0MouseEnter(Sender: TObject);
var
  id:shortint;
begin
  id:=main.Children.IndexOf(TFmxObject(sender));
  if id<>lst then
  begin
    TAnimator.AnimateFloat(Main.Children[lst], 'width', w);

    TAnimator.AnimateFloat(Main, 'Position.X', p-(60*TFmxObject(sender).Tag/3));
    TAnimator.AnimateFloat(TFmxObject(sender), 'width', 60+w);
    lst:=id;
  end;
end;

procedure TFoundationForm.addShow;
var
  i:byte;
  t:TText;
  m:TArray<TText>;
begin
  w:=main.Width/4;
  for i:=0 to 3 do
    (main.Children[i] as TControl).Width:=w;
  m:=[t0, t1, t2, t3];
  for t in m do
    t.Font.Size:=22*t0.Width/220;
  p:=main.Position.X;
end;

end.

unit TaskUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.StdCtrls,
  FMX.Layouts, DataUnit, FMX.ImgList, FMX.ani,
  Forms;

type
  TTaskForm = class(TGForm)
    img: TGlyph;
    BG: TGlyph;
    main: TLayout;
    Text1: TText;
    text: TMemo;
    Text2: TText;
    Layout1: TLayout;
    Button1: TButton;
    Button2: TButton;
    num: TLabel;
    grid: TLayout;
    procedure DecClick(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
    procedure addWin; override;
  end;

var
  ans:word;


implementation

{$R *.fmx}

procedure TTaskForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  img.Width:=(Screen.Height-300)/597*457;
end;

procedure TTaskForm.addShow;
begin
  ans:=FormText.Items[0].ToInteger;
  repeat
    num.Tag:=random(14)-7+ans;
  until (num.Tag>ans+2)or(num.Tag<ans-2);
  Num.Text:=Num.Tag.ToString;
  self.setItem(1, text);
end;

procedure TTaskForm.addWin;
begin
  Num.StyleLookup:='SelText';
end;

procedure TTaskForm.DecClick(Sender: TObject);
begin
  if Num.Tag<>ans then
  begin
    if (Tbutton(sender).Tag=1)and(Num.Tag<ans+10) then Num.Tag:=Num.Tag+1 else
    if (Tbutton(sender).Tag=0)and(Num.Tag>ans-10) then Num.Tag:=Num.Tag-1;
    Num.Text:=Num.Tag.ToString;
    if ans=num.Tag then win;
  end;
end;

end.

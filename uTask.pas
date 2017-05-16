unit uTask;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts, FMX.ImgList,
  uFrame;

type
  TTaskFrame = class(TGFrame)
    Main: TLayout;
    Img: TGlyph;
    Grid: TLayout;
    Input: TLayout;
    DecBtn: TButton;
    IncBtn: TButton;
    Num: TLabel;
    Text: TMemo;
    Task: TText;
    Answer: TText;
    procedure DecBtnClick(Sender: TObject);
  protected
    procedure onFCreate; override;
    procedure win; override;
  public
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

var
  ans:word;

procedure TTaskFrame.onFCreate;
begin
  layouts:=[main];
end;

procedure TTaskFrame.onFShow;
begin
  if fText.Items[0]<>'' then
    ans:=fText.Items[0].ToInteger
  else
    ans:=418;
  repeat
    num.Tag:=random(14)-7+ans;
  until (num.Tag>ans+2)or(num.Tag<ans-2);
  Num.Text:=Num.Tag.ToString;
  inherited;
end;

procedure TTaskFrame.Win;
begin
  inherited;
  Num.StyleLookup:='SelText';
  setBonus(2);
end;

procedure TTaskFrame.DecBtnClick(Sender: TObject);
begin
  if Num.Tag<>ans then
  begin
    if (Tbutton(sender).Tag=1)and(Num.Tag<ans+10) then Num.Tag:=Num.Tag+1 else
    if (Tbutton(sender).Tag=0)and(Num.Tag>ans-10) then Num.Tag:=Num.Tag-1;
    Num.Text:=Num.Tag.ToString;
    if ans=num.Tag then win
      else clicks;
  end;
end;

end.

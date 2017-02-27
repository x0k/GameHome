unit TaskUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.StdCtrls,
  FMX.Layouts, DataUnit, FMX.ImgList;

type
  TTaskForm = class(TGForm)
    Text: TMemo;
    Grid: TGridPanelLayout;
    Dec: TButton;
    Num: TLabel;
    Inc: TButton;
    ttask: TText;
    tans: TText;
    img: TGlyph;
    BG: TGlyph;
    procedure DecClick(Sender: TObject);
  protected
    procedure gShow; override;
    procedure aWin; override;
  public
    { Public declarations }
  end;

var
  ans:word;


implementation

{$R *.fmx}

procedure TTaskForm.gShow;
begin
  ans:=TM.getName(1).toInteger;
  repeat
    num.Tag:=random(14)-7+ans;
  until (num.Tag>ans+2)or(num.Tag<ans-2);
  Num.Text:=Num.Tag.ToString;
  self.setDescription(2, text);
  ldesc:=0;
end;

procedure TTaskForm.aWin;
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

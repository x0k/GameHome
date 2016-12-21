unit TaskUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.StdCtrls,
  FMX.Layouts, DataUnit;

type
  TTaskForm = class(TGForm)
    BG: TImage;
    Schem: TImage;
    Text: TMemo;
    GridPanelLayout1: TGridPanelLayout;
    Dec: TButton;
    Num: TLabel;
    Inc: TButton;
    ttask: TText;
    tans: TText;
    Main: TLayout;
    procedure DecClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
    procedure BarNextBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ans:word;


implementation

{$R *.fmx}

procedure TTaskForm.BarBackBtnClick(Sender: TObject);
begin
  //GameForm.OnActivate(TObject(self));
  //TaskForm.Release;
end;

procedure TTaskForm.BarNextBtnClick(Sender: TObject);
begin
  //FoundationForm:=TFoundationForm.Create(GameForm);
  //FoundationForm.Show;
  //TaskForm.Release;
end;

procedure TTaskForm.DecClick(Sender: TObject);
begin
  if (Tbutton(sender).Tag=1)and(Num.Tag<ans+10) then Num.Tag:=Num.Tag+1 else
  if (Tbutton(sender).Tag=0)and(Num.Tag>ans-10) then Num.Tag:=Num.Tag-1;
  Num.Text:=Num.Tag.ToString;
  if Num.Tag=ans then
  begin
    Dec.OnClick:=nil;
    Inc.OnClick:=nil;
    //lev[5]:=2;
    //vis[9]:=true;
    //Bar.DrawProgress;
    Bar.NextBtn.Enabled:=true;
    Bar.NextBtn.Opacity:=1;
    Num.StyleLookup:='SelText';
    //DataForm.Load(1);
    SM.Play;
  end;
end;

procedure TTaskForm.FormActivate(Sender: TObject);
begin
  //Bar.DrawProgress;
end;

procedure TTaskForm.FormCreate(Sender: TObject);
begin
  //Bar.Load(nLogo,self.Name);
  //DataForm.LoadImg(3,4,schem);
  //ans:=FD.SubNames[1].ToInteger;
  repeat
    num.Tag:=random(14)-7+ans;
  until not((num.Tag<ans+2)and(num.Tag>ans-2));
  Num.Text:=Num.Tag.ToString;
  //Text.Lines.Assign(PData.SubTexts[2]);
end;

procedure TTaskForm.FormShow(Sender: TObject);
begin
  //Lev[5]:=1;
  //DataForm.LoadSound(1);
  Bar.Draw(self.Width,self.Height);
  //DataForm.LoadScaleImg(0,1,BG);
end;

end.

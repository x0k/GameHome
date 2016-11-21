unit BarUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, DataUnit, FMX.Ani,
  FGX.Animations, FMX.ScrollBox, FMX.Memo, FMX.TabControl;

type
  TBar = class(TFrame)
    BonusBtn: TButton;
    MenuBtn: TButton;
    progress: TLayout;
    l14: TImage;
    l13: TImage;
    l12: TImage;
    l11: TImage;
    l10: TImage;
    l9: TImage;
    l8: TImage;
    l7: TImage;
    l6: TImage;
    l5: TImage;
    l4: TImage;
    l3: TImage;
    l2: TImage;
    l1: TImage;
    Logo: TImage;
    Pos: TFloatAnimation;
    SpeedButton1: TSpeedButton;
    Pos2: TFloatAnimation;
    RBonus: TPanel;
    m1: TImage;
    m2: TImage;
    m3: TImage;
    m4: TImage;
    m5: TImage;
    m6: TImage;
    m7: TImage;
    wh1: TImage;
    tools: TImage;
    woods: TImage;
    wh2: TImage;
    body: TImage;
    st1: TImage;
    st2: TImage;
    telega: TLayout;
    SPanel: TPanel;
    NextBtn: TSpeedButton;
    BackBtn: TSpeedButton;
    SubPanel1: TGridPanelLayout;
    SubLogo: TImage;
    SubText: TMemo;
    SubName: TText;
    chip: TImage;
    procedure BonusBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Draw(w,h:integer);
    procedure DrawPanel(s:byte;x:byte = 0;y:byte = 0);
    procedure DrawProgress;
    procedure Load(i:byte;s:string);
  end;

implementation

{$R *.fmx}

procedure TBar.DrawProgress;
var
  I: Integer;
  Img:Timage;
begin
  for I := 0 to progress.ChildrenCount-1 do
  begin
    img:=(progress.Children.Items[i] as Timage);
    if lev[img.tag]=2 then DataForm.LoadImg(2,3,img)
      else if lev[img.tag]=1 then DataForm.LoadImg(2,2,img)
        else DataForm.LoadImg(2,1,img);
  end;
  for I := 0 to RBonus.ChildrenCount-1 do
  begin
    if (RBonus.Children.Items[i] is Timage) then
    begin
      img:=(RBonus.Children.Items[i] as Timage);
      if vis[img.tag] then img.Visible:=true
        else img.Visible:=false;
    end;
  end;
  for I := 0 to telega.ChildrenCount-1 do
  begin
    if (telega.Children.Items[i] is Timage) then
    begin
      img:=(telega.Children.Items[i] as Timage);
      if vis[img.tag] then img.Visible:=true
        else img.Visible:=false;
    end;
  end;
end;

procedure TBar.DrawPanel(s:byte;x:byte = 0;y:byte = 0);
begin
  SubName.Text:=PData.SubNames[y];
  DataForm.LoadImg(2,s,SubLogo);
  if PData.SubTexts[x]=nil then SubText.Lines.Clear else SubText.Lines.Assign(PData.SubTexts[x]);
end;

procedure TBar.BonusBtnClick(Sender: TObject);
begin
  Pos.Enabled:=true;
  Pos2.Enabled:=false;
end;

procedure TBar.Load(i:byte;s:string);
begin

  if s<>PData.Last then
    if PData.Load(s) then showmessage('Error load');
  DrawPanel(i);
  DrawProgress;
  DataForm.LoadImg(2,0,Logo);
end;

procedure TBar.Draw(w,h:integer);
begin
  RBonus.Position.X:=w;
  RBonus.Position.Y:=0;
  RBonus.Height:=h-165;
  Pos.StartValue:=w;
  Pos.StopValue:=w-RBonus.Width;
  Pos2.StartValue:=w-RBonus.Width;
  Pos2.StopValue:=w;
end;

procedure TBar.SpeedButton1Click(Sender: TObject);
begin
  Pos2.Enabled:=true;
  pos.Enabled:=false;
end;

end.

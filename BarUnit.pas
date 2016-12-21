unit BarUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.Ani,
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
    procedure MenuBtnClick(Sender: TObject);
  private

  public
    procedure Draw(w,h:integer);
    procedure DrawPanel(s:string;x:byte = 0;y:byte = 0);
    procedure Load(Ico,s:string);
    procedure UpStatus(i:byte);
    procedure pUpdate;
  end;

implementation

{$R *.fmx}

uses GameUnit, DataUnit;

procedure TBar.UpStatus(i: Byte);
begin
  {GD.UpStatus(i);
  case GD.StatusLevels[i] of
    1:SM.LoadSound(0);
    2:begin
      SM.LoadSound(1);
      SM.Play;
    end;
  end;}
  pUpdate;
end;

procedure TBar.DrawPanel(s:string;x:byte = 0;y:byte = 0);
begin
  //IM.SetImage(IICO,TImg.Create(s,SubLogo),false);
  //SubName.Text:=FD.SubNames[y];
  //if FD.SubTexts[x]=nil then SubText.Lines.Clear else SubText.Lines.Assign(FD.SubTexts[x]);
end;

procedure TBar.BonusBtnClick(Sender: TObject);
var
  i:byte;
begin
  for i:=0 to RBonus.ChildrenCount-1 do
    if RBonus.Children.Items[i] is TImage then
      //if GD.Awards[(RBonus.Children.Items[i] as TImage).Tag] then (RBonus.Children.Items[i] as TImage).Visible:=true
        else (RBonus.Children.Items[i] as TImage).Visible:=false;
  Pos.Enabled:=true;
  Pos2.Enabled:=false;
end;

procedure TBar.Load(Ico,s:string);
begin
  DrawPanel(ico);
end;

procedure TBar.MenuBtnClick(Sender: TObject);
begin
  //GameForm.Show;
end;

procedure TBar.pUpdate;
  function GetName(i:byte):string;
  begin
    case i of
      0:result:='Black';
      1:result:='Gray'
      else result:='White';
    end;
  end;
var
  i:byte;
begin
  //for i:=0 to progress.ChildrenCount-1 do
    //if progress.Children.Items[i] is Timage then
      //IM.SetImage(IICO,TImg.Create(GetName(GD.StatusLevels[(progress.Children.Items[i] as TFmxObject).Tag]),(progress.Children.Items[i] as Timage)))
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

unit GameUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Layouts, FGX.FlipView, FMX.Filter.Effects, BarUnit;

type
  TGameForm = class(TForm)
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Map: TImage;
    TabItem3: TTabItem;
    l4btn: TButton;
    l5btn: TButton;
    l7btn: TButton;
    l9btn: TButton;
    l8btn: TButton;
    l3btn: TButton;
    l6btn: TButton;
    l1btn: TButton;
    l2btn: TButton;
    l14btn: TButton;
    l13btn: TButton;
    l12btn: TButton;
    l11btn: TButton;
    l10btn: TButton;
    BG1: TImage;
    Alex: TImage;
    BG2: TImage;
    BG3: TImage;
    Btns: TLayout;
    Bar: TBar;
    procedure ExitBtnClick(Sender: TObject);
    procedure NextSBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BackSBtnClick(Sender: TObject);
    procedure l1btnClick(Sender: TObject);
    procedure MenuBtnClick(Sender: TObject);
    procedure l2btnClick(Sender: TObject);
    procedure l3btnClick(Sender: TObject);
    procedure BarNextBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure l4btnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure l5btnClick(Sender: TObject);
    procedure l6btnClick(Sender: TObject);
    procedure l7btnClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  GameForm: TGameForm;
implementation

{$R *.fmx}

uses SeazonUnit, PlaceUnit, ToolsUnit, MaterialsUnit, DataUnit, TaskUnit,
  FoundationUnit, MapUnit;

procedure TGameForm.BackSBtnClick(Sender: TObject);
begin
  Tabs.Previous();
end;

procedure TGameForm.BarNextBtnClick(Sender: TObject);
begin
  Tabs.Next();
  Bar.DrawPanel(1+Tabs.TabIndex,Tabs.TabIndex,Tabs.TabIndex);
  if Tabs.TabIndex=2 then
  begin
    Bar.NextBtn.Visible:=false;
    Bar.progress.Visible:=true;
    Bar.MenuBtn.Visible:=true;
    bar.BonusBtn.Visible:=true;
  end;
end;

procedure TGameForm.ExitBtnClick(Sender: TObject);
begin
  GameForm.Close;
end;

procedure TGameForm.FormActivate(Sender: TObject);
begin
  Bar.DrawProgress;
end;

procedure TGameForm.FormCreate(Sender: TObject);
begin
  DataForm.LoadImg(3,0,Alex);
  DataForm.LoadImg(3,1,Map);
  Bar.Load(1,self.Name);
  Bar.progress.Visible:=false;
  Bar.MenuBtn.Visible:=false;
  bar.BonusBtn.Visible:=false;
end;

procedure TGameForm.FormShow(Sender: TObject);
begin
  Bar.Draw(self.Width,self.Height);
  DataForm.LoadScaleImg(0,0,BG1);
  DataForm.LoadScaleImg(0,1,BG2);
  DataForm.LoadScaleImg(0,1,BG3);
end;

procedure TGameForm.l1btnClick(Sender: TObject);
begin
  SeazonForm:=TSeazonForm.Create(GameForm);
  SeazonForm.Show;
end;

procedure TGameForm.l2btnClick(Sender: TObject);
begin
  PlaceForm:=TPlaceForm.Create(GameForm);
  PlaceForm.Show;
end;

procedure TGameForm.l3btnClick(Sender: TObject);
begin
  ToolsForm:=TToolsForm.Create(GameForm);
  ToolsForm.Show;
end;

procedure TGameForm.l4btnClick(Sender: TObject);
begin
  MaterialsForm:=TMaterialsForm.Create(GameForm);
  MaterialsForm.Show;
end;

procedure TGameForm.l5btnClick(Sender: TObject);
begin
  TaskForm:=TTaskForm.Create(GameForm);
  TaskForm.Show;
end;

procedure TGameForm.l6btnClick(Sender: TObject);
begin
  FoundationForm:=TFoundationForm.Create(GameForm);
  FoundationForm.Show;
end;

procedure TGameForm.l7btnClick(Sender: TObject);
begin
  MapForm:=TMapForm.Create(GameForm);
  MapForm.Show;
end;

procedure TGameForm.MenuBtnClick(Sender: TObject);
begin
  GameForm.Close;
end;

procedure TGameForm.NextSBtnClick(Sender: TObject);
begin
  Tabs.Next();
end;

end.

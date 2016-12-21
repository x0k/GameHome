unit MaterialsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.StdCtrls, DataUnit;

type
  TMaterialsForm = class(TGForm)
    BG: TImage;
    Trees: TImage;
    Text: TMemo;
    Grid: TGridPanelLayout;
    Tfor: TText;
    Tiul: TText;
    Tsent: TText;
    Tsosn: TText;
    cSosn: TCheckBox;
    cEl: TCheckBox;
    cList: TCheckBox;
    cOsina: TCheckBox;
    Main: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cSosnChange(Sender: TObject);
    procedure cElChange(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BarNextBtnClick(Sender: TObject);
  private
    procedure up;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TMaterialsForm.up;
begin
  if cSosn.IsChecked and cList.IsChecked then
  begin
    //vis[2]:=true;
    //lev[4]:=2;
    //Bar.DrawProgress;
    Bar.NextBtn.Enabled:=true;
    Bar.NextBtn.Opacity:=1;
    SM.LoadSound(1);
    SM.Play;
  end;
end;

procedure TMaterialsForm.BarBackBtnClick(Sender: TObject);
begin
  //MaterialsForm.Release;
end;

procedure TMaterialsForm.BarNextBtnClick(Sender: TObject);
begin
  //TaskForm:=TTaskForm.Create(GameForm);
  //TaskForm.Show;
  //MaterialsForm.Release;
end;

procedure TMaterialsForm.cElChange(Sender: TObject);
begin
  TCheckBox(sender).HitTest:=false;
  //Bar.DrawPanel(nLogo,TCheckBox(sender).Tag);
  //DataForm.Load(0);
  SM.Play;
end;

procedure TMaterialsForm.cSosnChange(Sender: TObject);
begin
  TCheckBox(sender).OnChange:=nil;
  //DataForm.Load(1);
  SM.Play;
  //Bar.DrawPanel(nLogo,TCheckBox(sender).Tag);
  up;
end;

procedure TMaterialsForm.FormActivate(Sender: TObject);
begin
  //Bar.DrawProgress;
end;

procedure TMaterialsForm.FormCreate(Sender: TObject);
begin
  //Bar.Load(nLogo,self.Name);
  //DataForm.LoadImg(3,3,Trees);
  //Text.Lines.Assign(FD.SubTexts[5]);
end;

procedure TMaterialsForm.FormShow(Sender: TObject);
begin
  //Lev[4]:=1;
  //DataForm.LoadSound(0);
  Bar.Draw(self.Width,self.Height);
  //DataForm.LoadScaleImg(0,1,BG);
end;

end.

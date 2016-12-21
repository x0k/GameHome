unit ToolsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Effects, FMX.Filter.Effects, DataUnit;

type
  TToolsForm = class(TGForm)
    BG: TImage;
    Tools: TLayout;
    T1: TImage;
    T2: TImage;
    T3: TImage;
    T4: TImage;
    T5: TImage;
    T6: TImage;
    T7: TImage;
    T8: TImage;
    T9: TImage;
    T10: TImage;
    procedure FormShow(Sender: TObject);
    procedure T2Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure T6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BarNextBtnClick(Sender: TObject);
  private
    procedure rotate;
    procedure Up;
  public
    { Public declarations }
  end;
var
  eff:TInnerGlowEffect;
  a,b:boolean;

implementation

{$R *.fmx}

procedure TToolsForm.Up;
begin
  if a and b then
  begin
    //vis[8]:=true;
    //Lev[3]:=2;
    //Bar.DrawPanel(1,11);
    Bar.NextBtn.Enabled:=true;
    Bar.NextBtn.Opacity:=1;
    //Bar.DrawProgress;
    SM.LoadSound(1);
    SM.Play;
  end;
end;

procedure TToolsForm.rotate;
var
  i:byte;
begin
  for I := 0 to tools.ChildrenCount-1 do
    (tools.Children.Items[i] as Timage).RotationAngle:=random(360);
end;

procedure TToolsForm.T1Click(Sender: TObject);
  var ef:TInnerGlowEffect;//topor
begin
  eff.Parent:=nil;
  eff.UpdateParentEffects;
  ef:=TInnerGlowEffect.Create(Tcomponent(Sender));
  ef.GlowColor:=TAlphaColorRec.Gold;
  ef.Parent:=TFmxObject(Sender);
  ef.UpdateParentEffects;
  a:=true;
  //Bar.DrawPanel(nLogo,(Sender as Timage).Tag);
  up;
  Timage(Sender).OnClick:=nil;
end;

procedure TToolsForm.T2Click(Sender: TObject);
begin
  SM.Play;
  eff.Parent:=TFmxObject(Sender);
  eff.UpdateParentEffects;
  //Bar.DrawPanel(nLogo,(Sender as Timage).Tag);
end;

procedure TToolsForm.T6Click(Sender: TObject);
  var ef:TInnerGlowEffect;//pila
begin
  eff.Parent:=nil;
  eff.UpdateParentEffects;
  ef:=TInnerGlowEffect.Create(Tcomponent(Sender));
  ef.GlowColor:=TAlphaColorRec.Gold;
  ef.Parent:=TFmxObject(Sender);
  ef.UpdateParentEffects;
  b:=true;
  //Bar.DrawPanel(nLogo,(Sender as Timage).Tag);
  up;
  Timage(Sender).OnClick:=nil;
end;

procedure TToolsForm.BarBackBtnClick(Sender: TObject);
begin
  //ToolsForm.Release;
end;

procedure TToolsForm.BarNextBtnClick(Sender: TObject);
begin
  //MaterialsForm:=TMaterialsForm.Create(GameForm);
  //MaterialsForm.Show;
  //ToolsForm.Release;
end;

procedure TToolsForm.FormActivate(Sender: TObject);
begin
  //Bar.DrawProgress;
end;

procedure TToolsForm.FormCreate(Sender: TObject);
begin
  eff:=TInnerGlowEffect.Create(Tcomponent(Sender));
  eff.GlowColor:=TAlphaColorRec.Blue;
  //Bar.Load(nLogo,self.Name);
  a:=false;b:=false;
end;

procedure TToolsForm.FormShow(Sender: TObject);
begin
  //Lev[3]:=1;
  Bar.Draw(self.Width,self.Height);
  //DataForm.LoadSound(0);
  //DataForm.LoadScaleImg(0,1,BG);
  rotate;
end;

end.

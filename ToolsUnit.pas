unit ToolsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Effects, BarUnit,FMX.Filter.Effects;

type
  TToolsForm = class(TForm)
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
    Bar: TBar;
    procedure FormShow(Sender: TObject);
    procedure T2Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure T6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure rotate;
    procedure Up;
  public
    { Public declarations }
  end;

var
  ToolsForm: TToolsForm;
  eff:TInnerGlowEffect;
  a,b:boolean;

implementation

{$R *.fmx}

uses GameUnit, DataUnit;

procedure TToolsForm.Up;
begin
  if a and b then
  begin
    vis[8]:=true;
    Lev[3]:=2;
    //Bar.DrawPanel(1,11);
    Bar.DrawProgress;
    DataForm.Load(1);
    DataForm.Play;
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
  Bar.DrawPanel(1,(Sender as Timage).Tag);
  up;
  Timage(Sender).OnClick:=nil;
end;

procedure TToolsForm.T2Click(Sender: TObject);
begin
  DataForm.Play;
  eff.Parent:=TFmxObject(Sender);
  eff.UpdateParentEffects;
  Bar.DrawPanel(1,(Sender as Timage).Tag);
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
  Bar.DrawPanel(1,(Sender as Timage).Tag);
  up;
  Timage(Sender).OnClick:=nil;
end;

procedure TToolsForm.BarBackBtnClick(Sender: TObject);
begin
  GameForm.FormActivate(TObject(self));
  ToolsForm.Release;
end;

procedure TToolsForm.FormActivate(Sender: TObject);
begin
  Bar.DrawProgress;
end;

procedure TToolsForm.FormCreate(Sender: TObject);
begin
  eff:=TInnerGlowEffect.Create(Tcomponent(Sender));
  eff.GlowColor:=TAlphaColorRec.Blue;
  Bar.Load(1,self.Name);
  a:=false;b:=false;
end;

procedure TToolsForm.FormShow(Sender: TObject);
begin
  Lev[3]:=1;
  Bar.Draw(self.Width,self.Height);
  DataForm.Load(0);
  DataForm.LoadScaleImg(0,1,BG);
  rotate;
end;

end.

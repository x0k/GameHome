unit MapUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, BarUnit, FMX.Layouts, FMX.Ani, FMX.Effects, DataUnit;

type
  TMapForm = class(TGForm)
    BG: TImage;
    Imap: TImage;
    ct: TLayout;
    p1: TPath;
    P2: TPath;
    P3: TPath;
    P4: TPath;
    P5: TPath;
    P6: TPath;
    P7: TPath;
    P8: TPath;
    P9: TPath;
    P10: TPath;
    P11: TPath;
    P12: TPath;
    P13: TPath;
    P14: TPath;
    P15: TPath;
    P16: TPath;
    P17: TPath;
    P18: TPath;
    P19: TPath;
    ph: TImage;
    brevno: TImage;
    ShadowEffect1: TShadowEffect;
    shp: TImage;
    Main: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure brevnoClick(Sender: TObject);
    procedure p1Click(Sender: TObject);
  private
    procedure OnClickPN(Sender: TObject);
    procedure Up;
  public
    { Public declarations }
  end;
var
  Paths:array[0..18] of Tpath;
  efs:array[0..18] of TFloatAnimation;
  F:TGlowEffect;
  s:byte = 21;
  d:byte = 0;

implementation

{$R *.fmx}

procedure TMapForm.BarBackBtnClick(Sender: TObject);
begin
  //GameForm.Show;
  //MapForm.Release;
end;

procedure TMapForm.Up;
begin
  if d=20 then
  begin
    GD.GetAwd(17);
    GD.UpStatus(Status);
    //Bar.DrawPanel(nLogo,1);
    //Bar.DrawProgress;
    SM.LoadSound(sAward);
    SM.Play;
  end;
end;

procedure TMapForm.brevnoClick(Sender: TObject);
begin
  if s=20 then
  begin
    s:=0;
    ph.Visible:=false;
    shp.Visible:=true;
    SM.Play;
    inc(d);
    up;
  end;
end;

procedure TMapForm.FormActivate(Sender: TObject);
begin
  //Bar.DrawProgress;
end;

procedure TMapForm.OnClickPN(Sender: TObject);
begin
  F.Parent:=TFmxObject(sender);
  s:=Tpath(sender).Tag;
  F.UpdateParentEffects;
end;

procedure TMapForm.p1Click(Sender: TObject);
begin
  if TFmxObject(sender).Tag=s then
  begin
    inc(d);
    Paths[s].Visible:=false;
    efs[s].Trigger:='IsVisible=false';
    efs[s].TriggerInverse:='IsVisible=false';
    s:=0;
    TPath(sender).Fill.Color:=TAlphaColorRec.Blue;
    TPath(sender).Opacity:=1;
    up;
    SM.Play;
  end;
end;

procedure TMapForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  //Bar.Load(nLogo,self.Name);
  //SM.LoadSound(2);
  F:=TGlowEffect.Create(self);
  //IM.SetImages('other',['Imap','Brevno','Shp'],false,[imap,brevno,shp]);
  for I:=0 to 18 do
    begin
      Paths[i]:=Tpath(imap.Children[i].Clone(self));
      Paths[i].Opacity:=1;
      efs[i]:=TFloatAnimation.Create(self);
      efs[i].Trigger:='IsMouseOver=true';
      efs[i].TriggerInverse:='IsMouseOver=false';
      efs[i].StopValue:=1;
      efs[i].PropertyName:='Opacity';
      efs[i].Duration:=1;
      efs[i].Parent:=TFmxObject(imap.Children[i]);
      Paths[i].Parent:=TFmxObject(CT);
      TPath(imap.Children[i]).Tag:=i;
      Paths[i].Tag:=i;
      Paths[i].OnClick:=OnClickPN;
    end;
  ph.OnClick:=OnClickPN;
end;

procedure TMapForm.FormShow(Sender: TObject);
var i:byte;
begin
  GD.UpStatus(Status);
  IM.SetImage('Wall',BG,true);
  ph.Position.X:=10+random(round(CT.Width-10));
  ph.Position.Y:=10+random(round(CT.Height-10));
  for I:=0 to 18 do
  begin
    paths[i].Scale.X:=1.1;
    paths[i].Scale.Y:=1.1;
    paths[i].RotationAngle:=random(360);
    paths[i].Position.X:=10+random(round(CT.Width-10));
    paths[i].Position.Y:=10+random(round(CT.Height-10));
    paths[i].Repaint;
  end;
end;

end.

unit GameUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Layouts, FGX.FlipView, FMX.Filter.Effects, DataUnit;

type
  TGameForm = class(TGForm)
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
    Main1: TLayout;
    Main2: TLayout;
    Main3: TLayout;
    Shome: TImage;
    //procedure l1btnClick(Sender: TObject);
    //procedure MenuBtnClick(Sender: TObject);
    //procedure BarNextBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure FShow; override;
  public
    { Public declarations }
  end;
implementation

{$R *.fmx}

procedure TGameForm.FormCreate(Sender: TObject);
begin
  IM.SetImages(TImgs.Create(IOTH,[],[Alex,Map]));
  Bar.progress.Visible:=false;
  Bar.MenuBtn.Visible:=false;
  Bar.BonusBtn.Visible:=false;
end;

{procedure TGameForm.FormShow(Sender: TObject);
begin
  if not showed then
  begin
    Bar.Load(nLogo[Tabs.TabIndex],self.Name);
    Bar.Draw(self.Width,self.Height);

    showed:=true;
  end else Bar.pUpdate;
end; }

procedure TGameForm.FShow;
begin
  IM.SetImages(TImgs.Create(IBG,['Village','Village','Wall'],[BG1,BG2,BG3]));
  IM.SetImage(IOTH,TImg.Create('Shome',Shome),true);
end;

{procedure TGameForm.BarNextBtnClick(Sender: TObject);
begin
  Tabs.Next();
  Bar.DrawPanel(nLogo[Tabs.TabIndex],Tabs.TabIndex,Tabs.TabIndex);
  if Tabs.TabIndex=2 then
  begin
    Bar.NextBtn.Opacity:=0;
    Bar.progress.Visible:=true;
    Bar.MenuBtn.Visible:=true;
    bar.BonusBtn.Visible:=true;
  end;
end;}

{procedure TGameForm.l1btnClick(Sender: TObject);
begin
  case (Sender as TFmxObject).Tag of
    1:SeazonForm.Show;
    2:PlaceForm.Show;
    3:ToolsForm.Show;
    4:MaterialsForm.Show;
    5:TaskForm.Show;
    6:FoundationForm.Show;
    7:MapForm.Show;
    else showmessage('Error');
  end;
end;}

end.

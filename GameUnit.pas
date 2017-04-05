unit GameUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Layouts, FMX.Filter.Effects, FMX.ImgList, BarUnit, FMX.ani,
  GameForms, DataUnit;

type
  TGameForm = class(TGTabForm)
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
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
    Btns: TLayout;
    Main1: TLayout;
    Main2: TLayout;
    Main3: TLayout;
    BG1: TGlyph;
    BG2: TGlyph;
    BG3: TGlyph;
    Alex: TGlyph;
    Place: TGlyph;
    Home: TGlyph;
    procedure l1btnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  protected
    procedure onFormCreate; override;
    procedure afterTabChange(newTab: byte); override;
  end;

implementation

{$R *.fmx}

uses
  ResourcesManager;

procedure TGameForm.onFormCreate;
begin
  backgrounds:=[home, BG1, BG2, BG3];
  layouts:=[main1, main2, main3];
  gTabs:=tabs;
  gTab:=2;
end;

procedure TGameForm.afterTabChange(newTab: Byte);
begin
  if newTab=2 then
  begin
    if state<2 then state:=2;
    Bar.nxtBtn:=false;
  end;
end;

procedure TGameForm.FormActivate(Sender: TObject);
begin
  Bar.nxtBtn:=Tabs.TabIndex<>gTab;
end;

procedure TGameForm.l1btnClick(Sender: TObject);
begin
  hideAni;
    showForm((Sender as TFmxObject).Tag);
  hide;
end;

end.

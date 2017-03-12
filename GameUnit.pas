unit GameUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Layouts, FMX.Filter.Effects, DataUnit,
  FMX.ImgList, BarUnit, FMX.ani;

type
  TGameForm = class(TGForm)
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
  protected
    procedure onFormCreate; override;
  public
    procedure Back(Sender: TObject);override;
    procedure Next(Sender: TObject);override;
  end;

var
  GameForm: TGameForm;

implementation

{$R *.fmx}

procedure TGameForm.onFormCreate;
begin
  IM.add(rSequences);
  IM.add(rImages);
  IM.add(rOther);
  bgs:=[home, BG1, BG2, BG3];
  lts:=[main1, main3];
end;

procedure TGameForm.Next;
begin
  if Tabs.TabIndex<2 then
  begin
    Tabs.Next();
    SetText(Tabs.TabIndex,Tabs.TabIndex,Tabs.TabIndex);
  end else Bar.setShowBonus;
end;

procedure TGameForm.Back(Sender: TObject);
begin
  hideAni;
  Bar.Parent:=nil;
  hide;
end;

procedure TGameForm.l1btnClick(Sender: TObject);
begin
  hideAni;
  DataForm.ShowForm((Sender as TFmxObject).Tag);
end;

end.

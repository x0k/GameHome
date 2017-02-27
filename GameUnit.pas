unit GameUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation,
  FMX.TabControl, FMX.Layouts, FGX.FlipView, FMX.Filter.Effects, DataUnit,
  FMX.ImgList, BarUnit;

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
    Alex: TImage;
    Btns: TLayout;
    Main1: TLayout;
    Main2: TLayout;
    Main3: TLayout;
    BG1: TGlyph;
    BG2: TGlyph;
    BG3: TGlyph;
    procedure l1btnClick(Sender: TObject);
  protected
    procedure gShow; override;
  public
    procedure GNext(Sender: TObject);override;
  end;
implementation

{$R *.fmx}

procedure TGameForm.gShow;
begin
  Bar.showNext;
end;

procedure TGameForm.GNext;
begin
  if Tabs.TabIndex<2 then
  begin
    Tabs.Next();
    SetText(Tabs.TabIndex,Tabs.TabIndex,Tabs.TabIndex);
  end else Bar.setShowBonus;
end;

procedure TGameForm.l1btnClick(Sender: TObject);
begin
  DataForm.ShowForm((Sender as TFmxObject).Tag);
end;

end.

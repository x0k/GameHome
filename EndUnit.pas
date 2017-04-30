unit EndUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ImgList, GameForms, FMX.TabControl, DataUnit;

type
  TEndForm = class(TGTabForm)
    BG: TGlyph;
    Tabs: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    TabItem5: TTabItem;
    TabItem6: TTabItem;
    TabItem7: TTabItem;
    TabItem8: TTabItem;
    BG1: TGlyph;
    BG2: TGlyph;
    BG3: TGlyph;
    BG4: TGlyph;
    BG5: TGlyph;
    BG6: TGlyph;
    BG7: TGlyph;
  protected
    procedure onFormCreate; override;
  end;

var
  EndForm: TEndForm;

implementation

{$R *.fmx}

uses
  ResourcesManager, ImageManager;

{ TEndForm }

procedure TEndForm.onFormCreate;
begin
  if dbgMode then
    IM.add(rWinMuseum);
  backgrounds:=[BG, BG1, BG2, BG3, BG4, BG5, BG6, BG7];
  gTabs:=tabs;
  gTab:=8;
end;

end.

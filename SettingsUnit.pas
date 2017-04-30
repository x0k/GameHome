unit SettingsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, BarUnit,
  FMX.ImgList,
  Forms;

type
  TSettingsForm = class(TBarForm)
    Grid: TGridPanelLayout;
    Volume: TText;
    Brithnes: TText;
    DecVol: TButton;
    VLev: TLabel;
    IncVol: TButton;
    DecBr: TButton;
    IncBr: TButton;
    BLev: TLabel;
    DecCtr: TButton;
    IncCtr: TButton;
    CLev: TLabel;
    Contrast: TText;
    BG: TGlyph;
    procedure IncVolClick(Sender: TObject);
    procedure DecBrClick(Sender: TObject);
    procedure DecCtrClick(Sender: TObject);
  protected
    procedure onFormCreate; override;
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.fmx}

uses
  ResourcesManager, GameData, ImageManager, SoundManager;

procedure TSettingsForm.DecBrClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Blev.Tag<10) then Blev.Tag:=Blev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Blev.Tag>0) then Blev.Tag:=Blev.Tag-1;
  Blev.Text:=Blev.Tag.ToString;
  GD.brightnes:=Blev.Tag;
end;

procedure TSettingsForm.DecCtrClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Clev.Tag<10) then Clev.Tag:=Clev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Clev.Tag>0) then Clev.Tag:=Clev.Tag-1;
  Clev.Text:=Clev.Tag.ToString;
  GD.contrast:=Clev.Tag;
end;

procedure TSettingsForm.IncVolClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Vlev.Tag<10) then Vlev.Tag:=Vlev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Vlev.Tag>0) then Vlev.Tag:=Vlev.Tag-1;
  Vlev.Text:=Vlev.Tag.ToString;
  SM.volume:=Vlev.Tag;
  SM.Play(sWrong);
end;

procedure TSettingsForm.onFormCreate;
begin
  IM.setSize(BG, Screen.Size);
  Vlev.Tag:=SM.volume;
  Vlev.Text:=Vlev.Tag.ToString;

  Blev.Tag:=GD.brightnes;
  Blev.Text:=Blev.Tag.ToString;

  Clev.Tag:=GD.contrast;
  Clev.Text:=Clev.Tag.ToString;

  setItem(0, Volume);
  setItem(1, Brithnes);
  setItem(2, Contrast);
end;

end.

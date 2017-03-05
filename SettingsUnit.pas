unit SettingsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, DataUnit, BarUnit,
  FMX.ImgList;

type
  TSettingsForm = class(TBarForm)
    Grid: TGridPanelLayout;
    Volume: TText;
    Brithness: TText;
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
    procedure onCreateGForm; override;
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.fmx}

procedure TSettingsForm.DecBrClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Blev.Tag<10) then Blev.Tag:=Blev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Blev.Tag>0) then Blev.Tag:=Blev.Tag-1;
  Blev.Text:=Blev.Tag.ToString;
  GD.SetBr(Blev.Tag);
end;

procedure TSettingsForm.DecCtrClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Clev.Tag<10) then Clev.Tag:=Clev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Clev.Tag>0) then Clev.Tag:=Clev.Tag-1;
  Clev.Text:=Clev.Tag.ToString;
  GD.SetCt(Clev.Tag);
end;

procedure TSettingsForm.IncVolClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Vlev.Tag<10) then Vlev.Tag:=Vlev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Vlev.Tag>0) then Vlev.Tag:=Vlev.Tag-1;
  Vlev.Text:=Vlev.Tag.ToString;
  SM.SetVol(Vlev.Tag);
  SM.Play;
end;

procedure TSettingsForm.onCreateGForm;
begin
  SM.LoadSound(eSound.sWrong);

  Vlev.Tag:=SM.GetVol;
  Vlev.Text:=Vlev.Tag.ToString;

  Blev.Tag:=GD.GetBr;
  Blev.Text:=Blev.Tag.ToString;

  Clev.Tag:=GD.GetCt;
  Clev.Text:=Clev.Tag.ToString;
end;

end.

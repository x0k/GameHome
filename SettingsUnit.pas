unit SettingsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, DataUnit;

type
  TSettingsForm = class(TForm)
    GridPanelLayout1: TGridPanelLayout;
    Volume: TText;
    Brithness: TText;
    DecVol: TButton;
    VLev: TLabel;
    IncVol: TButton;
    DecBr: TButton;
    IncBr: TButton;
    BLev: TLabel;
    Panel1: TPanel;
    Button1: TButton;
    Layout1: TLayout;
    Desc: TText;
    Log: TImage;
    DecCtr: TButton;
    IncCtr: TButton;
    CLev: TLabel;
    Contrast: TText;
    BG: TImage;
    SetStyle: TButton;
    procedure IncVolClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DecBrClick(Sender: TObject);
    procedure DecCtrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  SettingsForm: TSettingsForm;

implementation

{$R *.fmx}

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  Eff.Parent:=nil;
  SettingsForm.Release;
end;

procedure TSettingsForm.DecBrClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Blev.Tag<20) then Blev.Tag:=Blev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Blev.Tag>0) then Blev.Tag:=Blev.Tag-1;
  Blev.Text:=Blev.Tag.ToString;
  Eff.Brightness:=Blev.Tag/50;
end;

procedure TSettingsForm.DecCtrClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Clev.Tag<20) then Clev.Tag:=Clev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Clev.Tag>0) then Clev.Tag:=Clev.Tag-1;
  Clev.Text:=Clev.Tag.ToString;
  Eff.Contrast:=Clev.Tag/10;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  DataForm.Load(0);
  Eff.Parent:=BG;
  SetStyle.OnClick:=DataForm.SelSt;

  Vlev.Tag:=round(vol*10);
  Vlev.Text:=Vlev.Tag.ToString;

  Blev.Tag:=round(Eff.Brightness*50);
  Blev.Text:=Blev.Tag.ToString;

  Clev.Tag:=round(Eff.Contrast*10);
  Clev.Text:=Clev.Tag.ToString;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  DataForm.LoadScaleImg(0,1,BG);
end;

procedure TSettingsForm.IncVolClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Vlev.Tag<10) then Vlev.Tag:=Vlev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Vlev.Tag>0) then Vlev.Tag:=Vlev.Tag-1;
  Vlev.Text:=Vlev.Tag.ToString;
  DataForm.SetVol(Vlev.Tag/10);
  DataForm.Play;
end;

end.

unit SettingsUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, DataUnit, BarUnit;

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
    DecCtr: TButton;
    IncCtr: TButton;
    CLev: TLabel;
    Contrast: TText;
    BG: TImage;
    main: TLayout;
    Bar: TBar;
    procedure IncVolClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DecBrClick(Sender: TObject);
    procedure DecCtrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  nLogo = 'Setts';
var
  SettingsForm: TSettingsForm;

implementation

{$R *.fmx}

procedure TSettingsForm.BarBackBtnClick(Sender: TObject);
begin
  //Eff.Parent:=nil;
  SettingsForm.Close;
  SettingsForm.Destroy;
end;

procedure TSettingsForm.DecBrClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Blev.Tag<10) then Blev.Tag:=Blev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Blev.Tag>0) then Blev.Tag:=Blev.Tag-1;
  Blev.Text:=Blev.Tag.ToString;
  TGForm.GD.Br:=Blev.Tag;
  TGForm.GD.UpdateGamma//if not  then
    //Raise Exception.create('ќшибка при изменении €ркости.');
end;

procedure TSettingsForm.DecCtrClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Clev.Tag<10) then Clev.Tag:=Clev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Clev.Tag>0) then Clev.Tag:=Clev.Tag-1;
  Clev.Text:=Clev.Tag.ToString;
  TGForm.GD.Ct:=Clev.Tag;
  TGForm.GD.UpdateGamma;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  TGForm.SM.LoadSound(0);

  Vlev.Tag:=round(TGForm.SM.Volume*50);
  Vlev.Text:=Vlev.Tag.ToString;

  Blev.Tag:=TGForm.GD.Br;
  Blev.Text:=Blev.Tag.ToString;

  Clev.Tag:=TGForm.GD.Ct;
  Clev.Text:=Clev.Tag.ToString;

  Bar.Load(nLogo,self.Name);
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  TGForm.IM.SetImage(IBG,TImg.Create('Wall',BG),true);
end;

procedure TSettingsForm.IncVolClick(Sender: TObject);
begin
  if ((sender as Tbutton).Tag=1)and(Vlev.Tag<10) then Vlev.Tag:=Vlev.Tag+1 else
  if ((sender as Tbutton).Tag=0)and(Vlev.Tag>0) then Vlev.Tag:=Vlev.Tag-1;
  Vlev.Text:=Vlev.Tag.ToString;
  TGForm.SM.SetVol(Vlev.Tag/50);
  TGForm.SM.Play;
end;

end.

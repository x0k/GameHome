unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.Effects, FMX.Filter.Effects;

type
  TMainForm = class(TForm)
    BGameBtn: TButton;
    SettsBtn: TButton;
    ExitBtn: TButton;
    Panel1: TPanel;
    GridPanelLayout1: TGridPanelLayout;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    Text5: TText;
    MuseumBtn: TButton;
    AboutBtn: TButton;
    Text6: TText;
    Logo: TImage;
    BG: TImage;
    procedure ExitBtnClick(Sender: TObject);
    procedure SettsBtnClick(Sender: TObject);
    procedure MuseumBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure BGameBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses SettingsUnit, MuseumUnit, AboutUnit, GameUnit, DataUnit;

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  AboutForm:=TAboutForm.Create(MainForm);
  AboutForm.Show;
end;

procedure TMainForm.BGameBtnClick(Sender: TObject);
begin
  if GameForm=nil then GameForm:=TGameForm.Create(MainForm);
  GameForm.Show;
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
   mainform.Release;
   mainform.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if DataForm.LoadText then
  begin
    showmessage('Error: Тексты не найдены.');
  end;
  if DataForm.Lbass then ShowMessage('Error: Ошибка инициализации BASS.');
  DataForm.LoadImg(2,0,Logo);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  DataForm.LoadScaleImg(0,0,BG);
end;

procedure TMainForm.MuseumBtnClick(Sender: TObject);
begin
  MuseumForm:=TMuseumForm.Create(MainForm);
  MuseumForm.Show;
end;

procedure TMainForm.SettsBtnClick(Sender: TObject);
begin
  SettingsForm:=TSettingsForm.Create(Application);
  SettingsForm.Show;
end;

end.

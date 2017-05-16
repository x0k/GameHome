unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.ImgList, FMX.ListBox,
  Forms;

type
  TMainForm = class(TBarForm)
    BGameBtn: TButton;
    SettsBtn: TButton;
    ExitBtn: TButton;
    Bar: TPanel;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    Text5: TText;
    MuseumBtn: TButton;
    AboutBtn: TButton;
    barText: TText;
    BG: TGlyph;
    Logo: TGlyph;
    centerLayout: TLayout;
    Main: TLayout;
    beginLayout: TLayout;
    MenuLayout: TScaledLayout;
    exitLayout: TLayout;
    aboutLayout: TLayout;
    museumLayout: TLayout;
    settingsLayout: TLayout;
    procedure BGameBtnClick(Sender: TObject);
  protected
    procedure onCreate; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  FMX.Dialogs,
  GameUnit, ImageManager, SettingsUnit, MuseumUnit, AboutUnit, TextManager, ResourcesManager, SoundManager;

procedure TMainForm.onCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
  GameForm:=TGameForm.Create(self);
  SettingsForm:=TSettingsForm.Create(self);
  AboutForm:=TAboutForm.Create(self);
  MuseumForm:=TMuseumForm.Create(self);
end;

procedure TMainForm.BGameBtnClick(Sender: TObject);
begin
  SM.play(sClick);
  case TFmxObject(sender).Tag of
    0:GameForm.Show;
    1:SettingsForm.Show;
    2:MuseumForm.Show;
    3:AboutForm.Show;
    4:close;
  end;
end;

end.

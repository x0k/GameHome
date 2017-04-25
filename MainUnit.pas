unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.ImgList, FGX.ApplicationEvents;

type
  TMainForm = class(TForm)
    BGameBtn: TButton;
    SettsBtn: TButton;
    ExitBtn: TButton;
    Panel1: TPanel;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    Text5: TText;
    MuseumBtn: TButton;
    AboutBtn: TButton;
    Text6: TText;
    BG: TGlyph;
    Logo: TGlyph;
    centerLayout: TLayout;
    main: TLayout;
    beginLayout: TLayout;
    MenuLayout: TScaledLayout;
    exitLayout: TLayout;
    aboutLayout: TLayout;
    museumLayout: TLayout;
    settingsLayout: TLayout;
    procedure ExitBtnClick(Sender: TObject);
    procedure SettsBtnClick(Sender: TObject);
    procedure MuseumBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure BGameBtnClick(Sender: TObject);
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

uses
  FMX.Dialogs,
  DataUnit, SettingsUnit, MuseumUnit, AboutUnit, Forms, GameForms, TextManager, ResourcesManager;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: byte;
  t: TFormText;
  m: TArray<TText>;
begin
  IM.setSize(BG, Screen.Size);

  m:=[text1, text2, text3, text4, text5];
  t:=TM.Forms[name];
  text6.Text:=t.Names[0];
  for i:=0 to 4 do
    m[i].Text:=t.Items[i];
  SettingsForm:=TSettingsForm.Create(self);
  AboutForm:=TAboutForm.Create(self);
  if not dbgMode then
    MuseumForm:=TMuseumForm.Create(self, rMuseum);
end;


procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TMainForm.BGameBtnClick(Sender: TObject);
begin
  Bar.setDots(15);
  showForm(0);
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TMainForm.MuseumBtnClick(Sender: TObject);
begin
  if dbgMode then
  begin
    IM.add(rMuseum);
    if not Assigned(MuseumForm) then MuseumForm:=TMuseumForm.Create(self, rMuseum);
  end;
  Bar.setDots(15);
  MuseumForm.Show;
end;

procedure TMainForm.SettsBtnClick(Sender: TObject);
begin
  SettingsForm.Show;
end;

end.

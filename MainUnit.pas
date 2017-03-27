unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.ImgList, FMX.Ani;

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
    BG: TGlyph;
    Glyph1: TGlyph;
    centerLayout: TLayout;
    main: TLayout;
    procedure ExitBtnClick(Sender: TObject);
    procedure SettsBtnClick(Sender: TObject);
    procedure MuseumBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure BGameBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  SettingsUnit, MuseumUnit, AboutUnit, Forms, TextManager;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SettingsForm:=TSettingsForm.Create(self);
  AboutForm:=TAboutForm.Create(self);
  IM.setSize(BG, Screen.Size);
  main.Opacity:=0;
end;

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TMainForm.BGameBtnClick(Sender: TObject);
begin
  TGForm.showForm(0);
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TMainForm.MuseumBtnClick(Sender: TObject);
begin
  if not Assigned(MuseumForm) then MuseumForm:=TMuseumForm.Create(self);
  MuseumForm.Show;
end;

procedure TMainForm.SettsBtnClick(Sender: TObject);
begin
  SettingsForm.Show;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  m:TArray<TText>;
  t:TFormText;
  i: byte;
begin
  t:=TM.Forms[name];
  m:=[text1, text2, text3, text4, text5];
  text6.Text:=t.Names[0];
  for i:=0 to 4 do
    m[i].Text:=t.Items[i];
  TAnimator.AnimateFloatDelay(main, 'opacity', 1, 1, 1);
end;

end.

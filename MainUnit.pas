unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, GameUnit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.Layouts, FMX.Effects, FMX.Filter.Effects, System.ImageList, FMX.ImgList;

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

uses SettingsUnit, MuseumUnit, AboutUnit, DataUnit;

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  TM.Load(tOther);
  AboutForm.Show;
end;

procedure TMainForm.BGameBtnClick(Sender: TObject);
begin
  TM.Load(tLevels);
  DataForm.ShowForm(0);
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
   mainform.Release;
   mainform.Close;
end;

procedure TMainForm.MuseumBtnClick(Sender: TObject);
begin
  TM.Load(tMuseum);
  MuseumForm.Show;
end;

procedure TMainForm.SettsBtnClick(Sender: TObject);
begin
  TM.Load(tOther);
  SettingsForm.Show;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SettingsForm:=TSettingsForm.Create(self);
  MuseumForm:=TMuseumForm.Create(self);
  AboutForm:=TAboutForm.Create(self);
end;

end.

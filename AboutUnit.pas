unit AboutUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, FMX.ScrollBox, FMX.Memo, FMX.Filter.Effects,
  FMX.ImgList,
  Forms;

type
  TAboutForm = class(TBarForm)
    Text: TMemo;
    BG: TGlyph;
    Main: TLayout;
    logoLayout: TLayout;
    Logo: TGlyph;
    SPanel: TPanel;
    sgy: TGlyph;
    vtb: TGlyph;
    hmpk: TGlyph;
    procedure BackBtnClick(Sender: TObject);
  protected
    procedure onCreate; override;
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.fmx}

uses
  ImageManager, SoundManager;

procedure TAboutForm.BackBtnClick(Sender: TObject);
begin
  SM.play(sClick);
  Close;
end;

procedure TAboutForm.onCreate;
begin
  backgrounds:=[BG];
  layouts:=[main];
end;

end.

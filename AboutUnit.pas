unit AboutUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, FMX.ScrollBox, FMX.Memo,FMX.Filter.Effects;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Layout1: TLayout;
    Desc: TText;
    Log: TImage;
    Logo: TImage;
    Memo: TMemo;
    BG: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.fmx}

procedure TAboutForm.Button1Click(Sender: TObject);
begin
  AboutForm.Release;
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  Memo.Lines.LoadFromFile('Text.txt',TEncoding.UTF8);
  DataForm.LoadScaleImg(0,1,BG);
  DataForm.LoadImg(2,0,Logo);
end;

end.

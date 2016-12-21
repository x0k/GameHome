unit AboutUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, FMX.ScrollBox, FMX.Memo,FMX.Filter.Effects, BarUnit;

type
  TAboutForm = class(TForm)
    Logo: TImage;
    Text: TMemo;
    BG: TImage;
    main: TLayout;
    Bar: TBar;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BarBackBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  nLogo = 'About';
var
  AboutForm: TAboutForm;

implementation

{$R *.fmx}

uses DataUnit;

procedure TAboutForm.BarBackBtnClick(Sender: TObject);
begin
  AboutForm.Release;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Bar.Load(nLogo,self.Name);
  //Text.Lines.Assign(FD.SubTexts[1]);
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  TGForm.IM.SetImage(IBG,TImg.Create('Wall',BG),true);
  TGForm.IM.SetImage(IICO,TImg.Create('Logo',logo),false);
end;

end.

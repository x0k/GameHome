unit AboutUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.ListBox, FMX.ScrollBox, FMX.Memo, FMX.Filter.Effects, BarUnit,
  FMX.ImgList;

type
  TAboutForm = class(TBarForm)
    Text: TMemo;
    BG: TGlyph;
  protected
    procedure onFormShow; override;
    procedure onFormClose; override;
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.fmx}


procedure TAboutForm.onFormShow;
begin
  Bar.Logo.Visible:=false;
  SetDescription(1, Text);
end;

procedure TAboutForm.onFormClose;
begin
  lDesc:=0;
  Bar.Logo.Visible:=true;
end;

end.

unit MuseumUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, DataUnit,
  FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation,
  BarUnit, FMX.ImgList, FMX.Layouts, FMX.ani,
  Forms;

type
  TMuseumForm = class(TMForm)
    main: TLayout;
    controls: TLayout;
    lBack: TLayout;
    lNext: TLayout;
  protected
    procedure onFormCreate; override;
  end;

var
  MuseumForm: TMuseumForm;

implementation

{$R *.fmx}

procedure TMuseumForm.onFormCreate;
var
  g:TGlyph;
begin
  for g in imgs do
    main.AddObject(g);
  lBack.OnClick:=back;
  lNext.OnClick:=next;
end;

end.

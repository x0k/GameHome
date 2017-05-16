unit uLoading;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ImgList,
  FMX.Objects, FMX.Layouts, FMX.Effects;

type
  TLoadingForm = class(TForm)
    logo: TGlyph;
    prog: TRectangle;
    Layout2: TLayout;
    procedure FormShow(Sender: TObject);
  public
    procedure setCount(c: byte; const t: string = '');
    procedure up(const t: string);
  end;

implementation

{$R *.fmx}

uses
  FMX.Ani, DataUnit;

var
  p: single;

{ TLoadingForm }

procedure TLoadingForm.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
end;

procedure TLoadingForm.setCount(c: byte; const t: string);
begin
  p:=(layout2.Width-10)/c;
  Application.ProcessMessages;
end;

procedure TLoadingForm.up(const t: string);
begin
  prog.Width:=prog.Width+p;
  Application.ProcessMessages;
end;

end.

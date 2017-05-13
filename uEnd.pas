unit uEnd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ImgList,
  uFrame;

type
  TEndFrame = class(TGFrame)
    BG: TGlyph;
  protected
    procedure onFCreate; override;
  end;

implementation

{$R *.fmx}

{ TEndFrame }

procedure TEndFrame.onFCreate;
begin
  backgrounds:=[BG];
end;

end.

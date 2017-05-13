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
  public
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

uses
  GameUnit;

{ TEndFrame }

procedure TEndFrame.onFCreate;
begin
  backgrounds:=[BG];
end;

procedure TEndFrame.onFShow;
begin
  (Owner as TGameForm).states[level]:=2;
  inherited;
end;

end.

unit uEnd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ImgList, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  uFrame;

type
  TEndFrame = class(TGFrame)
    BG: TGlyph;
    Text: TMemo;
  protected
    procedure onFCreate; override;
  public
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

uses
  GameUnit, dataUnit;

{ TEndFrame }

procedure TEndFrame.onFCreate;
begin
  backgrounds:=[BG];
  layouts:=[text];
end;

procedure TEndFrame.onFShow;
begin
  (Owner as TGameForm).states[level]:=2;
  inherited;
end;

end.

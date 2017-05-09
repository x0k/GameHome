unit uTabFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  GameUnit, uFrame, FMX.TabControl;

type
  TTabFrame = class(TGFrame)
    gTabs: TTabControl;
  protected
    gTab: byte;

  public
    procedure next; override;
  end;

var
  TabFrame: TTabFrame;

implementation

{$R *.fmx}

{ TTabFrame }

procedure TTabFrame.next;
begin
  clBlock:=true;
  if gTabs.TabIndex=gTabs.TabCount-1 then
  begin
    if (Owner as TGameForm).states[level]<2 then exit;
      if level<LVL_COUNT-1 then (Owner as TGameForm).setNext(level+1)
        else (Owner as TGameForm).gameExit;
  end
  else if (gTabs.TabIndex<>gTab) or ((Owner as TGameForm).states[level]>1) then
  begin
    gTabs.Next();
    clBlock:=false;
  end;
end;

end.

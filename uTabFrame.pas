unit uTabFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  GameUnit, uFrame, FMX.TabControl, DataUnit;

type
  TTabFrame = class(TGFrame)
    gTabs: TTabControl;
  protected
    gTab: byte;

    procedure setBarText; override;

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
    inherited
  else if (gTabs.TabIndex<>gTab) or ((Owner as TGameForm).states[level]>1) then
  begin
    gTabs.Next();
    setBarText;
    clBlock:=false;
  end;
end;

procedure TTabFrame.setBarText;
begin
  (Owner as TGameForm).Caption:=fText.Names[gTabs.TabIndex];
  (Owner as TGameForm).Logo:=fText.Logos[gTabs.TabIndex];
  (Owner as TGameForm).Text:=fText.TabTexts[gTabs.TabIndex];
  (Owner as TGameForm).nxtBtn:=((Owner as TGameForm).states[level]=2) or (gTabs.TabIndex<>gTab);
end;

end.

program Launcher;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  uRegFont in 'uRegFont.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

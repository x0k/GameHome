program GHome;





uses
  System.StartUpCopy,
  FMX.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  SettingsUnit in 'SettingsUnit.pas' {SettingsForm},
  DataUnit in 'DataUnit.pas' {DataForm: TDataModule},
  MuseumUnit in 'MuseumUnit.pas' {MuseumForm},
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  GameUnit in 'GameUnit.pas' {GameForm},
  SeazonUnit in 'SeazonUnit.pas' {SeazonForm},
  BarUnit in 'BarUnit.pas' {Bar: TFrame},
  PlaceUnit in 'PlaceUnit.pas' {PlaceForm},
  ToolsUnit in 'ToolsUnit.pas' {ToolsForm},
  MaterialsUnit in 'MaterialsUnit.pas' {MaterialsForm},
  TaskUnit in 'TaskUnit.pas' {TaskForm},
  FoundationUnit in 'FoundationUnit.pas' {FoundationForm},
  MapUnit in 'MapUnit.pas' {MapForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDataForm, DataForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

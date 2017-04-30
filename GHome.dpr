program GHome;

uses
  System.SysUtils,
  FMX.Forms,
  FMX.Dialogs,
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
  MapUnit in 'MapUnit.pas' {MapForm},
  OmenUnit in 'OmenUnit.pas' {OmenForm},
  WarmingUnit in 'WarmingUnit.pas' {WarmingForm},
  Forms in 'Forms.pas',
  TextManager in 'TextManager.pas',
  ResourcesManager in 'ResourcesManager.pas',
  ImageManager in 'ImageManager.pas',
  GameData in 'GameData.pas',
  SoundManager in 'SoundManager.pas',
  FullScreenTabs in 'FullScreenTabs.pas',
  GameForms in 'GameForms.pas',
  DesignManager in 'DesignManager.pas',
  MatrixUnit in 'MatrixUnit.pas' {MatrixForm},
  WindowsUnit in 'WindowsUnit.pas' {WindowsForm},
  RoofUnit in 'RoofUnit.pas' {RoofForm},
  RidgeUnit in 'RidgeUnit.pas' {RidgeForm},
  MovingUnit in 'MovingUnit.pas' {MovingForm},
  EndUnit in 'EndUnit.pas' {EndForm},
  winMessages in 'winMessages.pas';

{$R *.res}

begin
  if FindCmdLineSwitch('debug') then
    ReportMemoryLeaksOnShutdown:=True;

  Application.Initialize;
  Application.CreateForm(TDataForm, DataForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.RegisterFormFamily('MainForm', [TMainForm]);
  Application.Run;
end.

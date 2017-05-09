program GHome;

uses
  System.SysUtils,
  System.IOUtils,
  FMX.Forms,
  Windows,
  MainUnit in 'MainUnit.pas' {MainForm},
  SettingsUnit in 'SettingsUnit.pas' {SettingsForm},
  DataUnit in 'DataUnit.pas' {DataForm: TDataModule},
  MuseumUnit in 'MuseumUnit.pas' {MuseumForm},
  AboutUnit in 'AboutUnit.pas' {AboutForm},
  GameUnit in 'GameUnit.pas' {GameForm},
  Forms in 'Forms.pas',
  TextManager in 'TextManager.pas',
  ResourcesManager in 'ResourcesManager.pas',
  ImageManager in 'ImageManager.pas',
  GameData in 'GameData.pas',
  SoundManager in 'SoundManager.pas',
  FullScreenTabs in 'FullScreenTabs.pas',
  DesignManager in 'DesignManager.pas',
  winMessages in 'winMessages.pas',
  uSeazon in 'uSeazon.pas' {SeazonFrame: TFrame},
  uPlace in 'uPlace.pas' {PlaceFrame: TFrame},
  uTools in 'uTools.pas' {ToolsFrame: TFrame},
  uMaterials in 'uMaterials.pas' {MaterialsFrame: TFrame},
  uTask in 'uTask.pas' {TaskFrame: TFrame},
  uFoundation in 'uFoundation.pas' {FoundationFrame: TFrame},
  uMap in 'uMap.pas' {MapFrame: TFrame},
  uOmen in 'uOmen.pas' {OmenFrame: TFrame},
  uWarming in 'uWarming.pas' {WarmingFrame: TFrame},
  uMatrix in 'uMatrix.pas' {MatrixFrame: TFrame},
  uWindows in 'uWindows.pas' {WindowsFrame: TFrame},
  uRoof in 'uRoof.pas' {RoofFrame: TFrame},
  uRidge in 'uRidge.pas' {RidgeFrame: TFrame},
  uMoving in 'uMoving.pas' {MovingFrame: TFrame},
  uEnd in 'uEnd.pas' {EndFrame: TFrame},
  uFrame in 'uFrame.pas' {GFrame: TFrame},
  uTabFrame in 'uTabFrame.pas' {TabFrame: TFrame};

{$R *.res}
const
  fName = 'TkachenkoSketch4F.ttf';

begin
  AddFontResourceEx(PChar(TPath.Combine(getPath(pTexts),  fName)), FR_NOT_ENUM, nil);
  Application.Initialize;
  Application.CreateForm(TDataForm, DataForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

unit ResourcesManager;

interface

uses
  FMX.ImgList;

type
  ePath = (pTexts, pSounds, pResource);

  eResource = (rStyle, rImages, rSequences, rSwitchers, rOther, rMuseum, rProgress);

  eTexts = (tLevels, tMuseum, tOther, tForms, tFrames);

  function getPath(p:ePath):string;

  function findTexts(t:eTexts):boolean;
  function getTexts(t:eTexts):string;

  function pathResource(r:eResource):string;

  function getSounds: TArray<string>;

  function getImgList(r:eResource):TImageList;

implementation

uses
  FMX.Dialogs,
  System.IOUtils, System.SysUtils, System.Types,
  DataUnit;

var
  exePath: string;

function getPath(p:ePath):string;
begin
  case p of
    pTexts: result:=TPath.Combine(exePath,'t');
    pSounds: result:=TPath.Combine(exePath,'s');
    pResource: result:=TPath.Combine(exePath,'i');
  end;
end;

function pathTexts(t:eTexts):string;
begin
  case t of
    tLevels: result:=TPath.Combine(getPath(pTexts),'levels.json');
    tMuseum: result:=TPath.Combine(getPath(pTexts),'museum.json');
    tOther: result:=TPath.Combine(getPath(pTexts),'other.json');
    tForms: result:=TPath.Combine(getPath(pTexts),'forms.json');
    tFrames: result:=TPath.Combine(getPath(pTexts),'frames.json');
  end;
end;

function findTexts(t:eTexts):boolean;
begin
  result:=TFile.Exists(pathTexts(t));
  if not result then
    raise Exception.Create('Не найден текст : '+sLineBreak+pathTexts(t));
end;

function getTexts(t:eTexts):string;
begin
  result:='';
  try
    if findTexts(t) then
      result:=TFile.ReadAllText(pathTexts(t), TEncoding.UTF8);
  except
    on E: exception do
      showMessage(E.Message);
  end;
end;

function pathResource(r:eResource):string;
begin
  case r of
    rStyle: result:=TPath.Combine(getPath(pResource), 'Style.style');
    rImages: result:=TPath.Combine(getPath(pResource), 'Images.style');
    rSequences: result:=TPath.Combine(getPath(pResource), 'Sequences.style');
    rSwitchers: result:=TPath.Combine(getPath(pResource), 'Switchers.style');
    rOther: result:=TPath.Combine(getPath(pResource), 'Other.style');
    rMuseum: result:=TPath.Combine(getPath(pResource), 'Museum.style');
  end;
end;

function getSounds: TArray<string>;
begin
  result:=TArray<string>(TDirectory.GetFiles(getPath(pSounds)));
end;

function getImgList(r: eResource):TImageList;
begin
  result:=nil;
  case r of
    rImages: result:=DataForm.Images;
    rSequences: result:=DataForm.Sequence;
    rSwitchers: result:=DataForm.Switchers;
    rOther: result:=DataForm.Other;
    rMuseum: result:=DataForm.Museum;
    rProgress: result:=DataForm.progress;
  end;
end;

initialization
  exePath:=TPath.GetLibraryPath;

end.

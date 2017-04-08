unit ResourcesManager;

interface

uses
  FMX.ImgList;

type
  ePath = (pTexts, pSounds, pResource);

  eResource = (rImages, rSequences, rOther, rMuseum);

  eSound = (sMain, sBackground, sClick, sAward, sWrong);

  eTexts = (tLevels, tMuseum, tOther, tLayouts);

  function getPath(p:ePath):string;

  function findTexts(t:eTexts):boolean;
  function getTexts(t:eTexts):string;

  function pathResource(r:eResource):string;

  function getSound(s:eSound):string;

  function getImgList(r:eResource):TImageList;

implementation

uses System.IOUtils, System.SysUtils, DataUnit;

function getPath(p:ePath):string;
begin
  case p of
    pTexts: result:=TPath.Combine(TPath.GetLibraryPath,'t');
    pSounds: result:=TPath.Combine(TPath.GetLibraryPath,'s');
    pResource: result:=TPath.Combine(TPath.GetLibraryPath,'i');
  end;
end;

function pathTexts(t:eTexts):string;
begin
  case t of
    tLevels: result:=TPath.Combine(getPath(pTexts),'levels.json');
    tMuseum: result:=TPath.Combine(getPath(pTexts),'museum.json');
    tOther: result:=TPath.Combine(getPath(pTexts),'other.json');
    tLayouts: result:=TPath.Combine(getPath(pTexts),'layouts.json');
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
  if findTexts(t) then
    result:=TFile.ReadAllText(pathTexts(t), TEncoding.UTF8);
end;

function pathResource(r:eResource):string;
begin
  case r of
    rImages: result:=TPath.Combine(getPath(pResource),'Images.style');
    rSequences: result:=TPath.Combine(getPath(pResource),'Sequences.style');
    rOther: result:=TPath.Combine(getPath(pResource),'Other.style');
    rMuseum: result:=TPath.Combine(getPath(pResource),'Museum.style');
  end;
end;

function getSound(s:eSound):string;
  function gWrong:string;
  begin
    result:='wrong'+random(1).toString+'.wav';
  end;
  function gAward:string;
  begin
    result:='award'+random(1).toString+'.wav';
  end;
begin
  case s of
    sMain: result:=TPath.Combine(getPath(pSounds),'s.wav');
    sBackground: result:=TPath.Combine(getPath(pSounds),'bgtheme.mp3');
    sClick: result:=TPath.Combine(getPath(pSounds),'Click.wav');
    sAward: result:=TPath.Combine(getPath(pSounds),gAward);
    sWrong: result:=TPath.Combine(getPath(pSounds),gWrong);
  end;
end;

function getImgList(r: eResource):TImageList;
begin
  result:=nil;
  case r of
    rImages: result:=DataForm.Images;
    rSequences: result:=DataForm.Sequence;
    rOther: result:=DataForm.Other;
    rMuseum: result:=DataForm.Museum;
  end;
end;

end.

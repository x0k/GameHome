unit SoundManager;

interface

uses
  System.Generics.Collections,
  Bass;

type
  eSound = (sBackground, sClick, sAward, sWrong);

  TSoundManager = class
  private
    bgs, cls, aws, wrs: TList<HSTREAM>;
    lts: TArray<TList<HSTREAM>>;
    mst, bgst: HSTREAM;
    bgSync: HSYNC;
    fail: boolean;
    Vol:single;
    procedure setVol(v:single); overload;
    procedure setVol(v:byte); overload;

    function getSound(s: eSound): HSTREAM;
    function getVol:byte;

    procedure playBG;
  public
    procedure play(s:eSound);
    property volume:byte read getVol write setVol;

    constructor Create;
    destructor Destroy; override;
  end;

var
  SM: TSoundManager;

implementation

uses
  System.SysUtils, FMX.Dialogs,
  DataUnit, ResourcesManager;

  {TSoundManager}

constructor TSoundManager.Create;
var
  files: TArray<string>;
  s: string;
  i: byte;
begin
  fail:=true;
  try
    if not BASS_Init(-1, 44100, 0, 0, nil) then
      Raise Exception.create('Ошибка при загрузке BASS');
    files:=getSounds;
    lts:=[bgs, cls, aws, wrs];
    for i:=0 to 3 do
      lts[i]:=TList<HSTREAM>.Create;
    for s in files do
    begin
      if s.Contains('background') then i:=0
      else if s.Contains('click') then i:=1
      else if s.Contains('award') then i:=2
      else if s.Contains('wrong') then i:=3
      else continue;
      lts[i].Add(BASS_StreamCreateFile(false, pChar(s), 0, 0, BASS_UNICODE));
    end;
    SetVol(0.1);
    fail:=false;
    playBG;
  except
    on E: Exception do
    begin
      showMessage(E.Message);
      fail:=true;
    end;
  end;
end;

destructor TSoundManager.Destroy;
var
  l: TList<HSTREAM>;
  st: HSTREAM;
begin
  for l in lts do
  begin
    for st in l do
      BASS_StreamFree(st);
    l.Free;
  end;
  BASS_Free;
  inherited;
end;

function TSoundManager.getSound(s: eSound): HSTREAM;
begin
  result:=lts[ord(s)][random(lts[ord(s)].Count)];
end;

procedure TSoundManager.Play;
begin
  if fail then exit;
  if mst<>0 then BASS_ChannelStop(mst);
  mst:=getSound(s);
  Bass_ChannelSetAttribute(mst, BASS_ATTRIB_VOL, Vol);
  Bass_ChannelPlay(mst, true);
end;

procedure bgEndSync(handle: HSYNC; Stream, data: DWORD; user: Pointer); stdcall;
begin
  BASS_ChannelRemoveSync(Stream, Handle);
  SM.PlayBg;
end;

procedure TSoundManager.PlayBg;
begin
  if fail then exit;
  bgst:=getSound(sBackground);
  Bass_ChannelSetAttribute(bgst, BASS_ATTRIB_VOL, Vol/3);
  Bass_ChannelPlay(bgst, true);
  bgSync:=BASS_ChannelSetSync(bgst, BASS_SYNC_END, 0, @bgEndSync, nil);
end;

procedure TSoundManager.SetVol(v:single);
begin
  Vol:=v;
  Bass_ChannelSetAttribute(mst, BASS_ATTRIB_VOL, Vol);
  Bass_ChannelSetAttribute(bgst, BASS_ATTRIB_VOL, Vol/3);
end;

procedure TSoundManager.SetVol(v:byte);
begin
  setVol(v/50);
end;

function TSoundManager.GetVol: byte;
begin
  result:=round(Vol*50);
end;

end.

unit SoundManager;

interface

uses
  ResourcesManager, Bass;

type
  //Управление звуком
  TSoundManager = class
  private
    fail: boolean;
    Vol:single;
    last:eSound;
    mainStream,backgroundStream: HSTREAM;
    procedure setVol(v:single); overload;
    procedure setVol(v:byte); overload;
    procedure loadSound(s:eSound);
    function getVol:byte;
  public
    procedure play(s:eSound);
    property volume:byte read getVol write setVol;

    constructor Create;
  end;

var
  SM: TSoundManager;

implementation

uses
  System.SysUtils, FMX.Dialogs,
  DataUnit;

  {TSoundManager}

//Конструктор
constructor TSoundManager.Create;
begin
  fail:=true;
  try
    if not BASS_Init(-1, 44100, 0, 0, nil) then
      Raise Exception.create('Ошибка при загрузке BASS');
    BackgroundStream:=BASS_StreamCreateFile(false,pchar(getSound(sBackground)),0,0,BASS_UNICODE);
    BASS_ChannelFlags(BackgroundStream, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
    SetVol(0.1);
    //BASS_ChannelPlay(BackgroundStream, true);
    fail:=false;
  except
    on E: Exception do
    begin
      showMessage(E.Message);
      fail:=true;
    end;
  end;
end;

//Установить уровень звука
procedure TSoundManager.SetVol(v:single);
begin
  Vol:=v;
  if fail then exit;
  Bass_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, Vol);
  Bass_ChannelSetAttribute(BackgroundStream, BASS_ATTRIB_VOL, Vol/2);
end;

//Загрузить файл звука в поток
procedure TSoundManager.LoadSound;
begin
  if fail then exit;
  if MainStream <> 0 then Bass_StreamFree(MainStream);
  MainStream:=BASS_StreamCreateFile(false,pchar(getSound(s)),0,0,BASS_UNICODE);
  last:=s;
  SetVol(Vol);
end;

//Проиграть звук из потока
procedure TSoundManager.Play;
begin
  if fail then exit;
  if s<>last then LoadSound(s);
  Bass_ChannelPlay(MainStream,true);
end;

procedure TSoundManager.SetVol(v:byte);
begin
  SetVol(v/50);
end;

function TSoundManager.GetVol;
begin
  result:=round(Vol*50);
end;

end.

unit GameData;

interface

type
  // массив для хранения таблиц гамма-коррекции (gamma ramp)
  TRampArray = array[0..2] of array[byte] of word;

  //Игровая информация
  TGameData = class
  private
    origramparray: TRampArray;//текущие значения gamma ramp
    Br,Ct,Gm:byte;
    dpi, sr: single;
    function UpdateGamma: boolean;

    procedure SetBr(b:byte);
    function GetBr:byte;

    procedure SetCt(b:byte);
    function GetCt:byte;
  public
    procedure LoadSavedRamp;

    property brightnes:byte read getBr write setBr;
    property contrast:byte read getCt write setCt;

    property ppi: single read dpi;
    property sideRatio: single read sr;

    constructor Create;
  end;

var
  GD: TGameData;

implementation

uses
  System.Types, System.Math, windows, FMX.Platform,
  DataUnit;


  {TGameData}

//Конструктор
constructor TGameData.Create;
var
  ScreenService: IFMXScreenService;
  Sz: TPointF;
  dc: hdc;
begin
  dc := getdc(0);
  try
    getdevicegammaramp(dc, origramparray);
    if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, IInterface(ScreenService)) then
    begin
      sz:=ScreenService.GetScreenSize;
      sr:=GetDeviceCaps(DC,HORZSIZE)/GetDeviceCaps(DC,VERTSIZE);
      dpi:=sqrt(sqr(sz.X * ScreenService.GetScreenScale)+sqr(sz.Y * ScreenService.GetScreenScale))/(sqrt(sqr(GetDeviceCaps(DC,VERTSIZE))+sqr(GetDeviceCaps(DC,HORZSIZE)))/25.4);
    end else dpi:=92;
    //Получаем диагональ
  finally
    releasedc(0, dc)
  end;
  Ct:=5;
  Br:=5;
  Gm:=1;
end;

//Загрузить сохраненную гамму
procedure TGameData.LoadSavedRamp;
var
  dc: hdc;
begin
  dc := getdc(0);
  try
    setdevicegammaramp(dc, origramparray)
  finally
    releasedc(0, dc)
  end
end;

//Изменить гамму
function TGameData.UpdateGamma:boolean;
var
  ramparray: tramparray;
  i, value: integer;
  b,g,c,k:single;
  dc: hdc;
begin
  b:=((17+Br)/22-1)*256;
  c:=(17+Ct)/22;
  g:=Gm;
  for i := 0 to maxbyte do
  begin
    k:=i/256;
    k:=power(k, 1/g);
    k:=k*256;
    value:=round(k*c*256+b*256);
    if (value > maxword) then value:=maxword;
    if (value < 0) then value:=0;
    ramparray[0][i] := value;
    ramparray[1][i] := value;
    ramparray[2][i] := value;
  end;
  dc := getdc(0);
  try
    result:=setdevicegammaramp(dc, ramparray)
  finally
    releasedc(0, dc)
  end
end;

procedure TGameData.SetBr;
begin
  Br:=b;
  UpdateGamma;
end;

procedure TGameData.SetCt(b:byte);
begin
  Ct:=b;
  UpdateGamma;
end;

function TGameData.GetBr:byte;
begin
  result:=Br;
end;

function TGameData.GetCt;
begin
  result:=Ct;
end;

end.

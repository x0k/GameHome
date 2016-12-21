unit DataUnit;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Forms,
  System.ImageList, FMX.ImgList, FMX.Objects, FMX.Media,
  FMX.Styles, FMX.Dialogs, FMX.Graphics, FMX.MultiResBitmap,
  system.JSON, system.Generics.Collections, system.Types, BarUnit, Bass;

const
  AWD_COUNT = 17;
  LVL_COUNT = 14;
  IBG = 0;
  IICO = 1;
  ISEQ = 2;
  IOTH = 3;
  Sounds:TArray<string> = ['s0.wav','s1.wav','s2.wav'];
  TextsPath = 't';
  SoundsPath = 's';
  ImagesPath = 'i';

type
  //DataForm
  TDataForm = class(TDataModule)
    Styles:TStyleBook;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  end;

  //Управление изображениями
  TImg = TPair<string,Timage>;

  TImgs = record
    c:byte;
    m:Tarray<Timg>;
    constructor Create(const cat:byte; const names:TArray<string>;const images:TArray<TImage>);
  end;

  TImageManager = class
    Lists:TArray<TImageList>;//Изображения для форм
    function GetImgs(const s:TArray<string>;const m:TArray<TImage>):TArray<TImg>;
    function GetBitmap(const cat:byte; const name:string):TBitmap;
    procedure SetImage(cat:byte; P:TImg; const sc:boolean = false);
    procedure SetImages(Imgs:TImgs; const sc:boolean = true);
    constructor Create(const RName: string;const LNames:TArray<string>);
  end;

  //Управление текстами
  TTextManager = class
    Texts:TJSONObject;//Тексты для форм
    SubNames:TArray<string>;
    SubTexts:TArray<TStrings>;
    function LoadText(name:string):boolean;
    constructor Create(name:string);
  end;

  // массив для хранения таблиц гамма-коррекции (gamma ramp)
  TRampArray = array[0..2] of array[byte] of word;

  //Игровая информация
  TGameData = class
    CurrentForm:Byte;
    Awards:array[1..AWD_COUNT] of boolean;
    origramparray: tramparray;//текущие значения gamma ramp
    Br,Ct,Gm:byte;
    procedure GetAwd(index:byte);
    procedure UpStatus(index:byte);
    procedure LoadSavedRamp;
    function UpdateGamma: boolean;
    constructor Create;
  end;

  //Управление звуком
  TSoundManager = class
    Volume:single;
    MainStream,BackgroundStream:HSTREAM;
    procedure SetVol(v:single);
    procedure LoadSound(i:byte);
    procedure Play;
    constructor Create;
  end;

  //GForm
  TGForm = class(TForm)
    Bar: TBar;
  public class var
    Status:byte;//0 - не открывали, 1 - просматривали, 2 - прошли.
    nLevel:byte;
    nLogo:TArray<string>;
    IM:TImageManager;
    TM:TTextManager;
    SM:TSoundManager;
    GD:TGameData;
    Forms:array[0..LVL_COUNT] of TGForm;
    procedure GShow(Sender: TObject);
    procedure FShow; virtual;abstract;
    constructor Create(Lvl:byte;Logo:TArray<string>;AOwner: TComponent); overload;
  end;

var
  DataForm: TDataForm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses system.IOUtils, system.Math, windows, Messages,
GameUnit, SeazonUnit, PlaceUnit, ToolsUnit, MaterialsUnit, TaskUnit, FoundationUnit, MapUnit;

  {TGameData}

//Конструктор
constructor TGameData.Create;
var
  dc: hdc;
begin
  dc := getdc(0);
  try
    getdevicegammaramp(dc, origramparray)
  finally
    releasedc(0, dc)
  end;
  Ct:=5;
  Br:=5;
  Gm:=1;
end;

//Дать награду
procedure TGameData.GetAwd(index: Byte);
begin
  Awards[index]:=true;
end;

//Обновить статус в "прогрессбаре"
procedure TGameData.UpStatus(index: Byte);
begin
  //StatusLevels[index]:=StatusLevels[index]+1;
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

  {TSoundManager}

//Конструктор
constructor TSoundManager.Create;
begin
  try
    if not BASS_Init(-1, 44100, 0, 0, nil) then Raise Exception.create('Ошибка при загрузке шрифтов');
  finally
    Volume:=0.1;
  end;
end;

//Установить уровень звука
procedure TSoundManager.SetVol;
begin
  Volume:=v;
  Bass_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, Volume);
  Bass_ChannelSetAttribute(BackgroundStream, BASS_ATTRIB_VOL, Volume/2);
end;

//Загрузить файл звука в поток
procedure TSoundManager.LoadSound;
begin
  if MainStream <> 0 then Bass_StreamFree(MainStream);
  MainStream:=BASS_StreamCreateFile(false,pchar(TPath.GetLibraryPath+'\'+SoundsPath+'\'+Sounds[i]),0,0,BASS_UNICODE);
  SetVol(Volume);
end;

//Проиграть звук из потока
procedure TSoundManager.Play;
begin
  Bass_ChannelPlay(MainStream,true);
end;

  {TImageManager}

//Конструктор списка пар (название,изображение) из одной категории
constructor TImgs.Create(const cat: Byte; const names: TArray<System.string>; const images: TArray<FMX.Objects.TImage>);
var
  i,k,l:byte;
begin
  c:=cat;
  l:=length(names);
  k:=length(Images);
  setlength(m,k);
  for i:=0 to k-1 do
    if (l=0)or(names[i]='') then m[i]:=TImg.Create(images[i].Name,images[i])
      else m[i]:=TImg.Create(names[i],images[i]);
end;

//Конструктор (загрузка изображений из .style в массив TImageList'ов)
constructor TImageManager.Create(const RName: string;const LNames:TArray<string>);
var
  Res: TStyleBook;
  Cat: TFmxObject;
  Sor: TCustomSourceItem;
  i,j,c:byte;
  procedure LoadPicture(const Source: TCustomSourceItem; const Scale: Single; const pBitmap: FMX.graphics.TBitmap);
  var
    BitmapItem: TCustomBitmapItem;
  begin
    BitmapItem := Source.MultiResBitmap.ItemByScale(Scale, True, True);
    if BitmapItem = nil then
    begin
      BitmapItem := Source.MultiResBitmap.Add;
      BitmapItem.Scale := Scale;
    end;
    BitmapItem.Bitmap.Assign(pBitmap);
  end;
begin
  try
    Res:=TStyleBook.Create(DataForm);
    Res.LoadFromFile(TPath.GetLibraryPath+'\'+ImagesPath+'\'+RName+'.style');
  finally
    if Assigned(Res) then
    begin
      c:=length(LNames);
      SetLength(Lists,c);
      for i:=0 to c-1 do
      begin
        Lists[i]:=TImageList.Create(DataForm);
        Cat:=Res.Style.FindStyleResource(LNames[i]);
        for j:=0 to Cat.ChildrenCount-1 do
        begin
          Sor:=Lists[i].Source.Add;
          Sor.Name:=Cat.Children.Items[j].StyleName;
          Sor.MultiResBitmap.SizeKind:= TSizeKind.Source;
          LoadPicture(Sor, 1, (Cat.Children.Items[j] as TBitmapObject).Bitmap);
        end;
      end;
    end;
  end;
end;

//???
function TImageManager.GetImgs(const s: TArray<System.string>; const m: TArray<FMX.Objects.TImage>):TArray<Timg>;
var
  i,c:byte;
begin
  c:=length(s);
  setlength(result,c);
  for i:=0 to c-1 do
    result[i]:=TImg.Create(s[i],m[i]);
end;

//Возвращает битмап по категории и имени.
function TImageManager.GetBitmap;
var
  I:TCustomBitmapItem;
  S:TSize;
begin
  if Lists[cat].BitmapItemByName(name,I,S) then result:=I.Bitmap else result:=nil;
end;

//Загружает битмап в изображение с возможностью скейла
procedure TImageManager.SetImage(cat:byte; P:TImg; const sc:boolean = false);
var
  I:TCustomBitmapItem;
  S:TSize;
begin
  if Lists[cat].BitmapItemByName(P.Key,I,S) then
  begin
    if sc then I.Scale:=1/max(P.Value.Width/S.Width,P.Value.Height/S.Height);
    P.Value.Bitmap.Assign(I.Bitmap);
  end;
end;

//Загружает в каждое изображение из списка свой битмап с возможностью скейла
procedure TImageManager.SetImages(Imgs:TImgs; const sc:boolean = true);
var
  i:byte;
begin
  for i:=0 to High(Imgs.m) do
    SetImage(Imgs.c, Imgs.m[i], sc);
end;

  {TTextManager}

//Конструктор загружает данные из файла
constructor TTextManager.Create(name:string);
var
  f:string;
begin
  try
    f:=TPath.GetLibraryPath+'\'+TextsPath+'\'+name;
    if TFile.Exists(f) then
      Texts:=TJSONObject(TJSONObject.ParseJSONValue(TFile.ReadAllText(f,TEncoding.UTF8)))
  finally
    //if Assigned(Texts) then result:=false else result:=true;
  end;
end;

//Загружает данные для конкретной формы
function TTextManager.LoadText(name:string):boolean;
var
  i,j:byte;
  ss:TStringList;
  Form:TJsonObject;
  STexts,Strs,SNames:TJsonArray;
begin
  try
    Form:=TJSONObject(TJSONObject.ParseJSONValue(Texts.GetValue(name).ToJSON));
    //SubNames
    SNames:=TJsonObject.ParseJSONValue(Form.GetValue('SubNames').ToJSON) as TJsonArray;
    Setlength(SubNames,SNames.Count);
    for i:=0 to SNames.Count-1 do SubNames[i]:=SNames.Items[i].Value;
    //SubTexts
    STexts:=TJsonObject.ParseJSONValue(Form.GetValue('SubTexts').ToJSON) as TJsonArray;
    Setlength(SubTexts,STexts.Count);
    for i:=0 to STexts.Count-1 do
    begin
      Strs:=TJsonObject.ParseJSONValue(STexts.Items[i].ToJSON) as TJsonArray;
      ss:=TStringList.Create;
      for j:=0 to Strs.Count-1 do ss.Add(Strs.Items[j].Value);
      SubTexts[i]:=ss;
    end;
  finally
    if length(SubNames)+Length(SubTexts)=0 then result:=true else result:=false;
  end;
end;

  {TGForm}

//Конструктор, инициализация полей
constructor TGForm.Create(Lvl:byte;Logo:TArray<string>;AOwner: TComponent);
begin
  inherited Create(AOwner);
  nLevel:=lvl;
  nLogo:=logo;
  Bar:=TBar.Create(self);
  Bar.parent:=self;
  self.OnShow:=GShow;
end;

//Код исполняющийся при открытии формы
procedure TGForm.GShow;
begin
  if status=0 then
  begin
    Bar.Load(nLogo[0],self.Name);
    Bar.Draw(self.Width,self.Height);
    Bar.UpStatus(1);
    FShow;
  end else Bar.pUpdate;
end;

  {TDataForm}

//Инициализация классовых переменных TGForm. Создание форм.
procedure TDataForm.DataModuleCreate(Sender: TObject);
var
  i:byte;
begin
  try
    TGForm.GD:=TGameData.Create;
    TGForm.SM:=TSoundManager.Create;
    TGForm.TM:=TTextManager.Create('text.json');
    TGForm.IM:=TImageManager.Create('Images',['bg','icon','seq','other']);
    if AddFontResource(PChar(TPath.GetLibraryPath+'\'+TextsPath+'\'+'font.ttf')) = 1 then
      SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0)
    else
      Raise Exception.create('Ошибка при загрузке шрифтов');
  finally
    with TGForm do
    begin
      Forms[0]:=(TGameForm.Create(0,['Alex','Map','Map'],self) as TGForm);
      for i:=1 to LVL_COUNT-13 do
        Forms[i]:=(TSeazonForm.Create(i,['L'+i.ToString],self) as TGForm);
    end;
  end;
end;

//Ворвращение дефолтных настроек системе
procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  RemoveFontResource(PChar(TPath.GetLibraryPath+'\'+TextsPath+'\'+'font.ttf'));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  TGForm.GD.LoadSavedRamp;
end;

end.

unit DataUnit;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Forms,
  System.ImageList, FMX.ImgList, FMX.Objects, FMX.Media, FMX.Memo,
  FMX.Styles, FMX.Dialogs, FMX.Graphics, FMX.MultiResBitmap,
  system.JSON, system.Generics.Collections, system.Types, BarUnit, Bass,
  System.Actions, FMX.ActnList, System.UITypes;

const
  AWD_COUNT = 17;
  LVL_COUNT = 14;

type
  ePath = (pTexts, pSounds, pResource);

  eResource = (rBackgrounds, rIcons, rSequences, rOther, rMuseum);

  eSound = (sMain, sBackground, sClick, sAward, sWrong);

  eTexts = (tLevels, tMuseum, tOther);

  //Управление изображениями
  TImg = TPair<string, TImage>;

  TImgs = TArray<TImg>;

  TImageManager = class
  private
    List:TImageList;//Изображения для форм
    rm:TDictionary<eResource, TList<integer>>;
  public
    procedure add(r:eResource;bRm:boolean = false);
    procedure remove(r: eResource);
    procedure clear;
    function getBitmap(const name:string):TBitmap;
    procedure setImage(P:TImg); overload;
    procedure setImage(name:string; img:TImage; const sc:boolean = false); overload;
    procedure setImages(Imgs:TImgs);

    constructor Create();
  end;

  //Управление текстами
  TTextManager = class
  private
    last:string;
    Texts:TJSONObject;//Тексты для форм
    SubLogos:TArray<string>;
    SubNames:TArray<string>;
    SubTexts:TArray<TStrings>;
  public
    function getName(id:byte):string;
    procedure Load(t:eTexts);
    procedure LoadText(name:string);
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
    procedure UpStatus(var st:byte);
    procedure LoadSavedRamp;
    function UpdateGamma: boolean;
    procedure SetBr(b:byte);
    function GetBr:byte;
    procedure SetCt(b:byte);
    function GetCt:byte;
    constructor Create;
  end;

  //Управление звуком
  TSoundManager = class
    Volume:single;
    MainStream,BackgroundStream:HSTREAM;
    procedure SetVol(v:single); overload;
    procedure SetVol(v:byte); overload;
    procedure LoadSound(s:eSound);
    procedure Play;
    function GetVol:byte;
    constructor Create;
  end;

  TBarForm = class(TForm)
  protected
    lLogo,lCapt,lDesc:byte;
    last:TFmxObject;
    procedure setLogo(Logo:byte; img:TImage);
    procedure setCaption(Capt:byte; text:TText);
    procedure setDescription(Desc:byte; memo:TMemo);
    procedure vCreate; virtual;
    procedure vShow; virtual;
    procedure vClose; virtual;
  public
    procedure setText;
    procedure bCreate(Sender:TObject);
    procedure bShow(Sender:TObject);
    procedure closeByClick(Sender:TObject);
    procedure bClose(Sender: TObject; var Action: TCloseAction);
    constructor Create(AOwner: TComponent); override;
  End;

  //GForm
  TGForm = class(TBarForm)
  protected
    status:byte;
    level:byte;
    sLogo:TArray<string>;
    images:TImgs;
    procedure fShow; virtual;
    procedure aWin; virtual;
    procedure gShow; virtual;
    procedure gBack; virtual;//возврат на форму
    procedure vShow; override;
    procedure vClose; override;
  public
    procedure win;
    procedure setText(l, c, d: byte); overload;
    procedure GNext(Sender: TObject); virtual;
    constructor Create(Lvl:byte);  overload;
  end;

  //DataForm
  TDataForm = class(TDataModule)
    Backgrounds: TImageList;
    Icons: TImageList;
    Sequence: TImageList;
    Other: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ShowForm(i:byte);
  end;

var
  DataForm: TDataForm;
  Styles:TStyleBook;
  IM:TImageManager;
  TM:TTextManager;
  SM:TSoundManager;
  GD:TGameData;
  Bar: TBar;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses system.IOUtils, system.Math, windows, Messages,
GameUnit, SeazonUnit, PlaceUnit, ToolsUnit, MaterialsUnit, TaskUnit, FoundationUnit, MapUnit;

  { }

function getPath(p:ePath):string;
begin
  case p of
    pTexts: result:=TPath.Combine(TPath.GetLibraryPath,'t');
    pSounds: result:=TPath.Combine(TPath.GetLibraryPath,'s');
    pResource: result:=TPath.Combine(TPath.GetLibraryPath,'i');
  end;
end;

function getResource(r:eResource):string;
begin
  case r of
    rBackgrounds: result:=TPath.Combine(getPath(pResource),'Backgrounds.style');
    rIcons: result:=TPath.Combine(getPath(pResource),'Icons.style');
    rSequences: result:=TPath.Combine(getPath(pResource),'Sequences.style');
    rOther: result:=TPath.Combine(getPath(pResource),'Other.style');
    rMuseum: result:=TPath.Combine(getPath(pResource),'Museum.style');
  end;
end;

function getTexts(t:eTexts):string;
begin
  case t of
    tLevels: result:=TPath.Combine(getPath(pTexts),'levels.json');
    tMuseum: result:=TPath.Combine(getPath(pTexts),'museum.json');
    tOther: result:=TPath.Combine(getPath(pTexts),'other.json');
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
procedure TGameData.UpStatus(var st: Byte);
begin
  st:=st+1;
  if st=2 then Bar.showNext;
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

  {TSoundManager}

//Конструктор
constructor TSoundManager.Create;
begin
  try
    if not BASS_Init(-1, 44100, 0, 0, nil) then Raise Exception.create('Ошибка при загрузке шрифтов');
    BackgroundStream:=BASS_StreamCreateFile(false,pchar(getSound(sBackground)),0,0,BASS_UNICODE);
    BASS_ChannelFlags(BackgroundStream, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);
  finally
    SetVol(0.1);
    //BASS_ChannelPlay(BackgroundStream,true);
  end;
end;

//Установить уровень звука
procedure TSoundManager.SetVol(v:single);
begin
  Volume:=v;
  Bass_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, Volume);
  Bass_ChannelSetAttribute(BackgroundStream, BASS_ATTRIB_VOL, Volume/2);
end;

//Загрузить файл звука в поток
procedure TSoundManager.LoadSound;
begin
  if MainStream <> 0 then Bass_StreamFree(MainStream);
  MainStream:=BASS_StreamCreateFile(false,pchar(getSound(s)),0,0,BASS_UNICODE);
  SetVol(Volume);
end;

//Проиграть звук из потока
procedure TSoundManager.Play;
begin
  Bass_ChannelPlay(MainStream,true);
end;

procedure TSoundManager.SetVol(v:byte);
begin
  SetVol(v/50);
end;

function TSoundManager.GetVol;
begin
  result:=round(SM.Volume*50);
end;

  {TImageManager}

procedure TImageManager.add(r: eResource; bRm:boolean = false);
var
  Res: TStyleBook;
  Sor: TCustomSourceItem;
  lRm: TList<integer>;
  i:byte;
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
    Res.LoadFromFile(getResource(r));
    lRm:=TList<integer>.create;
    for i:=0 to Res.Style.ChildrenCount-1 do
    begin
      Sor:=List.Source.Add;
      Sor.Name:=Res.Style.Children.Items[i].StyleName;
      lRm.Add(sor.ID);
      Sor.MultiResBitmap.SizeKind:= TSizeKind.Source;
      LoadPicture(Sor, 1, (Res.Style.Children.Items[i] as TBitmapObject).Bitmap);
    end;
    if bRm then
      rm.Add(r, lRm);
  finally
    Res.Free;
    if List.Source.Count=0 then
      raise Exception.Create('Ошибка при загрузке изображений.');
  end;
end;

procedure TImageManager.remove(r: eResource);
var
  id:integer;
begin
  if rm.ContainsKey(r) then
    for id in rm.Items[r] do
      List.Source.Delete(id);
end;

procedure TImageManager.clear;
begin
  List.Source.clear;
end;

//Конструктор (загрузка изображений из .style в TImageList)
constructor TImageManager.Create();
begin
  List:=TImageList.Create(DataForm);
  rm:=TDictionary<eResource, TList<integer>>.create;
end;

//Возвращает битмап по имени.
function TImageManager.GetBitmap;
var
  I:TCustomBitmapItem;
  S:TSize;
begin
  if List.BitmapItemByName(name,I,S) then result:=I.Bitmap else result:=nil;
end;

//Загружает битмап в изображение с возможностью скейла
procedure TImageManager.SetImage(P:TImg);
begin
  SetImage( P.Key, P.Value, true);
end;

procedure TImageManager.SetImage(name:string; img:TImage; const sc:boolean);
var
  I:TCustomBitmapItem;
  S:TSize;
begin
  if List.BitmapItemByName(name,I,S) then
  begin
    if sc then I.Scale:=1/max(img.Width/S.Width,img.Height/S.Height);
    img.Bitmap.Assign(I.Bitmap);
  end;
end;

//Загружает в каждое изображение из списка свой битмап
procedure TImageManager.SetImages(Imgs:TImgs);
var
  img:TImg;
begin
  for img in Imgs do
    SetImage(img);
end;

  {TTextManager}

function TTextManager.getName(id: Byte):string;
begin
  result:=TM.SubNames[id];
end;

//загружает данные из файла
procedure TTextManager.Load(t: eTexts);
begin
  try
    if TFile.Exists(getTexts(t)) then
      Texts:=TJSONObject(TJSONObject.ParseJSONValue(TFile.ReadAllText(getTexts(t),TEncoding.UTF8)))
  finally
    if not Assigned(Texts) then
      raise Exception.Create('Ошибка при загрузке текстов.');
  end;
end;

//Загружает данные для конкретной формы
procedure TTextManager.LoadText(name:string);
var
  i,j:byte;
  ss:TStringList;
  Form:TJsonObject;
  STexts,Strs,SNames,SLogos:TJsonArray;
begin
  if last<>name then
    if Assigned(Texts.Values[name]) then
      try
        Form:=Texts.GetValue(name) as TJSonObject;
        //SubNames
        SNames:=TJsonObject.ParseJSONValue(Form.GetValue('SubNames').ToJSON) as TJsonArray;
        Setlength(SubNames,SNames.Count);
        for i:=0 to SNames.Count-1 do SubNames[i]:=SNames.Items[i].Value;
        //SubLogos
        SLogos:=TJsonObject.ParseJSONValue(Form.GetValue('SubLogos').ToJSON) as TJsonArray;
        Setlength(SubLogos,SLogos.Count);
        for i:=0 to SLogos.Count-1 do SubLogos[i]:=SLogos.Items[i].Value;
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
        last:=name;
        if length(SubNames)+Length(SubTexts)=0 then
        begin
          last:='';
          raise Exception.Create('Ошибка при чтении текста из памяти.');
        end;
      end
    else raise Exception.Create('Текст "'+name+'" не найден.');
end;

  {TBarForm}

procedure TBarForm.SetLogo(Logo:byte; img:TImage);
begin
  lLogo:=Logo;
  if Logo<length(TM.SubLogos) then
    IM.SetImage(TM.SubLogos[Logo], img, false);
end;

procedure TBarForm.SetCaption(Capt:byte; text:TText);
begin
  lCapt:=Capt;
  if Capt<length(TM.SubNames) then
    text.Text:=TM.SubNames[Capt];
end;

procedure TBarForm.SetDescription(Desc:byte; memo:TMemo);
begin
  lDesc:=Desc;
  if (Desc>=length(TM.SubTexts))or(TM.SubTexts[Desc]=nil) then memo.Lines.Clear
    else memo.Lines.Assign(TM.SubTexts[Desc]);
end;

procedure TBarForm.vCreate;
begin
end;

procedure TBarForm.vShow;
begin
end;

procedure TBarForm.vClose;
begin
end;

procedure TBarForm.SetText;
begin
  SetLogo(llogo, Bar.SubLogo);
  SetCaption(lCapt, Bar.SubName);
  SetDescription(lDesc, Bar.SubText);
end;

procedure TBarForm.bCreate(Sender: TObject);
begin
  vCreate;
end;

procedure TBarForm.bShow(Sender: TObject);
var
  i:byte;
begin
  last:=Bar.Parent;
  Bar.Parent:=self;
  Bar.update;
  vShow;
end;

procedure TBarForm.closeByClick(Sender: TObject);
begin
  close;
end;

procedure TBarForm.bClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(last) then
  begin
    Bar.Parent:=last;
    Bar.update;
    if last is TGForm then TGForm(last).gBack;    
  end else Bar.Parent:=nil;
  vClose;
end;

constructor TBarForm.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  self.OnCreate:=bCreate;
  self.OnShow:=bShow;
  self.OnClose:=bClose;
end;

  {TGForm}

//Конструктор, инициализация полей
constructor TGForm.Create(Lvl:byte);
begin
  inherited Create(nil);
  Level:=lvl;
end;

procedure TGForm.win;
begin
  GD.UpStatus(status);
  aWin;
end;

procedure TGForm.SetText(l, c, d: byte);
begin
  SetLogo(l, Bar.SubLogo);
  SetCaption(c, Bar.SubName);
  SetDescription(d, Bar.SubText);
end;

procedure TGForm.gBack;
begin
  if status=2 then
    Bar.showNext;
end;

procedure TGForm.gShow;
begin
end;

procedure TGForm.fShow;
begin
end;

procedure TGForm.aWin;
begin
end;

//Код исполняющийся при открытии формы
procedure TGForm.vShow;
begin
  gShow;
  if status=0 then//Первое открытие
  begin
    GD.UpStatus(Status);
    fShow;
  end;
end;

procedure TGForm.vClose;
begin
  self.Release;
end;

procedure TGForm.GNext;
begin
  if level<LVL_COUNT then
    DataForm.ShowForm(level+1);
end;

  {TDataForm}

function createForm(i:byte):TGForm;
begin
  case i of
    0:result:=TGameForm.Create(0);
    1:result:=TSeazonForm.Create(1);
    2:result:=TPlaceForm.Create(2);
    3:result:=TToolsForm.Create(3);
    4:result:=TMaterialsForm.Create(4);
    5:result:=TTaskForm.Create(5);
    6:result:=TFoundationForm.Create(6);
    else result:=nil;
  end;
end;

procedure TDataForm.ShowForm(i: Byte);
begin
  createForm(i).Show;
end;

//Инициализация классовых переменных TGForm. Создание форм.
procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  GD:=TGameData.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create();
  IM:=TImageManager.Create();
  IM.add(eResource.rBackgrounds);
  IM.add(eResource.rIcons);
  Bar:=TBar.create(self);
  if AddFontResource(PChar(getPath(pTexts)+'font.ttf'))>0 then SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  //  else Raise Exception.create('Ошибка при загрузке шрифтов');
end;

//
procedure TDataForm.DataModuleDestroy(Sender: TObject);
begin
  RemoveFontResource(PChar(getPath(pTexts)+'font.ttf'));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  GD.LoadSavedRamp;
end;

end.

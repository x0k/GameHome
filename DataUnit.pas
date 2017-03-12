unit DataUnit;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Forms,
  System.ImageList, FMX.ImgList, FMX.Objects, FMX.Media, FMX.Memo,
  FMX.Styles, FMX.Dialogs, FMX.Graphics, FMX.MultiResBitmap,
  system.JSON, system.Generics.Collections, system.Types, BarUnit, Bass,
  System.Actions, FMX.ActnList, System.UITypes, FMX.Layouts, FMX.ani;

const
  AWD_COUNT = 17;
  LVL_COUNT = 14;

type
  ePath = (pTexts, pSounds, pResource);

  eResource = (rImages, rSequences, rOther, rMuseum);

  eSound = (sMain, sBackground, sClick, sAward, sWrong);

  eTexts = (tLevels, tMuseum, tOther);

  //Управление изображениями
  TImageManager = class
  private
    loaded:TList<eResource>;
  public
    procedure add(r:eResource);
    procedure remove(r:eResource);
    procedure clear;

    procedure setSize(img:TGlyph; s:TControlSize); overload;
    procedure setSize(img:TGlyph; s:TSizeF); overload;

    constructor Create();
  end;

  //Управление текстами
  TTextManager = class
  private
    last:string;
    Texts:TJSONObject;//Тексты для форм
    SubLogos:TArray<byte>;
    SubNames:TArray<string>;
    SubTexts:TArray<string>;
  public
    function getName(id:byte):string;
    procedure Load(t:eTexts);
    procedure LoadText(name:string);
  end;

  // массив для хранения таблиц гамма-коррекции (gamma ramp)
  TRampArray = array[0..2] of array[byte] of word;

  //Игровая информация
  TGameData = class
  private
    Status:array[0..LVL_COUNT] of byte;
    Awards:array[1..AWD_COUNT] of boolean;
    origramparray: tramparray;//текущие значения gamma ramp
    Br,Ct,Gm:byte;
    procedure GetAwd(index:byte);
    procedure UpStatus(l:byte);
    procedure LoadSavedRamp;
    function UpdateGamma: boolean;
    procedure SetBr(b:byte);
    function GetBr:byte;
    procedure SetCt(b:byte);
    function GetCt:byte;
  public
    property brightnes:byte read getBr write setBr;
    property contrast:byte read getCt write setCt;
    constructor Create;
  end;

  //Управление звуком
  TSoundManager = class
  private
    Vol:single;
    last:eSound;
    mainStream,backgroundStream:HSTREAM;
    procedure setVol(v:single); overload;
    procedure setVol(v:byte); overload;
    procedure loadSound(s:eSound);
    function getVol:byte;
  public
    procedure play(s:eSound);
    property volume:byte read getVol write setVol;
    constructor Create;
  end;

  TBarForm = class(TForm)
  protected
    lLogo,lCapt,lDesc:byte;
    procedure setLogo(Logo:byte; img:TGlyph);
    procedure setCaption(Capt:byte; text:TText);
    procedure setDescription(Desc:byte; memo:TMemo);
    procedure onFormCreate; virtual;
    procedure afterFormCreate; virtual;
    procedure onFormShow; virtual;
    procedure onFormClose; virtual;
  public
    procedure setText;
    procedure onBarCreate(Sender:TObject);
    procedure onBarShow(Sender:TObject);
    procedure onBarClose(Sender: TObject; var Action: TCloseAction);

    procedure closeByClick(Sender:TObject);
    constructor Create(AOwner: TComponent); override;
  End;

  //GForm
  TGForm = class(TBarForm)
  protected
    level:byte;
    bgs:TArray<TGlyph>;
    lts:TArray<TControl>;
    function getStatus:byte;
    procedure upStatus(l:byte);

    procedure addShow; virtual;
    procedure firstShow; virtual;
    procedure addWin; virtual;

    procedure afterFormCreate; override;
    procedure onFormShow; override;
    procedure onFormClose; override;

    class function getFormById(i:byte):TGForm;
  public
    procedure win;
    procedure setText(l, c, d: byte); overload;
    procedure showAni; virtual;
    procedure hideAni; virtual;
    procedure Next(Sender: TObject); virtual;
    procedure Back(Sender: TObject); virtual;

    property lvl:byte read level;
    property status:byte read getStatus write upStatus;

    constructor Create(Lvl:byte);
  end;

  //DataForm
  TDataForm = class(TDataModule)
    Museum: TImageList;
    Backgrounds: TImageList;
    Icons: TImageList;
    Sequence: TImageList;
    Other: TImageList;
    Images: TImageList;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    function getList(r:eResource):TImageList;
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
GameUnit, SeazonUnit, PlaceUnit, ToolsUnit, MaterialsUnit, TaskUnit, FoundationUnit, MapUnit, OmenUnit;

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
    rImages: result:=TPath.Combine(getPath(pResource),'Images.style');
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
  Status[0]:=3;
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
procedure TGameData.UpStatus(l: Byte);
begin
  if status[l]<2 then inc(status[l]);
  if status[l]=2 then Bar.showNext;
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
  Vol:=v;
  Bass_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, Vol);
  Bass_ChannelSetAttribute(BackgroundStream, BASS_ATTRIB_VOL, Vol/2);
end;

//Загрузить файл звука в поток
procedure TSoundManager.LoadSound;
begin
  if MainStream <> 0 then Bass_StreamFree(MainStream);
  MainStream:=BASS_StreamCreateFile(false,pchar(getSound(s)),0,0,BASS_UNICODE);
  last:=s;
  SetVol(Vol);
end;

//Проиграть звук из потока
procedure TSoundManager.Play;
begin
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

  {TImageManager}

procedure TImageManager.add(r: eResource);
var
  res: TStyleBook;
  list:TImageList;
  Sor: TCustomSourceItem;
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
  res:=nil;
  list:=DataForm.getList(r);
  if not loaded.Contains(r) then
  try
    Res:=TStyleBook.Create(DataForm);
    Res.LoadFromFile(getResource(r));
    for i:=0 to Res.Style.ChildrenCount-1 do
    begin
      Sor:=List.Source.AddOrSet(Res.Style.Children.Items[i].StyleName, [],[]);
      Sor.MultiResBitmap.SizeKind:=TSizeKind.Source;
      LoadPicture(Sor, 1, (Res.Style.Children.Items[i] as TBitmapObject).Bitmap);
    end;
  finally
    loaded.Add(r);
    Res.Free;
  end;
end;

procedure TImageManager.remove(r: eResource);
begin
  if loaded.Contains(r) then
  begin
    DataForm.getList(r).Source.Clear;
    loaded.Remove(r);
  end;
end;

procedure TImageManager.setSize(img: TGlyph; s:TControlSize);
begin
  setSize(img, s.Size);
end;

procedure TImageManager.setSize(img: TGlyph; s:TSizeF);
var
  i:byte;
  w,h,k:single;
  b:TBounds;
begin
  w:=0;
  h:=0;
  with (img.Images.Destination.FindItemID(img.ImageIndex) as TCustomDestinationItem).Layers do
    for i:=0 to Count-1 do
    begin
      b:=items[i].SourceRect;
      w:=max(w,b.Width-b.Left);
      h:=max(h,b.Height-b.Top);
    end;
  k:=max(s.Width/w, s.Height/h);
  img.Width:=w*k;
  img.Height:=h*k;
end;

procedure TImageManager.clear;
var
  i:byte;
begin
  if loaded.Count>0 then
  for i:=0 to loaded.Count-1 do
    remove(loaded[i]);
end;

//Конструктор (загрузка изображений из .style в TImageList)
constructor TImageManager.Create();
begin
  loaded:=TList<eResource>.create;
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
  i:byte;
  Form:TJsonObject;
  A:TJsonArray;
begin
  if last<>name then
    if Assigned(Texts.Values[name]) then
      try
        Form:=Texts.GetValue(name) as TJSonObject;
        //SubNames
        A:=Form.GetValue('SubNames') as TJsonArray;
        Setlength(SubNames, A.Count);
        for i:=0 to A.Count-1 do
          SubNames[i]:=A.Items[i].Value;
        //SubLogos
        A:=Form.GetValue('SubLogos') as TJsonArray;
        Setlength(SubLogos, A.Count);
        for i:=0 to A.Count-1 do
          SubLogos[i]:=(A.Items[i] as TJsonNumber).AsInt;
        //SubTexts
        A:=Form.GetValue('SubTexts') as TJsonArray;
        Setlength(SubTexts, A.Count);
        for i:=0 to A.Count-1 do
          SubTexts[i]:=A.Items[i].Value;
      finally
        last:=name;
        if length(subNames)*length(subTexts)=0 then
        begin
          last:='';
          raise Exception.Create('Ошибка при чтении текста из памяти.');
        end;
      end
    else raise Exception.Create('Текст "'+name+'" не найден.');
end;

  {TBarForm}

procedure TBarForm.SetLogo(Logo:byte; img:TGlyph);
begin
  if Logo<length(TM.SubLogos) then
    img.ImageIndex:=TM.SubLogos[Logo];
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
  if (Desc>=length(TM.SubTexts))or(TM.SubTexts[Desc]='') then memo.Lines.Clear
    else memo.Text:=TM.SubTexts[Desc];
end;

procedure TBarForm.onFormCreate;
begin
end;

procedure TBarForm.afterFormCreate;
begin
end;

procedure TBarForm.onFormShow;
begin
end;

procedure TBarForm.onFormClose;
begin
end;

procedure TBarForm.SetText;
begin
  SetLogo(llogo, Bar.SubLogo);
  SetCaption(lCapt, Bar.SubName);
  SetDescription(lDesc, Bar.SubText);
end;

procedure TBarForm.onBarCreate(Sender: TObject);
begin
  onFormCreate;
  afterFormCreate;
end;

procedure TBarForm.onBarShow(Sender: TObject);
begin
  Bar.Parent:=self;
  Bar.update;
  onFormShow;
end;

procedure TBarForm.onBarClose(Sender: TObject; var Action: TCloseAction);
begin
  Bar.Parent:=nil;
  onFormClose;
end;

procedure TBarForm.closeByClick(Sender: TObject);
begin
  close;
end;

constructor TBarForm.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  self.OnCreate:=onBarCreate;
  self.OnShow:=onBarShow;
  self.OnClose:=onBarClose;
end;

  {TGForm}

constructor TGForm.Create(Lvl:byte);
begin
  inherited Create(DataForm);
  Level:=lvl;
end;

procedure TGForm.win;
begin
  GD.UpStatus(level);
  addWin;
end;

procedure TGForm.SetText(l, c, d: byte);
begin
  SetLogo(l, Bar.SubLogo);
  SetCaption(c, Bar.SubName);
  SetDescription(d, Bar.SubText);
end;

function TGForm.getStatus;
begin
  result:=GD.Status[level];
end;

procedure TGForm.upStatus;
begin
  GD.upStatus(l);
end;

procedure TGForm.addShow;
begin
end;

procedure TGForm.firstShow;
begin
end;

procedure TGForm.addWin;
begin
end;

procedure TGForm.showAni;
var
  i:byte;
begin
  if length(lts)>0 then
  begin
    for i:=1 to High(lts) do
      TAnimator.AnimateFloat(lts[i], 'opacity', 1, 0.5);
    TAnimator.AnimateFloatWait(lts[0], 'opacity', 1, 0.5);
  end;
end;

procedure TGForm.hideAni;
var
  i:byte;
begin
  if length(lts)>0 then
  begin
    for i:=1 to High(lts) do
      TAnimator.AnimateFloat(lts[i], 'opacity', 0, 0.4);
    TAnimator.AnimateFloatWait(lts[0], 'opacity', 0, 0.4);
  end;
end;

procedure TGForm.afterFormCreate;
var
  i:byte;
begin
  if length(bgs)>0 then
  for i:=0 to High(bgs) do
    IM.setSize(bgs[i], screen.Size);
  if length(lts)>0 then
  for i:=0 to High(lts) do
    lts[i].Opacity:=0;
end;

procedure TGForm.onFormShow;
begin
  addShow;
  if status=0 then//Первое открытие
  begin
    GD.UpStatus(level);
    firstShow;
  end;
  showAni;
end;

procedure TGForm.onFormClose;
begin
  if level>0 then
  begin
    DataForm.ShowForm(0);
    Release;
  end;
  hide;
end;

procedure TGForm.Next;
begin
  hideAni;
  if level<LVL_COUNT then
    DataForm.ShowForm(level+1);
  free;
end;

procedure TGForm.Back;
begin
  hideAni;
  if level>0 then
  begin
    DataForm.ShowForm(level-1);
    free;
  end else free;
end;

class function TGForm.getFormById(i: Byte):TGForm;
begin
  case i of
    0:begin
        if not Assigned(GameForm) then GameForm:=TGameForm.Create(0);
        result:=GameForm;
      end;
    1:result:=TSeazonForm.Create(1);
    2:result:=TPlaceForm.Create(2);
    3:result:=TToolsForm.Create(3);
    4:result:=TMaterialsForm.Create(4);
    5:result:=TTaskForm.Create(5);
    6:result:=TFoundationForm.Create(6);
    7:result:=TMapForm.Create(7);
    8:result:=TOmenForm.Create(8);
    else result:=nil;
  end;
end;

  {TDataForm}

function TDataForm.getList(r: eResource):TImageList;
begin
  case r of
    rImages: result:=Images;
    rSequences: result:=Sequence;
    rOther: result:=self.Other;
    rMuseum: result:=self.Museum;
  end;
end;

procedure TDataForm.ShowForm(i: Byte);
var
 f:TGForm;
begin
  f:=TGForm.getFormById(i);
  if Assigned(f) then
  begin
    f.Show;
    if i=0 then f.onBarShow(self);
  end;
end;

//Инициализация классовых переменных TGForm. Создание форм.
procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  GD:=TGameData.Create;
  SM:=TSoundManager.Create;
  TM:=TTextManager.Create();
  IM:=TImageManager.Create();
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

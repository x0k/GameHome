unit TextManager;

interface

uses
  System.JSON, System.Generics.Collections,
  ResourcesManager;

type
  fillProc<T> = procedure(const v:TJSONValue; var item: T) of object;

  TFormText = class
  protected
    sender: string;
    SubNames: TArray<string>;
    SubLogos: TArray<byte>;
    SubTexts: TArray<string>;
    SubTabTexts: TArray<string>;
    FormItems: TArray<string>;

    function getName(id: byte): string;
    function getLogo(id: byte): byte;
    function getText(id: byte): string;
    function getItem(id: byte): string;
    function getTabText(id: byte): string;

    procedure fillStr(const v:TJSONValue; var item: string);
    procedure fillByte(const v:TJSONValue; var item: byte);
    procedure fillTab(const v:TJSONValue; var item: string);

    procedure fillArr<T>(const j:TJSONArray; const f: fillProc<T>;var m: TArray<T>);
  public
    class function getDefault: TFormText;

    property Names[index: byte]:string read getName;
    property Logos[index: byte]:byte read getLogo;
    property Texts[index: byte]:string read getText;
    property TabTexts[index: byte]: string read getTabText;
    property Items[index: byte]:string read getItem;

    destructor Destroy; override;
    constructor Create(j:TJSONObject);
  end;

  TTextManager = class
  private
    texts: TDictionary<string, TFormText>;

  public
    function tryGetText(const name: string; var text: TFormText): boolean;

    destructor Destroy; override;
    constructor Create;
  end;

var
  TM: TTextManager;

implementation

  {TFormText}

uses
  System.SysUtils, FMX.Dialogs,
  DataUnit;

function TFormText.getName(id: Byte): string;
begin
  result:='';
  if id<length(SubNames) then
    result:=SubNames[id];
end;

function TFormText.getLogo(id: Byte): byte;
begin
  result:=0;
  if id<length(SubLogos) then
    result:=SubLogos[id];
end;

function TFormText.getText(id: Byte): string;
begin
  result:='';
  if id<length(SubTexts) then
    result:=SubTexts[id];
end;

function TFormText.getItem(id: Byte): string;
begin
  result:='';
  if id<length(FormItems) then
    result:=FormItems[id];
end;

function TFormText.getTabText(id: Byte): string;
begin
  result:='';
  if id<length(SubTabTexts) then
    result:=SubTabTexts[id];
end;

procedure TFormText.fillStr(const v: TJSONValue; var item: string);
begin
  item:=TJsonString(v).Value;
end;

procedure TFormText.fillByte(const v: TJSONValue; var item: Byte);
begin
  item:=TJsonNumber(v).AsInt;
end;

procedure TFormText.fillTab(const v: TJSONValue; var item: string);
var
  n: TJSONNumber;
begin
  if (n is TJSONNumber) and v.TryGetValue(n) and (n.AsInt<length(SubTabTexts)) then
    item:=SubTabTexts[n.AsInt]
  else
    item:=TJSONString(v).Value;
end;

procedure TFormText.fillArr<T>(const j:TJSONArray; const f: fillProc<T>; var m: TArray<T>);
var
  i:integer;
begin
  if Assigned(j) and (j.Count>0) then
  begin
    setlength(m, j.Count);
    for i:=0 to j.Count-1 do
      f(j.Items[i], m[i]);
  end;
end;

class function TFormText.getDefault: TFormText;
begin
  result:=TFormText.Create(TJSONObject(TJSONObject.ParseJSONValue('{}')));
end;

destructor TFormText.destroy;
begin
  inherited;
end;

constructor TFormText.create;
var
  val: TJSONArray;
begin
  if j.TryGetValue('Names', val) then
    fillArr<string>(val, fillStr, SubNames);
  if j.TryGetValue('Logos', val) then
    fillArr<byte>(val, fillByte, SubLogos);
  if j.TryGetValue('Texts', val) then
    fillArr<string>(val, fillStr, SubTexts);
  if j.TryGetValue('TabTexts', val) then
    fillArr<string>(val, fillTab, SubTabTexts);
  if j.TryGetValue('Items', val) then
    fillArr<string>(val, fillStr, FormItems);
end;

  {TTextManager}

function TTextManager.tryGetText(const name: string; var text: TFormText): boolean;
begin
  result:=texts.ContainsKey(name);
  if result then  
    text:=texts[name];
end;

destructor TTextManager.Destroy;
var
  p:TPair<string, TFormText>;
begin
  for p in texts do
    p.Value.Free;
  texts.Free;
  inherited;
end;

constructor TTextManager.Create;
var
  t: eTexts;
  p:TJSONPair;
  json:TJSONObject;
begin
  texts:=TDictionary<string, TFormText>.Create;
  try
    for t in [tLevels, tMuseum, tOther] do
      if findTexts(t) then
      begin
        json:=TJSONObject(TJSONObject.ParseJSONValue(getTexts(t)));
        for p in json do
          texts.Add(p.JsonString.Value, TFormText.create(p.JsonValue as TJSONObject));
        json.Free;
      end;
  except
    on E: Exception do
      ShowMessage('TextManager error: '+E.Message);
  end;
end;

end.

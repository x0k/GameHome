unit TextManager;

interface

uses
  System.JSON, System.Generics.Collections,
  ResourcesManager;

type

  TFormText = class
  protected
    SubNames: TArray<string>;
    SubLogos: TArray<byte>;
    SubTexts: TArray<string>;
    FormItems: TArray<string>;

    function getName(id: byte): string;
    function getLogo(id: byte): byte;
    function getText(id: byte): string;
    function getItem(id: byte): string;
  public
    property Names[index: byte]:string read getName;
    property Logos[index: byte]:byte read getLogo;
    property Texts[index: byte]:string read getText;
    property Items[index: byte]:string read getItem;

    constructor create(j:TJSONObject);
  end;

  TTextManager = class
  private
    texts: TDictionary<string, TFormText>;

    function getText(name:string): TFormText;
  public
    property Forms[index: string]:TFormText read getText;

    constructor create;
  end;

implementation

  {TFormText}

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

procedure fillStr(m: TJSONArray;var a: TArray<string>);
var
  i:integer;
begin
  if Assigned(m) and (m.Count>0) then
  begin
    setlength(a, m.Count);
    for i:=0 to m.Count-1 do
      a[i]:=(m.Items[i] as TJsonString).Value;
  end;
end;

procedure fillByte(m: TJSONArray;var a: TArray<byte>);
var
  i:integer;
begin
  if Assigned(m) and (m.Count>0) then
  begin
    setlength(a, m.Count);
    for i:=0 to m.Count-1 do
      a[i]:=(m.Items[i] as TJsonNumber).AsInt;
  end;
end;

constructor TFormText.create(j: TJSONObject);
var
  val: TJSONArray;
begin
  if j.TryGetValue('Names', val) then
    fillStr(val, SubNames);
  if j.TryGetValue('Logos', val) then
    fillByte(val, SubLogos);
  if j.TryGetValue('Texts', val) then
    fillStr(val, SubTexts);
  if j.TryGetValue('Items', val) then
    fillStr(val, FormItems);
end;

  {TTextManager}

function TTextManager.getText(name: string): TFormText;
begin
  result:=texts[name];
end;

constructor TTextManager.Create;
var
  t: eTexts;
  p:TJSONPair;
  json:TJSONObject;
begin
  texts:=TDictionary<string, TFormText>.Create;
  for t in [tLevels, tMuseum, tOther] do
    if findTexts(t) then
    begin
      json:=TJSONObject(TJSONObject.ParseJSONValue(getTexts(t)));
      for p in json do
        texts.Add(p.JsonString.Value, TFormText.create(p.JsonValue as TJSONObject));
    end;
end;

end.

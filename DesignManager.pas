unit DesignManager;

interface

uses
  System.JSON, System.Generics.Collections,
  ResourcesManager;

type
  fillProc<T> = procedure(const v:TJSONValue; var item: T) of object;

  TFormLayout = class
  protected
    n: string;
    TxtSize: TArray<single>;
    TbsSize: TArray<single>;
    Margins: TArray<single>;
    Childrens: TArray<TFormLayout>;

    function hasSize: boolean;
    function hasWidth: boolean;
    function hasMargins: boolean;
    function hasChildrens: boolean;

    procedure fillLayout(const v:TJSONValue; var item: TFormLayout);
    procedure fillSingl(const v:TJSONValue; var item: single);
    procedure fillArr<T>(const j:TJSONArray; const f: fillProc<T>;var m: TArray<T>);
  public
    property Name: string read n;
    property pSize: boolean read hasSize;
    property Size:TArray<single> read txtSize;
    property pWidth: boolean read hasWidth;
    property Width:TArray<single> read tbsSize;
    property pMargins: boolean read hasMargins;
    property LayoutMargins:TArray<single> read margins;
    property pChildrens: boolean read hasChildrens;
    property Childs:TArray<TFormLayout> read Childrens;

    constructor create(j:TJSONObject);
  end;

  TDesignManager = class
  private
    lName: string;
    lArr: TArray<TFormLayout>;
    layouts: TDictionary<string, TArray<TFormLayout>>;

    function getDesign(name: string): TArray<TFormLayout>;
  public
    function getFormLayout(const form, name: string): TFormLayout;

    property Designs[index: string]: TArray<TFormLayout> read getDesign;

    constructor create;
  end;

implementation

  {TFormText}

function TFormLayout.hasSize;
begin
  result:=length(TbsSize)>0;
end;

function TFormLayout.hasWidth;
begin
  result:=length(TxtSize)>0;
end;

function TFormLayout.hasMargins;
begin
  result:=length(Margins)=4;
end;

function TFormLayout.hasChildrens;
begin
  result:=length(Childrens)>0;
end;

procedure TFormLayout.fillLayout(const v: TJSONValue; var item: TFormLayout);
begin
  item:=TFormLayout.create(v as TJsonObject);
end;

procedure TFormLayout.fillSingl(const v: TJSONValue; var item: Single);
begin
  item:=TJsonNumber(v).AsDouble;
end;

procedure TFormLayout.fillArr<T>(const j:TJSONArray; const f: fillProc<T>; var m: TArray<T>);
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

constructor TFormLayout.create(j: TJSONObject);
var
  val: TJSONArray;
begin
  n:=TJSONString(j.GetValue('Name')).Value;
  if j.TryGetValue('TextSize', val) then
    fillArr<single>(val, fillSingl, TxtSize);
  if j.TryGetValue('TabsSize', val) then
    fillArr<single>(val, fillSingl, TbsSize);
  if j.TryGetValue('Margins', val) then
    fillArr<single>(val, fillSingl, margins);
  if j.TryGetValue('Childrens', val) and (Val.Count>0) then
    fillArr<TFormLayout>(val, fillLayout, childrens);
end;

  {TDesignManager}

function TDesignManager.getDesign(name: string): TArray<TFormLayout>;
begin
  if (lName<>name) and Layouts.ContainsKey(name) then
  begin
    lArr:=Layouts.Items[name];
    lName:=name;
  end;
  result:=lArr;
end;

function TDesignManager.getFormLayout(const form: string; const name: string): TFormLayout;

  function findName(const m: TArray<TFormLayout>): TFormLayout;
  var
    i: byte;
  begin
    result:=nil;
    if Assigned(m) and (length(m)>0) then
    begin
      for i:=0 to High(m) do
      begin
        if m[i].Name=name then
        begin
          result:=m[i];
          exit;
        end;
        if m[i].pChildrens then
          result:=findName(m[i].Childrens);
        if Assigned(result) then
          exit;
      end;
    end;
  end;

begin
  result:=findName(getDesign(form));
end;

constructor TDesignManager.Create;
var
  i, c: byte;
  p:TJSONPair;
  json:TJSONObject;
  m: TArray<TFormLayout>;
begin
  layouts:=TDictionary<string, TArray<TFormLayout>>.Create;
  if findTexts(tLayouts) then
  begin
    json:=TJSONObject(TJSONObject.ParseJSONValue(getTexts(tLayouts)));
    for p in json do
    begin
      c:=TJSONArray(p.JsonValue).Count;
      if c=0 then continue;
      setlength(m, c);
      for i:=0 to c-1 do
        m[i]:=TFormLayout.create(TJSONArray(p.JsonValue).Items[i] as TJsonObject);
      layouts.Add(p.JsonString.Value, copy(m, 0, c));
    end;
  end;
end;

end.

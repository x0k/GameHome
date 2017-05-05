unit DesignManager;

interface

uses
  FMX.Graphics, FMX.Types,
  System.JSON, System.Generics.Collections,
  ResourcesManager;

type
  fillProc<T> = procedure(const v:TJSONValue; var item: T) of object;

  TFormLayout = class
  protected
    n: string;
    Ani: boolean;
    TxtSize: TArray<single>;
    TbsSize: TArray<single>;
    hasAlign: boolean;
    Align: TAlignLayout;
    Font: TTextSettings;
    hasTxt: boolean;
    Txt: string;
    Bounds: TBounds;
    Margins: TBounds;
    hasChilds: boolean;
    Childrens: TArray<TFormLayout>;

    procedure fillLayout(const v:TJSONValue; var item: TFormLayout);
    procedure fillSingl(const v:TJSONValue; var item: single);
    procedure fillArr<T>(const j:TJSONArray; const f: fillProc<T>;var m: TArray<T>);

    function fontFromJSON(const v:TJSONObject): TTextSettings;
    function boundsFromJSON(const v:TJSONArray): TBounds;
  public
    property Name: string read n;
    property Animation: boolean read ani;
    property TextSize:TArray<single> read txtSize;
    property TabWidth:TArray<single> read tbsSize;
    property TextSettings: TTextSettings read Font;
    property pText: boolean read hasTxt;
    property Text: string read Txt;
    property pAlign: boolean read hasAlign;
    property LayoutAlign: TAlignLayout read Align;
    property LayouBounds:TBounds read Bounds;
    property LayoutMargins:TBounds read margins;
    property pClilds: boolean read hasChilds;
    property Childs:TArray<TFormLayout> read Childrens;

    destructor Destroy; override;
    constructor create(j:TJSONObject);
  end;

  TFormLayouts = TArray<TFormLayout>;

  TDesignManager = class
  private
    layouts: TDictionary<string, TFormLayouts>;

  public
    function tryGetLayout(const form, name: string; var lt: TFormLayout): boolean;
    function tryGetLayouts(const form: string; var lts: TFormLayouts): boolean;

    destructor Destroy; override;
    constructor Create;
  end;

var
  DM: TDesignManager;

implementation

uses
  System.UIConsts, System.Types, System.Math, System.SysUtils,
  FMX.Forms, FMX.Dialogs,
  DataUnit;

  {TFormText}

function TFormLayout.fontFromJSON(const v: TJSONObject): TTextSettings;
var
  val: TJSONValue;
begin
  result:=TTextSettings.Create(nil);
  if v.TryGetValue('Size', val) then
    result.Font.Size:=TJSONNumber(val).AsDouble;
  if v.TryGetValue('Name', val) then
    result.Font.Family:=TJSONString(val).Value;
  if v.TryGetValue('Color', val) then
    result.FontColor:=StringToAlphaColor(TJSONSTring(val).Value);
  if v.TryGetValue('HorzAlign', val) then
    result.HorzAlign:=TTextAlign(TJSONNumber(val).AsInt);
  if v.TryGetValue('VertAlign', val) then
    result.VertAlign:=TTextAlign(TJSONNumber(val).AsInt);
end;

function TFormLayout.boundsFromJSON(const v: TJSONArray): TBounds;
var
  w, h: single;
  r: TRectF;
  i: byte;
begin
  w:=Screen.Width/100;
  h:=Screen.Height/100;
  for i:=0 to v.Count-1 do
  case i of
    0:r.Left:=TJSONNumber(v.Items[0]).AsDouble*w;
    1:r.Top:=TJSONNumber(v.Items[1]).AsDouble*h;
    2:r.Right:=TJSONNumber(v.Items[2]).AsDouble*w;
    3:r.Bottom:=TJSONNumber(v.Items[3]).AsDouble*h;
    else break;
  end;
  result:=TBounds.Create(r);
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

destructor TFormLayout.destroy;
var
  l: TFormLayout;
begin
  Font.Free;
  Bounds.Free;
  Margins.Free;
  for l in Childrens do
    l.Free;
  inherited;
end;

constructor TFormLayout.create(j: TJSONObject);
var
  val: TJSONArray;
  obj: TJSONObject;
  num: TJSONNumber;
  str: TJSONString;
  bool: TJSONBool;
begin
  if j.TryGetValue('Name', str) then n:=str.Value
    else exit;
  if j.TryGetValue('Animation', bool) then Ani:=bool.AsBoolean
    else Ani:=true;
  if j.TryGetValue('TextSize', val) then
    fillArr<single>(val, fillSingl, TxtSize);
  if j.TryGetValue('TabsSize', val) then
    fillArr<single>(val, fillSingl, TbsSize);
  if j.TryGetValue('Font', obj) then
    Font:=fontFromJSON(obj);
  if j.TryGetValue('Align', num) then
  begin
    Align:=TAlignLayout(num.AsInt);
    hasAlign:=true;
  end;
  if j.TryGetValue('Text', str) then
  begin
    Txt:=str.Value;
    hasTxt:=true;
  end;
  if j.TryGetValue('Bounds', val) then
    bounds:=boundsFromJSON(val);
  if j.TryGetValue('Margins', val) then
    margins:=boundsFromJSON(val);
  if j.TryGetValue('Childrens', val) and (Val.Count>0) then
  begin
    fillArr<TFormLayout>(val, fillLayout, childrens);
    hasChilds:=true;
  end;
end;

  {TDesignManager}

function TDesignManager.tryGetLayouts(const form: string; var lts: TFormLayouts): boolean;
begin
  result:=Layouts.ContainsKey(form);
  if result then
    lts:=Layouts[form];
end;

function TDesignManager.tryGetLayout(const form, name: string; var lt: TFormLayout): boolean;
var
  lts: TFormLayouts;

  function tryFindName(const m: TArray<TFormLayout>): boolean;
  var
    i: byte;
  begin
    result:=false;
    if Assigned(m) and (length(m)>0) then
    begin
      for i:=0 to High(m) do
      begin
        if m[i].Name=name then
        begin
          result:=true;
          lt:=m[i];
          exit;
        end;
        if m[i].pClilds then result:=tryFindName(m[i].Childrens);
        if result then exit;
      end;
    end;
  end;

begin
  result:=tryGetLayouts(form, lts) and tryFindName(lts);
end;

destructor TDesignManager.destroy;
var
  p: TPair<string, TFormLayouts>;
  l: TFormLayout;
begin
  for p in layouts do
    for l in p.Value do
      l.Free;
  layouts.Free;
  inherited;
end;

constructor TDesignManager.Create;
var
  i, c: byte;
  p: TJSONPair;
  json: TJSONObject;
  val: TJSONValue;
  m: TArray<TFormLayout>;
begin
  layouts:=TDictionary<string, TArray<TFormLayout>>.Create;
  try
    if findTexts(tLayouts) then
    begin
      val:=TJSONObject.ParseJSONValue(getTexts(tLayouts));
      if Assigned(val) and (val is TJSONObject) then
      begin
        json:=val as TJSONObject;
        for p in json do
        begin
          c:=TJSONArray(p.JsonValue).Count;
          if c=0 then continue;
          setlength(m, c);
          for i:=0 to c-1 do
            m[i]:=TFormLayout.create(TJSONArray(p.JsonValue).Items[i] as TJsonObject);
          layouts.Add(p.JsonString.Value, copy(m, 0, c));
          p.Free;
        end;
      end;
    end;
  except
    on E: Exception do
      ShowMessage('DesigneManager error: '+E.Message);
  end;
end;

end.

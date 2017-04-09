unit ImageManager;

interface

uses
  System.Generics.Collections, System.Types,
  FMX.ImgList, FMX.Types,
  ResourcesManager;

type
  TImageManager = class
  private
    loaded: TList<eResource>;
  public
    procedure add(r: eResource);
    procedure remove(r: eResource);
    procedure clear;

    procedure setSize(img:TGlyph; s:TControlSize); overload;
    procedure setSize(img:TGlyph; s:TSizeF); overload;

    destructor Destroy; override;
    constructor Create();
  end;

implementation

uses
  System.Math, System.Classes, System.SysUtils,
  FMX.Graphics, FMX.MultiResBitmap, FMX.Controls, FMX.Dialogs,
  DataUnit;

  {TImageManager}

procedure TImageManager.add(r: eResource);
var
  res: TStyleBook;
  list:TImageList;
  Sor: TCustomSourceItem;
  i:byte;
  procedure LoadPicture(const Source: TCustomSourceItem; const Scale: Single; const pBitmap: TBitmap);
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
  list:=getImgList(r);
  if not loaded.Contains(r) then
  try
    try
      Res:=TStyleBook.Create(nil);
      Res.LoadFromFile(pathResource(r));
      for i:=0 to Res.Style.ChildrenCount-1 do
      begin
        Sor:=List.Source.AddOrSet(Res.Style.Children.Items[i].StyleName, [],[]);
        Sor.MultiResBitmap.SizeKind:=TSizeKind.Source;
        LoadPicture(Sor, 1, (Res.Style.Children.Items[i] as TBitmapObject).Bitmap);
      end;
    except
      on E: exception do
        showMessage(E.Message);
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
    getImgList(r).Source.Clear;
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

destructor TImageManager.Destroy;
begin
  {$IFDEF DEBUG}
    addD(self, 'Destroy');
  {$ENDIF}
  loaded.Free;
  inherited;
end;

// онструктор (загрузка изображений из .style в TImageList)
constructor TImageManager.Create();
begin
  {$IFDEF DEBUG}
    addD(self, 'Create Image Manager');
  {$ENDIF}
  loaded:=TList<eResource>.create;
end;

end.

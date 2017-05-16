unit uMatrix;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.ImgList,
  uFrame;

type
  TMatrixFrame = class(TGFrame)
    Main: TLayout;
    Left: TLayout;
    Img: TGlyph;
    Text: TMemo;
    Nums: TListBox;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    ListBoxItem13: TListBoxItem;
    ListBoxItem14: TListBoxItem;
    ListBoxItem15: TListBoxItem;
    ListBoxItem16: TListBoxItem;
    List: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    procedure ListDragDrop(Sender: TObject; const Data: TDragObject;
      const Point: TPointF);
    procedure ListDragOver(Sender: TObject; const Data: TDragObject;
      const Point: TPointF; var Operation: TDragOperation);
    procedure ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ListMouseLeave(Sender: TObject);
    procedure ListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
  protected
    procedure onFCreate; override;
  public
    procedure onFShow; override;
  end;

implementation

{$R *.fmx}

uses
  System.Generics.Collections,
  DesignManager;

var
  last: TListBoxItem;

procedure TMatrixFrame.onFCreate;
var
  i, id: byte;
  m: single;
  l: TList<TPair<Byte, String>>;
  lt: TFormLayout;
begin
  layouts:=[main];

  if DM.tryGetFormLayout(name, 'List', lt) then m:=lt.FontSize
    else m:=20;

  l:=TList<TPair<Byte, String>>.Create;

  if Assigned(fText) then
  for i:=0 to 7 do
     l.Add(TPair<byte, string>.Create(i, fText.Items[i]));
  for i:=0 to 7 do
  begin
    id:=random(l.Count);
    list.ListItems[i].Tag:=l[id].Key;
    list.ListItems[i].Text:=l[id].Value;
    list.ListItems[i].TextSettings.Font.Size:=m;
    nums.ListItems[i].TextSettings.Font.Size:=m+4;
    l.Delete(id);
  end;
  l.Free;
end;

procedure TMatrixFrame.onFShow;
begin
  List.ItemHeight:=List.Height/8;
  Nums.ItemHeight:=List.Height/8;
  inherited;
end;

procedure TMatrixFrame.ListDragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);

  function check: boolean;
  var
    i:byte;
  begin
    result:=false;
    for i:=0 to 7 do
      with List.ListItems[i] do
        if i<>Tag then exit;
    result:=true;
  end;

begin
  if Assigned(List.ItemByPoint(Point.X, Point.Y)) and Assigned(Last) then
  begin
    List.ItemsExchange(List.ItemByPoint(Point.X, Point.Y), last);
    if check then
    begin
      win;
      setBonus(6);
    end else clicks;
  end;
end;

procedure TMatrixFrame.ListDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
begin
  if sender = Data.Source then
    Operation:=TDragOperation.Move;
end;

procedure TMatrixFrame.ListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Assigned(List.ItemByPoint(X, Y)) then
    last:=List.ItemByPoint(X, Y);
end;

procedure TMatrixFrame.ListMouseLeave(Sender: TObject);
begin
  List.ItemIndex:=-1;
end;

procedure TMatrixFrame.ListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  if Assigned(List.ItemByPoint(X, Y)) then
    List.ItemIndex:=List.ItemByPoint(X, Y).Index;
end;

end.

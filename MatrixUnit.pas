unit MatrixUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  GameForms, FMX.ImgList, FMX.Objects, FMX.Layouts, FMX.ListBox,
  FMX.TabControl, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TMatrixForm = class(TGForm)
    List: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    Left: TLayout;
    Img: TGlyph;
    BG: TGlyph;
    Main: TLayout;
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
    procedure ListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure ListDragOver(Sender: TObject; const Data: TDragObject;
      const Point: TPointF; var Operation: TDragOperation);
    procedure ListDragDrop(Sender: TObject; const Data: TDragObject;
      const Point: TPointF);
    procedure ListMouseLeave(Sender: TObject);
    procedure ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
  protected
    procedure onFormCreate; override;
    procedure addShow; override;
  end;

implementation

{$R *.fmx}

uses
  System.Generics.Collections,
  DesignManager;

var
  last: TListBoxItem;

procedure TMatrixForm.ListDragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
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
      setBonus(7);
    end;
  end;
end;

procedure TMatrixForm.ListDragOver(Sender: TObject; const Data: TDragObject; const Point: TPointF; var Operation: TDragOperation);
begin
  if sender = Data.Source then
    Operation:=TDragOperation.Move;
end;

procedure TMatrixForm.ListMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Assigned(List.ItemByPoint(X, Y)) then
    last:=List.ItemByPoint(X, Y);
end;

procedure TMatrixForm.ListMouseLeave(Sender: TObject);
begin
  List.ItemIndex:=-1;
end;

procedure TMatrixForm.ListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  if Assigned(List.ItemByPoint(X, Y)) then
    List.ItemIndex:=List.ItemByPoint(X, Y).Index;
end;

procedure TMatrixForm.onFormCreate;
var
  i, id: byte;
  m: TArray<single>;
  l: TList<TPair<Byte, String>>;
begin
  backgrounds:=[BG];
  layouts:=[main];

  setItem(0, Text);
  m:=DM.getFormLayout(name, 'List').TextSize;

  l:=TList<TPair<Byte, String>>.Create;
  for i:=0 to 7 do
     l.Add(TPair<byte, string>.Create(i, getItem(i)));
  for i:=0 to 7 do
  begin
    id:=random(l.Count);
    list.ListItems[i].Tag:=l[id].Key;
    list.ListItems[i].Text:=l[id].Value;
    l.Delete(id);
  end;
  l.Free;
end;

procedure TMatrixForm.addShow;
begin
  List.ItemHeight:=List.Height/8;
  Nums.ItemHeight:=List.Height/8;
end;

end.

unit Forms;

interface

uses
  System.UITypes, System.Classes, System.Generics.Collections,
  FMX.Forms, FMX.ImgList, FMX.Objects, FMX.Memo, FMX.Controls, FMX.Ani, FMX.Types, FMX.Layouts, FMX.TabControl,
  ImageManager, TextManager, SoundManager, GameData, ResourcesManager;

type
  TBarForm = class(TForm)
  protected
    fText: TFormText;
    backgrounds: TArray<TGlyph>;
    layouts: TArray<TControl>;

    procedure onCreate; virtual;
    procedure onDestroy; virtual;
  public
    procedure barShow(Sender: TObject); virtual;
    procedure barClose(Sender: TObject; var  Action: TCloseAction); virtual;
    procedure setItem(id: byte; text: TText); overload;
    procedure setItem(id: byte; memo: TMemo); overload;

    constructor Create(AOwner: TComponent); override;
  End;

implementation

uses
  System.Types, System.SysUtils,
  FMX.Dialogs,
  DataUnit, DesignManager;

  {TBarForm}

procedure TBarForm.onCreate;
begin
end;

procedure TBarForm.onDestroy;
begin
end;

procedure TBarForm.barShow(Sender: TObject);
var
  i:byte;
  lts: TFormLayouts;

begin
  if length(layouts)>0 then
  begin
    if DM.tryGetFormLayouts(name, lts) then
      DM.setSz(TArray<TFmxObject>(layouts), lts);

    for i:=1 to High(layouts) do
      TAnimator.AnimateFloat(layouts[i], 'opacity', 1, 0.5);
    TAnimator.AnimateFloatWait(layouts[0], 'opacity', 1, 0.5);
  end;
end;

procedure TBarForm.barClose(Sender: TObject; var  Action: TCloseAction);
var
  i:byte;
begin
  for i:=1 to High(layouts) do
    TAnimator.AnimateFloat(layouts[i], 'opacity', 0, 0.5);
  TAnimator.AnimateFloatWait(layouts[0], 'opacity', 0, 0.5);
end;

procedure TBarForm.setItem(id: byte; text:TText);
begin
  if Assigned(fText) then
    text.text:=fText.Items[id]
  else
    text.text:=''
end;

procedure TBarForm.setItem(id: byte; memo: TMemo);
begin
  memo.Lines.Clear;
  if Assigned(fText) and (length(fText.Items[id])>0) then
    memo.Text:=fText.Items[id];
end;

constructor TBarForm.create(AOwner: TComponent);
var
  i:byte;
begin
  inherited create(AOwner);
  OnShow:=barShow;
  OnClose:=barClose;
  TM.tryGetText(name, fText);

  onCreate;

  if length(backgrounds)>0 then
    for i:=0 to High(backgrounds) do
      IM.setSize(backgrounds[i], screen.Size);

  if length(layouts)>0 then
    for i:=0 to High(layouts) do
      layouts[i].Opacity:=0;
end;

end.

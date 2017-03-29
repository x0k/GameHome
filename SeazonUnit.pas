unit SeazonUnit;

interface

uses
  System.SysUtils, System.Types, System.Classes,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Ani, FMX.ImgList,
  Forms;

type
  TSeazonForm = class(TGForm)
    s0: TLayout;
    s1: TLayout;
    s2: TLayout;
    s3: TLayout;
    img0: TGlyph;
    img1: TGlyph;
    img2: TGlyph;
    img3: TGlyph;
    Main: TLayout;
    t0: TText;
    t1: TText;
    t2: TText;
    t3: TText;
    BG: TGlyph;
    procedure s0Click(Sender: TObject);
    procedure s0MouseEnter(Sender: TObject);
  protected
    procedure addShow; override;
    procedure onFormCreate; override;
  public
    procedure isWin(id: byte);
  end;

implementation

{$R *.fmx}

uses
  FullScreenTabs;

var
  Tabs: FSTabs;

procedure TSeazonForm.onFormCreate;
begin
  backgrounds:=[BG];
  layouts:=[Main];
  Tabs:=FSTabs.create(self, 4, main);
  Tabs.showClick:=isWin;
end;

procedure TSeazonForm.addShow;
begin
  Tabs.setSize(true);
end;

procedure TSeazonForm.s0Click(Sender: TObject);
begin
  Tabs.onClick(TFmxObject(sender).Tag);
end;

procedure TSeazonForm.isWin(id: Byte);
begin
  if id=1 then win;
end;

procedure TSeazonForm.s0MouseEnter(Sender: TObject);
begin
  Tabs.onEnter(TFmxObject(sender).Tag);
end;

end.

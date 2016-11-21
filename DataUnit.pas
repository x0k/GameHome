unit DataUnit;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Media,
  System.ImageList, FMX.ImgList, FMX.MultiResBitmap, FMX.Forms, FMX.Objects,
  system.JSON, Bass, FMX.Filter.Effects;

type
  TPanelData = record
    Last:string;
    SubNames:array of string;
    SubTexts:array of TStrings;
    function Load(name:string):boolean;
  end;
  TDataForm = class(TDataModule)
    Styles: TStyleBook;
    BGList: TImageList;
    SeqList: TImageList;
    OtherList: TImageList;
    LogoList: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    function GetList(i:byte):TImageList;
  public
    function LBass:boolean;
    procedure SetVol(v:single);
    procedure Load(i:byte);
    procedure Play;
    procedure LoadImg(l,p:byte; img:Timage);
    procedure LoadScaleImg(l,p:byte; img:Timage);
    procedure LoadSeqImgs(l,p:byte; mass:array of Timage);
    function LoadText:boolean;
  end;

const
  f:array[0..2]of string = ('s0.wav','s1.wav','s2.wav');

var
  DataForm: TDataForm;
  vis:array[1..17] of boolean;
  lev:array[1..14] of byte;
  vol:single = 0.2;
  Texts:TJSONObject;
  PData:TPanelData;
  bSt,mSt:HSTREAM;
  Eff:TContrastEffect;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses Winapi.Windows, system.IOUtils;

procedure TDataForm.SetVol;
begin
  Vol:=v;
  Bass_ChannelSetAttribute(mSt, BASS_ATTRIB_VOL, vol);
  Bass_ChannelSetAttribute(bSt, BASS_ATTRIB_VOL, vol/2);
end;

procedure TDataForm.DataModuleCreate(Sender: TObject);
begin
  Eff:=TContrastEffect.Create(self);
  Eff.Contrast:=1;
  Eff.Brightness:=0;
end;

function TDataForm.GetList(i: Byte):TImageList;
begin
  case i of
    0:result:=BGList;
    1:result:=SeqList;
    2:result:=LogoList;
    3:result:=OtherList;
    else result:=nil;
  end;
end;

procedure TDataForm.LoadImg(l,p:byte; img:Timage);
begin
  img.Bitmap.Assign(GetList(l).Source.Items[p].MultiResBitmap.Items[0].Bitmap);
end;

procedure TDataForm.LoadScaleImg(l,p:byte; img:TImage);
begin
  with GetList(l).Source.Items[p].MultiResBitmap.Items[0] do
  begin
    if (Img.Width-Width)>(img.Height-height) then Scale:=Width/img.Width
     else Scale:=Height/img.Height;
    img.Bitmap.Assign(Bitmap);
  end;
end;

procedure TDataForm.LoadSeqImgs(l,p:byte; mass:array of Timage);
var
  i, m: Integer;
begin
  m:=length(mass);
  for i:=0 to m-1 do
    with GetList(l).Source.Items[i+p].MultiResBitmap.Items[0] do
    begin
      if (mass[i].Width-Width)>(mass[i].Height-height) then Scale:=Width/mass[i].Width
        else Scale:=Height/mass[i].Height;
      mass[i].Bitmap.Assign(Bitmap);
    end;
end;

function TDataForm.LoadText:boolean;
var
  f:string;
begin
  result:=false;
  f:=TPath.Combine(TPath.GetLibraryPath, 'text.json');
  if TFile.Exists(f) then
    Texts:=TJSONObject(TJSONObject.ParseJSONValue(TFile.ReadAllText(f,TEncoding.BigEndianUnicode)))
  else result:=true;
end;

function TPanelData.Load(name:string):boolean;
var
  i,j:byte;
  ss:TStringList;
  Form:TJsonObject;
  STexts,Strs,SNames:TJsonArray;
begin
  result:=false;
  Form:=TJSONObject(TJSONObject.ParseJSONValue(Texts.GetValue(name).ToJSON));
  //SubNames
  SNames:=TJsonObject.ParseJSONValue(Form.GetValue('SubNames').ToJSON) as TJsonArray;
  Setlength(SubNames,SNames.Count);
  for i:=0 to SNames.Count-1 do SubNames[i]:=SNames.Items[i].Value;
  //SubTexts
  STexts:=TJsonObject.ParseJSONValue(Form.GetValue('SubTexts').ToJSON) as TJsonArray;
  Setlength(SubTexts,STexts.Count);
  for i:=0 to STexts.Count-1 do
  begin
    Strs:=TJsonObject.ParseJSONValue(STexts.Items[i].ToJSON) as TJsonArray;
    ss:=TStringList.Create;
    for j:=0 to Strs.Count-1 do ss.Add(Strs.Items[j].Value);
    SubTexts[i]:=ss;
  end;
  last:=name;
  if length(SubNames)+Length(SubTexts)=0 then result:=true;
end;

function TDataForm.LBass:boolean;
begin
  result:=true;
  if BASS_Init(-1, 44100, 0, 0, nil) then result:=false;
end;

procedure TDataForm.Play;
begin
  Bass_ChannelPlay(mSt,true);
end;

procedure TDataForm.Load(i: Byte);
begin
  if mSt <> 0 then Bass_StreamFree(mSt);
  mSt:=BASS_StreamCreateFile(false,pchar(TPath.Combine(TPath.GetLibraryPath, 's\'+f[i])),0,0,BASS_UNICODE);
  SetVol(vol);
end;

end.

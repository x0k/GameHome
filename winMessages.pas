unit winMessages;

interface

uses
  System.SysUtils,
  FMX.Platform.Win,
  windows, Messages;

type
  Comands = (cOpen, cSetCount, cUpCount, cClose);

  procedure sendMsg(const cmd: Comands; const s: string = String.Empty);
  procedure setHandle;

implementation

var
  m: boolean;
  hdl: Cardinal;
  msg: TCopyDataStruct;

procedure setHandle;
begin
  hdl:=0;
  m:=not ((ParamCount>0) and Cardinal.TryParse(ParamStr(ParamCount), hdl));
end;

procedure sendMsg(const cmd: Comands; const s: string = String.Empty);
begin
  if m then exit;
  msg.dwData:=ord(cmd);
  msg.cbData:=sizeOf(s)*Length(s);
  GetMem(msg.lpData, msg.cbData);
  try
    StrPCopy(msg.lpData, s);
    SendMessage(hdl, WM_COPYDATA, FMX.Platform.Win.ApplicationHWND, Integer(@msg));
  finally
    FreeMem(msg.lpData, msg.cbData);
  end;
end;

end.

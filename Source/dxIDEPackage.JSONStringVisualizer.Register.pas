//Once installed, you can also see your visualizer in
// the Debugger Options | Visualizers section of the Tools | Options dialog.
unit dxIDEPackage.JSONStringVisualizer.Register;

interface

uses
  ToolsAPI;

  procedure Register;

var
  pubJSONVisualizer:IOTADebuggerVisualizer;


implementation
uses
  System.SysUtils,
  dxIDEPackage.JSONStringVisualizer.ExternalViewer;


procedure Register;
begin
  pubJSONVisualizer := TJSONStringDebugVisualizer.Create();
  (BorlandIDEServices as IOTADebuggerServices).RegisterDebugVisualizer(pubJSONVisualizer);
end;


procedure RemoveVisualizer();
var
  vDebuggerServices:IOTADebuggerServices;
begin
  if Supports(BorlandIDEServices, IOTADebuggerServices, vDebuggerServices) then
  begin
    vDebuggerServices.UnregisterDebugVisualizer(pubJSONVisualizer);
    pubJSONVisualizer := nil;
  end;
end;


initialization

finalization
  RemoveVisualizer();

end.

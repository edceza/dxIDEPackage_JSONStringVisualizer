unit dxIDEPackage.JSONStringVisualizer.ExternalViewer;

interface

uses
  ToolsAPI;

type

  TJSONStringDebugVisualizer = class(TInterfacedObject,
                                     IOTADebuggerVisualizer,
                                     IOTADebuggerVisualizerExternalViewer)
  public

    {IOTADebuggerVisualizer}
    function GetSupportedTypeCount():Integer;
    procedure GetSupportedType(aIndex:Integer; var aTypeName:String; var vAllDescendants:Boolean);
    function GetVisualizerIdentifier():String;
    function GetVisualizerName():String;
    function GetVisualizerDescription():String;

    {IOTADebuggerVisualizerExternalViewer}
    function GetMenuText():String;
    function Show(const aExpression:String; const aTypeName:String; const aEvalResult:String;
                  aSuggestedleft:Integer; aSuggestedTop:Integer):IOTADebuggerVisualizerExternalViewerUpdater;
  end;


implementation
uses
  Vcl.Forms,
  dxIDEPackage.JSONStringVisualizer.DisplayFrame,
  dxIDEPackage.JSONStringVisualizer.DockableForm;


resourcestring
  JSONString_VisualizerName = 'dxIDEPackage JSON String Visualizer for Delphi';
  JSONString_VisualizerDescription = 'Used on strings in JSON format - reformats the JSON into a more easily readable form (JSON pretty printer)';
  JSONString_VisualizerMenuText = 'View string as formatted JSON';


function TJSONStringDebugVisualizer.GetMenuText():String;
begin
  Result := JSONString_VisualizerMenuText;
end;


procedure TJSONStringDebugVisualizer.GetSupportedType(aIndex:Integer;
                                                      var aTypeName:String;
                                                      var vAllDescendants:Boolean);
begin
  aTypeName := 'string';
  vAllDescendants := True;
end;


function TJSONStringDebugVisualizer.GetSupportedTypeCount:Integer;
begin
  Result := 1;
end;


function TJSONStringDebugVisualizer.GetVisualizerDescription():String;
begin
  Result := JSONString_VisualizerDescription;
end;


function TJSONStringDebugVisualizer.GetVisualizerIdentifier():String;
begin
  Result := ClassName;
end;


function TJSONStringDebugVisualizer.GetVisualizerName():String;
begin
  Result := JSONString_VisualizerName;
end;


function TJSONStringDebugVisualizer.Show(const aExpression:String;
                                         const aTypeName:String;
                                         const aEvalResult:String;
                                         aSuggestedleft:Integer;
                                         aSuggestedTop:Integer):IOTADebuggerVisualizerExternalViewerUpdater;
var
  vForm:TCustomForm;
  vFrame:TJSONStringDebugVisualizerFrame;
  vDockForm: INTACustomDockableForm;
begin
  vDockForm := TJSONStringDebugVisualizerForm.Create(aExpression) as INTACustomDockableForm;
  vForm := (BorlandIDEServices as INTAServices).CreateDockableForm(vDockForm);
  vForm.Left := aSuggestedLeft;
  vForm.Top := aSuggestedTop;
  (vDockForm as IFrameFormHelper).SetForm(vForm);
  vFrame := (vDockForm as IFrameFormHelper).GetFrame as TJSONStringDebugVisualizerFrame;
  vFrame.CustomDisplay(aExpression, aTypeName, aEvalResult);
  Result := vFrame as IOTADebuggerVisualizerExternalViewerUpdater;
end;


end.

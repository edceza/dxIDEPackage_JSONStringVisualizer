(*
Copyright (c) 2016 Darian Miller
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so, provided that the above copyright notice(s) and this permission notice
appear in all copies of the Software and that both the above copyright notice(s) and this permission notice appear in supporting documentation.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS INCLUDED IN THIS NOTICE BE
LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Except as contained in this notice, the name of a copyright holder shall not be used in advertising or otherwise to promote the sale, use or other
dealings in this Software without prior written authorization of the copyright holder.

As of January 2016, latest version available online at:
  https://github.com/darianmiller/dxIDEPackage_JSONStringVisualizer/
*)
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

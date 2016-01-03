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
unit dxIDEPackage.JSONStringVisualizer.DockableForm;

interface
uses
  ToolsAPI, DesignIntf,
  Vcl.Forms,
  Vcl.ActnList,
  Vcl.ComCtrls,
  Vcl.ImgList,
  Vcl.Menus,
  System.IniFiles,
  dxIDEPackage.JSONStringVisualizer.DisplayFrame;

type

  IFrameFormHelper = interface
    ['{97B8D8F4-CADC-448D-A555-4D358B8D8E04}']
    function GetForm:TCustomForm;
    function GetFrame:TCustomFrame;
    procedure SetForm(aForm:TCustomForm);
    procedure SetFrame(aForm:TCustomFrame);
  end;


  TJSONStringDebugVisualizerForm = class(TInterfacedObject, INTACustomDockableForm, IFrameFormHelper)
  private
    fMyFrame:TJSONStringDebugVisualizerFrame;
    fMyForm:TCustomForm;
    fExpression:String;
  public
    constructor Create(const aExpression:String);

    { INTACustomDockableForm }
    function GetCaption():String;
    function GetIdentifier():String;
    function GetFrameClass():TCustomFrameClass;
    procedure FrameCreated(AFrame:TCustomFrame);
    function GetMenuActionList():TCustomActionList;
    function GetMenuImageList():TCustomImageList;
    procedure CustomizePopupMenu(aPopupMenu:TPopupMenu);
    function GetToolbarActionList():TCustomActionList;
    function GetToolbarImageList():TCustomImageList;
    procedure CustomizeToolBar(aToolBar:TToolBar);
    procedure LoadWindowState(aDesktop:TCustomIniFile; const aSection:String);
    procedure SaveWindowState(aDesktop:TCustomIniFile; const aSection:String; aIsProject:Boolean);
    function GetEditState():TEditState;
    function EditAction(aAction:TEditAction):Boolean;

    { IFrameFormHelper }
    function GetForm():TCustomForm;
    function GetFrame():TCustomFrame;
    procedure SetForm(aForm:TCustomForm);
    procedure SetFrame(aFrame:TCustomFrame);
  end;


implementation
uses
  System.SysUtils;

resourcestring
  JSONString_VisualizerFormCaption = 'JSON String Visualizer for %s';


constructor TJSONStringDebugVisualizerForm.Create(const aExpression:String);
begin
  inherited Create();
  fExpression := aExpression;
end;

procedure TJSONStringDebugVisualizerForm.CustomizePopupMenu(aPopupMenu:TPopupMenu);
begin
end;

procedure TJSONStringDebugVisualizerForm.CustomizeToolBar(aToolBar:TToolBar);
begin
end;

function TJSONStringDebugVisualizerForm.EditAction(aAction:TEditAction):Boolean;
begin
  Result := False;
end;

procedure TJSONStringDebugVisualizerForm.FrameCreated(aFrame:TCustomFrame);
begin
  fMyFrame := TJSONStringDebugVisualizerFrame(aFrame);
end;

function TJSONStringDebugVisualizerForm.GetCaption():String;
begin
  Result := Format(JSONString_VisualizerFormCaption, [fExpression]);
end;

function TJSONStringDebugVisualizerForm.GetEditState():TEditState;
begin
  Result := [];
end;

function TJSONStringDebugVisualizerForm.GetForm():TCustomForm;
begin
  Result := fMyForm;
end;

function TJSONStringDebugVisualizerForm.GetFrame():TCustomFrame;
begin
  Result := fMyFrame;
end;

function TJSONStringDebugVisualizerForm.GetFrameClass():TCustomFrameClass;
begin
  Result := TJSONStringDebugVisualizerFrame;
end;

function TJSONStringDebugVisualizerForm.GetIdentifier():String;
begin
  Result := ClassName;
end;

function TJSONStringDebugVisualizerForm.GetMenuActionList():TCustomActionList;
begin
  Result := nil;
end;

function TJSONStringDebugVisualizerForm.GetMenuImageList():TCustomImageList;
begin
  Result := nil;
end;

function TJSONStringDebugVisualizerForm.GetToolbarActionList():TCustomActionList;
begin
  Result := nil;
end;

function TJSONStringDebugVisualizerForm.GetToolbarImageList():TCustomImageList;
begin
  Result := nil;
end;

procedure TJSONStringDebugVisualizerForm.LoadWindowState(aDesktop:TCustomIniFile; const aSection:String);
begin
end;

procedure TJSONStringDebugVisualizerForm.SaveWindowState(aDesktop:TCustomIniFile; const aSection:String; aIsProject:Boolean);
begin
end;

procedure TJSONStringDebugVisualizerForm.SetForm(aForm:TCustomForm);
begin
  fMyForm := aForm;
  if Assigned(fMyFrame) then
  begin
    fMyFrame.SetForm(fMyForm);
  end;
end;

procedure TJSONStringDebugVisualizerForm.SetFrame(aFrame:TCustomFrame);
begin
   fMyFrame := TJSONStringDebugVisualizerFrame(aFrame);
end;


end.

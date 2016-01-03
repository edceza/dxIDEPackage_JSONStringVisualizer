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

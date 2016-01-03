unit dxIDEPackage.JSONStringVisualizer.DisplayFrame;

interface

uses
  ToolsAPI,
  System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TAvailableState = (asAvailable, asProcRunning, asOutOfScope);

  TJSONStringDebugVisualizerFrame = class(TFrame,
                                          IOTADebuggerVisualizerExternalViewerUpdater,
                                          IOTAThreadNotifier)
    memJSON: TMemo;
    labInfo: TLabel;
  private
    FOwningForm: TCustomForm;
    FClosedProc: TOTAVisualizerClosedProcedure;
    FExpression: string;
    FNotifierIndex: Integer;
    FCompleted: Boolean;
    FDeferredResult: string;
    FDeferredError: Boolean;
    FAvailableState: TAvailableState;
    function Evaluate(Expression: string): string;
  protected
    procedure SetParent(AParent: TWinControl); override;
  public
    {TJSONStringDebugVisualizerFrame}
    procedure SetForm(AForm: TCustomForm);
    procedure CustomDisplay(const Expression, TypeName, EvalResult: string);

    {IOTADebuggerVisualizerExternalViewerUpdater}
    procedure CloseVisualizer;
    procedure MarkUnavailable(Reason: TOTAVisualizerUnavailableReason);
    procedure RefreshVisualizer(const Expression, TypeName, EvalResult: string);
    procedure SetClosedCallback(ClosedProc: TOTAVisualizerClosedProcedure);

    {IOTAThreadNotifier}
    procedure ThreadNotify(Reason: TOTANotifyReason);
    procedure EvaluteComplete(const ExprStr, ResultStr: string; CanModify: Boolean;
      ResultAddress, ResultSize: LongWord; ReturnCode: Integer);
    procedure ModifyComplete(const ExprStr, ResultStr: string; ReturnCode: Integer);

    {IOTANotifier}
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;
  end;



implementation

uses
  System.SysUtils,
  dxIDEPackage.JSONStringVisualizer.DockableForm,
  dxLib_JSONFormatter;


{$R *.dfm}

procedure TJSONStringDebugVisualizerFrame.CustomDisplay(const Expression, TypeName, EvalResult: string);
const
  CRLF = '#$D#$A';
var
  vText:String;
begin
  FAvailableState := asAvailable;
  FExpression := Expression;

  try
    //Quick-n-dirty fixup for strings like:
    //{"test":123}'#$D#$A#9'{"test":123}'#$D#$A
    vText := StringReplace(EvalResult, QuotedStr(CRLF), '', [rfReplaceAll]);
    while vText.EndsWith(CRLF) do
    begin
      vText := Copy(vText, 1, Length(vText) - Length(CRLF));
    end;

    memJSON.Text := FormatJSON(vText.DeQuotedString);
    labInfo.Caption := '';
  except
    on E: Exception do
    begin
      memJSON.Text := '';
      labInfo.Caption := 'Error: ' + E.Message;
    end;
  end;

  labInfo.Invalidate;
  memJSON.Invalidate;
  Self.Invalidate;
end;

procedure TJSONStringDebugVisualizerFrame.AfterSave;
begin
end;

procedure TJSONStringDebugVisualizerFrame.BeforeSave;
begin
end;

procedure TJSONStringDebugVisualizerFrame.CloseVisualizer;
begin
  if FOwningForm <> nil then
    FOwningForm.Close;
end;

procedure TJSONStringDebugVisualizerFrame.Destroyed;
begin
end;

function TJSONStringDebugVisualizerFrame.Evaluate(Expression: string): string;
var
  CurProcess: IOTAProcess;
  CurThread: IOTAThread;
  ResultStr: array[0..4095] of Char;
  CanModify: Boolean;
  ResultAddr, ResultSize, ResultVal: LongWord;
  EvalRes: TOTAEvaluateResult;
  DebugSvcs: IOTADebuggerServices;
begin
  begin
    Result := '';
    if Supports(BorlandIDEServices, IOTADebuggerServices, DebugSvcs) then
      CurProcess := DebugSvcs.CurrentProcess;
    if CurProcess <> nil then
    begin
      CurThread := CurProcess.CurrentThread;
      if CurThread <> nil then
      begin
        EvalRes := CurThread.Evaluate(Expression, @ResultStr, Length(ResultStr),
          CanModify, eseAll, '', ResultAddr, ResultSize, ResultVal, '', 0);
        case EvalRes of
          erOK: Result := ResultStr;
          erDeferred:
            begin
              FCompleted := False;
              FDeferredResult := '';
              FDeferredError := False;
              FNotifierIndex := CurThread.AddNotifier(Self);
              while not FCompleted do
                DebugSvcs.ProcessDebugEvents;
              CurThread.RemoveNotifier(FNotifierIndex);
              FNotifierIndex := -1;
              if not FDeferredError then
              begin
                if FDeferredResult <> '' then
                  Result := FDeferredResult
                else
                  Result := ResultStr;
              end;
            end;
          erBusy:
            begin
              DebugSvcs.ProcessDebugEvents;
              Result := Evaluate(Expression);
            end;
        end;
      end;
    end;
  end;
end;

procedure TJSONStringDebugVisualizerFrame.EvaluteComplete(const ExprStr,
  ResultStr: string; CanModify: Boolean; ResultAddress, ResultSize: LongWord;
  ReturnCode: Integer);
begin
  FCompleted := True;
  FDeferredResult := ResultStr;
  FDeferredError := ReturnCode <> 0;
end;

procedure TJSONStringDebugVisualizerFrame.MarkUnavailable(
  Reason: TOTAVisualizerUnavailableReason);
begin
  if Reason = ovurProcessRunning then
  begin
    FAvailableState := asProcRunning;
  end else if Reason = ovurOutOfScope then
    FAvailableState := asOutOfScope;

end;

procedure TJSONStringDebugVisualizerFrame.Modified;
begin

end;

procedure TJSONStringDebugVisualizerFrame.ModifyComplete(const ExprStr,
  ResultStr: string; ReturnCode: Integer);
begin

end;

procedure TJSONStringDebugVisualizerFrame.RefreshVisualizer(const Expression, TypeName,
  EvalResult: string);
begin
  FAvailableState := asAvailable;
  CustomDisplay(Expression, TypeName, EvalResult);
end;

procedure TJSONStringDebugVisualizerFrame.SetClosedCallback(
  ClosedProc: TOTAVisualizerClosedProcedure);
begin
  FClosedProc := ClosedProc;
end;

procedure TJSONStringDebugVisualizerFrame.SetForm(AForm: TCustomForm);
begin
  FOwningForm := AForm;
end;

procedure TJSONStringDebugVisualizerFrame.SetParent(AParent: TWinControl);
begin
  if AParent = nil then
  begin
    if Assigned(FClosedProc) then
      FClosedProc;
  end;
  inherited;
end;

procedure TJSONStringDebugVisualizerFrame.ThreadNotify(Reason: TOTANotifyReason);
begin
end;

end.


object JSONStringDebugVisualizerFrame: TJSONStringDebugVisualizerFrame
  Left = 0
  Top = 0
  Width = 451
  Height = 305
  Align = alClient
  Color = clBtnFace
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object labInfo: TLabel
    Left = 0
    Top = 0
    Width = 451
    Height = 13
    Align = alTop
    Caption = 'Info'
    ExplicitWidth = 20
  end
  object memJSON: TMemo
    Left = 0
    Top = 13
    Width = 451
    Height = 292
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
end

object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'AlwaysOnTopManager'
  ClientHeight = 306
  ClientWidth = 832
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -28
  Font.Name = 'Segoe UI'
  Font.Style = [fsBold]
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 38
  object ListBoxWindows: TListBox
    Left = 0
    Top = 0
    Width = 439
    Height = 266
    AutoComplete = False
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 38
    TabOrder = 0
    OnClick = ListBoxWindowsClick
    ExplicitLeft = -4
    ExplicitTop = -6
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 266
    Width = 832
    Height = 40
    Panels = <
      item
        Alignment = taCenter
        Text = 'Always On Top is On'
        Width = 300
      end>
  end
  object ScrollBox1: TScrollBox
    Left = 439
    Top = 0
    Width = 393
    Height = 266
    Align = alClient
    AutoSize = True
    TabOrder = 2
    object SpeedToggleTop: TSpeedButton
      Left = 0
      Top = 0
      Width = 389
      Height = 128
      Align = alTop
      AllowAllUp = True
      Anchors = [akLeft, akRight]
      GroupIndex = 1
      Caption = 'ALWAYS ON TOP'
      OnClick = SpeedToggleTopClick
    end
    object ButtonRefresh: TButton
      Left = 0
      Top = 128
      Width = 389
      Height = 128
      Align = alTop
      Anchors = [akLeft, akRight]
      Caption = 'REFRESH LIST'
      TabOrder = 0
      OnClick = ButtonRefreshClick
    end
  end
end

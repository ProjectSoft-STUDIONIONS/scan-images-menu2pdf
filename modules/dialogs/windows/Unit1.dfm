object Form1: TForm1
  Left = 0
  Top = 0
  Margins.Right = 5
  BorderIcons = [biSystemMenu]
  Caption = 
    #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1086#1090#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1085#1099#1093' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081' '#1084#1077#1085#1102' '#1074' PDF' +
    ' '#1092#1072#1081#1083#1099
  ClientHeight = 516
  ClientWidth = 553
  Color = clWindow
  Constraints.MinWidth = 500
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 16
  object LabelTypeConvert: TLabel
    AlignWithMargins = True
    Left = 5
    Top = 407
    Width = 543
    Height = 16
    Margins.Left = 5
    Margins.Right = 5
    Align = alBottom
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 4
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 547
    Height = 54
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 5
    ExplicitWidth = 543
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 182
      Height = 48
      Align = alLeft
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'Panel2'
      ParentColor = True
      ShowCaption = False
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 182
        Height = 16
        Align = alTop
        Alignment = taRightJustify
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        ExplicitLeft = 179
        ExplicitWidth = 3
      end
      object Label2: TLabel
        Left = 0
        Top = 16
        Width = 182
        Height = 16
        Align = alTop
        Alignment = taRightJustify
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        ExplicitLeft = 179
        ExplicitWidth = 3
      end
      object Label3: TLabel
        Left = 0
        Top = 32
        Width = 182
        Height = 16
        Align = alTop
        Alignment = taRightJustify
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        ExplicitLeft = 179
        ExplicitWidth = 3
      end
    end
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 191
      Top = 3
      Width = 353
      Height = 48
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'Panel3'
      ParentColor = True
      ShowCaption = False
      TabOrder = 1
      ExplicitWidth = 349
      object DateLabel: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 0
        Width = 343
        Height = 16
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        EllipsisPosition = epPathEllipsis
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnMouseMove = LabelMouseMove
        ExplicitWidth = 278
      end
      object DirectoryLabel: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 16
        Width = 343
        Height = 16
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alTop
        AutoSize = False
        EllipsisPosition = epPathEllipsis
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnMouseMove = LabelMouseMove
        ExplicitWidth = 278
      end
      object MenuLabel: TLabel
        AlignWithMargins = True
        Left = 5
        Top = 32
        Width = 343
        Height = 16
        Margins.Left = 5
        Margins.Top = 0
        Margins.Right = 5
        Align = alTop
        AutoSize = False
        EllipsisPosition = epPathEllipsis
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnMouseMove = LabelMouseMove
        ExplicitWidth = 278
      end
    end
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 0
    Top = 60
    Width = 553
    Height = 42
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 549
    object MonthBox: TComboBox
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 183
      Height = 22
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alLeft
      Style = csOwnerDrawFixed
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = CalendarChange
    end
    object YearBox: TComboBox
      AlignWithMargins = True
      Left = 449
      Top = 18
      Width = 99
      Height = 22
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Style = csOwnerDrawFixed
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnChange = CalendarChange
      ExplicitLeft = 445
    end
  end
  object Calendar1: TCalendar
    AlignWithMargins = True
    Left = 5
    Top = 102
    Width = 543
    Height = 149
    Margins.Left = 5
    Margins.Top = 0
    Margins.Right = 5
    Align = alClient
    Constraints.MinHeight = 148
    GridLineWidth = 2
    ParentColor = True
    ParentShowHint = False
    ShowHint = True
    StartOfWeek = 1
    TabOrder = 1
    OnChange = CalendarChange
    ExplicitWidth = 539
    ExplicitHeight = 148
  end
  object TypeMenuBox: TComboBox
    AlignWithMargins = True
    Left = 5
    Top = 257
    Width = 543
    Height = 22
    Margins.Left = 5
    Margins.Right = 5
    Align = alBottom
    Style = csOwnerDrawFixed
    ParentColor = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnChange = TypeMenuChange
    ExplicitTop = 256
    ExplicitWidth = 539
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 282
    Width = 553
    Height = 122
    Align = alBottom
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    Padding.Left = 5
    Padding.Right = 5
    ParentFont = False
    TabOrder = 7
    ExplicitTop = 281
    ExplicitWidth = 549
    object Panel4: TScrollBox
      Left = 7
      Top = 18
      Width = 539
      Height = 102
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentBackground = True
      ParentFont = False
      TabOrder = 0
      OnMouseMove = PanelMouseMove
      OnMouseWheel = PanelMouseWheel
      ExplicitWidth = 535
    end
  end
  object ComboTypeConvert: TComboBox
    AlignWithMargins = True
    Left = 5
    Top = 429
    Width = 543
    Height = 22
    Margins.Left = 5
    Margins.Right = 5
    Align = alBottom
    Style = csOwnerDrawFixed
    ItemIndex = 0
    ParentColor = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = 'convert'
    Items.Strings = (
      'convert'
      'magick')
    ExplicitTop = 428
    ExplicitWidth = 539
  end
  object DialogButton: TButton
    AlignWithMargins = True
    Left = 5
    Top = 457
    Width = 543
    Height = 25
    Margins.Left = 5
    Margins.Right = 5
    Align = alBottom
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = DialogButtonClick
    ExplicitTop = 456
    ExplicitWidth = 539
  end
  object StartButton: TButton
    AlignWithMargins = True
    Left = 5
    Top = 488
    Width = 543
    Height = 25
    Margins.Left = 5
    Margins.Right = 5
    Align = alBottom
    ModalResult = 1
    TabOrder = 4
    ExplicitTop = 487
    ExplicitWidth = 539
  end
  object ImageList1: TImageList
    Left = 24
    Top = 8
    Bitmap = {
      494C010101000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006C6C6CFF6C6C6CFF000000FF0B0B0BFF010101FF030303FF0000
      00FF000000570000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00FF030303FF2A2A2AFFA2A2A2FF6E6E6EFF636363FF484848FF040404FF0000
      00FF000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000050505FF0000
      00FF2E2E2EFF555656FF5C5C5CFF6D6A69FF7E7D7BFF373534FF070707FF0202
      02FF0B0B0BFF000000FF030303FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004F4F4F57000000FF0000
      00FF252525FF000000FF131414FF40352AFFF0E8D9FF000000FF030303FF0000
      00FF020202FF0B0B0BFF040404FF000000570000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000888888FFCDCDCDFF0000
      00FF5C5C5CFFE4E2E0FFEDEBEAFFEEE8E5FFCABFB6FFFEEED9FF494645FF3736
      34FF1E1E1EFF020202FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000024242450000000FF353432FF0000
      00FF000000FFE6E6E6FFCBC7C3FFBCB7B4FFD8D4CEFFF2F1ECFFA99483FF4E4C
      4BFF000000FF000000FF2E2C2CFF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000DB9E9E9EFFA09F9FFF7875
      71FF3F3F3FFF949494FF98928EFF79726CFFDCD5C7FFD9BEABFF897767FFAAAA
      A8FF000000FFECECEBFF272727FF020202FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000FC050505FF3D3D3DFF5050
      50FF4F4F4FFF282623FF909090FF989898FF8C8079FFAA8F7CFF545452FF6B69
      67FF000000FF4B4B4BFF030303FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000DB000000FF020202FF1212
      12FF575757FF545454FF434343FF7C7D7DFF969491FF000000FF000000FF3536
      36FF000000FF0A0A0AFF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000050000000FF000000FF0000
      00FF000000FF000000FF040404FF6D6D6DFFDAD7D3FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000FF000000FF0000
      00FF000000FF000000FF000000FFC5C0B9FFA7A8A8FF78736EFF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000FF0000
      00FF000000FF000000FF101111FFBEBAB8FFE0D8D0FF595552FF000000FF0000
      00FF000000FF000000FF000000FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000FF0000
      00FF000000FF000000FF000000FFB8B5B3FF8B8582FF2B2928FF060606FF0000
      00FF000000FF000000FF000000FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00FF000000FF000000FF000000FFFFFFFFFFA6A6A6FF020202FF000000FF0000
      00FF000000FF000000FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000FF000000FF1F1F1FFF151515FF000000FF000000FF0000
      00FF000000570000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000050020202DB020202FC000000DB000000500000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end

object FootageForm: TFootageForm
  Left = 0
  Top = 0
  Caption = 'FootageForm'
  ClientHeight = 454
  ClientWidth = 858
  Color = clHighlight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object imgFootage: TImage
    Left = 0
    Top = 0
    Width = 857
    Height = 385
    Stretch = True
  end
  object bmbClose: TBitBtn
    Left = 328
    Top = 399
    Width = 209
    Height = 47
    DoubleBuffered = True
    Kind = bkClose
    ParentDoubleBuffered = False
    TabOrder = 0
    OnClick = bmbCloseClick
  end
end

object StaffForm: TStaffForm
  Left = 0
  Top = 0
  Caption = 'StaffForm'
  ClientHeight = 555
  ClientWidth = 1117
  Color = clHighlight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object pgcStaff: TPageControl
    Left = 24
    Top = 32
    Width = 1065
    Height = 505
    ActivePage = tbsDashboard
    TabOrder = 0
    object tbsDashboard: TTabSheet
      Caption = 'Dashboard'
      object lblActiveDrones: TLabel
        Left = 16
        Top = 96
        Width = 117
        Height = 17
        Caption = 'ACTIVE DRONES'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSuburbStatus: TLabel
        Left = 536
        Top = 96
        Width = 117
        Height = 17
        Caption = 'SUBURB STATUS'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object grpDroneStatus: TGroupBox
        Left = 16
        Top = 16
        Width = 409
        Height = 65
        Caption = ' Active Drones '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object lblDemand: TLabel
          Left = 314
          Top = 30
          Width = 79
          Height = 18
          Alignment = taRightJustify
          Caption = 'lblDemand'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblNumberDrones: TLabel
          Left = 224
          Top = 30
          Width = 89
          Height = 18
          Caption = 'lblNumDrones'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object pgbDrones: TProgressBar
          Left = 16
          Top = 32
          Width = 202
          Height = 17
          Max = 20
          Position = 18
          Smooth = True
          TabOrder = 0
        end
      end
      object dbgSuburbStatus: TDBGrid
        Left = 536
        Top = 112
        Width = 496
        Height = 321
        DataSource = dtsSuburbStatus
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object bmbRefreshDashboard: TBitBtn
        Left = 936
        Top = 439
        Width = 97
        Height = 25
        Caption = '&Refresh'
        DoubleBuffered = True
        Kind = bkRetry
        ParentDoubleBuffered = False
        TabOrder = 2
        OnClick = bmbRefreshDashboardClick
      end
      object dbgActiveDrones: TDBGrid
        Left = 16
        Top = 112
        Width = 489
        Height = 321
        DataSource = dtsActiveDrones
        ReadOnly = True
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object tbsAnalyseSurveillance: TTabSheet
      Caption = 'Analyse Surveillance'
      ImageIndex = 1
      TabVisible = False
      object dbgDroneSurveillance: TDBGrid
        Left = 16
        Top = 16
        Width = 633
        Height = 329
        DataSource = dtsAnalyseSurveillance
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = dbgDroneSurveillanceCellClick
      end
      object grpSurveillanceReport: TGroupBox
        Left = 672
        Top = 16
        Width = 361
        Height = 441
        Caption = ' Surveillance Report '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object imgSurveillance: TImage
          Left = 16
          Top = 33
          Width = 329
          Height = 145
          Stretch = True
        end
        object lblDescription: TLabel
          Left = 104
          Top = 200
          Width = 162
          Height = 17
          Caption = 'Choose Description'
        end
        object redSummary: TRichEdit
          Left = 16
          Top = 272
          Width = 329
          Height = 153
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cbxSummary: TComboBox
          Left = 16
          Top = 223
          Width = 329
          Height = 25
          ItemIndex = 0
          TabOrder = 1
          Text = 'False Alarm'
          OnChange = cbxSummaryChange
          Items.Strings = (
            'False Alarm'
            'All Clear'
            'Suspicious Activity'
            'Breaking or Entering Property'
            'Write Own Description')
        end
      end
      object btnSubmit: TButton
        Left = 216
        Top = 376
        Width = 265
        Height = 57
        Caption = 'Submit Analysis'
        Enabled = False
        TabOrder = 2
        OnClick = btnSubmitClick
      end
      object bmbRefreshAnalyseSurv: TBitBtn
        Left = 552
        Top = 351
        Width = 97
        Height = 25
        Caption = '&Refresh'
        DoubleBuffered = True
        Kind = bkRetry
        ParentDoubleBuffered = False
        TabOrder = 3
        OnClick = bmbRefreshAnalyseSurvClick
      end
    end
    object tbsDroneManagement: TTabSheet
      Caption = 'Drone Management'
      ImageIndex = 2
      TabVisible = False
      object dbgDrones: TDBGrid
        Left = 24
        Top = 240
        Width = 593
        Height = 185
        DataSource = dsrDrones
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = dbgDronesCellClick
      end
      object bmbRefreshDrones: TBitBtn
        Left = 520
        Top = 431
        Width = 97
        Height = 25
        Caption = '&Refresh'
        DoubleBuffered = True
        Kind = bkRetry
        ParentDoubleBuffered = False
        TabOrder = 1
        OnClick = bmbRefreshDronesClick
      end
      object grpChangeDroneStatus: TGroupBox
        Left = 640
        Top = 232
        Width = 385
        Height = 224
        Caption = ' Edit Drone Details '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object lblSuburb: TLabel
          Left = 40
          Top = 97
          Width = 54
          Height = 17
          Caption = 'Suburb'
        end
        object lblEditDroneType: TLabel
          Left = 43
          Top = 157
          Width = 90
          Height = 17
          Caption = 'Drone Type'
        end
        object lblDroneStatus: TLabel
          Left = 195
          Top = 34
          Width = 54
          Height = 17
          Caption = 'Status'
        end
        object ledEditSerialNumber: TLabeledEdit
          Left = 40
          Top = 56
          Width = 137
          Height = 25
          EditLabel.Width = 117
          EditLabel.Height = 17
          EditLabel.Caption = 'Serial Number'
          MaxLength = 7
          TabOrder = 0
        end
        object cbxEditSuburb: TComboBox
          Left = 40
          Top = 119
          Width = 185
          Height = 25
          TabOrder = 1
        end
        object cbxEditDroneType: TComboBox
          Left = 40
          Top = 181
          Width = 241
          Height = 25
          TabOrder = 2
        end
        object btnSaveDetails: TButton
          Left = 248
          Top = 120
          Width = 113
          Height = 41
          Caption = 'Save Details'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnSaveDetailsClick
        end
        object cbxDroneStatus: TComboBox
          Left = 197
          Top = 55
          Width = 148
          Height = 25
          TabOrder = 4
          Items.Strings = (
            'Active'
            'Inactive'
            'Being Repaired'
            'Decomissioned')
        end
      end
      object grpNewDrone: TGroupBox
        Left = 24
        Top = 17
        Width = 593
        Height = 209
        Caption = ' Add New Drone '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object lblSuburbs: TLabel
          Left = 56
          Top = 79
          Width = 54
          Height = 17
          Caption = 'Suburb'
        end
        object lblDroneType: TLabel
          Left = 304
          Top = 81
          Width = 90
          Height = 17
          Caption = 'Drone Type'
        end
        object rdbGenerateSerialNum: TRadioButton
          Left = 32
          Top = 40
          Width = 185
          Height = 17
          Caption = 'Generated Serial Number'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
          OnClick = rdbGenerateSerialNumClick
        end
        object rdbUniqueSerailNum: TRadioButton
          Left = 235
          Top = 40
          Width = 161
          Height = 17
          Caption = 'Unique Serial Number:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = rdbUniqueSerailNumClick
        end
        object edtNewSerialNumber: TEdit
          Left = 402
          Top = 39
          Width = 159
          Height = 25
          Enabled = False
          MaxLength = 7
          TabOrder = 2
        end
        object cbxSuburbsDrones: TComboBox
          Left = 56
          Top = 103
          Width = 209
          Height = 25
          TabOrder = 3
        end
        object cbxDroneType: TComboBox
          Left = 304
          Top = 103
          Width = 241
          Height = 25
          TabOrder = 4
        end
        object bmbDroneRetry: TBitBtn
          Left = 294
          Top = 152
          Width = 155
          Height = 41
          DoubleBuffered = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkRetry
          ParentDoubleBuffered = False
          ParentFont = False
          TabOrder = 5
          OnClick = bmbDroneRetryClick
        end
        object btnAddDrone: TButton
          Left = 126
          Top = 152
          Width = 155
          Height = 41
          Caption = 'Add Drone'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = btnAddDroneClick
        end
      end
      object rgpSortDrones: TRadioGroup
        Left = 736
        Top = 40
        Width = 217
        Height = 161
        Caption = ' Sort Displayed Drones '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          ' Serial Number'
          ' Suburb'
          ' Drone Type'
          ' Status')
        ParentFont = False
        TabOrder = 4
        OnClick = rgpSortDronesClick
      end
    end
    object tbsSuburbManagement: TTabSheet
      Caption = 'Suburb Management'
      ImageIndex = 3
      TabVisible = False
      object grpAddSuburb: TGroupBox
        Left = 248
        Top = 17
        Width = 593
        Height = 248
        Caption = ' Add New Suburb '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object rdbRecommendedSuburb: TRadioButton
          Left = 32
          Top = 40
          Width = 217
          Height = 17
          Caption = 'Add A Recommended Suburb:'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
          OnClick = rdbRecommendedSuburbClick
        end
        object rdbEnterSuburbDetails: TRadioButton
          Left = 32
          Top = 72
          Width = 209
          Height = 17
          Caption = 'Manually Enter Suburb Details'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = rdbEnterSuburbDetailsClick
        end
        object bmbSuburbRetry: TBitBtn
          Left = 294
          Top = 184
          Width = 155
          Height = 41
          DoubleBuffered = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkRetry
          ParentDoubleBuffered = False
          ParentFont = False
          TabOrder = 2
          OnClick = bmbSuburbRetryClick
        end
        object btnAddSuburb: TButton
          Left = 126
          Top = 184
          Width = 155
          Height = 41
          Caption = 'Add Suburb'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnAddSuburbClick
        end
        object cbxRecommendedSuburbs: TComboBox
          Left = 320
          Top = 36
          Width = 217
          Height = 25
          TabOrder = 4
          Text = 'cbxRecommendedSuburbs'
        end
        object ledNewSuburbName: TLabeledEdit
          Left = 72
          Top = 128
          Width = 193
          Height = 25
          EditLabel.Width = 99
          EditLabel.Height = 17
          EditLabel.Caption = 'Suburb Name'
          Enabled = False
          TabOrder = 5
        end
        object ledNewSubPostCode: TLabeledEdit
          Left = 320
          Top = 128
          Width = 193
          Height = 25
          EditLabel.Width = 99
          EditLabel.Height = 17
          EditLabel.Caption = 'Postal Code'
          Enabled = False
          TabOrder = 6
        end
      end
      object dbgSuburbs: TDBGrid
        Left = 312
        Top = 288
        Width = 305
        Height = 137
        DataSource = dsrSuburbs
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = dbgSuburbsCellClick
      end
      object rgpSortSuburbs: TRadioGroup
        Left = 48
        Top = 313
        Width = 234
        Height = 88
        Caption = ' Sort Desplayed Suburbs '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'A to Z'
          'Z to A')
        ParentFont = False
        TabOrder = 2
        OnClick = rgpSortSuburbsClick
      end
      object grpEditOrDelete: TGroupBox
        Left = 648
        Top = 280
        Width = 385
        Height = 177
        Caption = ' Edit or Delete Suburb '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object ledSuburbName: TLabeledEdit
          Left = 32
          Top = 56
          Width = 186
          Height = 25
          EditLabel.Width = 99
          EditLabel.Height = 17
          EditLabel.Caption = 'Suburb Name'
          TabOrder = 0
        end
        object ledPostalCode: TLabeledEdit
          Left = 32
          Top = 120
          Width = 186
          Height = 25
          EditLabel.Width = 99
          EditLabel.Height = 17
          EditLabel.Caption = 'Postal Code'
          TabOrder = 1
        end
      end
      object btnSaveEditSuburb: TButton
        Left = 888
        Top = 358
        Width = 129
        Height = 43
        Caption = 'Save Details'
        Enabled = False
        TabOrder = 4
        OnClick = btnSaveEditSuburbClick
      end
      object bmbRefreshSuburbs: TBitBtn
        Left = 520
        Top = 431
        Width = 97
        Height = 25
        Caption = '&Refresh'
        DoubleBuffered = True
        Kind = bkRetry
        ParentDoubleBuffered = False
        TabOrder = 5
        OnClick = bmbRefreshSuburbsClick
      end
    end
    object tbsStaffManagement: TTabSheet
      Caption = 'Staff Management'
      ImageIndex = 4
      TabVisible = False
      object grpAddStaffMember: TGroupBox
        Left = 16
        Top = 240
        Width = 1001
        Height = 217
        Caption = ' Add Staff Member '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object lblJobTitle: TLabel
          Left = 497
          Top = 93
          Width = 81
          Height = 17
          Caption = 'Job Title'
        end
        object ledStaffName: TLabeledEdit
          Left = 108
          Top = 48
          Width = 329
          Height = 25
          EditLabel.Width = 36
          EditLabel.Height = 17
          EditLabel.Caption = 'Name'
          TabOrder = 0
        end
        object ledStaffSurname: TLabeledEdit
          Left = 497
          Top = 48
          Width = 329
          Height = 25
          EditLabel.Width = 63
          EditLabel.Height = 17
          EditLabel.Caption = 'Surname'
          TabOrder = 1
        end
        object ledStaffEmail: TLabeledEdit
          Left = 108
          Top = 112
          Width = 329
          Height = 25
          EditLabel.Width = 45
          EditLabel.Height = 17
          EditLabel.Caption = 'Email'
          TabOrder = 2
        end
        object cbxJobTitles: TComboBox
          Left = 497
          Top = 112
          Width = 329
          Height = 25
          TabOrder = 3
        end
        object btnAddStaffMember: TButton
          Left = 281
          Top = 152
          Width = 193
          Height = 49
          Caption = 'Add Staff Member'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = btnAddStaffMemberClick
        end
        object bmbRetryAddStaff: TBitBtn
          Left = 497
          Top = 152
          Width = 193
          Height = 49
          DoubleBuffered = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkRetry
          ParentDoubleBuffered = False
          ParentFont = False
          TabOrder = 5
          OnClick = bmbRetryAddStaffClick
        end
      end
      object btnDeactivateReactivateStaff: TButton
        Left = 409
        Top = 192
        Width = 192
        Height = 42
        Caption = 'Deactivate Staff Member'
        Enabled = False
        TabOrder = 1
        OnClick = btnDeactivateReactivateStaffClick
      end
      object dbgStaff: TDBGrid
        Left = 16
        Top = 16
        Width = 999
        Height = 170
        DataSource = dtsStaff
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = dbgStaffCellClick
      end
      object bmbRefreshStaff: TBitBtn
        Left = 920
        Top = 192
        Width = 97
        Height = 25
        Caption = '&Refresh'
        DoubleBuffered = True
        Kind = bkRetry
        ParentDoubleBuffered = False
        TabOrder = 3
        OnClick = bmbRefreshStaffClick
      end
    end
    object tbsFlightLogs: TTabSheet
      Caption = 'Flight Logs'
      ImageIndex = 5
      TabVisible = False
      object dbgFlightLogs: TDBGrid
        Left = 16
        Top = 208
        Width = 1025
        Height = 225
        DataSource = dsrFlightLogs
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object rgpSortFlightLogs: TRadioGroup
        Left = 64
        Top = 16
        Width = 305
        Height = 178
        Caption = ' Sort Flight Logs '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          ' Suburb'
          ' Drone Type'
          ' Latest To Earliest Response'
          ' Earliest To Latest Response'
          ' Assigned Staffs Name')
        ParentFont = False
        TabOrder = 1
        OnClick = rgpSortFlightLogsClick
      end
      object grpFlightLogDates: TGroupBox
        Left = 408
        Top = 16
        Width = 273
        Height = 178
        Caption = ' Dates '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object lblLatestDate: TLabel
          Left = 32
          Top = 42
          Width = 117
          Height = 17
          Caption = 'Earliest Date'
        end
        object lblDate: TLabel
          Left = 34
          Top = 105
          Width = 99
          Height = 17
          Caption = 'Latest Date'
        end
        object dtpEarliestDate: TDateTimePicker
          Left = 32
          Top = 64
          Width = 186
          Height = 25
          Date = 43948.534691087960000000
          Time = 43948.534691087960000000
          TabOrder = 0
          OnChange = dtpEarliestDateChange
        end
        object dtpLatestDate: TDateTimePicker
          Left = 31
          Top = 127
          Width = 186
          Height = 25
          Date = 43948.534691087960000000
          Time = 43948.534691087960000000
          TabOrder = 1
          OnChange = dtpLatestDateChange
        end
      end
      object bmbRefreshFlighLogs: TBitBtn
        Left = 944
        Top = 439
        Width = 97
        Height = 25
        Caption = '&Refresh'
        DoubleBuffered = True
        Kind = bkRetry
        ParentDoubleBuffered = False
        TabOrder = 3
        OnClick = bmbRefreshFlighLogsClick
      end
      object rgpFlighStatus: TRadioGroup
        Left = 712
        Top = 16
        Width = 273
        Height = 105
        Caption = ' Flight Status '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          ' All'
          ' Completed'
          ' In Flight')
        ParentFont = False
        TabOrder = 4
        OnClick = rgpFlighStatusClick
      end
      object grpSearchFlightLogs: TGroupBox
        Left = 712
        Top = 127
        Width = 273
        Height = 67
        Caption = ' Search Flight Number '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        object edtFlighNumberSearch: TEdit
          Left = 24
          Top = 28
          Width = 225
          Height = 25
          TabOrder = 0
          OnChange = edtFlighNumberSearchChange
        end
      end
    end
    object tbsReports: TTabSheet
      Caption = 'Staff Reports'
      ImageIndex = 6
      object dbgReports: TDBGrid
        Left = 16
        Top = 16
        Width = 689
        Height = 433
        DataSource = dtsReports
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object rgpReportOptions: TRadioGroup
        Left = 744
        Top = 32
        Width = 273
        Height = 313
        Caption = ' Reports '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          ' All Drones'
          ' Active Drones'
          ' Drones being Serviced'
          ' Drone Servicing Schedule'
          ' All Suburbs'
          ' Suburb Flight List'
          ' All Recommended Suburbs'
          ' Suburbs to Expand Into')
        ParentFont = False
        TabOrder = 1
      end
      object btnGetReport: TButton
        Left = 784
        Top = 359
        Width = 209
        Height = 57
        Caption = 'Get Report'
        TabOrder = 2
        OnClick = btnGetReportClick
      end
    end
    object tbsAccountDetails: TTabSheet
      Caption = 'Account Details'
      ImageIndex = 7
      object grpDeactivateAccount: TGroupBox
        Left = 528
        Top = 343
        Width = 465
        Height = 105
        Caption = ' Deactivate Account '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object bmbDeactivateAcc: TBitBtn
          Left = 80
          Top = 32
          Width = 329
          Height = 62
          Caption = 'Deactivate Account'
          DoubleBuffered = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkCancel
          ParentDoubleBuffered = False
          ParentFont = False
          TabOrder = 0
          OnClick = bmbDeactivateAccClick
        end
      end
      object grpChangePassword: TGroupBox
        Left = 64
        Top = 24
        Width = 433
        Height = 277
        Caption = ' Change Password '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object ledCurrentPass: TLabeledEdit
          Left = 40
          Top = 60
          Width = 353
          Height = 25
          EditLabel.Width = 144
          EditLabel.Height = 17
          EditLabel.Caption = 'Current Password'
          TabOrder = 0
        end
        object ledNewPass: TLabeledEdit
          Left = 40
          Top = 121
          Width = 353
          Height = 25
          EditLabel.Width = 108
          EditLabel.Height = 17
          EditLabel.Caption = 'New Password'
          TabOrder = 1
        end
        object ledRetypedNewPass: TLabeledEdit
          Left = 40
          Top = 181
          Width = 353
          Height = 25
          EditLabel.Width = 171
          EditLabel.Height = 17
          EditLabel.Caption = 'Retype New Password'
          TabOrder = 2
        end
        object btnChangePass: TButton
          Left = 128
          Top = 221
          Width = 169
          Height = 41
          Caption = 'Change Password'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnChangePassClick
        end
      end
      object grpDetails: TGroupBox
        Left = 528
        Top = 24
        Width = 465
        Height = 207
        Caption = ' Client Information '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        object lblNameTitle: TLabel
          Left = 24
          Top = 40
          Width = 45
          Height = 17
          Caption = 'Name:'
        end
        object lblSurnameTitle: TLabel
          Left = 24
          Top = 80
          Width = 72
          Height = 17
          Caption = 'Surname:'
        end
        object lblEmailTitle: TLabel
          Left = 24
          Top = 120
          Width = 54
          Height = 17
          Caption = 'Email:'
        end
        object lblName: TLabel
          Left = 136
          Top = 40
          Width = 36
          Height = 17
          Caption = 'Ryan'
        end
        object lblSurname: TLabel
          Left = 136
          Top = 80
          Width = 72
          Height = 17
          Caption = 'Trickett'
        end
        object lblEmail: TLabel
          Left = 136
          Top = 120
          Width = 270
          Height = 17
          Caption = 'richard.trickett@huhtamaki.com'
        end
        object lblJob: TLabel
          Left = 136
          Top = 160
          Width = 270
          Height = 17
          Caption = 'richard.trickett@huhtamaki.com'
        end
        object lblJobTitleTitle: TLabel
          Left = 24
          Top = 160
          Width = 90
          Height = 17
          Caption = 'Job Title:'
        end
      end
      object grpLogout: TGroupBox
        Left = 64
        Top = 343
        Width = 433
        Height = 105
        Caption = ' Log Out of Account '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        object bmbLogOut: TBitBtn
          Left = 56
          Top = 32
          Width = 329
          Height = 62
          Caption = 'Log Out'
          DoubleBuffered = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = bkIgnore
          ParentDoubleBuffered = False
          ParentFont = False
          TabOrder = 0
          OnClick = bmbLogOutClick
        end
      end
    end
  end
  object btnHelp: TButton
    Left = 984
    Top = 32
    Width = 103
    Height = 25
    Caption = 'Need Help?'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MV Boli'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnHelpClick
  end
  object adoActiveDrones: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=BirdsEyeSecuritySur' +
      'veillance_Data.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'Select [Serial Number], [Suburb Name], [Service Name] AS [Drone ' +
        'Type]'
      'from Drones, Suburbs, Services'
      
        'where [DroneID] IN (Select [DroneID] from DroneFlights where [St' +
        'atus] = "Departed") AND [Suburb] = [SuburbID] AND [Drone Type] =' +
        ' [ServiceID]')
    Left = 976
    Top = 592
  end
  object dtsActiveDrones: TDataSource
    DataSet = adoActiveDrones
    Left = 1064
    Top = 592
  end
  object adoSuburbStatus: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=BirdsEyeSecuritySur' +
      'veillance_Data.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select [Suburb Name], Count(*) AS [Number of Active Drones]'
      'from Drones, Suburbs, Services'
      
        'where [DroneID] IN (Select [DroneID] from DroneFlights where [St' +
        'atus] = "Departed") AND [Suburb] = [SuburbID] AND [Drone Type] =' +
        ' [ServiceID]'
      'group by [Suburb Name]')
    Left = 800
    Top = 592
  end
  object dtsSuburbStatus: TDataSource
    DataSet = adoSuburbStatus
    Left = 888
    Top = 592
  end
  object dtsAnalyseSurveillance: TDataSource
    DataSet = adoAnalyseSurveillance
    Left = 696
    Top = 592
  end
  object adoAnalyseSurveillance: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=BirdsEyeSecuritySur' +
      'veillance_Data.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'Select [DroneFlights.DroneFlightID] AS [Flight No],  [Service Na' +
        'me], [Serial Number] AS [Drone Serial Number], [Date and Time of' +
        ' Response]'
      'from DroneFlights, Drones, Services, SurveillanceReports '
      
        'where [DroneFlights.DroneID] = [Drones.DroneID] AND [Drone Type]' +
        ' = [Services.ServiceID] AND [DroneFlights.DroneFlightID] = [Surv' +
        'eillanceReports.DroneFlightID] AND [StaffID] = 4 AND [Time Analy' +
        'sed] IS NULL')
    Left = 576
    Top = 592
  end
  object dsrDrones: TDataSource
    DataSet = adoDrones
    Left = 488
    Top = 592
  end
  object adoDrones: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=BirdsEyeSecuritySur' +
      'veillance_Data.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'Select [Serial Number], [Suburb Name], [Service Name] AS [Drone ' +
        'Type], [Status]'
      'from Drones, Suburbs, Services'
      'where [Suburb] = [SuburbID] AND [Drone Type] = [ServiceID]')
    Left = 432
    Top = 592
  end
  object dsrSuburbs: TDataSource
    DataSet = adoSuburbs
    Left = 368
    Top = 592
  end
  object adoSuburbs: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=BirdsEyeSecuritySur' +
      'veillance_Data.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'Select [Suburb Name], [Postal Code]'
      'from Suburbs')
    Left = 304
    Top = 592
  end
  object dsrFlightLogs: TDataSource
    DataSet = adoFlightLogs
    Left = 232
    Top = 592
  end
  object adoFlightLogs: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=BirdsEyeSecuritySur' +
      'veillance_Data.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'Select [DroneFlights.DroneFlightID] AS [Flight No], [Serial Numb' +
        'er], [Service Name] AS [Drone Type], [Suburb Name], [Date and Ti' +
        'me of Response], [First Name] & " " & [Surname] AS [Assigned Sta' +
        'ff Member]'
      
        'from DroneFlights, Drones, Services, Suburbs, SurveillanceReport' +
        's, Staff'
      
        'where [DroneFlights.DroneID] = [Drones.DroneID] AND [Drone Type]' +
        ' = [ServiceID] AND [Drones.Suburb] = [Suburbs.SuburbID] AND [Dro' +
        'neFlights.DroneFlightID] = [SurveillanceReports.DroneFlightID] A' +
        'ND [SurveillanceReports.StaffID] = [Staff.StaffID]')
    Left = 152
    Top = 592
  end
  object dtsReports: TDataSource
    DataSet = adoReports
    Left = 88
    Top = 592
  end
  object adoReports: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=BirdsEyeSecuritySur' +
      'veillance_Data.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'Select [Serial Number], [Suburb Name], [Service Name] AS [Drone ' +
        'Type], [Status]'
      'from Drones, Suburbs, Services'
      'where [Suburb] = [SuburbID] AND [Drone Type] = [ServiceID]')
    Left = 24
    Top = 592
  end
  object dtsStaff: TDataSource
    DataSet = adoStaff
    Left = 72
    Top = 640
  end
  object adoStaff: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=BirdsEyeSecuritySur' +
      'veillance_Data.mdb;Persist Security Info=False'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'Select [First Name], [Surname], [Email], [Job Title Name] AS [Jo' +
        'b Title], [Inactive Staff]'
      'from Staff, JobTitles'
      'where [Staff.Job Title] = [JobTitleID]'
      'Order by [Surname], [First Name]')
    Left = 24
    Top = 640
  end
  object tmrAuto: TTimer
    Interval = 300000
    OnTimer = tmrAutoTimer
    Left = 144
    Top = 640
  end
end

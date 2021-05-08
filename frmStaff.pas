unit frmStaff;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, uStaff, StdCtrls, DB, ADODB, Grids, DBGrids, uDashboard,
  ExtCtrls, uAnalyseSurveillance, Buttons, uDroneManagement, uSuburbManagement,
  uStaffReportsAndLogs, uStaffManagement, uStaffPageAccess, uAccountDetails,
  uAutoDroneDeployment, uHelp;

type
  TStaffForm = class(TForm)
    pgcStaff: TPageControl;
    tbsDashboard: TTabSheet;
    tbsAnalyseSurveillance: TTabSheet;
    tbsDroneManagement: TTabSheet;
    tbsSuburbManagement: TTabSheet;
    tbsStaffManagement: TTabSheet;
    tbsFlightLogs: TTabSheet;
    tbsReports: TTabSheet;
    tbsAccountDetails: TTabSheet;
    grpDroneStatus: TGroupBox;
    lblDemand: TLabel;
    lblNumberDrones: TLabel;
    pgbDrones: TProgressBar;
    dbgActiveDrones: TDBGrid;
    dbgSuburbStatus: TDBGrid;
    lblActiveDrones: TLabel;
    lblSuburbStatus: TLabel;
    adoActiveDrones: TADOQuery;
    dtsActiveDrones: TDataSource;
    adoSuburbStatus: TADOQuery;
    dtsSuburbStatus: TDataSource;
    dbgDroneSurveillance: TDBGrid;
    dtsAnalyseSurveillance: TDataSource;
    imgSurveillance: TImage;
    adoAnalyseSurveillance: TADOQuery;
    grpSurveillanceReport: TGroupBox;
    btnSubmit: TButton;
    cbxSummary: TComboBox;
    redSummary: TRichEdit;
    lblDescription: TLabel;
    bmbRefreshAnalyseSurv: TBitBtn;
    bmbRefreshDashboard: TBitBtn;
    dbgDrones: TDBGrid;
    dsrDrones: TDataSource;
    adoDrones: TADOQuery;
    bmbRefreshDrones: TBitBtn;
    grpNewDrone: TGroupBox;
    grpChangeDroneStatus: TGroupBox;
    rdbGenerateSerialNum: TRadioButton;
    rdbUniqueSerailNum: TRadioButton;
    edtNewSerialNumber: TEdit;
    lblSuburbs: TLabel;
    cbxSuburbsDrones: TComboBox;
    cbxDroneType: TComboBox;
    lblDroneType: TLabel;
    bmbDroneRetry: TBitBtn;
    btnAddDrone: TButton;
    rgpSortDrones: TRadioGroup;
    ledEditSerialNumber: TLabeledEdit;
    cbxEditSuburb: TComboBox;
    lblSuburb: TLabel;
    cbxEditDroneType: TComboBox;
    lblEditDroneType: TLabel;
    btnSaveDetails: TButton;
    cbxDroneStatus: TComboBox;
    lblDroneStatus: TLabel;
    grpAddSuburb: TGroupBox;
    rdbRecommendedSuburb: TRadioButton;
    rdbEnterSuburbDetails: TRadioButton;
    bmbSuburbRetry: TBitBtn;
    btnAddSuburb: TButton;
    cbxRecommendedSuburbs: TComboBox;
    ledNewSuburbName: TLabeledEdit;
    ledNewSubPostCode: TLabeledEdit;
    dbgSuburbs: TDBGrid;
    rgpSortSuburbs: TRadioGroup;
    grpEditOrDelete: TGroupBox;
    ledSuburbName: TLabeledEdit;
    ledPostalCode: TLabeledEdit;
    btnSaveEditSuburb: TButton;
    dsrSuburbs: TDataSource;
    adoSuburbs: TADOQuery;
    bmbRefreshSuburbs: TBitBtn;
    dbgFlightLogs: TDBGrid;
    rgpSortFlightLogs: TRadioGroup;
    dsrFlightLogs: TDataSource;
    adoFlightLogs: TADOQuery;
    grpFlightLogDates: TGroupBox;
    dtpEarliestDate: TDateTimePicker;
    lblLatestDate: TLabel;
    bmbRefreshFlighLogs: TBitBtn;
    lblDate: TLabel;
    dtpLatestDate: TDateTimePicker;
    rgpFlighStatus: TRadioGroup;
    dbgReports: TDBGrid;
    rgpReportOptions: TRadioGroup;
    btnGetReport: TButton;
    dtsReports: TDataSource;
    adoReports: TADOQuery;
    grpSearchFlightLogs: TGroupBox;
    edtFlighNumberSearch: TEdit;
    grpAddStaffMember: TGroupBox;
    ledStaffName: TLabeledEdit;
    ledStaffSurname: TLabeledEdit;
    ledStaffEmail: TLabeledEdit;
    cbxJobTitles: TComboBox;
    lblJobTitle: TLabel;
    btnAddStaffMember: TButton;
    bmbRetryAddStaff: TBitBtn;
    dbgStaff: TDBGrid;
    btnDeactivateReactivateStaff: TButton;
    dtsStaff: TDataSource;
    adoStaff: TADOQuery;
    bmbRefreshStaff: TBitBtn;
    grpDetails: TGroupBox;
    lblNameTitle: TLabel;
    lblSurnameTitle: TLabel;
    lblEmailTitle: TLabel;
    lblName: TLabel;
    lblSurname: TLabel;
    lblEmail: TLabel;
    grpChangePassword: TGroupBox;
    ledCurrentPass: TLabeledEdit;
    ledNewPass: TLabeledEdit;
    ledRetypedNewPass: TLabeledEdit;
    btnChangePass: TButton;
    grpDeactivateAccount: TGroupBox;
    bmbDeactivateAcc: TBitBtn;
    lblJob: TLabel;
    lblJobTitleTitle: TLabel;
    grpLogout: TGroupBox;
    bmbLogOut: TBitBtn;
    tmrAuto: TTimer;
    btnHelp: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbxSummaryChange(Sender: TObject);
    procedure btnSubmitClick(Sender: TObject);
    procedure bmbRefreshDashboardClick(Sender: TObject);
    procedure bmbRefreshAnalyseSurvClick(Sender: TObject);
    procedure rdbGenerateSerialNumClick(Sender: TObject);
    procedure rdbUniqueSerailNumClick(Sender: TObject);
    procedure btnAddDroneClick(Sender: TObject);
    procedure bmbRefreshDronesClick(Sender: TObject);
    procedure rgpSortDronesClick(Sender: TObject);
    procedure dbgDronesCellClick(Column: TColumn);
    procedure btnSaveDetailsClick(Sender: TObject);
    procedure rdbRecommendedSuburbClick(Sender: TObject);
    procedure rdbEnterSuburbDetailsClick(Sender: TObject);
    procedure bmbDroneRetryClick(Sender: TObject);
    procedure bmbSuburbRetryClick(Sender: TObject);
    procedure btnAddSuburbClick(Sender: TObject);
    procedure rgpSortSuburbsClick(Sender: TObject);
    procedure btnSaveEditSuburbClick(Sender: TObject);
    procedure bmbRefreshSuburbsClick(Sender: TObject);
    procedure dbgSuburbsCellClick(Column: TColumn);
    procedure dtpEarliestDateChange(Sender: TObject);
    procedure dtpLatestDateChange(Sender: TObject);
    procedure rgpSortFlightLogsClick(Sender: TObject);
    procedure bmbRefreshFlighLogsClick(Sender: TObject);
    procedure rgpFlighStatusClick(Sender: TObject);
    procedure btnGetReportClick(Sender: TObject);
    procedure edtFlighNumberSearchChange(Sender: TObject);
    procedure bmbRetryAddStaffClick(Sender: TObject);
    procedure btnAddStaffMemberClick(Sender: TObject);
    procedure dbgStaffCellClick(Column: TColumn);
    procedure btnDeactivateReactivateStaffClick(Sender: TObject);
    procedure bmbRefreshStaffClick(Sender: TObject);
    procedure bmbDeactivateAccClick(Sender: TObject);
    procedure btnChangePassClick(Sender: TObject);
    procedure bmbLogOutClick(Sender: TObject);
    procedure dbgDroneSurveillanceCellClick(Column: TColumn);
    procedure tmrAutoTimer(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    procedure FormatFlightLogs;

    procedure PopulateDashboard;
    procedure CollectInfoForDroneAnalyses;
    procedure ShowDroneFootage;
    procedure PopulateDroneManagement;
    procedure PopulateDroneGrid;
    procedure PopulateEditDrones;
    procedure PopulateRecommendedSuburbs;
    procedure RecommendedSuburbErrorHandling;
    procedure PopulateEditSuburbs;
    procedure PopulateSuburbGrid;
    procedure PopulateFlightLogsDatePickers;
    procedure PopulateFlightLogsGrid;
    procedure PopulateStaffManagement;
    procedure ChangeStaffButton;
    procedure MakePagesVisible;
    procedure SetupAccountDetails;

    procedure RefreshAnalyseSurv;
    procedure RefreshDrones;
    procedure RefreshSuburbGrid;
    procedure RefreshStaff;
    procedure RefreshFlightLogs;
  public
    procedure FormSetup(StaffObj: TStaff; AccountDetialsObj : TAccountDetails;
    HelpObj : THelp);
  end;

var
  StaffForm: TStaffForm;
  objStaff : TStaff;
  objAccounDetails : TAccountDetails;
  objHelp : THelp;
  bGeneratedSerialNumber : boolean;

implementation

{$R *.dfm}

{ TStaffForm }

procedure TStaffForm.bmbRefreshFlighLogsClick(Sender: TObject);
begin
  RefreshFlightLogs;
end;

procedure TStaffForm.bmbDeactivateAccClick(Sender: TObject);
begin
  objAccounDetails.DeactivateAcc(objStaff.GetStaffID, Self);
end;

procedure TStaffForm.bmbDroneRetryClick(Sender: TObject);
begin
  rdbGenerateSerialNum.Checked := true;
  rdbUniqueSerailNum.Checked := false;
  edtNewSerialNumber.Clear;
  cbxSuburbsDrones.ItemIndex := 0;
  cbxDroneType.ItemIndex := 0;
end;

procedure TStaffForm.bmbLogOutClick(Sender: TObject);
begin
  objAccounDetails.LogOut(Self);
end;

procedure TStaffForm.bmbRefreshAnalyseSurvClick(Sender: TObject);
begin
  RefreshAnalyseSurv;
  ShowDroneFootage;
end;

procedure TStaffForm.bmbRefreshDashboardClick(Sender: TObject);
begin
  PopulateDashboard;
end;

procedure TStaffForm.bmbRefreshDronesClick(Sender: TObject);
begin
  RefreshDrones;
end;

procedure TStaffForm.bmbRefreshStaffClick(Sender: TObject);
begin
  RefreshStaff;
end;

procedure TStaffForm.bmbRefreshSuburbsClick(Sender: TObject);
begin
  RefreshSuburbGrid;
end;

procedure TStaffForm.bmbRetryAddStaffClick(Sender: TObject);
begin
  ledStaffName.Clear;
  ledStaffSurname.Clear;
  ledStaffEmail.Clear;
  cbxJobTitles.ItemIndex := 0;
end;

procedure TStaffForm.bmbSuburbRetryClick(Sender: TObject);
begin
  rdbRecommendedSuburb.Checked := true;
  rdbEnterSuburbDetails.Checked := false;
  cbxRecommendedSuburbs.ItemIndex := 0;
  ledNewSuburbName.Clear;
  ledNewSubPostCode.Clear;
end;

procedure TStaffForm.btnAddDroneClick(Sender: TObject);
var
  sSerialNumber, sSuburb, sDroneType : string;
begin
  if rdbGenerateSerialNum.Checked = true then
    sSerialNumber := GenerateSerialNumber
  else
    sSerialNumber := edtNewSerialNumber.Text;

  sSuburb := cbxSuburbsDrones.Items[cbxSuburbsDrones.ItemIndex];
  sDroneType := cbxDroneType.Items[cbxDroneType.ItemIndex];
  AddNewDrone(sSerialNumber, sSuburb, sDroneType);
end;

procedure TStaffForm.btnAddStaffMemberClick(Sender: TObject);
var
  sName, sSurname, sEmail, sJobTitle : string;
begin
  sName := ledStaffName.Text;
  sSurname := ledStaffSurname.Text;
  sEmail := ledStaffEmail.Text;
  sJobTitle := cbxJobTitles.Items[cbxJobTitles.ItemIndex];
  AddStaffMember(sName, sSurname, sEmail, sJobTitle);
end;

procedure TStaffForm.btnAddSuburbClick(Sender: TObject);
var
  sSuburb, sPostalCode : string;
  iIndex : byte;
begin
  iIndex := cbxRecommendedSuburbs.ItemIndex;
  if rdbRecommendedSuburb.Checked = true then
  begin
    SplitSuburbAndPostCode(cbxRecommendedSuburbs.Items[iIndex], sSuburb,
                            sPostalCode);
  end
  else
  begin
    sSuburb := ledNewSuburbName.Text;
    sPostalCode := ledNewSubPostCode.Text;
  end;

  AddSuburb(sSuburb, sPostalCode);
  cbxRecommendedSuburbs.Items.Delete(iIndex);
  cbxRecommendedSuburbs.ItemIndex := 0;
  RefreshSuburbGrid;
end;

procedure TStaffForm.btnChangePassClick(Sender: TObject);
var
  sOldPass, sNewPass, sRetypedPass : string;
  bCompleted : boolean;
begin
  sOldPass := Trim(ledCurrentPass.Text);
  sNewPass := Trim(ledNewPass.Text);
  sRetypedPass := Trim(ledRetypedNewPass.Text);
  objAccounDetails.ChangePassword(sOldPass, sNewPass, sRetypedPass,
  objStaff.GetPass, objStaff.GetStaffID, objStaff.GetName + ' ' +
  objStaff.GetSurname, objStaff.GetEmail, bCompleted);

  if bCompleted = true then
  begin
    objStaff.SetPass(sNewPass);
    SetupAccountDetails;
  end;
end;

procedure TStaffForm.btnDeactivateReactivateStaffClick(Sender: TObject);
var
  sEmail : string;
begin
  sEmail := adoStaff['Email'];
  if adoStaff['Inactive Staff'] = 'True' then
    ReactivateStaffMember(sEmail)
  else
    DeactiveStaffMember(sEmail);
end;

procedure TStaffForm.btnSaveDetailsClick(Sender: TObject);
var
  sOldSerialNumber, sNewSerialNumber, sStatus, sSuburb, sDroneType : string;
begin
  sOldSerialNumber := adoDrones['Serial Number'];
  sNewSerialNumber := ledEditSerialNumber.Text;
  sStatus := cbxDroneStatus.Items[cbxDroneStatus.ItemIndex];
  sSuburb := cbxEditSuburb.Items[cbxEditSuburb.ItemIndex];
  sDroneType := cbxDroneType.Items[cbxDroneType.ItemIndex];
  EditDrone(sOldSerialNumber, sNewSerialNumber, sStatus, sSuburb, sDroneType);
end;

procedure TStaffForm.btnSaveEditSuburbClick(Sender: TObject);
var
  sSuburbName, sPostalCode, sNewSuburbName, sNewPostalCode : string;
begin
  sSuburbName := adoSuburbs['Suburb Name'];
  sPostalCode := adoSuburbs['Postal Code'];
  sNewSuburbName := ledNewSuburbName.Text;
  sNewPostalCode := ledPostalCode.Text;
  SaveSuburbDetails(sSuburbName, sPostalCode, sNewSuburbName, sNewPostalCode);
  RefreshSuburbGrid;
end;

procedure TStaffForm.btnSubmitClick(Sender: TObject);
var
  sSummary, sFlightID : string;
begin
  if redSummary.Enabled = false then
    sSummary := cbxSummary.Items[cbxSummary.ItemIndex]
  else
    sSummary := redSummary.Text;

  sFlightID := adoAnalyseSurveillance['Flight No'];
  SubmitSurveillanceAnalyses(sFlightID, sSummary);
  RefreshAnalyseSurv;
end;

procedure TStaffForm.btnGetReportClick(Sender: TObject);
begin
  adoReports.Active := false;
  adoReports.SQL.Text := Report(rgpReportOptions.ItemIndex);
  adoReports.Active := true;
end;

procedure TStaffForm.btnHelpClick(Sender: TObject);
begin
  objHelp.LoadHelp(pgcStaff.ActivePage.Caption);
end;

procedure TStaffForm.cbxSummaryChange(Sender: TObject);
begin
  if cbxSummary.ItemIndex <> 4 then
    redSummary.Enabled := false
  else
    redSummary.Enabled := true;
end;

procedure TStaffForm.ChangeStaffButton;
begin
  if adoStaff.RecordCount <> 0 then
    if adoStaff['Inactive Staff'] = 'True' then
      btnDeactivateReactivateStaff.Caption := 'Reactivate Staff Member'
    else
      btnDeactivateReactivateStaff.Caption := 'Deactivate Staff Member';
end;

procedure TStaffForm.CollectInfoForDroneAnalyses;
begin
  adoAnalyseSurveillance.Active := false;
  adoAnalyseSurveillance.SQL.Text := SurveillanceToBeAnalysed(
                                                      objStaff.GetStaffID);
  adoAnalyseSurveillance.Active := true;
  if adoAnalyseSurveillance.RecordCount <> 0 then
  begin
    btnSubmit.Enabled := true;
    ShowDroneFootage;
  end
  else
    btnSubmit.Enabled := false;
end;

procedure TStaffForm.dbgDronesCellClick(Column: TColumn);
begin
  PopulateEditDrones;
end;

procedure TStaffForm.dbgDroneSurveillanceCellClick(Column: TColumn);
begin
  ShowDroneFootage;
end;

procedure TStaffForm.dbgStaffCellClick(Column: TColumn);
begin
  ChangeStaffButton;
end;

procedure TStaffForm.dbgSuburbsCellClick(Column: TColumn);
begin
  PopulateEditSuburbs;
end;

procedure TStaffForm.dtpEarliestDateChange(Sender: TObject);
begin
  PopulateFlightLogsGrid;
end;

procedure TStaffForm.dtpLatestDateChange(Sender: TObject);
begin
  PopulateFlightLogsGrid;
end;

procedure TStaffForm.edtFlighNumberSearchChange(Sender: TObject);
begin
  PopulateFlightLogsGrid;
end;

//-------------------------------------FORMATS THE FLIGHT LOGS GRID
procedure TStaffForm.FormatFlightLogs;
begin
  dbgFlightLogs.Columns.Items[4].Alignment := taRightJustify;
  dbgFlightLogs.Columns.Items[5].Width := 200;
end;

procedure TStaffForm.FormCreate(Sender: TObject);
begin
  //-------------------------------------MAKES THIS FORM THE MAIN FORM
  Pointer((@Application.MainForm)^) := Self;

  adoActiveDrones.Active := true;
  adoSuburbStatus.Active := true;
  adoSuburbs.Active := true;
  adoStaff.Active := true;
  adoFlightLogs.Active := true;

  PopulateDashboard;
  PopulateDroneGrid;
  PopulateDroneManagement;
  PopulateEditDrones;
  PopulateRecommendedSuburbs;
  RecommendedSuburbErrorHandling;
  PopulateEditSuburbs;
  PopulateSuburbGrid;
  PopulateFlightLogsDatePickers;
  PopulateFlightLogsGrid;
  PopulateStaffManagement;
end;

//-------------------------------------ASSIGNS OBJECTS AND WELCOMES USER
procedure TStaffForm.FormSetup(StaffObj: TStaff; AccountDetialsObj :
TAccountDetails; HelpObj : THelp);
begin
  objStaff := StaffObj;
  objAccounDetails := AccountDetialsObj;
  objHelp := HelpObj;
  CollectInfoForDroneAnalyses;
  MakePagesVisible;
  SetupAccountDetails;

  MessageDlg('Welcome ' + objStaff.GetName + ' ' + objStaff.GetSurname +
  ' you have been succesfully logged in!', mtInformation, mbOKCancel, 0);
end;

procedure TStaffForm.MakePagesVisible;
begin
  SetUpDictionary;
  AccessPages(pgcStaff, objStaff.GetJobTitle);
end;

procedure TStaffForm.PopulateDashboard;
var
  iTotDrones, iActiveDrones : word;
  sDemand : string;
begin
  DroneStatus(iTotDrones, iActiveDrones, sDemand);
  pgbDrones.Max := iTotDrones;
  pgbDrones.Position := iActiveDrones;
  lblNumberDrones.Caption := IntToStr(iActiveDrones) + '/' +
                             IntToStr(iTotDrones);
  lblDemand.Caption := sDemand;
  adoActiveDrones.Active := false;
  adoSuburbStatus.Active := false;
  adoActiveDrones.Active := true;
  adoSuburbStatus.Active := true;
end;

procedure TStaffForm.PopulateDroneGrid;
begin
  adoDrones.Active := false;
  adoDrones.SQL.Text := DroneOrderBy(rgpSortDrones.Items[
                                                  rgpSortDrones.ItemIndex]);
  adoDrones.Active := true;
end;

procedure TStaffForm.PopulateDroneManagement;
var
  sSuburbs, sDroneTypes : string;
begin
  sSuburbs := ToStringSuburbs;
  sDroneTypes := ToStringDroneTypes;

  cbxSuburbsDrones.Items.Text := sSuburbs;
  cbxDroneType.Items.Text := sDroneTypes;
  cbxSuburbsDrones.ItemIndex := 0;
  cbxDroneType.ItemIndex := 0;

  cbxEditSuburb.Items.Text := sSuburbs;
  cbxEditDroneType.Items.Text := sDroneTypes;
end;

procedure TStaffForm.PopulateEditDrones;
begin
  if adoDrones.RecordCount <> 0 then
  begin
    ledEditSerialNumber.Text := adoDrones['Serial Number'];
    btnSaveDetails.Enabled := true;
  end
  else
    btnSaveDetails.Enabled := false;

  cbxEditDroneType.ItemIndex := 0;
  cbxEditSuburb.ItemIndex := 0;
  cbxDroneStatus.ItemIndex := 0;
end;

procedure TStaffForm.PopulateEditSuburbs;
begin
  if adoSuburbs.RecordCount <> 0 then
  begin
    btnSaveEditSuburb.Enabled := true;
    ledSuburbName.Text := adoSuburbs['Suburb Name'];
    ledPostalCode.Text := adoSuburbs['Postal Code'];
  end
  else
  begin
    btnSaveEditSuburb.Enabled := false;
  end;
end;

procedure TStaffForm.PopulateFlightLogsDatePickers;
var
  dEarliestDate, dLatestDate : TDate;
begin
  dEarliestDate := EarliestDate;
  dLatestDate := LatestDate;

  dtpEarliestDate.Date := dEarliestDate;
  dtpLatestDate.Date := dLatestDate;

  dtpEarliestDate.MinDate := dEarliestDate;
  dtpEarliestDate.MaxDate := dLatestDate;

  dtpLatestDate.MinDate := dEarliestDate;
  dtpLatestDate.MaxDate := dLatestDate;
end;

procedure TStaffForm.PopulateFlightLogsGrid;
var
  sStartDate, sEndDate, sFlightNumber : string;
  iOrderByIndex, iStatusIndex : byte;
begin
  iStatusIndex := rgpFlighStatus.ItemIndex;
  iOrderByIndex := rgpSortFlightLogs.ItemIndex;
  sStartDate := DateToStr(dtpEarliestDate.Date);
  sEndDate := DateToStr(dtpLatestDate.Date);
  sFlightNumber := Trim(edtFlighNumberSearch.Text);

  adoFlightLogs.Active := false;
  adoFlightLogs.SQL.Text := FlightLogsOrderBy(iOrderByIndex, iStatusIndex,
  sStartDate, sEndDate, sFlightNumber);
  adoFlightLogs.Active := true;

  FormatFlightLogs;
end;

procedure TStaffForm.PopulateStaffManagement;
begin
  cbxJobTitles.Items.Text := JobTitles;
  cbxJobTitles.ItemIndex := 0;
  if adoStaff.RecordCount <> 0 then
    btnDeactivateReactivateStaff.Enabled := true;
end;

procedure TStaffForm.PopulateSuburbGrid;
begin
  adoSuburbs.Active := false;
  if rgpSortSuburbs.ItemIndex = 0 then
    adoSuburbs.SQL.Text := SuburbsOrderBy(true)
  else
    adoSuburbs.SQL.Text := SuburbsOrderBy(false);
  adoSuburbs.Active := true;
end;

procedure TStaffForm.PopulateRecommendedSuburbs;
begin
  cbxRecommendedSuburbs.Items.Text := RecommendedSuburbs;
  cbxRecommendedSuburbs.ItemIndex := 0;
end;

procedure TStaffForm.rdbRecommendedSuburbClick(Sender: TObject);
begin
  if (rdbRecommendedSuburb.Checked = true) AND (
  cbxRecommendedSuburbs.Items.Count <> 0) then
  begin
    rdbEnterSuburbDetails.Checked := false;
    ledNewSuburbName.Enabled := false;
    ledNewSubPostCode.Enabled := false;
    cbxRecommendedSuburbs.Enabled := true;
    cbxRecommendedSuburbs.SetFocus;
  end;

  RecommendedSuburbErrorHandling;
end;

procedure TStaffForm.rdbEnterSuburbDetailsClick(Sender: TObject);
begin
  if rdbEnterSuburbDetails.Checked = true then
  begin
    rdbRecommendedSuburb.Checked := false;
    ledNewSuburbName.Enabled := true;
    ledNewSubPostCode.Enabled := true;
    cbxRecommendedSuburbs.Enabled := false;
  end;
end;

procedure TStaffForm.rdbGenerateSerialNumClick(Sender: TObject);
begin
  if rdbGenerateSerialNum.Checked = true then
  begin
    rdbUniqueSerailNum.Checked := false;
    edtNewSerialNumber.Enabled := false;
    bGeneratedSerialNumber := true;
  end;
end;

procedure TStaffForm.rdbUniqueSerailNumClick(Sender: TObject);
begin
  if rdbUniqueSerailNum.Checked = true then
  begin
    rdbGenerateSerialNum.Checked := false;
    edtNewSerialNumber.Enabled := true;
    edtNewSerialNumber.SetFocus;
    bGeneratedSerialNumber := false;
  end;
end;

procedure TStaffForm.RecommendedSuburbErrorHandling;
begin
  if (rdbRecommendedSuburb.Checked = true) AND (
  cbxRecommendedSuburbs.Items.Count = 0) then
  begin
    rdbEnterSuburbDetails.Checked := true;
    rdbRecommendedSuburb.Checked := false;
  end;
end;

procedure TStaffForm.RefreshAnalyseSurv;
begin
  adoAnalyseSurveillance.Active := false;
  adoAnalyseSurveillance.Active := true;
end;

procedure TStaffForm.RefreshDrones;
begin
  adoDrones.Active := false;
  adoDrones.Active := true;
end;

procedure TStaffForm.RefreshFlightLogs;
begin
  adoFlightLogs.Active := false;
  adoFlightLogs.Active := true;
end;

procedure TStaffForm.RefreshStaff;
begin
  adoStaff.Active := false;
  adoStaff.Active := true;
  ChangeStaffButton;
end;

procedure TStaffForm.RefreshSuburbGrid;
begin
  adoSuburbs.Active := false;
  adoSuburbs.Active := true;
end;

procedure TStaffForm.rgpFlighStatusClick(Sender: TObject);
begin
  PopulateFlightLogsGrid;
end;

procedure TStaffForm.rgpSortDronesClick(Sender: TObject);
begin
  PopulateDroneGrid;
end;

procedure TStaffForm.rgpSortFlightLogsClick(Sender: TObject);
begin
  PopulateFlightLogsGrid;
end;

procedure TStaffForm.rgpSortSuburbsClick(Sender: TObject);
begin
  PopulateSuburbGrid;
end;

procedure TStaffForm.SetupAccountDetails;
begin
  lblName.Caption := objStaff.GetName;
  lblSurname.Caption := objStaff.GetSurname;
  lblEmail.Caption := objStaff.GetEmail;
  lblJob.Caption := objStaff.GetJobTitle;
end;

procedure TStaffForm.ShowDroneFootage;
var
  sFileName, sFlightID : string;
begin
  if adoAnalyseSurveillance.RecordCount <> 0 then
  begin
    sFlightID := adoAnalyseSurveillance['Flight No'];
    sFileName := GetSurveillanceFootage(sFlightID);
    imgSurveillance.Picture.LoadFromFile(sFileName);
  end;
end;

procedure TStaffForm.tmrAutoTimer(Sender: TObject);
begin
  DeployDrones;
  CompleteFlights;
  PopulateDashboard;
  RefreshAnalyseSurv;
  RefreshDrones;
  RefreshSuburbGrid;
  RefreshStaff;
  RefreshFlightLogs;
end;

end.

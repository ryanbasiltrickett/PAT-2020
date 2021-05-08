unit frmClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, jpeg, ExtCtrls, DB, ADODB, Grids, DBGrids, StdCtrls,
  uClient, uServiceRequest, Buttons, uClientReportsAndLogs, uAccountDetails,
  uAutoDroneDeployment, uHelp, uLibrary, DateUtils;

type
  TClientForm = class(TForm)
    imgBackground: TImage;
    pgcClient: TPageControl;
    tbsDroneServices: TTabSheet;
    tbsResponseLogs: TTabSheet;
    tbsReports: TTabSheet;
    tbsAccountDetails: TTabSheet;
    dbgServices: TDBGrid;
    adoServices: TADOQuery;
    dtsServices: TDataSource;
    dtpStart: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    lblStartDate: TLabel;
    lblEndDate: TLabel;
    grbSummary: TGroupBox;
    btnRequestService: TButton;
    lblSummary: TLabel;
    dbgDroneFlights: TDBGrid;
    adoResponeLogs: TADOQuery;
    dtsResponseLogs: TDataSource;
    grpIncidentSummary: TGroupBox;
    lblIncidentSummary: TLabel;
    bmbRefreshLogs: TBitBtn;
    rgpSort: TRadioGroup;
    btnShowFootage: TButton;
    rgpReportType: TRadioGroup;
    redReports: TRichEdit;
    btnSendToEmail: TButton;
    Button1: TButton;
    grpChangePassword: TGroupBox;
    ledCurrentPass: TLabeledEdit;
    ledNewPass: TLabeledEdit;
    ledRetypedNewPass: TLabeledEdit;
    btnChangePass: TButton;
    grpDetails: TGroupBox;
    lblNameTitle: TLabel;
    lblSurnameTitle: TLabel;
    lblEmailTitle: TLabel;
    lblName: TLabel;
    lblSurname: TLabel;
    lblEmail: TLabel;
    grpAddress: TGroupBox;
    lblAddressTitle: TLabel;
    lblSuburbTitle: TLabel;
    lblAddress: TLabel;
    lblSuburb: TLabel;
    grpDeactivateAccount: TGroupBox;
    bmbDeactivateAcc: TBitBtn;
    grpLogout: TGroupBox;
    bmbLogOut: TBitBtn;
    tmrAuto: TTimer;
    rgpStatus: TRadioGroup;
    btnHelp: TButton;
    procedure dbgServicesCellClick(Column: TColumn);
    procedure dtpStartChange(Sender: TObject);
    procedure dtpEndChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRequestServiceClick(Sender: TObject);
    procedure bmbRefreshLogsClick(Sender: TObject);
    procedure dbgDroneFlightsCellClick(Column: TColumn);
    procedure rgpSortClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnChangePassClick(Sender: TObject);
    procedure bmbDeactivateAccClick(Sender: TObject);
    procedure bmbLogOutClick(Sender: TObject);
    procedure tmrAutoTimer(Sender: TObject);
    procedure rgpStatusClick(Sender: TObject);
    procedure btnSendToEmailClick(Sender: TObject);
    procedure btnShowFootageClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    procedure FormatServiceDBGrid;
    procedure FormatFlightLogsDBGrid;
    procedure FormatReportsRichEdit;

    procedure UpdateSummary;
    procedure PopulateServiceResponse;
    procedure SurveillanceReport;
    procedure AccountDetailsSetup;

    procedure RefreshFlightLogs;
  public
    procedure FormSetup(ClientObj: TClient; AccountDetialsObj :
    TAccountDetails; HelpObj : THelp);
  end;

var
  ClientForm: TClientForm;
  objClient : TClient;
  objServiceRequest : TServiceRequest;
  objAccountDetails : TAccountDetails;
  objHelp : THelp;

implementation

{$R *.dfm}

{ TClientForm }

procedure TClientForm.AccountDetailsSetup;
begin
  lblName.Caption := objClient.GetName;
  lblSurname.Caption := objClient.GetSurname;
  lblEmail.Caption := objClient.GetEmail;
  lblAddress.Caption := objClient.GetAddressLine1;
  lblSuburb.Caption := objClient.GetSuburbName;
end;

procedure TClientForm.bmbDeactivateAccClick(Sender: TObject);
begin
  objAccountDetails.DeactivateAcc(objClient.GetUserID, Self);
end;

procedure TClientForm.bmbLogOutClick(Sender: TObject);
begin
  objAccountDetails.LogOut(Self);
end;

procedure TClientForm.bmbRefreshLogsClick(Sender: TObject);
begin
  RefreshFlightLogs;
end;

procedure TClientForm.btnChangePassClick(Sender: TObject);
var
  sOldPass, sNewPass, sRetypedPass : string;
  bCompleted : boolean;
begin
  sOldPass := Trim(ledCurrentPass.Text);
  sNewPass := Trim(ledNewPass.Text);
  sRetypedPass := Trim(ledRetypedNewPass.Text);
  objAccountDetails.ChangePassword(sOldPass, sNewPass, sRetypedPass,
  objClient.GetPass, objClient.GetUserID, objClient.GetName + ' ' +
  objClient.GetSurname, objClient.GetEmail, bCompleted);

  if bCompleted = true then
  begin
    objClient.SetPass(sNewPass);
    AccountDetailsSetup;
  end;
end;

procedure TClientForm.btnHelpClick(Sender: TObject);
begin
  objHelp.LoadHelp(pgcClient.ActivePage.Caption);
end;

procedure TClientForm.btnRequestServiceClick(Sender: TObject);
var
  sStartTime : string;
begin
  if MessageDlg(objServiceRequest.ConfirmServiceRequest, mtConfirmation,
  mbYesNo, 0) = mrYes then
  begin
    sStartTime := adoServices['Surveillance Start Time'];
    objServiceRequest.RequestService(objClient.GetUserID, sStartTime);
  end;
end;

procedure TClientForm.btnSendToEmailClick(Sender: TObject);
var
  sReportName, sFullName : string;
begin
  MessageDlg('Sending Email Please Wait...', mtInformation, mbOKCancel, 0);
  sFullName := objClient.GetName + ' ' + objClient.GetSurname;
  sReportName := Trim(rgpReportType.Items[rgpReportType.ItemIndex]);
  objEmails.SendEmail(sFullName, objClient.GetEmail, sReportName +
  ' for ' + LongMonthNames[MonthOf(Date())], 'Dear ' + sFullName + ',' +
  #13 + 'Here is the following report you requested.' + #13 +
  redReports.Text + #13 + #13 + 'Regards,' + #13 + 'Birds Eye Security');
end;

procedure TClientForm.btnShowFootageClick(Sender: TObject);
var
  sDroneFlightID : string;
begin
  sDroneFlightID := adoResponeLogs['Flight No'];
  ShowSurvFootage(sDroneFlightID);
end;

procedure TClientForm.Button1Click(Sender: TObject);
begin
  if rgpReportType.ItemIndex = 0 then
    redReports.Text := CostOfServicesReport(objClient.GetUserID)
  else
    redReports.Text := SuburbReport(objClient.GetUserID);
  btnSendToEmail.Enabled := true;
end;

//-------------------------------------ASSIGNS OBJECTS AND WELCOMES USER
procedure TClientForm.FormSetup(ClientObj: TClient; AccountDetialsObj :
TAccountDetails; HelpObj : THelp);
begin
  objClient := ClientObj;
  objAccountDetails := AccountDetialsObj;
  objHelp := HelpObj;
  PopulateServiceResponse;
  SurveillanceReport;
  AccountDetailsSetup;

  MessageDlg('Welcome ' + objClient.GetName + ' ' + objClient.GetSurname +
  ' you have been succesfully logged in!', mtInformation, mbOKCancel, 0);
end;

procedure TClientForm.dbgDroneFlightsCellClick(Column: TColumn);
begin
  SurveillanceReport;
end;

procedure TClientForm.dbgServicesCellClick(Column: TColumn);
begin
  UpdateSummary;
end;

procedure TClientForm.dtpEndChange(Sender: TObject);
begin
  if dtpStart.Date > dtpEnd.Date then
    dtpStart.Date := dtpEnd.Date;

  UpdateSummary;
end;

procedure TClientForm.dtpStartChange(Sender: TObject);
begin
  if dtpStart.Date > dtpEnd.Date then
    dtpEnd.Date := dtpStart.Date;

  UpdateSummary;
end;

//-------------------------------------FORMATS THE FLIGHT LOGS GRID
procedure TClientForm.FormatFlightLogsDBGrid;
begin
  dbgDroneFlights.Columns.Items[0].Width := 65;

  dbgDroneFlights.Columns.Items[3].Alignment := taRightJustify;
end;

//-------------------------------------FORMATS THE REPORTS RICH EDIT
procedure TClientForm.FormatReportsRichEdit;
begin
  redReports.Paragraph.TabCount := 2;
  redReports.Paragraph.Tab[0] := 140;
  redReports.Paragraph.Tab[1] := 315;
end;

//-------------------------------------FORMATS THE REQUEST SERVICES GRID
procedure TClientForm.FormatServiceDBGrid;
begin
  dbgServices.Columns.Items[1].Width := 160;
  dbgServices.Columns.Items[2].Width := 160;
  dbgServices.Columns.Items[3].Width := 120;

  dbgServices.Columns.Items[1].Alignment := taRightJustify;
  dbgServices.Columns.Items[2].Alignment := taRightJustify;
  dbgServices.Columns.Items[3].Alignment := taRightJustify;
end;

procedure TClientForm.FormCreate(Sender: TObject);
begin
  //-------------------------------------MAKES THIS FORM THE MAIN FORM
  Pointer((@Application.MainForm)^) := Self;

  objServiceRequest := TServiceRequest.Create;

  adoServices.Active := true;

  dtpStart.MinDate := Date();
  dtpEnd.MinDate := Date();
  UpdateSummary;
  FormatServiceDBGrid;
  FormatReportsRichEdit;
end;

procedure TClientForm.PopulateServiceResponse;
begin
  adoResponeLogs.Active := false;
  adoResponeLogs.SQL.Text := UserFlightReports(objClient.GetUserID,
                              rgpSort.ItemIndex, rgpStatus.ItemIndex);
  adoResponeLogs.Active := true;
  FormatFlightLogsDBGrid;
end;

procedure TClientForm.RefreshFlightLogs;
begin
  adoResponeLogs.Active := false;
  adoResponeLogs.Active := true;
  FormatFlightLogsDBGrid;
end;

procedure TClientForm.rgpSortClick(Sender: TObject);
begin
  PopulateServiceResponse;
end;

procedure TClientForm.rgpStatusClick(Sender: TObject);
begin
  PopulateServiceResponse;
end;

procedure TClientForm.SurveillanceReport;
var
  sFlightID : string;
begin
  if adoResponeLogs.RecordCount <> 0 then
  begin
    sFlightID := adoResponeLogs['Flight No'];
    lblIncidentSummary.Caption := SurveillanceSummary(sFlightID);

    if adoResponeLogs['Status'] = 'Completed' then
      btnShowFootage.Enabled := true
    else
      btnShowFootage.Enabled := false;
  end;
end;

procedure TClientForm.tmrAutoTimer(Sender: TObject);
begin
  DeployDrones;
  CompleteFlights;
  RefreshFlightLogs;
end;

procedure TClientForm.UpdateSummary;
var
  startDate, endDate : TDate;
  sService : string;
  rPricePerDay : real;
begin
  startDate := dtpStart.Date;
  endDate := dtpEnd.Date;
  sService := adoServices['Service Name'];
  rPricePerDay := adoServices['Price Per Day'];
  objServiceRequest.SetValues(startDate, endDate, sService, rPricePerDay);
  lblSummary.Caption := objServiceRequest.UpdateServiceSummary;
end;

end.

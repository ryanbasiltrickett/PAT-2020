program BirdsEyeSecuritySurveillance;

uses
  Forms,
  uServiceRequest in 'uServiceRequest.pas',
  frmClient in 'frmClient.pas' {ClientForm},
  uClient in 'uClient.pas',
  uDB_Source in 'uDB_Source.pas',
  uLoginFormManager in 'uLoginFormManager.pas',
  frmLogin in 'frmLogin.pas' {LoginForm},
  uDroneLaunch in 'uDroneLaunch.pas',
  frmStaff in 'frmStaff.pas' {StaffForm},
  uStaff in 'uStaff.pas',
  uDashboard in 'uDashboard.pas',
  uLibrary in 'uLibrary.pas',
  uClientReportsAndLogs in 'uClientReportsAndLogs.pas',
  uAnalyseSurveillance in 'uAnalyseSurveillance.pas',
  uDroneManagement in 'uDroneManagement.pas',
  uSuburbManagement in 'uSuburbManagement.pas',
  uStaffReportsAndLogs in 'uStaffReportsAndLogs.pas',
  uStaffPageAccess in 'uStaffPageAccess.pas',
  uStaffManagement in 'uStaffManagement.pas',
  uAccountDetails in 'uAccountDetails.pas',
  uAutoDroneDeployment in 'uAutoDroneDeployment.pas',
  frmFootage in 'frmFootage.pas' {FootageForm},
  uEmails in 'uEmails.pas',
  uHelp in 'uHelp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Birds Eye Security Surveillance';
  Application.CreateForm(TLoginForm, LoginForm);
  Application.Run;
end.

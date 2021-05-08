unit frmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, uLoginFormManager, jpeg, uAutoDroneDeployment,
  uHelp, uLibrary;

type
  TLoginForm = class(TForm)
    imgBackground: TImage;
    pnlLogin: TPanel;
    pnlRegister: TPanel;
    ledEmail: TLabeledEdit;
    ledPassword: TLabeledEdit;
    btnLogin: TButton;
    btnSignUp: TButton;
    cbxStaff: TCheckBox;
    btnShowHide: TButton;
    ledFirstName: TLabeledEdit;
    ledSurname: TLabeledEdit;
    ledPasswordSignUp: TLabeledEdit;
    cbxSuburbs: TComboBox;
    ledPasswordConfirm: TLabeledEdit;
    ledEmailSignUp: TLabeledEdit;
    ledEmailConfirm: TLabeledEdit;
    lblSuburbs: TLabel;
    ledAddressLine1: TLabeledEdit;
    btnRegister: TButton;
    btnAlreadyRegistered: TButton;
    lblRecommenedSuburb: TLabel;
    tmrAuto: TTimer;
    btnHelpLogin: TButton;
    btnHelpRegister: TButton;
    lblForgotPass: TLabel;
    procedure btnShowHideClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnSignUpClick(Sender: TObject);
    procedure btnAlreadyRegisteredClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure lblRecommenedSuburbClick(Sender: TObject);
    procedure ledPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure tmrAutoTimer(Sender: TObject);
    procedure btnHelpLoginClick(Sender: TObject);
    procedure btnHelpRegisterClick(Sender: TObject);
    procedure lblForgotPassClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoginUser;
    procedure ClearForm;

  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.dfm}

procedure TLoginForm.btnHelpLoginClick(Sender: TObject);
begin
  LoginHelp;
end;

procedure TLoginForm.btnHelpRegisterClick(Sender: TObject);
begin
  SignUpHelp;
end;

procedure TLoginForm.btnLoginClick(Sender: TObject);
begin
  LoginUser;
end;

procedure TLoginForm.btnRegisterClick(Sender: TObject);
var
  sName, sSurname, sEmail, sPassword, sAddressLine1, sSuburbAndCode,
  sSuburb, sPostCode, sRetypedPass, sRetypedEmail : string;
  iPos : byte;
begin
  sPassword := Trim(ledPasswordSignUp.Text);
  sName := Trim(ledFirstName.Text);
  sSurname := Trim(ledSurname.Text);
  sEmail := Trim(ledEmailSignUp.Text);
  sAddressLine1 := Trim(ledAddressLine1.Text);
  sSuburbAndCode := Trim(cbxSuburbs.Items[cbxSuburbs.ItemIndex]);

  sRetypedPass := Trim(ledPasswordConfirm.Text);
  sRetypedEmail := Trim(ledEmailConfirm.Text);

  iPos := POS(',', sSuburbAndCode);
  sSuburb := Copy(sSuburbAndCode, 1, iPos - 1);
  Delete(sSuburbAndCode, 1, iPos + 1);
  sPostCode := sSuburbAndCode;

  if RequiredFieldsFilled(sName, sSurname, sEmail, sRetypedEmail,
  sPassword, sRetypedPass, sAddressLine1, sSuburb, sPostCode) =
  true then
    if PasswordCriteriaMet(sPassword) = true then
      if FieldsConfirmed(sPassword, sRetypedPass, sEmail, sRetypedEmail) =
      true then
        if EmailVerified(sEmail) = true then
          RegisterNewUser(sName, sSurname, sEmail, sPassword, sAddressLine1,
          sSuburb, sPostCode, Self);
end;

procedure TLoginForm.btnShowHideClick(Sender: TObject);
begin
  if ledPassword.PasswordChar = '*' then
  begin
    ledPassword.PasswordChar := #0;
    btnShowHide.Caption := 'Hide';
  end
  else
  begin
    ledPassword.PasswordChar := '*';
    btnShowHide.Caption := 'Show';
  end;
end;

procedure TLoginForm.btnSignUpClick(Sender: TObject);
begin
  pnlRegister.Visible := true;
  pnlLogin.Visible := false;
  ClearForm;
  ledFirstName.SetFocus;
end;

//-------------------------------------CLEARS THE FORM AS IF IT WAS NEW
procedure TLoginForm.ClearForm;
begin
  ledEmail.Clear;
  ledPassword.Clear;
  cbxStaff.Checked := false;
  ledFirstName.Clear;
  ledSurname.Clear;
  ledEmailSignUp.Clear;
  ledEmailConfirm.Clear;
  ledPasswordSignUp.Clear;
  ledPasswordConfirm.Clear;
  ledAddressLine1.Clear;
  cbxSuburbs.ItemIndex := 0;
end;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  CreateObjs;
  cbxSuburbs.Items.Text := PopulateSuburbDropDown;
  cbxSuburbs.ItemIndex := 0;
  CompleteFlights;
  DeployDrones;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
  pnlLogin.Visible := true;
  pnlRegister.Visible := false;
  ClearForm;
  ledEmail.SetFocus;
end;

procedure TLoginForm.lblForgotPassClick(Sender: TObject);
var
  sEmail, sStaff : string;
  bStaff : boolean;
begin
  if MessageDlg('Have you forgot your password?', mtInformation, mbYesNo,
  0) = mrYes then
  begin
    sEmail := InputBox('Birds Eye Security Surveillance', 'Please ' +
    'enter the email your account is linked to.', '');

    repeat
      sStaff := InputBox('Birds Eye Security Surveillance', 'Are you part ' +
      'of our staff? (Yes/No)', 'No');
    until (UPPERCASE(sStaff) = 'YES') OR (UPPERCASE(sStaff) = 'NO');
    bStaff := UPPERCASE(sStaff) = 'YES';

    ForgotPass(sEmail, bStaff);
  end;
end;

procedure TLoginForm.lblRecommenedSuburbClick(Sender: TObject);
var
  sSuburb, sPostCode, sEmail : string;
begin
  if MessageDlg('Is the suburb you wish to register for not listed?',
  mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    sSuburb := InputBox('Birds Eye Security Surveillance',
    'Which suburb do you wish to signup for?', '');
    sPostCode := InputBox('Birds Eye Security Surveillance', 'What is ' +
    'the postal code of the suburb?', '');

    while ValidatePostal(sPostCode) = false do
        sPostCode := InputBox('Birds Eye Security Surveillance',
        'You entered an invalid postal code, please enter your suburbs' +
        ' postal code.', '');

    if AlreadyInSuburbs(sPostCode) = false then
    begin
      sEmail := InputBox('Birds Eye Security Surveillance', 'Please enter ' +
        'your email', '');

      while EmailVerified(sEmail) = false do
        sEmail := InputBox('Birds Eye Security Surveillance', 'You ' +
        'entered an invalid email, please enter a valid email.', '');

      MessageDlg('Thank you for your interest in our service in your area.' +
      ' We shall contact you as soon as we are operational in your suburb.',
      mtInformation, mbOKCancel, 0);

      RecommendSuburb(sSuburb, sPostCode, sEmail);
    end
    else
      MessageDlg('The area you wish to register for is already on the list' +
      ' of suburbs we operate in.', mtInformation, mbOKCancel, 0);
  end;
end;

procedure TLoginForm.ledPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    LoginUser;
end;

procedure TLoginForm.LoginUser;
var
  sEmail, sPassword : string;
  bStaff : boolean;
begin
  sEmail := Trim(ledEmail.Text);
  sPassword := Trim(ledPassword.Text);
  bStaff := cbxStaff.Checked;

  Login(sEmail, sPassword, bStaff, Self);
end;

procedure TLoginForm.tmrAutoTimer(Sender: TObject);
begin
  DeployDrones;
  CompleteFlights;
end;

procedure TLoginForm.btnAlreadyRegisteredClick(Sender: TObject);
begin
  pnlLogin.Visible := true;
  pnlRegister.Visible := false;
  ClearForm;
  ledEmail.SetFocus;
end;

end.

unit uAccountDetails;

interface

uses
  uLibrary, Dialogs, Forms, SysUtils;

Type
  TAccountDetails = class
  private
    fLoginForm: TForm;
    fIsClient: boolean;

  public
    constructor Create(LoginForm: TForm; IsClient: boolean);
    procedure ChangePassword(OldPass, NewPass, RetypedNewPass, PersonsPass,
    ID, Name, Email: string; var Completed : boolean);
    procedure DeactivateAcc(ID: string; Form: TForm);
    procedure LogOut(Form: TForm);
  end;

implementation

//-------------------------------------CHANGES A USERS PASSWORD
procedure TAccountDetails.ChangePassword(OldPass, NewPass, RetypedNewPass,
  PersonsPass, ID, Name, Email: string; var Completed : boolean);
var
  sSQL: string;
begin
  Completed := false;

  //-------------------------------------CHECKS THAT ALL FIELDS HAVE
  //-------------------------------------BEEN ENTERED
  if (OldPass = '') OR (NewPass = '') OR (RetypedNewPass = '') then
    MessageDlg('None of the field for changing your password may be empty',
      mtError, mbOKCancel, 0)
  else if OldPass = PersonsPass then
  begin
    if PasswordCriteriaMet(NewPass) then
    begin
      if NewPass = RetypedNewPass then
      begin
        Completed := true;

        if fIsClient = true then
          sSQL := 'Update Users '
                + 'Set [Password] = "' + NewPass + '" '
                + 'where [UserID] = ' + ID
        else
          sSQL := 'Update Staff '
                + 'Set [Password] = "' + NewPass + '" '
                + 'where [StaffID] = ' + ID;

        objDB.DoSQL(sSQL);

        MessageDlg('Email Sending Please Wait...', mtInformation, mbOKCancel,
        0);

        //-------------------------------------SENDS EMAIL CONFIRMING
        //-------------------------------------PASSWORD CHANGE
        objEmails.SendEmail(Name, Email, 'Your Password Has Been Changed',
        'Dear ' + Name + ',' + #13 + #13 + 'Your password has ' +
        'been changed to "' + NewPass + '", this change happened at ' +
        TimeToStr(Now()) + ' on the ' + DateToStr(Date()) + #13 +
        'If this was NOT you please log in and ensure that you change' +
        ' your password back and secure your account!' + #13 + #13 +
        'Regards,' + #13 + 'Birds Eye Security');

        MessageDlg('You password has been changed', mtInformation, mbOKCancel,
          0);
      end
      else
        MessageDlg('The new password that you entered if different to' +
            ' the retyped new password. Please ensure you entered your new ' +
            'desired password correctly', mtError, mbOKCancel, 0);
    end;
  end
  else
    MessageDlg('The current password that you entered if different to' +
        ' the password that is connected to this account. Please ensure you ' +
        'entered the password correctly', mtError, mbOKCancel, 0);
end;

//-------------------------------------CREATES ACCOUNT DETAILS OBJECT
constructor TAccountDetails.Create(LoginForm: TForm; IsClient: boolean);
begin
  fLoginForm := LoginForm;
  fIsClient := IsClient;
end;

//-------------------------------------DEACTIVATES A USERS ACCOUNT
procedure TAccountDetails.DeactivateAcc(ID: string; Form: TForm);
var
  sSQL: string;
begin
  if fIsClient = true then
    sSQL := 'Update Users ' + 'Set [Inactive User] = True ' +
      'where [UserID] = ' + ID
  else
    sSQL := 'Update Staff ' + 'Set [Inactive Staff] = True ' +
      'where [StaffID] = ' + ID;

  objDB.DoSQL(sSQL);

  MessageDlg('Your account has been successfully deactivated!', mtConfirmation,
    mbOKCancel, 0);

  LogOut(Form);
end;

//-------------------------------------LOGS A USER OUT OF THEIR ACCOUNT
procedure TAccountDetails.LogOut(Form: TForm);
begin
  MessageDlg('You have been Logged Out', mtInformation, mbOKCancel, 0);
  Pointer((@Application.MainForm)^) := fLoginForm;
  Form.Destroy;
  fLoginForm.Show;
end;

end.

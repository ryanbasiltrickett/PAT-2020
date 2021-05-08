unit uLoginFormManager;

interface
  uses
    Forms, Dialogs, SysUtils, uDB_Source, frmStaff, frmClient, uClient,
    uStaff, uLibrary, Controls, uAccountDetails, uHelp;

  var
    objAccountDetails : TAccountDetails;
    objHelp : THelp;

  procedure CreateObjs;

  //---------------------------------------------SIGN UP
  function PopulateSuburbDropDown : string;
  function FieldsConfirmed(Password, RetypedPass, Email, RetypedEmail :
  string) : boolean;
  function EmailVerified(Email : string) : boolean;
  function RequiredFieldsFilled(FirstName, Surname, Email, RetypedEmail,
  Password, RetypedPass, AddressLine1, SuburbName, PostCode : string)
  : boolean;
  procedure RegisterNewUser(FirstName, Surname, Email, Password, AddressLine1,
  SuburbName, PostCode : string; LoginForm : TForm);
  procedure SignUpHelp;

  //---------------------------------------------RECOMMEND SUBURB
  function AlreadyInSuburbs(PostCode : string) : boolean;
  procedure RecommendSuburb(SuburbName, PostCode, Email : string);

  //---------------------------------------------LOGIN
  procedure Login(Email, Password : string; IsStaff : boolean; LoginForm :
  TForm);
  procedure ForgotPass(Email : string; Staff : boolean);
  procedure LoginHelp;

implementation

//-------------------------------------CHECKS IF THE SUBURB A IS ALREADY IN
//-------------------------------------THE DATABASE
function AlreadyInSuburbs(PostCode : string) : boolean;
var
  sSQL : string;
begin
  sSQL := 'Select * '
        + 'from Suburbs '
        + 'where [Postal Code] = "' + PostCode + '"';
  Result := objDB.RecordExist(sSQL);
end;

//-------------------------------------ADDS/UPDATES A RECOMMENDED SUBRUB
procedure RecommendSuburb(SuburbName, PostCode, Email : string);
var
  sSQL, sRecommendID : string;
begin
  sSQL := 'Select * '
        + 'from RecommendedSuburbs '
        + 'where [Suburb Name] = "' +
  SuburbName + '" AND [Postal Code] = "' + PostCode + '"';

  //-------------------------------------CHECKS IF ITS ALREADY BEEN RECOMMENDED
  if objDB.RecordExist(sSQL) = true then
  begin
    //-------------------------------------INCREASES NUMBER OF RECOMMENDATIONS
    sSQL := 'Update RecommendedSuburbs'
          + ' set [Number of Recommendations] = ' +
            '[Number of Recommendations] + 1'
          + ' where [Suburb Name] = "' + SuburbName + '" AND ' +
            '[Postal Code] = "' + PostCode + '"';
    objDB.DoSQL(sSQL);
  end
  else
  begin
    //-------------------------------------ADDS A NEW RECOMMENDED SUBURB
    sSQL := 'Insert into RecommendedSuburbs'
          + ' ([Suburb Name], [Postal Code], [Number of Recommendations])'
          + ' Values("' + SuburbName + '", "' + PostCode + '", 1)';
    objDB.DoSQL(sSQL);
  end;

  sSQL := 'Select [RecSuburbID] '
        + 'from RecommendedSuburbs '
        + 'where [Suburb Name] = "' + SuburbName + '" AND [Postal Code]' +
          ' = "' + PostCode + '"';
  sRecommendID := objDB.ToString(sSQL, '');

  //-------------------------------------ADDS EMAIL TO NOTIFICATIONS
  sSQL := 'Insert into NewSuburbEmailNotify'
        + ' ([RecSubID], [User Email])'
        + ' Values(' + sRecommendID + ', "' + Email + '")';
  objDB.DoSQL(sSQL);
end;

//-------------------------------------CREATES OBJECTS NEED ACROSS THE
//-------------------------------------WHOLE APPLICATION
procedure CreateObjs;
begin
  CreateGlobalObjs;
  objHelp := THelp.Create;
end;

//-------------------------------------RETURNS ALL THE SUBURBS' DETAILS
function PopulateSuburbDropDown: string;
var
  sSQL : string;
begin
  sSQL := 'Select [Suburb Name], [Postal Code] '
        + 'from Suburbs';
  Result := objDB.ToString(sSQL, SUBURB_DELIMETER);
end;

function FieldsConfirmed(Password, RetypedPass, Email, RetypedEmail :
  string) : boolean;
begin
  if (Password = RetypedPass) AND (Email = RetypedEmail) then
    Result := true
  else
  begin
    Result := false;
    MessageDlg('The email or passsword you typed doesn''t match the ' +
    'confirm password or email. Please ensure these field are the same.',
    mtInformation, mbOKCancel, 0);
  end;
end;

//-------------------------------------CHECKS IF THE EMAIL IS A LEGITIMATE
//-------------------------------------EMAIL ADDRESS
function EmailVerified(Email : string) : boolean;
var
  iPosFirstAtSign, iPos : byte;
begin
  Result := true;
  if POS(' ', Email) <> 0 then
    Result := false
  else
  begin
    iPosFirstAtSign := POS('@', Email);
    if (iPosFirstAtSign <> 0) AND (iPosFirstAtSign <> 1) then
    begin
      Delete(Email, 1, iPosFirstAtSign);
      iPos := POS('@', Email);

      if iPos <> 0 then
        Result := false
      else
      begin
        iPos := POS('.', Email);
        if (iPos = 0) then
          Result := false;
      end;
    end
    else
      Result := false;
  end;

  if Result = false then
    MessageDlg('The email you entered is not verified. Please enter ' +
    'a authentic email address.', mtInformation, mbOKCancel, 0);
end;

//-------------------------------------CHECKS IF ALL FIELDS ARE FILLED OUT
function RequiredFieldsFilled(FirstName, Surname, Email, RetypedEmail,
  Password, RetypedPass, AddressLine1, SuburbName, PostCode : string)
  : boolean;
begin
  if (FirstName <> '') AND (Surname <> '') AND (Email <> '') AND
  (Password <> '') AND (AddressLine1 <> '') AND (SuburbName <> '') AND
  (PostCode <> '') AND (RetypedEmail <> '') AND (RetypedEmail <> '') then
  begin
    Result := true;
  end
  else
  begin
    Result := false;
    MessageDlg('All field are required in order to register, please ' +
    'ensure all fields are filled out.', mtInformation, mbOKCancel, 0);
  end;
end;

//-------------------------------------ADDS A NEW CLIENT TO THE DATABASE
procedure RegisterNewUser(FirstName, Surname, Email,
  Password, AddressLine1, SuburbName, PostCode : string; LoginForm : TForm);
var
  sSQL, sSuburbID : string;
begin
  if MessageDlg('Please Confirm That The Information You Have Entered is ' +
  'Correct' + #13 + #13 + 'First Name:' + #13 + FirstName + #13 + #13 +
  'Surname: '  + #13 + Surname + #13 + #13 + 'Email:' + #13 +
  Email + #13 + #13 + 'Password:' + #13 + Password + #13 + #13 +
  'Address:' + #13 + AddressLine1 + #13 + SuburbName + #13 + PostCode,
  mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    sSQL := 'Select * '
          + 'from Users '
          + 'where [Email] = "' + Email + '"';
    if objDB.RecordExist(sSQL) = false then
    begin
      sSQL := 'Select [SuburbID] '
            + 'from Suburbs '
            + 'where [Suburb Name] = "' + SuburbName + '" AND ' +
              '[Postal Code] = "' + PostCode + '"';

      sSuburbID := objDB.ToString(sSQL, '');

      sSQL := 'Insert into Users '
            + '([First Name], [Surname], [Email], [Password], ' +
              '[Address Line 1], [Suburb]) '
            + 'Values("' + FirstName + '", "' + Surname + '", "' + Email +
              '", "' + Password + '", "' + AddressLine1 + '", ' + sSuburbID +
              ')';

      objDB.DoSQL(sSQL);
      Login(Email, Password, false, LoginForm);
    end
    else
      MessageDlg('Your email is already registered within our database.' +
      ' Click Already Registered in order to sign into your account.',
      mtInformation, mbOKCancel, 0);
  end;
end;

//-------------------------------------LOADS HELP FOR A USER ON SIGN UP PAGE
procedure SignUpHelp;
begin
  objHelp.LoadHelp('Sign Up');
end;

//-------------------------------------LOGS A USER INTO THEIR ACCOUNT
procedure Login(Email, Password : string; IsStaff : boolean; LoginForm : TForm);
var
  sSQL, sPass : string;
  bExists : boolean;
  objClient : TClient;
  objStaff : TStaff;
  objClientForm : TClientForm;
  objStaffForm : TStaffForm;
begin
  if IsStaff = true then
    sSQL := 'Select * '
          + 'from Staff '
          + 'where [Email] = "' + Email + '" AND [Inactive Staff] = False'
  else
    sSQL := 'Select * '
          + 'from Users '
          + 'where [Email] = "' + Email + '" AND [Inactive User] = False';

  bExists := objDB.RecordExist(sSQL);

  if bExists = true then
  begin
    if IsStaff = true then
      sSQL := 'Select [Password] '
            + 'from Staff '
            + 'where [Email] = "' + Email + '"'
    else
      sSQL := 'Select [Password] '
            + 'from Users '
            + 'where [Email] = "' + Email + '"';

    sPass := objDB.ToString(sSQL, '');

    //-------------------------------------CHECKS IF PASSWORD IS CORRECT
    //-------------------------------------INCLUDING CASE SENSITIVITY
    if (Password = sPass) AND (IsStaff = true) then
    begin
      objStaff := TStaff.Create(Email, Password);
      objStaffForm := TStaffForm.Create(Application);
      objAccountDetails := TAccountDetails.Create(LoginForm, false);
      objStaffForm.FormSetup(objStaff, objAccountDetails, objHelp);
      objStaffForm.Show;
      LoginForm.Hide;
    end
    else if (Password = sPass) AND (IsStaff = false) then
    begin
      objClient := TClient.Create(Email, Password);
      objClientForm :=  TClientForm.Create(Application);
      objAccountDetails := TAccountDetails.Create(LoginForm, true);
      objClientForm.FormSetup(objClient, objAccountDetails, objHelp);
      objClientForm.Show;
      LoginForm.Hide;
    end
    else
      MessageDlg('Your password is incorrect. If you are a member ' +
      'of staff please remember to check the staff member login box.',
      mtInformation, mbOKCancel, 0);
  end
  else
    MessageDlg('Your email is incorrect. If you are a member ' +
    'of staff please remember to check the staff member login box.',
    mtInformation, mbOKCancel, 0);
end;

//-------------------------------------ALLOWS A USER TO REQUEST A TEMPORARY
//-------------------------------------PASSWORD
procedure ForgotPass(Email : string; Staff : boolean);
var
  sSQL, sPassword : string;
begin
  if Staff = true then
    sSQL := 'Select * '
          + 'from Staff '
          + 'where [Email] = "' + Email + '"'
  else
    sSQL := 'Select * '
          + 'from Users '
          + 'where [Email] = "' + Email + '"';

  if objDB.RecordExist(sSQL) = true then
  begin
    sPassword := RandomPass;

    if Staff = true then
      sSQL := 'Update Staff '
            + 'Set [Password] = "' + sPassword + '" '
            + 'where [Email] = "' + Email + '"'
    else
      sSQL := 'Update Users '
            + 'Set [Password] = "' + sPassword + '" '
            + 'where [Email] = "' + Email + '"';

    objDB.DoSQL(sSQL);

    //-------------------------------------SENDS USER A RANDOM PASSWORD
    MessageDlg('Sending Email Please Wait...', mtInformation, mbOKCancel, 0);
    objEmails.SendEmail('', Email, 'Forgot Password Request', 'Here ' +
    'is your new password: ' + sPassword + #13 + #13 + 'You can ' +
    'change your password in Account Details once you have signed in.' +
    #13 + #13 + 'Regards,' + 'Birds Eye Security');
  end
  else
    MessageDlg('Your email does not exist within our database. ' +
    'Please sign up in order to create an account.', mtInformation,
    mbOKCancel, 0);
end;

//-------------------------------------LOADS HELP FOR A USER ON LOGIN PAGE
procedure LoginHelp;
begin
  objHelp.LoadHelp('Login');
end;

end.

unit uStaffManagement;

interface
  uses
    uLibrary, SysUtils, Dialogs;

  function JobTitles : string;
  procedure AddStaffMember(FirtsName, Surname, Email, JobTitle : string);
  procedure DeactiveStaffMember(Email : string);
  procedure ReactivateStaffMember(Email : string);

implementation

//-------------------------------------RETURNS THE JOB TITLE NAME
function JobTitles : string;
var
  sSQL : string;
begin
  sSQL := 'Select [Job Title Name] '
        + 'from JobTitles';
  Result := objDB.ToString(sSQL, '');
end;

//-----------------------------------ADDS A NEW STAFF MEMBER
procedure AddStaffMember(FirtsName, Surname, Email, JobTitle : string);
var
  sSQL, sJobTitleID, sPassword : string;
  K : byte;
begin
  sSQL := 'Select * '
        + 'from Staff '
        + 'where [Email] = "' + Email + '"';

  //-------------------------------------CHECKS IF THE EMAIL ALREADY EXISTS
  if objDB.RecordExist(sSQL) = false then
  begin
    sSQL := 'Select [JobTitleID] '
          + 'from JobTitles '
          + 'where [Job Title Name] = "' + JobTitle + '"';
    sJobTitleID := objDB.ToString(sSQL, '');

    //-------------------------------------CREATES A RANDOM PASSWORD
    sPassword := RandomPass;

    sSQL := 'Insert into Staff '
          + '([First Name], [Surname], [Email], [Password], [Job Title])'
          + 'Values("' + FirtsName + '", "' + Surname + '", "' + Email +
            '", "' + sPassword + '", ' + sJobTitleID + ')';
    objDB.DoSQL(sSQL);

    //-------------------------------------SENDS EMAIL TO NEW STAFF MEMBER
    //-------------------------------------WITH THEIR PASSWORD
    MessageDlg('Sending Email Please Wait...', mtInformation, mbOKCancel, 0);
    objEmails.SendEmail(FirtsName + ' ' + Surname, Email,
    'Welcome to Our Staff', 'Dear ' + FirtsName + ' ' + Surname + ',' +
    #13 + #13 + 'You have been added to our staff as a ' + JobTitle +
    '.' + #13 + 'Your password is "' + sPassword + '".' + #13 + #13 +
    'You can change your password under Account Details.' + #13 + #13 +
    'Regards,' + #13 + 'Birds Eye Security');

    MessageDlg('Staff Member Successfully Added', mtInformation, mbOKCancel,
    0);
  end
  else
    MessageDlg('The staff member you are trying to add already ' +
    'works for this company. If you wish to reactivate their ' +
    'account you can do so by selecting their account above and' +
    ' reactivating it.', mtError, mbOKCancel, 0);
end;

//-------------------------------------MAKES A STAFF'S STATUS INACTIVE
procedure DeactiveStaffMember(Email : string);
var
  sSQL : string;
begin
  sSQL := 'Update Staff '
        + 'Set [Inactive Staff] = true '
        + 'where [Email] = "' + Email + '"';
  objDB.DoSQL(sSQL);

  MessageDlg('Staff Member Deactivated Successfully', mtInformation,
  mbOKCancel, 0);
end;

//-------------------------------------MAKES A STAFF'S STATUS ACTIVE
procedure ReactivateStaffMember(Email : string);
var
  sSQL : string;
begin
  sSQL := 'Update Staff '
        + 'Set [Inactive Staff] = false '
        + 'where [Email] = "' + Email + '"';
  objDB.DoSQL(sSQL);

  MessageDlg('Staff Member Reactivated Successfully', mtInformation,
  mbOKCancel, 0);
end;

end.

unit uStaff;

interface
  uses
    uDB_Source, uLibrary, Dialogs;

  Type
    TStaff = class
      private
        fID, fName, fSurname, fEmail, fPassword, fJobTitle : string;

      public
        constructor Create(Email, Password : string);
        function GetStaffID : string;
        function GetJobTitle : string;
        function GetName : string;
        function GetSurname : string;
        function GetEmail : string;
        function GetPass : string;
        procedure SetPass(Password : string);
    end;

implementation

{ TStaff }

//-----------------------------------CREATES A STAFF OBJECT
constructor TStaff.Create(Email, Password: string);
var
  sSQL : string;
  arrAccountInfo : TDynamicArray;
begin
  fEmail := Email;
  fPassword := Password;
  sSQL := 'Select [StaffID], [First Name], [Surname], [Job Title Name]'
        + 'from Staff, JobTitles '
        + 'where [Email] = "' + fEmail + '" AND [Password] = "' + fPassword +
          '" AND [Job Title] = [JobTitleID]';
  arrAccountInfo := objDB.ToArray(sSQL);
  fID := arrAccountInfo[0];
  fName := arrAccountInfo[1];
  fSurname := arrAccountInfo[2];
  fJobTitle := arrAccountInfo[3];
end;

//-----------------------------------RETURNS STAFF EMAIL ADDRESS
function TStaff.GetEmail: string;
begin
  Result := fEmail;
end;

//-----------------------------------RETURNS JOB TITLE
function TStaff.GetJobTitle: string;
begin
  Result := fJobTitle;
end;

//-----------------------------------RETURNS STAFF FIRST NAME
function TStaff.GetName: string;
begin
  Result := fName;
end;

//-----------------------------------RETURNS STAFF PASSWORD
function TStaff.GetPass: string;
begin
  Result := fPassword;
end;

//-----------------------------------RETURNS STAFF ID
function TStaff.GetStaffID: string;
begin
  Result := fID;
end;

//-----------------------------------RETURNS STAFF SURNAME
function TStaff.GetSurname: string;
begin
  Result := fSurname;
end;

//-----------------------------------CHANGES STAFF PASSWORD
procedure TStaff.SetPass(Password: string);
begin
  fPassword := Password;
end;

end.

unit uClient;

interface
  uses
    uDB_Source, uLibrary;

  Type
    TClient = class
      private
        fID, fName, fSurname, fEmail, fPassword, fAddressLine1,
        fSuburbName : string;

      public
        constructor Create(Email, Password : string);
        function GetUserID : string;
        function GetName : string;
        function GetSurname : string;
        function GetEmail : string;
        function GetAddressLine1 : string;
        function GetSuburbName : string;
        function GetPass : string;
        procedure SetPass(Password: string);
    end;

implementation

{ TClient }

//-------------------------------------CREATES A CLIENT OBJECT
constructor TClient.Create(Email, Password: string);
var
  sSQL : string;
  arrAccountInfo : TDynamicArray;
begin
  fEmail := Email;
  fPassword := Password;
  sSQL := 'Select [UserID], [First Name], [Surname], [Address Line 1], ' +
          '[Suburb] '
        + 'from Users '
        + 'where [Email] = "' + fEmail + '" AND [Password] = "' + fPassword
        + '"';
  arrAccountInfo := objDB.ToArray(sSQL);
  fID := arrAccountInfo[0];
  fName := arrAccountInfo[1];
  fSurname := arrAccountInfo[2];
  fAddressLine1 := arrAccountInfo[3];

  sSQL := 'Select [Suburb Name] '
        + 'from Suburbs '
        + 'where [SuburbID] = ' + arrAccountInfo[4];
  fSuburbName := objDB.ToString(sSQL, '');
end;

//-------------------------------------RETURNS CLIENTS ADDRESS
function TClient.GetAddressLine1: string;
begin
  Result := fAddressLine1;
end;

//-------------------------------------RETURNS CLIENTS EMAIL ADDRESS
function TClient.GetEmail: string;
begin
  Result := fEmail;
end;

//-------------------------------------RETURNS CLIENT FIRST NAME
function TClient.GetName: string;
begin
  Result := fName;
end;

//-------------------------------------RETURNS CLIENT PASSWORD
function TClient.GetPass: string;
begin
  Result := fPassword;
end;

//-------------------------------------RETURNS CLIENT SURNAME
function TClient.GetSurname: string;
begin
  Result := fSurname;
end;

//-------------------------------------RETURNS CLIENT ID
function TClient.GetUserID: string;
begin
  Result := fID;
end;

//-------------------------------------RETURNS CLEINTS SUBURB
function TClient.GetSuburbName: string;
begin
  Result := fSuburbName;
end;

//-----------------------------------CHANGES CLIENT PASSWORD
procedure TClient.SetPass(Password: string);
begin
  fPassword := Password;
end;

end.

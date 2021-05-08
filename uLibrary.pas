unit uLibrary;

interface
  uses
    uDB_Source, uEmails, Dialogs, SysUtils;

  const
    SECTION_BORDER = '---------------------------------------------------' +
                     '---------------------------------------------------';
    SUBURB_DELIMETER = ', ';
    TEXT_FILE_DELIMETER = '#';
    DB_FILE_NAME = 'BirdsEyeSecuritySurveillance_Data.mdb';

  var
    //-------------------------------------GLOBAL VARIABLES
    objDB : TDBClass;
    objEmails : TEmails;

  procedure CreateGlobalObjs;
  function PasswordCriteriaMet(Password: string): boolean;
  function RandomPass : string;
  function ValidatePostal(PostalCode : string) : boolean;

implementation

procedure CreateGlobalObjs;
begin
  objDB := TDBClass.Create(DB_FILE_NAME);
  objEmails := TEmails.Create;
end;

//-------------------------------------CHECKS THAT A PASSWORD MEETS PREDEFINED
//-------------------------------------CRITERIA
function PasswordCriteriaMet(Password: string): boolean;
var
  K, iLength, iCharCount, iNumCount: byte;
  cPass: char;
begin
  Result := true;
  iLength := Length(Password);
  if (iLength < 8) OR (iLength > 15) then
    Result := false
  else if POS(' ', Password) <> 0 then
    Result := false
  else
  begin
    //-------------------------------------ENSURES THE PASSWORD HAS ONE
    //-------------------------------------CHARACTER AND ONE NUMBER
    K := 1;
    iNumCount := 0;
    iCharCount := 0;
    while (K <= iLength) AND ((iCharCount = 0) OR (iNumCount = 0)) do
    begin
      cPass := UPCASE(Password[K]);
      if cPass IN ['A' .. 'Z'] then
        iCharCount := iCharCount + 1
      else if cPass IN ['0' .. '9'] then
        iNumCount := iNumCount + 1;
      K := K + 1;
    end;

    if (iCharCount = 0) OR (iNumCount = 0) then
      Result := false;
  end;

  if Result = false then
    MessageDlg('Your password does not meet the following criteria:' + #13 +
        '- Between 8 and 15 Characters' + #13 + '- No Spaces' + #13 +
        '- Atleast one character' + #13 + '- Atleast one number',
      mtInformation, mbOKCancel, 0);
end;

//-------------------------------------CREATES A RANDOM PASSWORD THAT MEETS
//-------------------------------------THE PREDEFINED CRITERIA
function RandomPass : string;
var
  K : byte;
begin
  Randomize;
  Result := Chr(Random(26) + 97);
  for K := 2 to 7 do
  begin
    if Random(2) + 1 = 1 then
    begin
      Result := Result + Chr(Random(26) + 97);
    end
    else
    begin
      Result := Result + IntToStr(Random(10));
    end;
  end;
  Result := Result + IntToStr(Random(10));
end;

//-----------------------------------CHECKS IF THE POSTAL CODE IS ONLY 4
//-----------------------------------CHARS LONG AND CONTAINS ONLY DIGITS
function ValidatePostal(PostalCode : string) : boolean;
var
  K, iLength : byte;
begin
  Result := true;
  K := 1;
  iLength := Length(PostalCode);
  if iLength <> 4 then
    Result := false
  else
  begin
    while (K <= iLength) AND (Result = true) do
      if NOT (PostalCode[K] IN ['0'..'9']) then
        Result := false
      else
        K := K + 1;
  end;

  if Result = false then
    MessageDlg('A postal code can only contain digits and be 4 ' +
    'characters long', mtError, mbOKCancel, 0);
end;

end.

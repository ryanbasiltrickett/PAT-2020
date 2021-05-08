unit uSuburbManagement;

interface
  uses
    uLibrary, Dialogs, uDB_Source;

  //-----------------------------------Add New Suburb Methods
  function RecommendedSuburbs : string;
  procedure SplitSuburbAndPostCode(SuburbAndCode : string; var Suburb,
  PostCode : string);
  function IsRecommendedSuburb(SuburbName, PostalCode : string) : boolean;
  procedure AddSuburb(SuburbName, PostalCode : string);
  procedure NotifyOfNewSuburb(RecommendedSubID, SuburbName, PostalCode
  : string);

  //-----------------------------------Edit Suburb Details Methods
  function SuburbsOrderBy(IsAscending : boolean) : string;
  procedure SaveSuburbDetails(SuburbName, PostalCode, NewSuburbName,
  NewPostalCode : string);

implementation

//-----------------------------------RETURNS ALL RECOMMENDED SUBURBS
function RecommendedSuburbs : string;
var
  sSQL : string;
begin
  sSQL := 'Select [Suburb Name], [Postal Code] '
        + 'from RecommendedSuburbs';
  Result := objDB.ToString(sSQL, SUBURB_DELIMETER);
end;

//-----------------------------------SPLITS THE POSTAL CODE AND SUBURB NAME
procedure SplitSuburbAndPostCode(SuburbAndCode : string; var Suburb,
PostCode : string);
var
  iPos : byte;
begin
  iPos := POS(SUBURB_DELIMETER, SuburbAndCode);
  Suburb := Copy(SuburbAndCode, 1, iPos - 1);
  Delete(SuburbAndCode, 1, iPos + Length(SUBURB_DELIMETER) - 1);
  PostCode := SuburbAndCode;
end;

//-----------------------------------CHECKS IF THE ENTERED SUBURB IS A
//-----------------------------------RECOMMENDED SUBURB
function IsRecommendedSuburb(SuburbName, PostalCode : string) : boolean;
var
  sSQL : string;
begin
  sSQL := 'Select * '
        + 'from RecommendedSuburbs '
        + 'where [Suburb Name] = "' + SuburbName + '" AND [Postal Code] = "' +
          PostalCode + '"';
  Result := objDB.RecordExist(sSQL);
end;

//-----------------------------------ADDS A NEW SUBURB
procedure AddSuburb(SuburbName, PostalCode : string);
var
  sSQL, sRecSubID : string;
begin
  sSQL := 'Select * '
        + 'from Suburbs '
        + 'where [Postal Code] = "' + PostalCode + '"';

  //-----------------------------------CHECKS IF SUBURB EXISTS
  if objDB.RecordExist(sSQL) = false then
  begin
    sSQL := 'Insert into Suburbs '
          + '([Suburb Name], [Postal Code]) '
          + 'Values("' + SuburbName + '", "' + PostalCode + '")';
    objDB.DoSQL(sSQL);

    //-----------------------------------CHECKS IF A USER ENTERED A
    //-----------------------------------RECOMMENDED SUBURB
    if IsRecommendedSuburb(SuburbName, PostalCode) = true then
    begin
      sSQL := 'Select [RecSuburbID] '
            + 'from RecommendedSuburbs '
            + 'where [Suburb Name] = "' + SuburbName + '" AND ' +
              '[Postal Code] = "' + PostalCode + '"';
      sRecSubID := objDB.ToString(sSQL, '');

      NotifyOfNewSuburb(sRecSubID, SuburbName, PostalCode);
    end;

    sSQL := 'Delete from RecommendedSuburbs '
          + 'where [Suburb Name] = "' + SuburbName + '" AND ' +
            '[Postal Code] = "' + PostalCode + '"';
    objDB.DoSQL(sSQL);

    MessageDlg('Suburb Successfully Added', mtInformation, mbOKCancel, 0);
  end
  else
    MessageDlg('The suburb you are trying to enter already exists ' +
    'within the database', mtError, mbOKCancel, 0);
end;

//-----------------------------------NOTIFIES PEOPLE VIA EMAIL
procedure NotifyOfNewSuburb(RecommendedSubID, SuburbName, PostalCode
  : string);
var
  sSQL : string;
  arrEmails : TDynamicArray;
  K : byte;
  iLength : word;
begin
  sSQL := 'Select [User Email] '
        + 'from NewSuburbEmailNotify '
        + 'where [RecSubID] = ' + RecommendedSubID;
  arrEmails := objDB.ToArray(sSQL);

  //-----------------------------------CHECKS IF THERE ARE EMAILS TO SEND
  iLength := Length(arrEmails);
  if iLength <> 0 then
  begin
    MessageDlg('Sending Emails Please Wait...', mtInformation, mbOKCancel, 0);
    for K := 0 to iLength - 1 do
    begin
      objEmails.SendEmail('', arrEmails[K],
      'Your Suburb Has Been Added to Our Service Areas', 'We are ' +
      'excited to announce that ' + SuburbName + ' with postal code ' +
      PostalCode + ' has been added to our service areas!' + #13 + #13 +
      'In order to sign up, press the Sign Up button and fill out ' +
      'all your information.' + #13 + 'You will now be able to ' +
      'select your suburb from the drop down.' + #13 + #13 + 'Regards,' +
      #13 + 'Birds Eye Security');
    end;
  end;
end;

//-----------------------------------ORDERS SUBURBS TABLE
function SuburbsOrderBy(IsAscending : boolean) : string;
begin
  Result := 'Select [Suburb Name], [Postal Code] '
          + 'from Suburbs ';

  if IsAscending = true then
    Result := Result + 'Order By [Suburb Name]'
  else
    Result := Result + 'Order By [Suburb Name] DESC';
end;

//-----------------------------------SAVES A SUBURBS DETAILS
procedure SaveSuburbDetails(SuburbName, PostalCode, NewSuburbName,
NewPostalCode : string);
var
  sSQL : string;
begin
  //-----------------------------------ENSURES POSTAL CODE IS VALID
  if ValidatePostal(PostalCode) = true then
  begin
    sSQL := 'Update Suburbs '
          + 'Set [Postal Code] = "' + NewPostalCode + '" '
          + 'where [Suburb Name] = "' + SuburbName + '" AND [Postal Code] ' +
            '= "' + PostalCode + '"';
    objDB.DoSQL(sSQL);

    sSQL := 'Update Suburbs '
          + 'Set [Suburb Name] = "' + NewSuburbName + '" '
          + 'where [Suburb Name] = "' + SuburbName + '" AND [Postal Code] ' +
            '= "' + PostalCode + '"';
    objDB.DoSQL(sSQL);

    MessageDlg('Suburb Details Changed Successfully', mtInformation,
    mbOKCancel, 0);
  end;
end;

end.

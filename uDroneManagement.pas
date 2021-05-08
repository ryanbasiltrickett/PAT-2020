unit uDroneManagement;

interface
  uses
    uLibrary, SysUtils, Dialogs;

  function DroneOrderBy(OrderBy : string) : string;
  function ToStringSuburbs : string;
  function ToStringDroneTypes : string;
  function GenerateSerialNumber : string;
  function SerialNumExists(SerialNumber : string) : boolean;
  procedure AddNewDrone(SerialNumber, Suburb, DroneType : string);
  procedure EditDrone(OldSerialNumber, NewSerialNumber, Status, Suburb,
  DroneType : string);
  function ValidateSerialNumber(SerialNumber : string) : boolean;

implementation

//-------------------------------------RETURNS SQL FOR A RECORD ORDER
function DroneOrderBy(OrderBy : string) : string;
begin
  Result := 'Select [Serial Number], [Suburb Name], [Service Name] AS' +
            ' [Drone Type], [Status] '
          + 'from Drones, Suburbs, Services '
          + 'where [Suburb] = [SuburbID] AND [Drone Type] = [ServiceID] '
          + 'order by [' + Trim(OrderBy) + ']';
end;

//-------------------------------------RETURNS ALL SUBURBS' DETAILS
function ToStringSuburbs : string;
var
  sSQL : string;
begin
  sSQL := 'Select [Suburb Name], [Postal Code] '
        + 'from Suburbs ';
  Result := objDB.ToString(sSQL, SUBURB_DELIMETER);
end;

//-------------------------------------RETURNS ALL SERVICE NAMES
function ToStringDroneTypes : string;
var
  sSQL : string;
begin
  sSQL := 'Select [Service Name] '
        + 'from Services ';
  Result := objDB.ToString(sSQL, '');
end;

//-------------------------------------GENERATES A RANDOM SERIAL NUMBER
function GenerateSerialNumber : string;
var
  K : byte;
begin
  Result := '';
  for K := 1 to 7 do
    Result := Result + IntToStr(Random(10));
end;

//-------------------------------------CHECKS IF SERIAL NUMBER EXISTS
function SerialNumExists(SerialNumber : string) : boolean;
var
  sSQL : string;
begin
  sSQL := 'Select [Serial Number] '
        + 'from Drones '
        + 'where [Serial Number] = "' + SerialNumber + '"';
  Result := objDB.RecordExist(sSQL);

  if Result = true then
    MessageDlg('The drones new serial number already exists ' +
    'please ensure that the serial number is unique', mtError, mbOKCancel,
    0);
end;

//-------------------------------------ADDS A NEW DRONE
procedure AddNewDrone(SerialNumber, Suburb, DroneType : string);
var
  sSQL, sSuburbID, sDroneTypeID : string;
begin
  if SerialNumExists(SerialNumber) = false then
  begin
    sSQL := 'Select [SuburbID] '
          + 'from Suburbs '
          + 'where [Suburb Name] & ", " & [Postal Code] = "' + Suburb + '"';
    sSuburbID := objDB.ToString(sSQL, '');

    sSQL := 'Select [ServiceID] '
          + 'from Services '
          + 'where [Service Name] = "' + DroneType + '"';
    sDroneTypeID := objDB.ToString(sSQL, '');

    sSQL := 'Insert into Drones '
          + '([Serial Number], [Suburb], [Drone Type]) '
          + 'Values("' + SerialNumber + '", ' + sSuburbID + ', ' +
            sDroneTypeID + ')';
    objDB.DoSQL(sSQL);

    MessageDlg('Drone Added Successfully', mtInformation, mbOKCancel, 0);
  end
  else
    MessageDlg('The serial number already exists please ensure that ' +
    'the serial number is unique', mtError, mbOKCancel, 0);
end;

//-------------------------------------UPDATES DATA FOR A SPECIFIC DRONE
procedure EditDrone(OldSerialNumber, NewSerialNumber, Status, Suburb,
DroneType : string);
var
  sSQL, sSuburbID, sDroneTypeID, sDroneID : string;
begin
  sSQL := 'Select [SuburbID] '
        + 'from Suburbs '
        + 'where [Suburb Name] & ", " & [Postal Code] = "' + Suburb + '"';
  sSuburbID := objDB.ToString(sSQL, '');

  sSQL := 'Select [ServiceID] '
        + 'from Services '
        + 'where [Service Name] = "' + DroneType + '"';
  sDroneTypeID := objDB.ToString(sSQL, '');

  sSQL := 'Select [DroneID] '
        + 'from Drones '
        + 'where [Serial Number] = "' + OldSerialNumber + '"';
  sDroneID := objDB.ToString(sSQL, '');

  //-------------------------------------UPDATES DRONE DATA
  if (SerialNumExists(NewSerialNumber) = false) AND (ValidateSerialNumber(
  NewSerialNumber) = true) then
  begin
    sSQL := 'Update Drones '
          + 'Set [Status] = "' + Status + '" '
          + 'where [Serial Number] = "' + NewSerialNumber + '"';
    objDB.DoSQL(sSQL);

    sSQL := 'Update Drones '
          + 'Set [Suburb] = ' + sSuburbID + ' '
          + 'where [Serial Number] = "' + NewSerialNumber + '"';
    objDB.DoSQL(sSQL);

    sSQL := 'Update Drones '
          + 'Set [Drone Type] = ' + sDroneTypeID + ' '
          + 'where [Serial Number] = "' + NewSerialNumber + '"';
    objDB.DoSQL(sSQL);

    if OldSerialNumber <> NewSerialNumber then
    begin
      sSQL := 'Update Drones '
            + 'Set [Serial Number] = "' + NewSerialNumber + '" '
            + 'where [Serial Number] = "' + OldSerialNumber + '"';
      objDB.DoSQL(sSQL);
    end;

    MessageDlg('Drone Details Changed Successfully', mtInformation,
    mbOKCancel, 0);
  end;
end;

//-------------------------------------ENSURES THAT THE SERIAL NUMBER IS
//-------------------------------------ACCORDING TO PREDEFINED PARAMETERS
function ValidateSerialNumber(SerialNumber : string) : boolean;
var
  iLength, K : byte;
begin
  Result := true;
  K := 1;

  iLength := Length(SerialNumber);
  if iLength <> 6 then
    Result := false
  else
  begin
    //-------------------------------------CHECKS THAT THE SERIAL NUMBER
    //-------------------------------------CONTAINS ONLY DIGITS
    while (Result = true) AND (K <= iLength) do
    begin
      if NOT (SerialNumber[K] IN ['0'..'9']) then
        Result := false
      else
        K := K + 1;
    end;
  end;

  if Result = false then
    MessageDlg('The drones new serial number can only contain numbers ' +
    'and must be exactly 6 characters long.', mtError, mbOKCancel, 0);
end;

end.

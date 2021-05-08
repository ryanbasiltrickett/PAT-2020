unit uClientReportsAndLogs;

interface
  uses
    uLibrary, uDB_Source, SysUtils, DateUtils, frmFootage, Forms;

  const
     //-------------------------------------ARRAY OF STATUS SQL
    STATUS : array[0..3] of string =
    (
        '',
        ' AND [DroneFlights.Status] = "Scheduled"',
        ' AND [DroneFlights.Status] = "Departed"',
        ' AND [DroneFlights.Status] = "Completed"'
    );

     //-------------------------------------ARRAY OF ORDER BY SQL
    ORDER_BY : array[0..1] of string =
    (
        ' order by [Service Name], [Date and Time of Response]',
        ' order by [Date and Time of Response]'
    );

  function UserFlightReports(UserID : string; OrderByIndex, StatusIndex
  : byte) : string;
  function SurveillanceSummary(DroneFlightID : string) : string;
  procedure ShowSurvFootage(DroneFlightID : string);

  function CostOfServicesReport(UserID : string) : string;
  function SuburbReport(UserID : string) : string;

implementation

//-------------------------------------RETURNS A DETAILED RECIEPT FOR ALL
//-------------------------------------DRONE REQUEST SERVICES FOR THE
//-------------------------------------CURRENT MONTH
function CostOfServicesReport(UserID: string): string;
var
  sSQL : string;
begin
  Result := 'Cost of Service Report for ' +
            LongMonthNames[MonthOf(Date())] + ':' + #13 + #13;

  //-------------------------------------GETS DETAILS OF EACH SERVICE REQUEST
  sSQL := 'Select [Service Name], [Date and Time of Response], ' +
          'Format([Price Per Day], "Currency") AS [Price] '
        + 'from DroneFlights, Drones, Services, FlightToServiceAssignment' +
          ', UserServices '
        + 'where [DroneFlights.DroneID] = [Drones.DroneID] AND ' +
          '[Drone Type] = [Services.ServiceID] AND ' +
          '[DroneFlights.DroneFlightID] = ' +
          '[FlightToServiceAssignment.DroneFlightID] AND ' +
          '[FlightToServiceAssignment.UserServiceID] = ' +
          '[UserServices.UserServiceID] AND [UserServices.UserID] = ' +
           UserID + ' AND Month([Date and Time of Response]) = ' +
           'Month(Date())';
  Result := Result + objDB.ToStringHeadings(sSQL, #9) + #13;
  Result := Result + SECTION_BORDER + #13;
  Result := Result + objDB.ToString(sSQL, #9) + #13;
  Result := Result + SECTION_BORDER + #13;

  //-------------------------------------GETS THE TOTAL AMOUNT OWING
  sSQL := 'Select Format(Sum([Price Per Day]), "Currency") AS [Total] '
        + 'from DroneFlights, Drones, Services, FlightToServiceAssignment' +
          ', UserServices '
        + 'where [DroneFlights.DroneID] = [Drones.DroneID] AND ' +
          '[Drone Type] = [Services.ServiceID] AND ' +
          '[DroneFlights.DroneFlightID] = ' +
          '[FlightToServiceAssignment.DroneFlightID] AND ' +
          '[FlightToServiceAssignment.UserServiceID] = ' +
          '[UserServices.UserServiceID] AND [UserServices.UserID] = ' +
           UserID + ' AND Month([Date and Time of Response]) = ' +
           'Month(Date())';
  Result := Result + objDB.ToStringHeadings(sSQL, '') + #9 + #9 +
            objDB.ToString(sSQL, '');
end;

//-------------------------------------RETURNS A LIST OF ALL SERVICES
//-------------------------------------REQUESTED IN THE USERS SUBURB
function SuburbReport(UserID: string): string;
var
  sSQL, sSuburbID : string;
begin
  Result := 'Suburb Report for ' + LongMonthNames[MonthOf(Date())] +
            ':' + #13 + #13;

  sSQL := 'Select [Suburb] '
        + 'from Users '
        + 'where [UserID] = ' + UserID;
  sSuburbID := objDB.ToString(sSQL, '');

  sSQL := 'Select [Service Name], Count(*) AS [Number of Responses] '
        + 'from DroneFlights, Drones, Services '
        + 'where [DroneFlights.DroneID] = [Drones.DroneID] AND ' +
          '[Suburb] = ' + sSuburbID + ' AND [Drone Type] = ' +
          '[Services.ServiceID] AND Month(' +
          '[Date and Time of Response]) = Month(Date()) '
        + 'group by [Service Name]';
  Result := Result + objDB.ToStringHeadings(sSQL, #9) + #13;
  Result := Result + SECTION_BORDER + #13;
  Result := Result + objDB.ToString(sSQL, #9);
end;

//-------------------------------------RETRUNS A SURVEILLANCE SUMMARY OF A
//-------------------------------------SPECIFIC FLIGHT
function SurveillanceSummary(DroneFlightID: string)
: string;
var
  sSQL : string;
begin
  sSQL := 'Select [Surveillance Summary] '
        + 'from SurveillanceReports '
        + 'where [DroneFlightID] = ' + DroneFlightID;

  Result := objDB.ToString(sSQL, '');
end;

//-------------------------------------OPENS THE FOOTAGE FILE IN A
//-------------------------------------DEDICATED FORM
procedure ShowSurvFootage(DroneFlightID : string);
var
  objFootageForm : TFootageForm;
  sSQL, sFilePath : string;
begin
  sSQL := 'Select [Surveillance Footage] '
        + 'from SurveillanceReports '
        + 'where [DroneFlightID] = ' + DroneFlightID;
  sFilePath := objDB.ToString(sSQL, '');

  objFootageForm := TFootageForm.Create(Application);
  objFootageForm.ShowFootage(sFilePath);
  objFootageForm.Show;
end;

//-------------------------------------RETURNS SQL FOR ALL THE USERS
//-------------------------------------SERVICE REQUEST
function UserFlightReports(UserID : string; OrderByIndex, StatusIndex
  : byte) : string;
begin
  Result := 'Select [DroneFlights.DroneFlightID] AS [Flight No], ' +
            '[Service Name], [Serial Number] AS [Drone Serial Number]' +
            ', [Date and Time of Response], [DroneFlights.Status] ' +
            'AS [Status] '
          + 'from DroneFlights, Drones, Services, ' +
            'FlightToServiceAssignment, UserServices '
          + 'where [DroneFlights.DroneID] = [Drones.DroneID] AND ' +
            '[Drone Type] = [Services.ServiceID] AND ' +
            '[DroneFlights.DroneFlightID] = ' +
            '[FlightToServiceAssignment.DroneFlightID] AND ' +
            '[FlightToServiceAssignment.UserServiceID] = ' +
            '[UserServices.UserServiceID] AND [UserServices.UserID] = ' +
            UserID + STATUS[StatusIndex] + ORDER_BY[OrderByIndex];
end;

end.

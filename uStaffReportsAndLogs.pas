unit uStaffReportsAndLogs;

interface
  uses
    uLibrary, SysUtils;

  const
    //-------------------------------------ARRAY OF ORDER BY SQL
    FLIGHT_LOGS_ORDER_BY_SQL : array[0..4] of string =
    (
        'Order by [Suburb Name], [DroneFlights.DroneFlightID]',
        'Order by [Drone Type], [DroneFlights.DroneFlightID]',
        'Order by [Date and Time of Response] DESC, ' +
        '[DroneFlights.DroneFlightID] DESC',
        'Order by [Date and Time of Response], [DroneFlights.DroneFlightID]',
        'Order by [First Name], [Surname], [DroneFlights.DroneFlightID]'
    );

    //-------------------------------------ARRAY OF STATUS SQL
    FLIGHT_LOGS_STATUS_SQL : array[0..2] of string =
    (
        '',
        '[DroneFlights.Status] = "Completed" AND ',
        '[DroneFlights.Status] = "Departed" AND '
    );

    //-------------------------------------ARRAY OF DIFFERENT REPORT SQL
    REPORTS_SQL : array[0..7] of string =
    (
          'Select [Serial Number], [Suburb Name], [Service Name] AS ' +
          '[Drone Type], [Status] '
        + 'from Drones, Suburbs, Services '
        + 'where [Suburb] = [SuburbID] AND [Drone Type] = [ServiceID]',

          'Select [Serial Number], [Suburb Name], [Service Name] AS ' +
          '[Drone Type], [Status] '
        + 'from Drones, Suburbs, Services '
        + 'where [Suburb] = [SuburbID] AND [Drone Type] = [ServiceID] AND' +
          ' [Status] = "Active"',

          'Select [Serial Number], [Suburb Name], [Service Name] AS ' +
          '[Drone Type], [Status] '
        + 'from Drones, Suburbs, Services '
        + 'where [Suburb] = [SuburbID] AND [Drone Type] = [ServiceID] AND' +
          ' [Status] = "Being Serviced"',

          'SELECT [Serial Number], [Suburb Name], [Service Name] AS ' +
          '[Drone Type], (40 - Count([DroneFlightID])) AS ' +
          '[Flights Till Service] '
        + 'FROM Drones, DroneFlights, Suburbs, Services '
        + 'WHERE [Drones.DroneID] = [DroneFlights.DroneID] AND ' +
          '[Suburb] = [SuburbID] AND [Drone Type] = [ServiceID] '
        + 'GROUP BY [Serial Number], [Suburb Name], [Service Name]',

          'Select [Suburb Name], [Postal Code], Count([UserID]) AS ' +
          '[Number of Users]'
        + 'from Suburbs, Users '
        + 'where [Suburbs.SuburbID] = [Users.Suburb] '
        + 'Group By [Suburb Name], [Postal Code]',

          'Select [Suburb Name], [Postal Code], [Serial Number], ' +
          'Format([Date and Time of Response], "Long Time"), ' +
          '[DroneFlights.Status] '
        + 'from DroneFlights, Drones, Suburbs '
        + 'where [Drones.DroneID] = [DroneFlights.DroneID] AND ' +
          '[Drones.Suburb] = [Suburbs.SuburbID]',

          'Select [Suburb Name], [Postal Code], [Number of Recommendations] '
        + 'from RecommendedSuburbs',

          'Select [Suburb Name], [Postal Code], [Number of Recommendations] '
        + 'from RecommendedSuburbs '
        + 'where [Number of Recommendations] > 100'
    );

  function EarliestDate : TDate;
  function LatestDate : TDate;
  function FlightLogsOrderBy(OrderIndex, StatusIndex : byte; StartDate,
  EndDate, FlightNumber : string) : string;
  function Report(ReportID : byte) : string;

implementation

//-------------------------------------RETURNS THE DATE OF THE EARLIEST FLIGHT
function EarliestDate : TDate;
var
  sSQL, sDate : string;
begin
  sSQL := 'Select DISTINCT Top 1 Format([Date and Time of Response]' +
          ', "Short Date") '
        + 'from DroneFlights '
        + 'order by Format([Date and Time of Response]' +
          ', "Short Date")';
  sDate := Copy(objDB.ToString(sSQL, ''), 1, 10);
  if sDate <> '' then
    Result := StrToDate(sDate)
  else
    Result := Date();
end;

//-------------------------------------RETURNS THE DATE OF THE LATEST FLIGHT
function LatestDate : TDate;
var
  sSQL, sDate : string;
begin
  sSQL := 'Select DISTINCT Top 1 Format([Date and Time of Response]' +
          ', "Short Date") '
        + 'from DroneFlights '
        + 'order by Format([Date and Time of Response]' +
          ', "Short Date") DESC';
  sDate := Copy(objDB.ToString(sSQL, ''), 1, 10);
  if sDate <> '' then
    Result := StrToDate(sDate)
  else
    Result := Date();
end;

//-------------------------------------RETURNS THE SQL FOR THE FLIGHT LOGS
//-------------------------------------USING ALL THE PARAMETERS
function FlightLogsOrderBy(OrderIndex, StatusIndex : byte; StartDate,
  EndDate, FlightNumber : string) : string;
var
  sOrderBy, sStatus : string;
begin
  sOrderBy := FLIGHT_LOGS_ORDER_BY_SQL[OrderIndex];
  sStatus := FLIGHT_LOGS_STATUS_SQL[StatusIndex];
  Result := 'Select [DroneFlights.DroneFlightID] AS [Flight No], ' +
            '[Serial Number], [Service Name] AS [Drone Type], ' +
            '[Suburb Name], [Date and Time of Response], ' +
            '[First Name] & " " & [Surname] AS [Assigned Staff Member] '
          + 'from DroneFlights, Drones, Services, Suburbs, ' +
            'SurveillanceReports, Staff '
          + 'where ' + sStatus + '[DroneFlights.DroneID] = ' +
            '[Drones.DroneID] AND [Drone Type] = [ServiceID] AND ' +
            '[Drones.Suburb] = [Suburbs.SuburbID] AND ' +
            '[DroneFlights.DroneFlightID] = ' +
            '[SurveillanceReports.DroneFlightID] AND ' +
            '[SurveillanceReports.StaffID] = [Staff.StaffID] AND ' +
            '[Date and Time of Response] >= #' + StartDate + '# AND ' +
            '[Date and Time of Response] <= #' + EndDate + '# AND ' +
            'cStr([DroneFlights.DroneFlightID]) Like "' + FlightNumber +
            '%" '
          + sOrderBy;
end;

//-------------------------------------RETURNS THE SQL FOR A SPECIFIC REPORT
function Report(ReportID : byte) : string;
begin
  Result := REPORTS_SQL[ReportID];
end;

end.

unit uAnalyseSurveillance;

interface
  uses
    uLibrary, Dialogs;

  function SurveillanceToBeAnalysed(StaffID : string) : string;
  function GetSurveillanceFootage(FlightID : string) : string;
  procedure SubmitSurveillanceAnalyses(FlightID, Summary : string);

implementation
//-------------------------------------RETURNS SQL OF ALL SURVEILLANCE WHICH
//-------------------------------------NEEDS TO BE ANALYSED BY A SPECIFC
//-------------------------------------STAFF MEMBER
function SurveillanceToBeAnalysed(StaffID : string) : string;
begin
  Result := 'Select [DroneFlights.DroneFlightID] AS [Flight No],' +
            ' [Service Name], [Serial Number] AS [Drone Serial Number]' +
            ', [Date and Time of Response] '
          + 'from DroneFlights, Drones, Services, SurveillanceReports '
          + 'where [DroneFlights.DroneID] = [Drones.DroneID] AND ' +
            '[Drone Type] = [Services.ServiceID] AND ' +
            '[DroneFlights.DroneFlightID] = ' +
            '[SurveillanceReports.DroneFlightID] AND ' +
            '[StaffID] = ' + StaffID + 'AND [Time Analysed] IS NULL AND ' +
            '[DroneFlights.Status] = "Completed"';
end;

//-------------------------------------RETURNS THE SURVEILLANCE FOOTAGE OF
//-------------------------------------A SPECIFIC FLIGHT
function GetSurveillanceFootage(FlightID : string) : string;
var
  sSQL : string;
begin
  sSQL := 'Select [Surveillance Footage] '
        + 'from SurveillanceReports '
        + 'where [DroneFlightID] = ' + FlightID;
  Result := objDB.ToString(sSQL, '');
end;

//-------------------------------------SUBMITS THE STAFF MEMBERS SURVEILLANCE
//-------------------------------------REPORT
procedure SubmitSurveillanceAnalyses(FlightID, Summary : string);
var
  sSQL : string;
begin
  sSQL := 'Update SurveillanceReports '
        + 'set [Surveillance Summary] = "' + Summary + '"  '
        + 'where [DroneFlightID] = ' + FlightID;
  objDB.DoSQL(sSQL);

  sSQL := 'Update SurveillanceReports '
        + 'set [Time Analysed] = Now() '
        + 'where [DroneFlightID] = ' + FlightID;
  objDB.DoSQL(sSQL);

  MessageDlg('Surveillance Analysis Submitted Successfully', mtInformation,
  mbOKCancel, 0);
end;

end.

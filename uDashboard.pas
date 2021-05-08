unit uDashboard;

interface
  uses
    uDB_Source, SysUtils, uLibrary;

  procedure DroneStatus(var TotalDrones, ActiveDrones : word; var Demand
  : string);


implementation
//-------------------------------------RETURNS DATA ABOUT IN FLIGHT DRONES
procedure DroneStatus(var TotalDrones, ActiveDrones : word; var Demand
: string);
var
  sSQL : string;
  rPercActive : real;
begin
  sSQL := 'Select Count(*) '
        + 'from Drones';
  TotalDrones := StrToInt(objDB.ToArray(sSQL)[0]);

  sSQL := 'Select Count(*) '
        + 'from Drones '
        + 'where [DroneID] IN (Select [DroneID] from DroneFlights where' +
          ' [Status] <> "Completed")';
  ActiveDrones := StrToInt(objDB.ToArray(sSQL)[0]);

  rPercActive := ActiveDrones/TotalDrones * 100;
  if rPercActive <= 40 then
    Demand := 'LOW DEMAND'
  else if rPercActive >= 80 then
    Demand := 'HIGH DEMAND'
  else
    Demand := 'AVG DEMAND';
end;

end.

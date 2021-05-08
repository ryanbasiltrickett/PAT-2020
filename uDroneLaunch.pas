unit uDroneLaunch;

interface
  uses
    uDB_Source, uLibrary, SysUtils;

  procedure AssignStaffToService(DroneFlightID : string);
  procedure ScheduleFlight(Service, Date, Time, UserID, UserServiceID,
  SuburbID : string);
  procedure AssignUserServiceToFlight(UserServiceID, DroneFlightID: string);

implementation

{ TDroneLaunch }

//-------------------------------------ASSIGNS A STAFF MEMBER TO A FLIGHT
procedure AssignStaffToService(DroneFlightID : string);
var
  sSQL : string;
  arrStaffMembers : TDynamicArray;
  iRandom : word;
begin
  sSQL := 'Select [StaffID] '
        + 'from Staff, JobTitles '
        + 'where [Job Title] = [JobTitleID] AND [Job Title Name] = ' +
          '"Surveillance Analyst"';
  arrStaffMembers := objDB.ToArray(sSQL);

  Randomize;
  iRandom := Random(Length(arrStaffMembers));
  sSQL := 'Insert into SurveillanceReports '
        + '([DroneFlightID], [StaffID]) '
        + 'Values(' + DroneFlightID + ', ' + arrStaffMembers[iRandom] + ')';
  objDB.DoSQL(sSQL);
end;

//-------------------------------------ASSIGNS A USERS SERVICE REQUEST TO
//-------------------------------------A SPECIFIC FLIGHT
procedure AssignUserServiceToFlight(UserServiceID, DroneFlightID: string);
var
  sSQL : string;
begin
  sSQL := 'Insert into FlightToServiceAssignment '
        + '([UserServiceID], [DroneFlightID]) '
        + 'Values(' + UserServiceID + ', ' + DroneFlightID + ')';
  objDB.DoSQL(sSQL);
end;

//-------------------------------------SCHEDULES ALL THE FLIGHTS FOR
//-------------------------------------A SERVICE REQUEST
procedure ScheduleFlight(Service, Date, Time, UserID, UserServiceID,
  SuburbID : string);
var
  sSQL, sServiceID, sDroneFlightID : string;
  arrAvailableDrones : TDynamicArray;
  iRandom : byte;
begin
  sSQL := 'Select [ServiceID] '
        + 'from Services '
        + 'where [Service Name] = "' + Service + '"';
  sServiceID := objDB.ToString(sSQL, '');

  //-------------------------------------FINDS ALL AVAILABLE DRONES FOR THE
  //-------------------------------------SPECIFIC DATE
  sSQL := 'Select [DroneID] '
        + 'from Drones '
        + 'where [Drone Type] = ' + sServiceID + 'AND [Suburb] = ' +
          SuburbID + ' AND [DroneID] NOT IN (Select [DroneID] ' +
          'from DroneFlights where Format(' +
          '[Date and Time of Response], "Short Date") = #' +
          Date + '# AND [Status] <> "Completed")';
  arrAvailableDrones := objDB.ToArray(sSQL);
  if Length(arrAvailableDrones) <> 0 then
  begin
    //-------------------------------------ASSIGNS A RANDOM DRONE TO
    //-------------------------------------A SERVICE REQUEST
    Randomize;
    iRandom := Random(Length(arrAvailableDrones));

    sSQL := 'Insert into DroneFlights '
          + '([DroneID], [Date and Time of Response]) '
          + 'Values(' + arrAvailableDrones[iRandom] + ', Format("' + Date +
            ' ' + Time + '", "General Date"))';
    objDB.DoSQL(sSQL);

    sSQL := 'Select [DroneFlightID] '
          + 'from DroneFlights '
          + 'where [DroneID] = ' + arrAvailableDrones[iRandom] +
            ' AND [Status] = "Scheduled" AND [DroneFlightID] NOT ' +
            'IN (Select [DroneFlightID] from FlightToServiceAssignment)';
    sDroneFlightID := objDB.ToString(sSQL, '');

    AssignUserServiceToFlight(UserServiceID, sDroneFlightID);
    AssignStaffToService(sDroneFlightID);
  end;
end;

end.

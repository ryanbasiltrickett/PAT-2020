unit uAutoDroneDeployment;

interface
  uses
    uLibrary, uDB_Source;

  const
    arrFootage : array[1..2] of string =
    (
      'SurvFootage1.jpg', 'SurvFootage2.jpg'
    );

  procedure DeployDrones;
  procedure CompleteFlights;

implementation

//-------------------------------------DEPLOYS ALL DRONES IF THEY HAVE A
//-------------------------------------SCHEDULED FLIGHT
procedure DeployDrones;
var
  sSQL : string;
  K, iLength : byte;
  arrDroneFlightIDs : TDynamicArray;
begin
  //-------------------------------------GETS ALL FLIGHTS WHICH ARE MEANT
  //-------------------------------------TO BE UNDERWAY
  sSQL := 'Select [DroneFlightID] '
        + 'from DroneFlights '
        + 'where [Date and Time of Response] <= Now() AND [Status] ' +
          '<> "Completed"';
  arrDroneFlightIDs := objDB.ToArray(sSQL);

  //-------------------------------------DEPART EACH DRONE
  iLength := Length(arrDroneFlightIDs);
  if iLength <> 0 then
  begin
    sSQL := 'Update DroneFlights '
        + 'Set [Status] = "Departed" '
        + 'where [Date and Time of Response] <= Now() AND [Status] ' +
          '<> "Completed"';
    objDB.DoSQL(sSQL);

    Randomize;
    for K := 0 to Length(arrDroneFlightIDs) - 1 do
    begin
      sSQL := 'Update SurveillanceReports '
            + 'Set [Surveillance Summary] = "Retrieving ' +
              'Surveillance Footage..." '
            + 'where [DroneFlightID] = ' + arrDroneFlightIDs[K];
      objDB.DoSQL(sSQL);
    end;
  end;
end;

//-------------------------------------CHANGE FLIGHT STATUS TO COMPLETE IF
//-------------------------------------SURVEILLANCE IS OVER
procedure CompleteFlights;
var
  sSQL : string;
  K, iRandom, iLength : byte;
  arrDroneFlightIDs : TDynamicArray;
begin
  //-------------------------------------GETS ALL FLIGHTS WHICH ARE MEANT
  //-------------------------------------TO HAVE BEEN COMPLETED
  sSQL := 'Select [DroneFlightID] '
        + 'from DroneFlights, Drones, Services '
        + 'where [DroneFlights.DroneID] = [Drones.DroneID] AND ' +
          '[Drones.Drone Type] = [ServiceID] AND ' +
          'IIF([Service Name] = "Emergency Response", DateAdd("h", 1, ' +
          '[Date and Time of Response]) <= Now(), Format(Format(' +
          '[Date and Time of Response], "Short Date") & " " & ' +
          'Format([Surveillance End Time], "Long Time"), ' +
          '"General Date") <= Now()) AND [DroneFlights.Status] ' +
          '<> "Completed"';
  arrDroneFlightIDs := objDB.ToArray(sSQL);

  //-------------------------------------COMPLETES EACH FLIGHT
  iLength := Length(arrDroneFlightIDs);
  if iLength <> 0 then
  begin
    sSQL := 'Update DroneFlights '
          + 'Set [Status] = "Completed" '
          + 'where [DroneFlightID] IN (Select [DroneFlightID]' +
            ' from DroneFlights, Drones, Services where ' +
            '[DroneFlights.DroneID] = [Drones.DroneID] AND ' +
            '[Drones.Drone Type] = [ServiceID] AND ' +
            'IIF([Service Name] = "Emergency Response", DateAdd("h", 1, ' +
            '[Date and Time of Response]) <= Now(), Format(Format(' +
            '[Date and Time of Response], "Short Date") & " " & ' +
            'Format([Surveillance End Time], "Long Time"), ' +
            '"General Date") <= Now()) AND [DroneFlights.Status] ' +
            '<> "Completed")';
    objDB.DoSQL(sSQL);

    //-------------------------------------ASSIGNS FOOTAGE TO A FLIGHT
    Randomize;
    for K := 0 to iLength - 1 do
    begin
      iRandom := Random(Length(arrFootage)) + 1;
      sSQL := 'Update SurveillanceReports '
            + 'Set [Surveillance Footage] = "' + arrFootage[iRandom] + '" '
            + 'where [DroneFlightID] = ' + arrDroneFlightIDs[K];
      objDB.DoSQL(sSQL);

      sSQL := 'Update SurveillanceReports '
            + 'Set [Surveillance Summary] = "Waiting for ' +
              'Incident Report..." '
            + 'where [DroneFlightID] = ' + arrDroneFlightIDs[K];
      objDB.DoSQL(sSQL);
    end;
  end;
end;

end.

unit uServiceRequest;

interface
  uses
    SysUtils, uDroneLaunch, uLibrary, Generics.Collections, Dialogs,
    DateUtils, uAutoDroneDeployment;

  Type
    TServiceRequest = class
      const
        EMERGENCY_SERVICE_NAME = 'Emergency Response';
        DETAILS_TXT = 'ServiceDetails.txt';
        DETAIL_DELIMETER = '#';

      private
        fStartDate, fEndDate : TDate;
        fServiceName : string;
        fPricePerDay : real;
        fDetailsDictionary : TDictionary<string, string>;


      public
        constructor Create;
        procedure SetValues(StartDate, EndDate : TDate;
        ServiceName : string; PricePerDay : real);
        function UpdateServiceSummary : string;
        function ConfirmServiceRequest : string;
        procedure RequestService(UserID, Time : string);
    end;

implementation

{ TServiceRequest }

//-------------------------------------RETURNS A DETAILED LIST OF THE DETAILS
//-------------------------------------OF A CLIENTS SEVICE REQUEST
function TServiceRequest.ConfirmServiceRequest: string;
begin
  Result := 'Are you sure you want to request this service:' + #13
          + 'Service Name:' + #13
          + fServiceName + #13 + #13
          + UpdateServiceSummary;
end;

constructor TServiceRequest.Create;
var
  tFl : TextFile;
  sLine, sService, sDetails : string;
  iPos : byte;
begin
  AssignFile(tFl, DETAILS_TXT);
  Reset(tFl);

  //-------------------------------------LOADS DATA INTO THE DICTIONARY
  fDetailsDictionary := TDictionary<string, string>.Create;
  while NOT EoF(tFl) do
  begin
    Readln(tFl, sLine);
    iPos := POS(DETAIL_DELIMETER, sLine);
    sService := UPPERCASE(Copy(sLine, 1, iPos - 1));
    Delete(sLine, 1, iPos);
    sDetails := sLine;
    fDetailsDictionary.Add(sService, sDetails);
  end;
  CloseFile(tFl);
end;

//-------------------------------------ADDS A CLIENTS SERVICE REQUEST TO
//-------------------------------------THE DATABASE
procedure TServiceRequest.RequestService(UserID, Time: string);
var
  sSQL, sServiceID, sOldDates, sUserServiceID, sSuburbID : string;
  K, iNumDays : byte;
  dDate : TDate;
begin
  sSQL := 'Select [ServiceID] '
        + 'from Services '
        + 'where [Service Name] = "' + fServiceName + '"';
  sServiceID := objDB.ToString(sSQL, '');

  sSQL := 'Select [Suburb] '
        + 'from Users '
        + 'where [UserID] = ' + UserID;
  sSuburbID := objDB.ToString(sSQL, '');

  sSQL := 'Select * '
        + 'from UserServices '
        + 'where [UserID] = ' + UserID + ' AND [ServiceID] = ' +
          sServiceID + ' AND (([Start Date] <= #' + DateToStr(fStartDate) +
          '# AND [End Date] >= #' + DateToStr(fStartDate) + '#) OR ' +
          '([Start Date] <= #' + DateToStr(fEndDate) + '# AND ' +
          '[End Date] >= #' + DateToStr(fEndDate) + '#))';

  //-------------------------------------CHECKS IF CLIENT HAS AN OVERLAPPING
  //-------------------------------------SERVICE REQUEST
  if objDB.RecordExist(sSQL) = false then
  begin
    sSQL := 'Select * '
          + 'from Drones '
          + 'where [DroneID] NOT IN (Select [DroneID] from ' +
            'DroneFlights where Format([Date and Time of Response], ' +
            '"Short Date") >= #' + DateToStr(fStartDate) + '# AND ' +
            'Format([Date and Time of Response], "Short Date") <= ' +
            '#' + DateToStr(fStartDate) + '#) AND [Drone Type] = ' +
            sServiceID + ' AND [Suburb] = ' + sSuburbID;
    if objDB.RecordExist(sSQL) = true then
    begin
      sSQL := 'Insert into UserServices '
            + '([UserID], [ServiceID], [Start Date], [End Date]) '
            + 'Values(' + UserID + ', ' + sServiceID + ', #' +
              DateToStr(fStartDate) + '#, #' + DateToStr(fEndDate) + '#)';
      objDB.DoSQL(sSQL);

      sSQL := 'Select [UserServiceID] '
            + 'from UserServices '
            + 'where [UserID] = ' + UserID + ' AND [ServiceID] = ' +
              sServiceID + ' AND [Start Date] = #' + DateToStr(fStartDate) +
              '# AND [End Date] = #' + DateToStr(fEndDate) + '#';
      sUserServiceID := objDB.ToString(sSQL, '');

      if UpperCase(fServiceName) = UpperCase(EMERGENCY_SERVICE_NAME) then
        ScheduleFlight(fServiceName, DateToStr(fStartDate),
        TimeToStr(Now()), UserID, sUserServiceID, sSuburbID)
      else
      begin
        //-------------------------------------SCHEDULES FLIGHTS FOR EACH
        //-------------------------------------DAY THE CLIENT REQUESTED
        iNumDays := Trunc(fEndDate - fStartDate) + 1;
        ScheduleFlight(fServiceName, DateToStr(fStartDate), Time,
        UserID, sUserServiceID, sSuburbID);
        dDate := fStartDate;
        for K := 2 to iNumDays do
        begin
          dDate := IncDay(dDate, 1);
          ScheduleFlight(fServiceName, DateToStr(dDate), Time,
          UserID, sUserServiceID, sSuburbID);
        end;
      end;
      DeployDrones;
      MessageDlg('Your Service Request was Submitted Successfully',
      mtInformation, mbOKCancel, 0);
    end
    else
      MessageDlg('All drones are currently busy between these ' +
      'dates. We are actively deploying more drones in order to' +
      ' meet demand. Please be patient until more drones are ' +
      'deployed in your area.', mtInformation, mbOKCancel, 0);
  end
  else
  begin
    //-------------------------------------CREATES A MESSAGE TELLING THE
    //-------------------------------------CLIENT ABOUT THE OVERLAP AND
    //-------------------------------------ITS DETAILS
    sSQL := 'Select [Start Date] & " and " & [End Date] '
          + 'from UserServices '
          + 'where [UserID] = ' + UserID + ' AND [ServiceID] = ' +
          sServiceID + ' AND (([Start Date] <= #' + DateToStr(fStartDate) +
          '# AND [End Date] >= #' + DateToStr(fStartDate) + '#) OR ' +
          '([Start Date] <= #' + DateToStr(fEndDate) + '# AND ' +
          '[End Date] >= #' + DateToStr(fEndDate) + '#))';
    sOldDates := objDB.ToString(sSQL, '');

    MessageDlg('You already have requested this service ' +
    'between these dates.' + #13 + 'The service you requested ' +
    'are between these dates ' + sOldDates,
    mtInformation, mbOKCancel, 0);
  end;
end;

procedure TServiceRequest.SetValues(StartDate, EndDate: TDate;
  ServiceName: string; PricePerDay: real);
begin
  fStartDate := StartDate;
  fEndDate := EndDate;
  fServiceName := ServiceName;
  fPricePerDay := PricePerDay;
end;

//-------------------------------------RETURNS A SUMMARY OF THE SERVICE WHICH
//-------------------------------------IS CURRENTLY SELECTED
function TServiceRequest.UpdateServiceSummary: string;
var
  rTot : real;
  rDays : real;
  sDetails : string;
begin
  fDetailsDictionary.TryGetValue(UPPERCASE(fServiceName), sDetails);
  if UpperCase(fServiceName) <> UpperCase(EMERGENCY_SERVICE_NAME) then
  begin
    rDays := fEndDate - fStartDate + 1;
    rTot := fPricePerDay * rDays;
    Result := 'Details:' + #13 + sDetails + #13 + #13 +
    'Service Period:' + #13 + DateToStr(fStartDate) + ' - ' +
    DateToStr(fEndDate) + #13 + #13 + 'Total Cost:' + #13 +
    FloatToStr(rDays) + ' day(s) x ' + FloatToStrF(fPricePerDay, ffCurrency,
    10, 2) + ' = ' + FloatToStrF(rTot, ffCurrency, 10, 2);
  end
  else
  begin
    Result := 'Details:' + #13 + sDetails + #13 + #13 +
    'Service Period:' + #13 + 'Immediate Response' + #13 + #13 +
    'Total Cost:' + #13 + FloatToStrF(fPricePerDay, ffCurrency,10, 2);
  end;
end;

end.

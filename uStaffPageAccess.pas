unit uStaffPageAccess;

interface
  uses
    ComCtrls, SysUtils, Generics.Collections, uLibrary, Dialogs;

  const
    FILE_NAME = 'PageAccess.txt';

  var
    PageAccessDictionary : TDictionary<string, string>;

  procedure SetUpDictionary;
  procedure AccessPages(PageControl : TPageControl; JobTitle : string);

implementation

//-------------------------------------LOADS DATA INTO THE DICTIONARY
procedure SetUpDictionary;
var
  tFl : TextFile;
  iPos : byte;
  sLine, sJobName : string;
begin
  PageAccessDictionary := TDictionary<string, string>.Create;
  AssignFile(tFl, FILE_NAME);
  Reset(tFl);
  while NOT EoF(tFl) do
  begin
    ReadLn(tFl, sLine);
    iPos := POS(TEXT_FILE_DELIMETER, sLine);
    sJobName := Copy(sLine, 1, iPos - 1);
    Delete(sLine, 1, iPos);

    PageAccessDictionary.Add(sJobName, sLine);
  end;
  CloseFile(tFl);
end;

//-------------------------------------CHANGES PAGES TO VISIBLE FOR A
//-------------------------------------SPECIFIC STAFF TYPE
procedure AccessPages(PageControl : TPageControl; JobTitle : string);
var
  K : byte;
  sPagesToAccess : string;
begin
  PageAccessDictionary.TryGetValue(UPPERCASE(JobTitle), sPagesToAccess);
  for K := 1 to Length(sPagesToAccess) do
  begin
    PageControl.Pages[StrToInt(sPagesToAccess[K])].TabVisible := true;
  end;
end;

end.

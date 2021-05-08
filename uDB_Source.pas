unit uDB_Source;

interface
  uses
    DB, AdoDB, Forms, SysUtils, Dialogs, Controls;

  Type
    TDynamicArray = array of string;
    TDBClass = class
      private
        fDbTbl : TADOQuery;

      public
        constructor Create(NameOfDB : string);
        procedure DoSQL(TheSql : string);
        function RecordExist (TheSQL : string) : boolean;
        function ToStringHeadings(TheSQL, Delimiter : string) : string;
        function ToString(TheSQL, Delimiter : string) : string;
        function ToArray(TheSQL : string) : TDynamicArray;
    end;

IMPLEMENTATION

{ TdbClass }

//-------------------------------------CREATES A DB OBJECT
constructor TDBClass.Create(NameOfDB: string);
begin
  fDbTbl := TADOQuery.Create(Application);
  fDbTbl.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;'
                          //'Provider= Microsoft.ACE.OLEDB.12.0; '
                          + 'Data Source=' + NameOfDB
                          + ';Persist Security Info=False';
end;

//-------------------------------------RETURNS ALL DATA OF A SQL STATEMENT
//-------------------------------------IN A ARRAY
function TDBClass.ToArray(TheSQL: string): TDynamicArray;
var
  K, iCount : byte;
begin
  DoSQL(TheSQL);
  fDbTbl.Open;
  fDbTbl.First;
  SetLength(Result, 0);
  iCount := 0;
  while NOT fDbTbl.Eof do
  begin
    for K := 0 to fDbTbl.FieldCount - 1 do
    begin
      iCount := iCount + 1;
      SetLength(Result, iCount);
      Result[iCount - 1] := fDbTbl.Fields[K].AsString;
    end;
    fDbTbl.Next;
  end;
  fDbTbl.Close;
end;

//-------------------------------------RETURNS ALL DATA OF A SQL STATEMENT
//-------------------------------------IN STRING FORMAT
function TDBClass.ToString(TheSQL, Delimiter : string)
: string;
var
  K : byte;
begin
  DoSQL(TheSQL);
  fDbTbl.Open;
  fDbTbl.First;
  Result := '';
  while NOT fDbTbl.Eof do
  begin
    for K := 0 to fDbTbl.FieldCount - 1 do
      Result := Result + fDbTbl.Fields[K].AsString + Delimiter;
    Delete(Result, Length(Result) - Length(Delimiter) + 1, Length(Delimiter));
    Result := Result + #13;
    fDbTbl.Next;
  end;
  Delete(Result, Length(Result), 1);
  fDbTbl.Close;
end;

//-------------------------------------PERFORMS THE SQL STATEMENT
procedure TDBClass.DoSQL(TheSQL : string);
begin
  //ShowMessage(TheSQL);
  fDbTbl.SQL.Text := TheSQL;
  fDbTbl.ExecSQL;
end;

//-------------------------------------RETURNS ALL THE FIELD HEADINGS OF
//-------------------------------------A SQL STATEMENT IN STRING FORMAT
function TDBClass.ToStringHeadings(TheSQL, Delimiter : string): string;
var
  K : byte;
begin
  DoSQL(TheSQL);
  fDbTbl.Open;
  fDbTbl.First;
  Result := '';
  for K := 0 to fDbTbl.FieldCount - 1 do
      Result := Result + fDbTbl.Fields[K].FieldName + Delimiter;
end;

//-------------------------------------CHECKS IF A RECORD EXISTS IN
//-------------------------------------THE DATABASE
function TDBClass.RecordExist(TheSQL: string): boolean;
begin
  DoSQL(TheSQL);
  fDbTbl.Open;
  fDbTbl.First;
  Result := NOT fDbTbl.Eof;
end;

end.

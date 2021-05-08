unit uHelp;

interface
  uses
    ShellAPI, Generics.Collections, uLibrary, Windows, SysUtils, DIalogs;

  Type
    THelp = class
      const
        FILE_NAME = 'HelpURLs.txt';

      private
        fHelpExtensionDictionary : TDictionary<string, string>;

      public
        constructor Create;
        procedure LoadHelp(PageName : string);
    end;

implementation

{ THelp }

//-------------------------------------LOADS DATA INTO THE DICTIONARY
constructor THelp.Create;
var
  tFl : TextFile;
  sLine, sPageName, sURL : string;
  iPos : byte;
begin
  fHelpExtensionDictionary := TDictionary<string, string>.Create;
  AssignFile(tFl, FILE_NAME);
  Reset(tFl);
  while NOT EoF(tFl) do
  begin
    ReadLn(tFl, sLine);
    iPos := POS(TEXT_FILE_DELIMETER, sLine);
    sPageName := Copy(sLine, 1, iPos - 1);
    Delete(sLine, 1, iPos);
    sURL := sLine;

    fHelpExtensionDictionary.Add(UPPERCASE(sPageName), sURL);
  end;
  CloseFile(tFl);
end;

//-------------------------------------DISPLAYS HELP TO A USER ACCORDING TO
//-------------------------------------A SPECIFIC PAGE
procedure THelp.LoadHelp(PageName: string);
var
  sURL : string;
begin
  fHelpExtensionDictionary.TryGetValue(UPPERCASE(PageName), sURL);
  ShellExecute(0, 'open', PChar(sURL), nil, nil, SW_SHOWNORMAL);
end;

end.

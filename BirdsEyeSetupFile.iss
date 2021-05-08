; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Birds Eye Security Surveillance"
#define MyAppVersion "1.0.5"
#define MyAppPublisher "Birds Eye Security"
#define MyAppURL "https://birdseyesecuity.wixsite.com/application"
#define MyAppExeName "BirdsEyeSecuritySurveillance.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{437AC36C-F341-4507-83ED-849856088A9D}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=F:\School\Information Technology\IEB PAT
OutputBaseFilename=BirdsEyeSecuritySetup
SetupIconFile=C:\Users\Ryan\Downloads\icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "F:\School\Information Technology\IEB PAT\BirdsEyeSecuritySurveillance.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\BirdsEyeSecuritySurveillance_Data.mdb"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\HelpURLs.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\libeay32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\PageAccess.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\ServiceDetails.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\ssleay32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\SurvFootage1.jpg"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\SurvFootage2.jpg"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\SurvFootage3.jpg"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\SurvFootage4.jpg"; DestDir: "{app}"; Flags: ignoreversion
Source: "F:\School\Information Technology\IEB PAT\SurvFootage5.jpg"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

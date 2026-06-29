; Multi-Architecture + Silent Install Inno Setup Script
; Save as script.iss and compile with Inno Setup Compiler

[Setup]
AppName=MyApp
AppVersion=1.0
AppPublisher=My Company
AppPublisherURL=https://www.mycompany.com
DefaultDirName={autopf}\MyApp
DefaultGroupName=MyApp
OutputDir=Output
OutputBaseFilename=MyAppInstaller
Compression=lzma
SolidCompression=yes
LicenseFile=license.txt
UninstallDisplayIcon={app}\MyApp.exe
UninstallDisplayName=MyApp 1.0
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
DisableProgramGroupPage=yes

[Files]
; Automatically include all files from the "dist" folder
; Replace "dist" with your actual app folder
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Start Menu shortcut
Name: "{group}\MyApp"; Filename: "{app}\MyApp.exe"
; Desktop shortcut
Name: "{commondesktop}\MyApp"; Filename: "{app}\MyApp.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Registry]
; Example registry entry for app settings
Root: HKCU; Subkey: "Software\MyCompany\MyApp"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Flags: uninsdeletekey

[Run]
; Launch app after install (skips in silent mode)
Filename: "{app}\MyApp.exe"; Description: "Launch MyApp"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Remove leftover config files
Type: files; Name: "{app}\config.ini"

[Code]
function InitializeSetup(): Boolean;
begin
  { Example: Detect architecture and log it }
  if Is64BitInstallMode then
    MsgBox('Installing 64-bit version...', mbInformation, MB_OK)
  else
    MsgBox('Installing 32-bit version...', mbInformation, MB_OK);
  Result := True;
end;


#define AppName "Ideapad Toolkit"
#define AppVersion "1.0.0"
#define AppPublisher "itsmeyogs"
#define AppExeName "IdeapadToolkit.WinUI3.exe"
#define SourceDir "..\artifacts\release\win-x64-combined"

[Setup]
AppId={{B8C1E5F2-8A12-4E1A-9D07-IDEAPADS340}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
OutputDir=..\artifacts\installer
OutputBaseFilename=IdeapadToolkit-Setup
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64
PrivilegesRequired=admin
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\{#AppExeName}

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "PowerBattery.dll"

[Code]

var
  DllPath: string;
  DllPage: TWizardPage;
  DllLabel: TNewStaticText;
  DllEdit: TNewEdit;
  DllInstruction: TNewStaticText;
  DllBrowseButton: TNewButton;

  ShortcutPage: TWizardPage;
  StartMenuCheck: TNewCheckBox;
  DesktopCheck: TNewCheckBox;


procedure BrowseDll(Sender: TObject);
var
  SelectedPath: string;
begin
  SelectedPath := DllEdit.Text;

  if GetOpenFileName(
    'Select PowerBattery.dll',
    SelectedPath,
    '',
    'DLL files (*.dll)|*.dll|All files (*.*)|*.*',
    ''
  ) then
    DllEdit.Text := SelectedPath;
end;


procedure InitializeWizard;
begin
  { Required DLL page }
  DllPage := CreateCustomPage(
    wpSelectDir,
    'Select Required DLL',
    'A required file is needed to continue.'
  );

  DllLabel := TNewStaticText.Create(DllPage);
  DllLabel.Parent := DllPage.Surface;
  DllLabel.Left := ScaleX(0);
  DllLabel.Top := ScaleY(0);
  DllLabel.Width := DllPage.SurfaceWidth;
  DllLabel.Caption :=
    'Ideapad Toolkit requires PowerBattery.dll to access certain Lenovo hardware features.';

 
  DllEdit := TNewEdit.Create(DllPage);
  DllEdit.Parent := DllPage.Surface;
  DllEdit.Left := ScaleX(0);
  DllEdit.Top := ScaleY(35);
  DllEdit.Width := DllPage.SurfaceWidth - ScaleX(115);
  DllEdit.Text := DllPath;

  DllBrowseButton := TNewButton.Create(DllPage);
  DllBrowseButton.Parent := DllPage.Surface;
  DllBrowseButton.Width := ScaleX(90);
  DllBrowseButton.Height := DllEdit.Height;
  DllBrowseButton.Left := DllEdit.Left + DllEdit.Width + ScaleX(10);
  DllBrowseButton.Top := DllEdit.Top;
  DllBrowseButton.Caption := 'Browse...';
  DllBrowseButton.OnClick := @BrowseDll;


  DllInstruction := TNewStaticText.Create(DllPage);
  DllInstruction.Parent := DllPage.Surface;
  DllInstruction.Left := ScaleX(0);
  DllInstruction.Top := ScaleY(75);
  DllInstruction.Width := DllPage.SurfaceWidth;
  DllInstruction.Caption :=
    'Need help finding this file? See the README for instructions.';


  { Shortcut selection page }
  ShortcutPage := CreateCustomPage(
    DllPage.ID,
    'Create Shortcuts',
    'Select which shortcuts to create.'
  );

  StartMenuCheck := TNewCheckBox.Create(ShortcutPage);
  StartMenuCheck.Parent := ShortcutPage.Surface;
  StartMenuCheck.Left := ScaleX(0);
  StartMenuCheck.Top := ScaleY(0);
  StartMenuCheck.Width := ShortcutPage.SurfaceWidth;
  StartMenuCheck.Caption := 'Create a Start Menu shortcut';
  StartMenuCheck.Checked := True;

  DesktopCheck := TNewCheckBox.Create(ShortcutPage);
  DesktopCheck.Parent := ShortcutPage.Surface;
  DesktopCheck.Left := ScaleX(0);
  DesktopCheck.Top := ScaleY(30);
  DesktopCheck.Width := ShortcutPage.SurfaceWidth;
  DesktopCheck.Caption := 'Create a desktop shortcut';
  DesktopCheck.Checked := True;
end;


{ Read one byte safely }
function ReadByteFromStream(Stream: TFileStream): Integer;
var
  Buffer: string;
begin
  SetLength(Buffer, 1);
  Stream.ReadBuffer(Buffer, 1);
  Result := Ord(Buffer[1]) and $FF;
end;


{ Validate 64-bit Windows DLL }
function IsValidX64PeDll(const FileName: string): Boolean;
var
  Stream: TFileStream;
  PeOffset: Longint;
  Machine: Integer;
  Characteristics: Integer;
  OptionalMagic: Integer;
  B0, B1, B2, B3: Integer;
begin
  Result := False;

  if not FileExists(FileName) then
    Exit;

  Stream := TFileStream.Create(
    FileName,
    fmOpenRead or fmShareDenyNone
  );

  try
    try
      { Check minimum DOS header size }
      if Stream.Size < $40 then
        Exit;

      { Check DOS signature (MZ) }
      Stream.Position := 0;

      B0 := ReadByteFromStream(Stream);
      B1 := ReadByteFromStream(Stream);

      if (B0 <> $4D) or (B1 <> $5A) then
        Exit;

      { Read PE header offset }
      Stream.Position := $3C;

      B0 := ReadByteFromStream(Stream);
      B1 := ReadByteFromStream(Stream);
      B2 := ReadByteFromStream(Stream);
      B3 := ReadByteFromStream(Stream);

      PeOffset :=
        B0 +
        (B1 shl 8) +
        (B2 shl 16) +
        (B3 shl 24);

      { Validate PE header bounds }
      if (PeOffset < $40) or
         (PeOffset > Stream.Size - 24) then
        Exit;

      { Check PE signature }
      Stream.Position := PeOffset;

      B0 := ReadByteFromStream(Stream);
      B1 := ReadByteFromStream(Stream);
      B2 := ReadByteFromStream(Stream);
      B3 := ReadByteFromStream(Stream);

      if (B0 <> $50) or
         (B1 <> $45) or
         (B2 <> 0) or
         (B3 <> 0) then
        Exit;

      { Check machine architecture }
      B0 := ReadByteFromStream(Stream);
      B1 := ReadByteFromStream(Stream);

      Machine := B0 + (B1 shl 8);

      { Read COFF characteristics }
      Stream.Position := PeOffset + 22;

      B0 := ReadByteFromStream(Stream);
      B1 := ReadByteFromStream(Stream);

      Characteristics := B0 + (B1 shl 8);

      { Read optional header magic }
      Stream.Position := PeOffset + 24;

      B0 := ReadByteFromStream(Stream);
      B1 := ReadByteFromStream(Stream);

      OptionalMagic := B0 + (B1 shl 8);

      { AMD64 + PE32+ + DLL }
      Result :=
        (Machine = $8664) and
        (OptionalMagic = $020B) and
        ((Characteristics and $2000) <> 0);

    except
      Result := False;
    end;
  finally
    Stream.Free;
  end;
end;


function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;

  if CurPageID = DllPage.ID then
  begin
    DllPath := Trim(DllEdit.Text);

    { Validate filename }
    if (DllPath = '') or
       (CompareText(
         ExtractFileName(DllPath),
         'PowerBattery.dll'
       ) <> 0) then
    begin
      MsgBox(
        'Please select a valid PowerBattery.dll file to continue.',
        mbError,
        MB_OK
      );

      Result := False;
      Exit;
    end;

    { Validate DLL architecture and PE structure }
    if not IsValidX64PeDll(DllPath) then
    begin
      MsgBox(
        'The selected file is not a valid 64-bit Windows DLL.' + #13#10 + #13#10 +
        'Please select the correct PowerBattery.dll file.',
        mbError,
        MB_OK
      );

      Result := False;
      Exit;
    end;
  end;
end;


procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    { Copy required DLL }
    if not FileCopy(
      DllPath,
      ExpandConstant('{app}\PowerBattery.dll'),
      False
    ) then
    begin
      MsgBox(
        'Failed to copy PowerBattery.dll to the installation directory.',
        mbError,
        MB_OK
      );
    end;

    { Create Start Menu shortcut }
    if StartMenuCheck.Checked then
    begin
      CreateShellLink(
        ExpandConstant('{autoprograms}\{#AppName}.lnk'),
        '{#AppName}',
        ExpandConstant('{app}\{#AppExeName}'),
        '',
        ExpandConstant('{app}'),
        ExpandConstant('{app}\{#AppExeName}'),
        0,
        SW_SHOWNORMAL
      );
    end;

    { Create Desktop shortcut }
    if DesktopCheck.Checked then
    begin
      CreateShellLink(
        ExpandConstant('{autodesktop}\{#AppName}.lnk'),
        '{#AppName}',
        ExpandConstant('{app}\{#AppExeName}'),
        '',
        ExpandConstant('{app}'),
        ExpandConstant('{app}\{#AppExeName}'),
        0,
        SW_SHOWNORMAL
      );
    end;
  end;
end;

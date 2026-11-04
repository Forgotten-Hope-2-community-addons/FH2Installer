[Code]

procedure BackupBF2RegistryEntries;
var
  ResultCode: Integer;
  RegCommandParams, Filename: String;
begin
  if RegKeyExists(HKLM32, 'Software\Electronic Arts\EA Games\Battlefield 2') then
    if MsgBox(ExpandConstant('{cm:BackupBF2RegistryEntries}'), mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES then
      begin
        Filename := '';
        if GetSaveFileName(ExpandConstant('{cm:SaveRegistryFile}'), Filename, '', 'Registry Files (*.reg)|*.reg|All Files (*.*)|*.*', 'reg') then
          begin
            RegCommandParams := 'export "HKLM\Software\Electronic Arts\EA Games\Battlefield 2" "' + Filename + '" /reg:32';
            { Exec only reports that the process was started, so check the
              reg.exe exit code as well: 0 means the export succeeded. }
            if Exec('reg', RegCommandParams, '', SW_SHOW, ewWaitUntilTerminated, ResultCode) and (ResultCode = 0) then
              MsgBox(FmtMessage(CustomMessage('FileSaved'), [Filename]), mbInformation, MB_OK)
            else
              begin
                Log('reg export failed, exit code: ' + IntToStr(ResultCode));
                MsgBox(ExpandConstant('{cm:FileNotSaved}'), mbError, MB_OK);
              end;
          end;
      end;
end;

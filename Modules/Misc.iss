[Code]

{ Sends a key press and release to the main window }

{ WinAPI INPUT layout notes: the union member is always as large as MOUSEINPUT
  (24 bytes on 32-bit), so the whole INPUT structure is 28 bytes even when only
  the keyboard part (16 bytes) is used. The two extra DWORDs below pad the
  Pascal Script record up to 28 bytes: SendInput validates cbSize against the
  real structure size and returns an error if they do not match.
  Setup.exe built by Inno Setup is 32-bit, so the 28-byte layout is correct
  here. A 64-bit Setup build would use a different record and alignment. }
const
    INPUT_KEYBOARD = 1;
    KEYEVENTF_KEYUP = $2;

type
    TKeyboardInput = record
        Itype: DWORD;
        wVk: WORD;
        wScan: WORD;
        dwFlags: DWORD;
        time: DWORD;
        dwExtraInfo: DWORD;
        Reserved: array[0..1] of DWORD; { pads 20 bytes up to the 24-byte union }
    end;

    TKeyboardInputs = array[0..1] of TKeyboardInput;

{ var is mandatory: SendInput expects a pointer to the first INPUT record.
  Passing the record by value would push its 28 bytes onto the stack instead. }
function SendInput(nInputs: UINT; var pInputs: TKeyboardInputs;
    cbSize: Integer): UINT;
    external 'SendInput@user32.dll stdcall';

function SendKeyPressed(KeyCode: Word): Boolean;
var
    Inputs: TKeyboardInputs;
begin
    { key down }
    Inputs[0].Itype := INPUT_KEYBOARD;
    Inputs[0].wVk := KeyCode;
    Inputs[0].wScan := 0;
    Inputs[0].dwFlags := 0;
    Inputs[0].time := 0;
    Inputs[0].dwExtraInfo := 0;
    Inputs[0].Reserved[0] := 0;
    Inputs[0].Reserved[1] := 0;

    { key release }
    Inputs[1].Itype := INPUT_KEYBOARD;
    Inputs[1].wVk := KeyCode;
    Inputs[1].wScan := 0;
    Inputs[1].dwFlags := KEYEVENTF_KEYUP;
    Inputs[1].time := 0;
    Inputs[1].dwExtraInfo := 0;
    Inputs[1].Reserved[0] := 0;
    Inputs[1].Reserved[1] := 0;

    { both events have to go out in a single SendInput call }
    Result := SendInput(2, Inputs, SizeOf(Inputs[0])) = 2;
    if not Result then
        Log(Format('SendKeyPressed: SendInput failed, error code %d', [DLLGetLastError]));
end;

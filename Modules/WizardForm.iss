[Code]

procedure BannerClick(Sender: TObject);
var
  ErrorCode:integer;
begin
  ShellExecAsOriginalUser('open', 'https://discord.gg/hU878P4', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure DiscordLogoOnClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExecAsOriginalUser('open', 'https://discord.gg/hU878P4', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure DiscordLogoInitializeWizard;
var
  BevelTop: Integer;
  DiscordLogoFileName: String;
  DiscordLogo: TBitmapImage;
  Page: TWizardPage;
begin
  DiscordLogoFileName := ExpandConstant('{tmp}\discord.ico');
  ExtractTemporaryFile(ExtractFileName(DiscordLogoFileName));

  DiscordLogo := TBitmapImage.Create(WizardForm);
  DiscordLogo.AutoSize := True;

  Page := PageFromID(wpSelectDir);
  InitializeBitmapImageFromIcon(DiscordLogo, DiscordLogoFileName, Page.Surface.Color, [16, 32, 48, 256]);
  DiscordLogo.Anchors := [akLeft, akBottom];
  BevelTop := WizardForm.Bevel.Top;
  DiscordLogo.Top := BevelTop + (WizardForm.ClientHeight - BevelTop - DiscordLogo.Bitmap.Height) div 2;
  DiscordLogo.Left := DiscordLogo.Top - BevelTop;
  DiscordLogo.Cursor := crHand;
  DiscordLogo.OnClick := @DiscordLogoOnClick;
  DiscordLogo.Parent := WizardForm;
end;
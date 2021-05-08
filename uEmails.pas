unit uEmails;

interface
  uses
    IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
    IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
    IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
    Dialogs, SysUtils;

  Type
    TEmails = class
      const
        COMPANY_EMAIL = 'birdseyesecuity@gmail.com';
        COMPANY_EMAIL_PASS = 'BirdsEyeSecure01';

      private
        fSSL : TIdSSLIOHandlerSocketOpenSSL;
        fSTMP : TIdSMTP;

      public
        constructor Create;
        procedure SendEmail(RecipientName, EmailAddress, Subject, BodyMessage
        : string);
    end;

implementation

{ TEmails }

//-------------------------------------SETS UP ALL OBJECTS NEEDED TO
//-------------------------------------SEND EMAILS
constructor TEmails.Create;
begin
  fSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  fSTMP := TIdSMTP.Create(nil);

  //---------------------------------------------SETTING UP SECURE SSL
  With fSSL do
  begin
    Destination := 'smtp.gmail.com:587';
    Host := 'smtp.gmail.com';
    Port := 587;
    SSLOptions.Method := sslvTLSv1;
    SSLOptions.Mode := sslmUnassigned;
    SSLOptions.VerifyMode := [];
    SSLOptions.VerifyDepth := 0;
  end;

  //---------------------------------------------SETTING SMTP DATA
  with fSTMP do
  begin
    Host := 'smtp.gmail.com';
    Port := 587;
    Username := COMPANY_EMAIL;
    Password := COMPANY_EMAIL_PASS;
    IOHandler := fSSL;
    AuthType := satDefault;
    UseTLS := utUseExplicitTLS;
  end;
end;

//-------------------------------------SENDS A USER AN EMAIL BASED ON
//-------------------------------------THE PARAMETERS
procedure TEmails.SendEmail(RecipientName, EmailAddress, Subject, BodyMessage
: string);
var
  mailMessage : TIdMessage;
begin
  mailMessage := TIdMessage.Create(nil);

  with mailMessage.Recipients.Add do
  begin
    Name := RecipientName;
    Address := EmailAddress;
  end;

  //-------------------------------------SETS UP THE EMAILS MESSAGE DETAILS
  mailMessage.From.Name := 'Birds Eye Security';
  mailMessage.From.Address :=  COMPANY_EMAIL;
  mailMessage.Subject := Subject;
  mailMessage.Body.Text := BodyMessage;
  mailMessage.Priority := mpHigh;

  //-------------------------------------CHECKS IF THE EMAILS HAS BEEN SENT
  TRY
    fSTMP.Connect();
    fSTMP.Send(mailMessage);
    MessageDlg('Email was Sent Succesfully', mtInformation, mbOKCancel, 0);
    fSTMP.Disconnect();
  except on e:Exception do
    begin
      MessageDlg('Email with email address ' + EmailAddress + ' was ' +
      'not sent, due to ' + e.Message, mtError, mbOKCancel, 0);
      fSTMP.Disconnect();
    end;
  END;
end;

end.

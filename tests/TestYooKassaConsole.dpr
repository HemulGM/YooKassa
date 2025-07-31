program TestYooKassaConsole;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  YooKassa.API in '..\YooKassa.API.pas',
  HGM.FastClientAPI in '..\FastClientAPI\HGM.FastClientAPI.pas',
  YooKassa.API.Payment in '..\YooKassa.API.Payment.pas',
  YooKassa.API.Error in '..\YooKassa.API.Error.pas';

function TestPayment: string;
begin
  var YooKassa := TYooKassa.Create('1136181', 'test_y3qdX9wZRMd2xFnLBHmnAZwziLCpv5UgBEpr4NRh2HA');
  try
    try
      var Payment := YooKassa.CreatePayment(342.21, 'RUB', 'Delphi wrapper, привет', '');
      try
        Writeln(Payment.Confirmation.ConfirmationUrl);
        Result := Payment.Id;
      finally
        Payment.Free;
      end;
    finally
      YooKassa.Free;
    end;
  except
    on E: ExceptionAPIRequest do
    begin
      if E is ExceptionAPIRequest<TYooKassaError>then
        Writeln(ExceptionAPIRequest<TYooKassaError>(E).Error.Description)
      else
        Writeln(E.Text);
    end;
  end;
end;

function TestGetPayment(const Id: string): string;
begin
  var YooKassa := TYooKassa.Create('1136181', 'test_y3qdX9wZRMd2xFnLBHmnAZwziLCpv5UgBEpr4NRh2HA');
  try
    try
      var Payment := YooKassa.GetPayment(Id);
      try
        Writeln(Payment.Status);
        Result := Payment.Status;
      finally
        Payment.Free;
      end;
    finally
      YooKassa.Free;
    end;
  except
    on E: ExceptionAPIRequest do
    begin
      if E is ExceptionAPIRequest<TYooKassaError>then
        Writeln(ExceptionAPIRequest<TYooKassaError>(E).Error.Description)
      else
        Writeln(E.Text);
    end;
  end;
end;

begin
  try
    var Id := TestPayment;
    while TestGetPayment(Id) = 'pending' do
    begin
      Sleep(4000);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  readln;
end.


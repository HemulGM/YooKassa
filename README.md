Init api
```pascal
var YooKassa := TYooKassa.Create('1136181', 'test_y3qdX9wZRMd2xFnLBHmnAZwziLCpv5UgBEpr4NRh2HA');
```

Create payment
```pascal
var Payment := YooKassa.CreatePayment(342.21, 'RUB', 'Delphi wrapper, привет', '');
try
  Writeln(Payment.Confirmation.ConfirmationUrl);
  Result := Payment.Id;
finally
  Payment.Free;
end;
```

Get payment (status)
```pascal
var Payment := YooKassa.GetPayment(Id);
try
  Writeln(Payment.Status);
  Result := Payment.Status;
finally
  Payment.Free;
end;
```

Error handling
```pascal
try
  YooKassa.Call...
except
  on E: ExceptionAPIRequest do
  begin
    if E is ExceptionAPIRequest<TYooKassaError>then
      Writeln(ExceptionAPIRequest<TYooKassaError>(E).Error.Description)
    else
      Writeln(E.Text);
  end;
end;
```

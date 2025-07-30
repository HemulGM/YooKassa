unit yookassa_api;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, fphttpclient, base64;

type
  TYookassaPayment = class
  public
    class function CreatePayment(const aShopId, aSecretKey: string;
      aAmount: Currency; const aCurrency, aDescription, aReturnUrl: string): string;
  end;

implementation

class function TYookassaPayment.CreatePayment(const aShopId, aSecretKey: string;
  aAmount: Currency; const aCurrency, aDescription, aReturnUrl: string): string;
var
  aHttp: TFPHttpClient;
  aJsonReq, aJsonResp: TJSONObject;
  aJsonAmount, JsonConfirmation: TJSONObject;
  RespStr: string;
  aPaymentUrl: string;
  Auth: string;
begin
  Result := '';
  aHttp := TFPHttpClient.Create(nil);
  try
    aJsonReq := TJSONObject.Create;
    try
      aJsonAmount := TJSONObject.Create;
      aJsonAmount.Add('value', Format('%.2f', [aAmount]));
      aJsonAmount.Add('currency', aCurrency);
      aJsonReq.Add('amount', aJsonAmount);

      aJsonReq.Add('description', aDescription);

      JsonConfirmation := TJSONObject.Create;
      JsonConfirmation.Add('type', 'redirect');
      JsonConfirmation.Add('return_url', aReturnUrl);
      aJsonReq.Add('confirmation', JsonConfirmation);

      aJsonReq.Add('capture', True);

      // Authorization via Basic auth
      Auth := EncodeStringBase64(aShopId + ':' + aSecretKey);
      aHttp.AddHeader('Authorization', 'Basic ' + Auth);
      aHttp.AddHeader('Content-Type', 'application/json');
      aHttp.AddHeader('Idempotence-Key', IntToHex(Random(MaxInt), 8) + IntToStr(Random(MaxInt))); // Unique key
      aHTTP.RequestBody:=TStringStream.Create(aJsonReq.AsJSON);
      try
        RespStr:=aHTTP.Post('https://api.yookassa.ru/v3/payments');
      finally
        aHTTP.RequestBody.Free;
        aHTTP.RequestBody:=nil;
      end;

      aJsonResp := TJSONObject(GetJSON(RespStr));
      try
        if aJsonResp.FindPath('confirmation.confirmation_url') <> nil then
          aPaymentUrl := aJsonResp.FindPath('confirmation.confirmation_url').AsString
        else if aJsonResp.Find('confirmation') <> nil then
          aPaymentUrl := aJsonResp.Objects['confirmation'].Get('confirmation_url', '')
        else
          aPaymentUrl := '';
        if aPaymentUrl = '' then
          raise Exception.Create('No confirmation_url in Yookassa response: ' + RespStr);
        Result := aPaymentUrl;
      finally
        aJsonResp.Free;
      end;
    finally
      aJsonReq.Free;
    end;
  finally
    aHttp.Free;
  end;
end;

end.

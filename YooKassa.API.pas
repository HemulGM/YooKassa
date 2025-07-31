unit YooKassa.API;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.NetEncoding,
  System.Net.HttpClient, HGM.FastClientAPI, YooKassa.API.Error,
  YooKassa.API.Payment;

type
  TYooKassaPaymentParams = class(TJSONParam)
    function Amount(const Value: Currency): TYooKassaPaymentParams;
    function Currency(const Value: string): TYooKassaPaymentParams;
    function Description(const Value: string): TYooKassaPaymentParams;
    function ReturnUrl(const Value: string): TYooKassaPaymentParams;
    function Capture(const Value: Boolean): TYooKassaPaymentParams;
  end;

  TYooKassa = class(TCustomAPI<TYooKassaError>)
  private
    FIdempotenceKey: string;
  public
    constructor Create(const ShopId, SecretKey: string); reintroduce;
    function CreatePayment(const Amount: Currency; const Currency, Description, ReturnUrl: string): TYooKassaPayment;
    function GetPayment(const Id: string): TYooKassaPayment;
  end;

implementation

uses
  System.Net.URLClient;

{ TYooKassa }

constructor TYooKassa.Create(const ShopId, SecretKey: string);
begin
  inherited Create(TAuthorizationScheme.Basic, TBase64Encoding.Base64.Encode(ShopId + ':' + SecretKey));
  Randomize;
  FIdempotenceKey := Random(MaxInt).ToHexString(8) + Random(MaxInt).ToString;
  CustomHeaders := [
    TNetHeader.Create('Content-Type', 'application/json'),
    TNetHeader.Create('Idempotence-Key', FIdempotenceKey)
    ];
  BaseUrl := 'https://api.yookassa.ru/v3';
end;

function TYooKassa.CreatePayment(const Amount: Currency; const Currency, Description, ReturnUrl: string): TYooKassaPayment;
begin
  Result := Post<TYooKassaPayment, TYooKassaPaymentParams>('payments',
    procedure(Params: TYooKassaPaymentParams)
    begin
      Params.Amount(Amount);
      Params.Currency(Currency);
      if not Description.IsEmpty then
        Params.Description(Description);
      Params.ReturnUrl(ReturnUrl);
      Params.Capture(True);
    end);
end;

function TYooKassa.GetPayment(const Id: string): TYooKassaPayment;
begin
  Result := Get<TYooKassaPayment>('payments/' + Id);
end;

{ TYooKassaPaymentParams }

function TYooKassaPaymentParams.Amount(const Value: Currency): TYooKassaPaymentParams;
begin
  GetOrCreateObject('amount').AddPair('value', Value);
  Result := Self;
end;

function TYooKassaPaymentParams.Capture(const Value: Boolean): TYooKassaPaymentParams;
begin
  Result := TYooKassaPaymentParams(Add('capture', Value));
end;

function TYooKassaPaymentParams.Currency(const Value: string): TYooKassaPaymentParams;
begin
  GetOrCreateObject('amount').AddPair('currency', Value);
  Result := Self;
end;

function TYooKassaPaymentParams.Description(const Value: string): TYooKassaPaymentParams;
begin
  Result := TYooKassaPaymentParams(Add('description', Value));
end;

function TYooKassaPaymentParams.ReturnUrl(const Value: string): TYooKassaPaymentParams;
begin
  GetOrCreateObject('confirmation').AddPair('type', 'redirect').AddPair('return_url', Value);
  Result := Self;
end;

end.


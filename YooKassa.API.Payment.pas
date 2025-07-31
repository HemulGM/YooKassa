unit YooKassa.API.Payment;

interface

uses
  Rest.Json, Rest.Json.Types;

type
  TRecipient = class
  private
    [JsonNameAttribute('account_id')]
    FAccountId: string;
    [JsonNameAttribute('gateway_id')]
    FGatewayId: string;
  public
    property AccountId: string read FAccountId write FAccountId;
    property GatewayId: string read FGatewayId write FGatewayId;
  end;

  TCardProduct = class
  private
    [JsonNameAttribute('code')]
    FCode: string;
    [JsonNameAttribute('name')]
    FName: string;
  public
    property Code: string read FCode write FCode;
    property Name: string read FName write FName;
  end;

  TCard = class
  private
    [JsonNameAttribute('first6')]
    FFirst6: string;
    [JsonNameAttribute('last4')]
    FLast4: string;
    [JsonNameAttribute('expiry_month')]
    FExpiryMonth: TDateTime;
    [JsonNameAttribute('expiry_year')]
    FExpiryYear: string;
    [JsonNameAttribute('card_type')]
    FCardType: string;
    [JsonNameAttribute('card_product')]
    FCardProduct: TCardProduct;
    [JsonNameAttribute('issuer_country')]
    FIssuerCountry: string;
    [JsonNameAttribute('issuer_name')]
    FIssuerName: string;
  public
    property First6: string read FFirst6 write FFirst6;
    property Last4: string read FLast4 write FLast4;
    property ExpiryMonth: TDateTime read FExpiryMonth write FExpiryMonth;
    property ExpiryYear: string read FExpiryYear write FExpiryYear;
    property CardType: string read FCardType write FCardType;
    property CardProduct: TCardProduct read FCardProduct write FCardProduct;
    property IssuerCountry: string read FIssuerCountry write FIssuerCountry;
    property IssuerName: string read FIssuerName write FIssuerName;
    destructor Destroy; override;
  end;

  TPaymentMethod = class
  private
    [JsonNameAttribute('type')]
    FType: string;
    [JsonNameAttribute('id')]
    FId: string;
    [JsonNameAttribute('saved')]
    FSaved: Boolean;
    [JsonNameAttribute('card')]
    FCard: TCard;
    [JsonNameAttribute('title')]
    FTitle: string;
  public
    property &Type: string read FType write FType;
    property Id: string read FId write FId;
    property Saved: Boolean read FSaved write FSaved;
    property Card: TCard read FCard write FCard;
    property Title: string read FTitle write FTitle;
    destructor Destroy; override;
  end;

  TMetadata = class
  end;

  TConfirmation = class
  private
    [JsonNameAttribute('type')]
    FType: string;
    [JsonNameAttribute('confirmation_url')]
    FConfirmationUrl: string;
  public
    property &Type: string read FType write FType;
    property ConfirmationUrl: string read FConfirmationUrl write FConfirmationUrl;
  end;

  TAmount = class
  private
    [JsonNameAttribute('value')]
    FValue: string;
    [JsonNameAttribute('currency')]
    FCurrency: string;
  public
    property Value: string read FValue write FValue;
    property Currency: string read FCurrency write FCurrency;
  end;

  TYooKassaPayment = class
  private
    [JsonNameAttribute('id')]
    FId: string;
    [JsonNameAttribute('status')]
    FStatus: string;
    [JsonNameAttribute('paid')]
    FPaid: Boolean;
    [JsonNameAttribute('amount')]
    FAmount: TAmount;
    [JsonNameAttribute('confirmation')]
    FConfirmation: TConfirmation;
    [JsonNameAttribute('created_at')]
    FCreatedAt: string;
    [JsonNameAttribute('description')]
    FDescription: string;
    [JsonNameAttribute('expires_at')]
    FExpiresAt: string;
    [JsonNameAttribute('metadata')]
    FMetadata: TMetadata;
    [JsonNameAttribute('payment_method')]
    FPaymentMethod: TPaymentMethod;
    [JsonNameAttribute('recipient')]
    FRecipient: TRecipient;
    [JsonNameAttribute('refundable')]
    FRefundable: Boolean;
    [JsonNameAttribute('test')]
    FTest: Boolean;
  public
    property Id: string read FId write FId;
    property Status: string read FStatus write FStatus;
    property Paid: Boolean read FPaid write FPaid;
    property Amount: TAmount read FAmount write FAmount;
    property Confirmation: TConfirmation read FConfirmation write FConfirmation;
    property CreatedAt: string read FCreatedAt write FCreatedAt;
    property Description: string read FDescription write FDescription;
    property ExpiresAt: string read FExpiresAt write FExpiresAt;
    property Metadata: TMetadata read FMetadata write FMetadata;
    property PaymentMethod: TPaymentMethod read FPaymentMethod write FPaymentMethod;
    property Recipient: TRecipient read FRecipient write FRecipient;
    property Refundable: Boolean read FRefundable write FRefundable;
    property Test: Boolean read FTest write FTest;
    destructor Destroy; override;
  end;

implementation

{ TCard }

destructor TCard.Destroy;
begin
  FCardProduct.Free;
  inherited;
end;

{ TPaymentMethod }

destructor TPaymentMethod.Destroy;
begin
  FCard.Free;
  inherited;
end;

{ TYooKassaPayment }

destructor TYooKassaPayment.Destroy;
begin
  FAmount.Free;
  FConfirmation.Free;
  FMetadata.Free;
  FPaymentMethod.Free;
  FRecipient.Free;
  inherited;
end;

end.


unit YooKassa.API.Error;

interface

uses
  Rest.Json, Rest.Json.Types;

type
  TYooKassaError = class
  private
    [JsonNameAttribute('type')]
    FType: string;
    [JsonNameAttribute('id')]
    FId: string;
    [JsonNameAttribute('code')]
    FCode: string;
    [JsonNameAttribute('description')]
    FDescription: string;
    [JsonNameAttribute('parameter')]
    FParameter: string;
  public
    property &Type: string read FType write FType;
    property Id: string read FId write FId;
    property Code: string read FCode write FCode;
    property Description: string read FDescription write FDescription;
    property Parameter: string read FParameter write FParameter;
  end;

implementation

end.


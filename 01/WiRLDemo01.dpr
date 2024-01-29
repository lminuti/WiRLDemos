program WiRLDemo01;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,

  WiRL.http.Server,
  WiRL.http.Server.Indy,

  WiRL.Core.Engine,
  WiRL.Core.Registry,

  WiRL.Core.Attributes,

  WiRL.http.Accept.MediaType,

  WiRL.Core.MessageBody.Default;

type
  TPerson = class(TObject)
  private
    FName: string;
  public
    property Name: string read FName write FName;
  end;

  [Path('person')]
  TPersonResource = class
  public
    [GET]
    [Produces(TMediaType.APPLICATION_JSON)]
    function GetPerson([QueryParam('name')] const AName: string): TPerson;
  end;

var
  LServer: TWiRLServer;

{ TPersonResource }

function TPersonResource.GetPerson(const AName: string): TPerson;
begin
  Result := TPerson.Create;
  Result.Name := AName;
end;

begin
  // Resources should be registered before activate the server
  // In a more complex app you can do the registration in the
  // initialization section of the unit of the class
  TWiRLResourceRegistry.Instance.RegisterResource<TPersonResource>;

  LServer := TWiRLServer.Create(nil);
  try
    LServer.SetPort(8080);

    LServer.AddEngine<TWiRLEngine>('rest')
      .AddApplication('app')
      .SetResources('*');

    LServer.Active := True;

    Readln;
  finally
    LServer.Free;
  end;

end.

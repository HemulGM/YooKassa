program test_yookassa_api_console;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  testregistry, testutils, testrunner,
  test_yookassa_api;

begin
  RunRegisteredTests;
end.

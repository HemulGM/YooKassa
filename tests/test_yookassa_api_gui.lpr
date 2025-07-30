program test_yookassa_api_gui;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, test_yookassa_api, yookassa_api
  ;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

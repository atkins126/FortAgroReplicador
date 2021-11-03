program Replicador;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrincipal in 'UPrincipal.pas' {frmPrincipal},
  UDM1 in 'DM\UDM1.pas' {dmDB: TDataModule},
  UdmPost in 'DM\UdmPost.pas' {dmPost: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmDB, dmDB);
  Application.CreateForm(TdmPost, dmPost);
  Application.Run;
end.

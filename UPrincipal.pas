unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  Horse,
  Horse.Jhonson,
  System.JSON, Horse.HandleException,Winapi.Windows, FireDAC.Phys.PGDef,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client,System.Json.writers,System.IniFiles,System.JSON.Types,
  IdBaseComponent, IdComponent, IdIPWatch, IdTCPConnection, IdTCPClient, IdHTTP;
type
  TfrmPrincipal = class(TForm)
    Rectangle1: TRectangle;
    btnFechar: TImage;
    lblWS: TLabel;
    Rectangle2: TRectangle;
    mlog: TMemo;
    lblTipoBase: TLabel;
    FDConPG: TFDConnection;
    IdIPWatch1: TIdIPWatch;
    PgDriverLink: TFDPhysPgDriverLink;
    IdHTTP1: TIdHTTP;
    procedure FormShow(Sender: TObject);
  private
    function GetVersaoArq: string;
    function LerIni(Diretorio,Chave1, Chave2, ValorPadrao: String): String;
  public
    vTipoBase:string;
    function ConectaPG: TJSONObject;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses UDM1, UdmPost;

{ TForm1 }

function TfrmPrincipal.ConectaPG: TJSONObject;
var
 Arquivo,
 vVendorLib,
 dbUser,
 dbPassw,
 dbName,
 dbServer,
 dbPort: String;
 StrAux     : TStringWriter;
 txtJson    : TJsonTextWriter;
begin
 StrAux  := TStringWriter.Create;
 txtJson := TJsonTextWriter.Create(StrAux);
 Arquivo := ExtractFilePath(ParamStr(0))+'Fort.ini';
 if not FileExists(Arquivo) then
 begin
   txtJson.WriteStartObject;
   txtJson.WritePropertyName('Erro');
   txtJson.WriteValue('Arquivo Fort.ini não localizado no seguinte diretorio:'+
   Arquivo);
   txtJson.WriteEndObject;
   Result := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(StrAux.ToString),0)as TJSONObject;
 end
 else
 begin
   vVendorLib := ExtractFilePath(ParamStr(0))+'libpq.dll';
   dbUser     := LerIni(Arquivo,'LOCAL','UserName','');
   dbPassw    := LerIni(Arquivo,'LOCAL','Password','');
   dbName     := LerIni(Arquivo,'LOCAL','Database','');
   dbServer   := LerIni(Arquivo,'LOCAL','Server','');
   dbPort     := LerIni(Arquivo,'LOCAL','Port','');
   with FDConPG do
   begin
    Params.Clear;
    Params.Values['DriverID']        := 'PG';
    Params.Values['User_name']       := dbUser;
    Params.Values['Database']        := dbName;
    Params.Values['Password']        := dbPassw;
    Params.Values['DriverName']      := 'PG';
    Params.Values['Server']          := dbServer;
    Params.Values['Port']            := dbPort;
    PgDriverLink.VendorLib           := vVendorLib;
   try
     Connected := true;
     vTipoBase := dmDB.RetornaTipoBase;
     lblTipoBase.Text := vTipoBase;
     txtJson.WriteStartObject;
     txtJson.WritePropertyName('Mensagem');
     txtJson.WriteValue('Conexao OK');
     txtJson.WriteEndObject;
     Result := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(StrAux.ToString),0)as TJSONObject;
    except
     on E: Exception do
     begin
      mlog.Lines.Add(E.Message);
      StrAux  := TStringWriter.Create;
      txtJson := TJsonTextWriter.Create(StrAux);
      txtJson.Formatting := TJsonFormatting.Indented;
      txtJson.WriteStartObject;
      txtJson.WritePropertyName('Erro');
      txtJson.WriteValue('Erro Ao Conectar DB LOCAL:'+E.Message);
      txtJson.WriteEndObject;
      Result := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(StrAux.ToString),0)as TJSONObject;
     end;
    end;
  end;
 end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
 ConectaPG;
 TThread.CreateAnonymousThread(procedure
 begin
   //Enviando
   TThread.Synchronize(nil, procedure
   begin
     mlog.Lines.Add('Enviando Dados :'+FormatDateTime('dd/mm/yyyy hh:mm:ss',date));
   end);
   mlog.Lines.Add('Enviando Abastecimento');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.AbastecimentoTable));
   mlog.Lines.Add('Enviando Abastecimento Outros');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.AbastecimentooutrosTable));
   mlog.Lines.Add('Enviando Comprador');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.CompradorTable));
   mlog.Lines.Add('Enviando Contrato');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.ContratosTable));
   mlog.Lines.Add('Enviando Desembarque');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.DesembarqueTable));
   mlog.Lines.Add('Enviando Embarque');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.EmbarqueTable));
   mlog.Lines.Add('Enviando Estoque Entrada');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.EstoqueentradaTable));
   mlog.Lines.Add('Enviando Itens Nota Fiscal');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.NotafiscalitemsTable));
   mlog.Lines.Add('Enviando Estoque Saida');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.EstoquesaidaTable));
   mlog.Lines.Add('Enviando Transferencia Estoque');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.TranferencialocalestoqueTable));
   mlog.Lines.Add('Enviando Devolucao Quimico');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.DevolucaoquimicoTable));
   mlog.Lines.Add('Enviando Revisao');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.RevisaomaquinaTable));
   mlog.Lines.Add('Enviando Revisao Itens');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.RevisaomaquinaitensTable));
   mlog.Lines.Add('Enviando Revisao Serviços');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.ServicomanutencaoTable));
   mlog.Lines.Add('Enviando Pluviometria');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.PluviometriaTable));
   mlog.Lines.Add('Enviando Stand Semetes');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.StandsementesTable));
   mlog.Lines.Add('Enviando Monitoramento Praga');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.MonitoramentopragasTable));
   mlog.Lines.Add('Enviando Monitoramento Praga Pontos');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.MonitoramentopragaspontosTable));
   mlog.Lines.Add('Enviando Monitoramento Praga Valores');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.MonitoramentopragaspontosvaloresTable));
   mlog.Lines.Add('Enviando Receituario');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.ReceiturarioTable));
   mlog.Lines.Add('Enviando Receiturario Valores');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.DetreceiturarioTable));
   mlog.Lines.Add('Enviando Receiturario Talhoes');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.DetreceiturariotalhaoTable));
   mlog.Lines.Add('Enviando Operacao Safra');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.OperacaosafratalhaoTable));
   mlog.Lines.Add('Enviando Operacao Safra Maquinas');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.DetoperacaosafratalhaomaquinasoperadoresTable));
   mlog.Lines.Add('Enviando Operacao Safra Ocorrencia');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.DetoperacaosafratalhaoocorrenciaTable));
   mlog.Lines.Add('Enviando Operação Safra Produtos');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.DetoperacaosafratalhaoprodutosTable));
   mlog.Lines.Add('Enviando Operação Safra Vazão');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.DetvazaooperacaoTable));

   mlog.Lines.Add('Enviando Pedido de Compras');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.PedidocompraTable));

   mlog.Lines.Add('Enviando Pedido Compra Itens');
   mlog.Lines.Add(dmPost.PostGenerico(dmPost.PedidocompraitemsTable));

   //Baixando
   TThread.Synchronize(nil, procedure
   begin
     mlog.Lines.Add('Baixando Dados :'+FormatDateTime('dd/mm/yyyy hh:mm:ss',date));
   end);
   mlog.Lines.Add('Baixando Usuario');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.UsuarioTable));
   mlog.Lines.Add('Baixando Tipo Operacao Solido');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxtipooperacaosolidoTable));
   mlog.Lines.Add('Baixando Tipo Tipo Maquina Veiculos');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxtipomaquinaveiculosTable));
   mlog.Lines.Add('Baixando Tipo Areas');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AreasTable));
   mlog.Lines.Add('Baixando Tipo Atividade Abastecimento');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxatividadeabastecimentoTable));
   mlog.Lines.Add('Baixando Tipo Ocorrencia');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxtipoocorrenciaTable));
   mlog.Lines.Add('Baixando Tipo Servico');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxtiposervicoTable));
   mlog.Lines.Add('Baixando Aux Marcas');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxmarcasTable));
   mlog.Lines.Add('Baixando Tipo Aux Culturas');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxculturasTable));
   mlog.Lines.Add('Baixando Aux Categoria Item');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxcategoriaitemTable));
   mlog.Lines.Add('Baixando Tipo Aux Cultivar');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxtipocultivarTable));
   mlog.Lines.Add('Baixando Aux Grupo Produtos');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxsubgrupoprodutosTable));
   mlog.Lines.Add('Baixando Tipo Aux Segmentos');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxsegmentoTable));
   mlog.Lines.Add('Baixando Aux Praga Tipo');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxpragastipoTable));
   mlog.Lines.Add('Baixando Aux Praga');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxpragasTable));
   mlog.Lines.Add('Baixando Tipo Aux Revisao Item');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxrevisaoitensTable));
   mlog.Lines.Add('Baixando Aux Cobertura');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxcoberturaTable));
   mlog.Lines.Add('Baixando Aux Cultivares');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxcultivaresTable));
   mlog.Lines.Add('Baixando Aux Grupo Produto');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.AuxgrupoprodutosTable));
   mlog.Lines.Add('Baixando Centro Custo');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.CentrocustoTable));
   mlog.Lines.Add('Baixando safra');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.SafraTable));
   mlog.Lines.Add('Baixando Fornecedor');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.FornecedorTable));
   mlog.Lines.Add('Baixando Aux Tipo de Pagamento');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.Forma_pagamento_fornecedorTable));
   mlog.Lines.Add('Baixando Local de Estoque');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.LocalestoqueTable));
   mlog.Lines.Add('Baixando Maquinas Veiculos');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.MaquinaveiculoTable));
   mlog.Lines.Add('Baixando Operador Maquinas');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.OperadormaquinasTable));
   mlog.Lines.Add('Baixando Operaçoes');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.OperacoesTable));
   mlog.Lines.Add('Baixando Propriedade');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PropriedadeTable));
   mlog.Lines.Add('Baixando Serviços');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.ServicoTable));
   mlog.Lines.Add('Baixando Produtos');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.ProdutosTable));
   mlog.Lines.Add('Baixando Pedido de Compras');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PedidocompraTable));
   mlog.Lines.Add('Baixando Status Pedido');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PedidostatusTable));
   mlog.Lines.Add('Baixando Pedido Compras Itens');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PedidocompraitemsTable));
   mlog.Lines.Add('Baixando Plano Revisao');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PlanorevisaoTable));
   mlog.Lines.Add('Baixando Plano Revisao Itens');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PlanorevisaoitensTable));
   mlog.Lines.Add('Baixando Plano Revisao Maquinas');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PlanorevisaomaquinasTable));
   mlog.Lines.Add('Baixando Orcamentos');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.OrcamentosTable));
   mlog.Lines.Add('Baixando Orcamentos Itens');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.OrcamentositensTable));
   mlog.Lines.Add('Baixando Pluviometro');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PluviometroTable));
   mlog.Lines.Add('Baixando Pluviometro Talhoes');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.PluviometrotalhoesTable));
   mlog.Lines.Add('Baixando Setor');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.SetorTable));
   mlog.Lines.Add('Baixando Talhoes');
   mlog.Lines.Add(dmDB.GetGenerico(dmDB.TalhoesTable));
   Application.Terminate;
 end).Start;
end;

function TfrmPrincipal.GetVersaoArq: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(
  ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0,
  VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue),
  VerValueSize);
  with VerValue^ do
  begin
    Result := IntToStr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntToStr(
    dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntToStr(
    dwFileVersionLS shr 16);
    Result := Result + '.' + IntToStr(
    dwFileVersionLS and $FFFF);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

function TfrmPrincipal.LerIni(Diretorio, Chave1, Chave2, ValorPadrao: String): String;
var
 FileIni: TIniFile;
begin
  result := ValorPadrao;
  try
    FileIni := TIniFile.Create(Diretorio);
    if FileExists(Diretorio) then
      result := FileIni.ReadString(Chave1, Chave2, ValorPadrao);
  finally
    FreeAndNil(FileIni)
  end;
end;

end.

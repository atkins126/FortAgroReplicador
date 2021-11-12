unit UdmPost;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON;

type
  TdmPost = class(TDataModule)
    AbastecimentoTable: TFDQuery;
    AbastecimentooutrosTable: TFDQuery;
    CompradorTable: TFDQuery;
    ContratosTable: TFDQuery;
    DesembarqueTable: TFDQuery;
    DetoperacaosafratalhaomaquinasoperadoresTable: TFDQuery;
    DetoperacaosafratalhaoocorrenciaTable: TFDQuery;
    DetoperacaosafratalhaoprodutosTable: TFDQuery;
    DetreceiturarioTable: TFDQuery;
    DetreceiturariotalhaoTable: TFDQuery;
    DetvazaooperacaoTable: TFDQuery;
    DevolucaoquimicoTable: TFDQuery;
    EmbarqueTable: TFDQuery;
    EstoqueentradaTable: TFDQuery;
    EstoquesaidaTable: TFDQuery;
    MonitoramentopragasTable: TFDQuery;
    MonitoramentopragaspontosTable: TFDQuery;
    MonitoramentopragaspontosvaloresTable: TFDQuery;
    NotafiscalitemsTable: TFDQuery;
    OperacaosafratalhaoTable: TFDQuery;
    PedidocompraTable: TFDQuery;
    PedidocompraitemsTable: TFDQuery;
    PluviometriaTable: TFDQuery;
    ReceiturarioTable: TFDQuery;
    RevisaomaquinaTable: TFDQuery;
    RevisaomaquinaitensTable: TFDQuery;
    ServicomanutencaoTable: TFDQuery;
    StandsementesTable: TFDQuery;
    TranferencialocalestoqueTable: TFDQuery;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
  private
    procedure AlteraFlagSyngGenerico(Atabela,ids:string);
  public
    function PostGenerico(DataSet:TFDQuery):string;
  end;

var
  dmPost: TdmPost;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses UPrincipal, UDM1;

{$R *.dfm}

{ TdmPost }

procedure TdmPost.AlteraFlagSyngGenerico(Atabela,ids: string);
var
 vQry:TFDQuery;
 vSql:string;
begin
 vSql := 'update '+Atabela+' set syncAws=1 where id in('+ids+')';
 vQry:=TFDQuery.Create(nil);
 vQry.Connection:=frmPrincipal.FDConPG;
 with vQry,vQry.SQL do
 begin
   Clear;
   Add(vSql);
   ExecSQL;
 end;
 vQry.Free;
end;

function TdmPost.PostGenerico(DataSet: TFDQuery): string;
var
 URL,vReultHTTP:STRING;
 JsonToSend  : TStringStream;
 I:integer;
begin
 DataSet.Close;
 DataSet.Open;
 if not DataSet.IsEmpty then
 begin
   JsonToSend := TStringStream.Create(nil);
   DataSet.SaveToStream(JsonToSend,sfJSON);
   Url := 'http://'+dmDB.Host+':'+dmDB.Porta+'/'+StringReplace(DataSet.Name,'Table','',[rfReplaceAll]);
   frmPrincipal.IdHTTP1.Request.CustomHeaders.Clear;
   frmPrincipal.IdHTTP1.Request.CustomHeaders.Clear;
   frmPrincipal.IdHTTP1.Request.ContentType := 'application/json';
   frmPrincipal.IdHTTP1.Request.Accept      := 'application/json';
   try
     vReultHTTP := frmPrincipal.IdHTTP1.Post(url,JsonToSend);
     if copy(vReultHTTP,0,4)='{"OK'then
     begin
       vReultHTTP := StringReplace(vReultHTTP,'{"OK":"','',[rfReplaceAll]);
       vReultHTTP := StringReplace(vReultHTTP,'"}','',[rfReplaceAll]);
       AlteraFlagSyngGenerico(
        StringReplace(DataSet.Name,'Table','',[rfReplaceAll]),
        vReultHTTP
       );
     Result:=StringReplace(DataSet.Name,'Table','',[rfReplaceAll])+' Ids Enviados:'+vReultHTTP;
     end
     else
     Result     :=vReultHTTP;
   except
    on E: Exception do
     frmPrincipal.mlog.Lines.Add('Erro ao Enviar dados:'+DataSet.Name+' : '+E.Message);
   end;
 end
 else
  Result     := StringReplace(DataSet.Name,'Table','',[rfReplaceAll])+': Sem Dados para Envias';
end;

end.

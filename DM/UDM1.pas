unit UDM1;

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
  IdBaseComponent, IdComponent, IdIPWatch, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;


type
  TdmDB = class(TDataModule)
    AreasTable: TFDQuery;
    AuxatividadeabastecimentoTable: TFDQuery;
    AuxcategoriaitemTable: TFDQuery;
    AuxcoberturaTable: TFDQuery;
    AuxcultivaresTable: TFDQuery;
    AuxculturasTable: TFDQuery;
    AuxgrupoprodutosTable: TFDQuery;
    AuxmarcasTable: TFDQuery;
    AuxpragasTable: TFDQuery;
    AuxpragastipoTable: TFDQuery;
    AuxrevisaoitensTable: TFDQuery;
    AuxsegmentoTable: TFDQuery;
    AuxsubgrupoprodutosTable: TFDQuery;
    AuxtipocultivarTable: TFDQuery;
    AuxtipomaquinaveiculosTable: TFDQuery;
    AuxtipoocorrenciaTable: TFDQuery;
    AuxtipooperacaosolidoTable: TFDQuery;
    AuxtiposervicoTable: TFDQuery;
    CentrocustoTable: TFDQuery;
    Forma_pagamento_fornecedorTable: TFDQuery;
    FornecedorTable: TFDQuery;
    LocalestoqueTable: TFDQuery;
    MaquinaveiculoTable: TFDQuery;
    OperacoesTable: TFDQuery;
    OperadormaquinasTable: TFDQuery;
    OrcamentosTable: TFDQuery;
    OrcamentositensTable: TFDQuery;
    PedidocompraTable: TFDQuery;
    PedidostatusTable: TFDQuery;
    PlanorevisaoTable: TFDQuery;
    PlanorevisaoitensTable: TFDQuery;
    PlanorevisaomaquinasTable: TFDQuery;
    PluviometroTable: TFDQuery;
    PluviometrotalhoesTable: TFDQuery;
    ProdutosTable: TFDQuery;
    PropriedadeTable: TFDQuery;
    SafraTable: TFDQuery;
    ServicoTable: TFDQuery;
    SetorTable: TFDQuery;
    TalhoesTable: TFDQuery;
    UsuarioTable: TFDQuery;
    PedidocompraitemsTable: TFDQuery;
  private
    { Private declarations }
  public
    host,Porta:string;
    function GetGenerico(DataSet: TFDQuery): string;
    function RetornaTipoBase:string;
    function MudaFlagSyncAws(Atabela,vId:string):string;
  end;

var
  dmDB: TdmDB;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses UPrincipal;

{$R *.dfm}

{ TdmDB }

function TdmDB.GetGenerico(DataSet: TFDQuery): string;
var
 Url,vJsonString,vIsert,vJsonCopy,
 vField,vFieldJS,vId:string;
 vJoInsert,vJoItemO,vJoItemO1,jSubObj,vJoGetJ : TJSONObject;
 vJoItem,vJoItem1,vJoGet  : TJSONArray;
 JsonValue,JsonId:TJSONValue;
 I,J,z:integer;
 joName,objJson,joItem : TJSONObject;
 joItems: TJSONArray;
 f: TField;
begin
  Url := 'http://'+Host+':'+Porta+'/'+StringReplace(DataSet.Name,'Table','',[rfReplaceAll]);
  frmPrincipal.IdHTTP1.Request.CustomHeaders.Clear;
   try
    vJsonString        := frmPrincipal.IdHTTP1.Get(URL);
    vJsonCopy          := copy(vJsonString,0,6);
     if(vJsonCopy<>'{"Erro') then
     begin
      if(vJsonString<>'{"'+DataSet.Name+'":[]}') then
      begin
        DataSet.Close;
        DataSet.Open;
        jSubObj  := TJSONObject.ParseJSONValue(vJsonString) as TJSONObject;
         vJoGet := jSubObj.GetValue<TJSONArray>(DataSet.Name) as TJSONArray;
         for i := 0 to vJoGet.Count-1 do
         begin
            vJoGetJ         := vJoGet.Items[i] as TJSONObject;
            vId               := vJoGetJ.GetValue('id').value;
            DataSet.Filtered := false;
            DataSet.Filter   := 'id='+vId;
            DataSet.Filtered := true;
            if not DataSet.IsEmpty then
             DataSet.Edit
            else
             DataSet.Insert;
             for f in DataSet.Fields do
             begin
              vField:=f.FieldName;
              DataSet.FieldByName(vField).AsString := vJoGetJ.GetValue(vField).value;
             end;
            try
             DataSet.ApplyUpdates(-1);
             MudaFlagSyncAws(StringReplace(DataSet.Name,'Table','',[rfReplaceAll]),vId);
            except
             on E: Exception do
              result:='Erro:'+E.Message;
            end;
         end;
         result:=StringReplace(DataSet.Name,'Table','',[rfReplaceAll])+
         ' Baixados com Sucesso!'
      end
      else
       Result :=StringReplace(DataSet.Name,'Table','',[rfReplaceAll])+' Sem Dados Para Baixar!'
     end
     else
       Result :=vJsonString;
     except
     on E: Exception do
       begin
         result:='Erro ao comunicar com Servidor:'+E.Message;
       end;
     end;
end;

function TdmDB.MudaFlagSyncAws(Atabela,vId: string): string;
var
   URL,vReultHTTP,sql,vResltCopy:STRING;
   JsonToSend  : TStringStream;
   I:integer;
   Txt         : TextFile;
   Quebra      : TStringList;
   LJSon       : TJSONArray;
   vReultHTTPc,
   vReultHTTPClean,ResponseBody: String;
   StrAux      : TStringWriter;
   txtJson     : TJsonTextWriter;
   LJsonObj    : TJSONObject;
begin
 sql := 'update '+Atabela+' set syncfaz=1 where id='+vId;
 JsonToSend := TStringStream.Create(nil);
 StrAux  := TStringWriter.Create;
 txtJson := TJsonTextWriter.Create(StrAux);
 txtJson.Formatting := TJsonFormatting.Indented;
  txtJson.WriteStartObject;
   TxtJSON.WritePropertyName('Flag');
    TxtJSON.WriteStartArray;
     txtJson.WriteStartObject;
       txtJson.WritePropertyName('SQL');
       txtJson.WriteValue(SQL);
     txtJson.WriteEndObject;
    TxtJSON.WriteEndArray;
  txtJson.WriteEndObject;
 LJsonObj := TJsonObject.ParseJSONValue(TEncoding.UTF8.GetBytes(StrAux.ToString),0)as TJSONObject;
 JsonToSend := TStringStream.Create(LJsonObj.ToJSON);
 Url := 'http://'+Host+':'+Porta+'/FlagSync';
 frmPrincipal.IdHTTP1.Request.Accept      := 'application/json';
 frmPrincipal.IdHTTP1.Request.ContentType := 'application/json';
 ResponseBody := frmPrincipal.IdHTTP1.Post(url,JsonToSend);
 vResltCopy   := copy(ResponseBody,0,4);
 if vResltCopy='{"OK' then
 begin
   vReultHTTP := StringReplace(vReultHTTP,'{"OK":"','',[rfReplaceAll]);
   vReultHTTP := StringReplace(vReultHTTP,'"}]}','',[rfReplaceAll]);
 end;
 Result     := Atabela+'-'+vReultHTTP;
end;

function TdmDB.RetornaTipoBase: string;
var
 vQry:TFDQuery;
begin
 vQry:=TFDQuery.Create(nil);
 vQry.Connection:=frmPrincipal.FDConPG;
 with vQry,vQry.SQL do
 begin
   Clear;
   Add('select * from systemconfig');
   Open;
   if vQry.FieldByName('agricultura').AsInteger=1 then
   begin
    Result := 'Agricultura';
    host   := '54.198.102.100';
    Porta  := '8092'
   end
   else
   begin
    host   := '54.198.102.100';
    Porta  := '8001';
    Result := 'Pecuaria'
   end;
 end;
 vQry.Free;
end;

end.

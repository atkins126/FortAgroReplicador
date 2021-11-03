object dmPost: TdmPost
  OldCreateOrder = False
  Height = 551
  Width = 758
  object AbastecimentoTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM abastecimento'
      'WHERE syncAws=0')
    Left = 84
    Top = 76
  end
  object AbastecimentooutrosTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM abastecimentooutros'
      'WHERE syncAws=0')
    Left = 86
    Top = 129
  end
  object CompradorTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM comprador'
      'WHERE syncAws=0')
    Left = 71
    Top = 213
  end
  object ContratosTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM contratos'
      'WHERE syncAws=0')
    Left = 76
    Top = 263
  end
  object DesembarqueTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM desembarque'
      'WHERE syncAws=0')
    Left = 79
    Top = 322
  end
  object DetoperacaosafratalhaomaquinasoperadoresTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM detoperacaosafratalhaomaquinasoperadores'
      'WHERE syncAws=0')
    Left = 489
    Top = 55
  end
  object DetoperacaosafratalhaoocorrenciaTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM detoperacaosafratalhaoocorrencia'
      'WHERE syncAws=0')
    Left = 486
    Top = 102
  end
  object DetoperacaosafratalhaoprodutosTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM detoperacaosafratalhaoprodutos'
      'WHERE syncAws=0')
    Left = 479
    Top = 158
  end
  object DetreceiturarioTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM detreceiturario'
      'WHERE syncAws=0')
    Left = 318
    Top = 337
  end
  object DetreceiturariotalhaoTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM detreceiturariotalhao'
      'WHERE syncAws=0')
    Left = 321
    Top = 405
  end
  object DetvazaooperacaoTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM detvazaooperacao'
      'WHERE syncAws=0')
    Left = 474
    Top = 207
  end
  object DevolucaoquimicoTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM devolucaoquimico'
      'WHERE syncAws=0')
    Left = 68
    Top = 441
  end
  object EmbarqueTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM embarque'
      'WHERE syncAws=0')
    Left = 65
    Top = 383
  end
  object EstoqueentradaTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM estoqueentrada'
      'WHERE syncAws=0')
    Left = 205
    Top = 14
  end
  object EstoquesaidaTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM estoquesaida'
      'WHERE syncAws=0')
    Left = 201
    Top = 127
  end
  object MonitoramentopragasTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM monitoramentopragas'
      'WHERE syncAws=0')
    Left = 328
    Top = 73
  end
  object MonitoramentopragaspontosTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM monitoramentopragaspontos'
      'WHERE syncAws=0')
    Left = 319
    Top = 141
  end
  object MonitoramentopragaspontosvaloresTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM monitoramentopragaspontosvalores'
      'WHERE syncAws=0')
    Left = 316
    Top = 220
  end
  object NotafiscalitemsTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM notafiscalitems'
      'WHERE syncAws=0')
    Left = 203
    Top = 74
  end
  object OperacaosafratalhaoTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM operacaosafratalhao'
      'WHERE syncAws=0')
    Left = 484
    Top = 10
  end
  object PedidocompraTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM pedidocompra'
      'WHERE syncAws=0')
    Left = 676
    Top = 16
  end
  object PedidocompraitemsTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM pedidocompraitems'
      'WHERE syncAws=0')
    Left = 676
    Top = 79
  end
  object PluviometriaTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM pluviometria'
      'WHERE syncAws=0')
    Left = 196
    Top = 439
  end
  object ReceiturarioTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM receiturario'
      'WHERE syncAws=0')
    Left = 324
    Top = 278
  end
  object RevisaomaquinaTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM revisaomaquina'
      'WHERE syncAws=0')
    Left = 196
    Top = 261
  end
  object RevisaomaquinaitensTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM revisaomaquinaitens'
      'WHERE syncAws=0')
    Left = 196
    Top = 321
  end
  object ServicomanutencaoTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM servicomanutencao'
      'WHERE syncAws=0')
    Left = 196
    Top = 384
  end
  object StandsementesTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM standsementes'
      'WHERE syncAws=0')
    Left = 324
    Top = 12
  end
  object TranferencialocalestoqueTable: TFDQuery
    CachedUpdates = True
    Connection = frmPrincipal.FDConPG
    SQL.Strings = (
      'SELECT * FROM tranferencialocalestoque'
      'WHERE syncAws=0')
    Left = 196
    Top = 202
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 64
    Top = 8
  end
end

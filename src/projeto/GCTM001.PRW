#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_GCTM001
    Exemplo de funcao MVC para construcao de cadastro no formato modelo 1.
    @type  Function
    @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE (Cores de Legenda)
    @see https://tdn.totvs.com.br/display/framework/Classe_Acervo
    @see https://tdn.totvs.com.br/display/framework/FWMBrowse
    @see https://tdn.totvs.com/display/framework/MPFormModel
    @see https://tdn.totvs.com/display/framework/FWFormStruct
    @see https://tdn.totvs.com/display/framework/FWFormModelStruct
    @see https://tdn.totvs.com/display/framework/FwStruTrigger
    @see https://tdn.totvs.com/display/framework/FWLoadModel
    @see https://tdn.totvs.com/display/framework/FWFormView
    @see https://tdn.totvs.com/display/framework/FWFormCommit
    @see https://tdn.totvs.com/display/framework/FWFormCancel
    @see https://tdn.totvs.com/display/framework/FWModelActive
    /*/
Function U_GCTM001
    
    Private aRotina     := menudef()
    Private oBrowse     := fwMBrowse():new()
    
    oBrowse:setAlias('Z50')
    oBrowse:setDescription('Tipos de Contratos')
    oBrowse:setExecuteDef(4) // alterar opção padrar no duplo clique do mouse de visualizar para alterar
    oBrowse:addLegend("Z50_TIPO == 'V' ","BR_AMARELO","Vendas"          )
    oBrowse:addLegend("Z50_TIPO == 'C' ","BR_LARANJA","Compras"         )
    oBrowse:addLegend("Z50_TIPO == 'S' ","BR_CINZA"  ,"Sem Integracao"  )
    oBrowse:activate()
   
Return

Static Function menudef

    // ACTION recebe fixo VIEWDEV.<nome do arquivo que contem o model sem a extensão .prw>
    Local aRotina := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar' ACTION 'axPesqui'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'ACTION 'VIEWDEF.GCTM001'  OPERATION 2 ACCESS 0 
    ADD OPTION aRotina TITLE 'Incluir'   ACTION 'VIEWDEF.GCTM001'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'   ACTION 'VIEWDEF.GCTM001'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'   ACTION 'VIEWDEF.GCTM001'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'  ACTION 'VIEWDEF.GCTM001'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'    ACTION 'VIEWDEF.GCTM001'  OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} viewdef
    Construcao da interface grafica
    @type  Static Function
    /*/
Static Function VIEWDEF

    Local oView
    Local oModel
    Local oStruct

    oStruct := fwFormStruct(2,'Z50') // primeiro parametro 2 quando a estrutura é para viewdef
    oModel := fwLoadModel('GCTM001') // nome do arquivo que contem o model sem a extensão .prw
    oView := fwFormView():new()

    oView:setModel(oModel)
    oView:addField('Z50MASTER',oStruct,'Z50MASTER') // componente de formulario
    oView:createHorizontalBox('BOXZ50',100)
    oView:setOwnerView('Z50MASTER','BOXZ50')

Return oView


/*/{Protheus.doc} modeldef
    Construcao da regra de negocio
    @type  Static Function
    /*/
Static Function modeldef

    Local oModel
    Local oStruct
    Local aTrigger

    oStruct := fwFormStruct(1,'Z50') // primeiro parametro 1 quando a estrutura é para modeldef
    oModel := mpFormModel():new('MODEL_GCTM001')

    aTrigger := fwStruTrigger('Z50_TIPO','Z50_CODIGO','U_GCTT001()',.F.,Nil,Nil,Nil,Nil)
    oStruct:addTrigger(aTrigger[1],aTrigger[2],aTrigger[3],aTrigger[4])

    oModel:addFields('Z50MASTER',,oStruct)
    oModel:setDescription('Tipos de contratos')
    oModel:setPrimaryKey({'Z50_FILIAL','Z50_CODIGO'}) // X2_UNICO da tabela

Return oModel


/*/{Protheus.doc} U_GCTT001
    Funcao para execucao do gatilho de codigo
    @type  Function
    /*/
Function U_GCTT001
    
    Local cNovoCod := ''
    Local cAliasSQL := ''

    cAliasSQL := getNextAlias()

    BeginSQL alias cAliasSQL
        SELECT COALESCE(MAX(Z50_CODIGO),'00') Z50_CODIGO
        FROM %table:Z50% Z50
        WHERE Z50.%notdel%
        AND Z50_FILIAL = %exp:xFilial('Z50')%
        AND Z50_TIPO = %exp:M->Z50_TIPO%
    EndSQL

    (cAliasSQL)->(dbEval({|| cNovoCod := alltrim(Z50_CODIGO)}),dbCloseArea())

    If cNovoCod == '00'
        cNovoCod := M->Z50_TIPO + '01'
    Else
        cNovoCod := soma1(cNovoCod)
    EndIf

Return cNovoCod

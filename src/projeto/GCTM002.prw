#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} U_GCTM002
    Cadastro de contratos - ADVPL MVC
    @type  Function
    @see https://centraldeatendimento.totvs.com/hc/pt-br/articles/360029127091-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Op%C3%A7%C3%B5es-de-cores-na-legenda-da-Classe-FWMBROWSE (Cores de Legenda)
    @see https://tdn.totvs.com/display/framework/Classe_Acervo
    @see https://tdn.totvs.com/display/framework/FWMBrowse
    @see https://tdn.totvs.com/display/framework/MPFormModel
    @see https://tdn.totvs.com/display/framework/FWFormStruct
    @see https://tdn.totvs.com/display/framework/FWFormViewStruct
    @see https://tdn.totvs.com/display/framework/FWFormModelStruct
    @see https://tdn.totvs.com/display/framework/FwStruTrigger
    @see https://tdn.totvs.com/display/framework/FWLoadModel
    @see https://tdn.totvs.com/display/framework/FWFormView
    @see https://tdn.totvs.com/display/framework/FWFormCommit
    @see https://tdn.totvs.com/display/framework/FWFormCancel
    @see https://tdn.totvs.com/display/framework/FWModelActive    
    @see https://tdn.totvs.com/display/framework/FWLoadMenuDef
    @see https://tdn.totvs.com/display/framework/FWFldGet
    @see https://tdn.totvs.com/display/framework/FWFldPut
    @see https://tdn.totvs.com/display/framework/formLoadGrid
    @see https://tdn.totvs.com/display/framework/FormLoadField
    @see https://tdn.totvs.com/display/framework/AdvPl+utilizando+MVC    
/*/
Function U_GCTB002

    Private aRotina     := menudef()
    Private oBrowse     := fwMBrowse():new()
    
    oBrowse:setAlias('Z51')
    oBrowse:setDescription('Contratos')
    oBrowse:setExecuteDef(4)
    oBrowse:addLegend("Z51_TPINTE == 'V' "                          ,"BR_AMARELO"   ,"Vendas"          ,'1')
    oBrowse:addLegend("Z51_TPINTE == 'C' "                          ,"BR_LARANJA"   ,"Compras"         ,'1')
    oBrowse:addLegend("Z51_TPINTE == 'S' "                          ,"BR_CINZA"     ,"Sem Integracao"  ,'1')
    oBrowse:addLegend("Z51_STATUS == 'N' .or. empty(Z51_STATUS)  "  ,"AMARELO"      ,"Não Iniciado"    ,'2')
    oBrowse:addLegend("Z51_STATUS == 'I' "                          ,"VERDE"        ,"Iniciado"        ,'2')
    oBrowse:addLegend("Z51_STATUS == 'E' "                          ,"VERMELHO"     ,"Encerrado"       ,'2') 
    oBrowse:activate()
    
Return 

Static Function menudef

    Local aRotina := array(0)

    ADD OPTION aRotina TITLE 'Pesquisar' ACTION 'axPesqui'         OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'ACTION 'VIEWDEF.GCTM002'  OPERATION 2 ACCESS 0 
    ADD OPTION aRotina TITLE 'Incluir'   ACTION 'VIEWDEF.GCTM002'  OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'   ACTION 'VIEWDEF.GCTM002'  OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'   ACTION 'VIEWDEF.GCTM002'  OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE 'Imprimir'  ACTION 'VIEWDEF.GCTM002'  OPERATION 8 ACCESS 0
    ADD OPTION aRotina TITLE 'Copiar'    ACTION 'VIEWDEF.GCTM002'  OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} viewdef
    Construcao da interface grafica
    @type  Static Function
    /*/
Static Function viewdef

    Local oView

Return oView

/*/{Protheus.doc} modeldef
    Construcao da regra de negocio
    @type  Static Function
    /*/
Static Function modeldef

    Local oModel

Return oModel

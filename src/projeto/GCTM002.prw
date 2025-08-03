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
    Local oModel
    Local oStructZ51
    Local oStructZ52

    oStructZ51 := fwFormStruct(2,'Z51')    
    oStructZ52 := fwFormStruct(2,'Z52',{|cCampo| .not. alltrim(cCampo) $ 'Z52_NUMERO'})
    oModel := fwLoadModel('GCTM002')
    oView := fwFormView():new()   

    oView:setModel(oModel)
    oView:addField('Z51MASTER',oStructZ51,'Z51MASTER')
    oView:addGrid('Z52DETAIL',oStructZ52,'Z52DETAIL')
    oView:addIncrementView('Z52DETAIL','Z52_ITEM')
    oView:createHorizontalBox('BOXZ51',50)
    oView:createHorizontalBox('BOXZ52',50)
    oView:setOwnerView('Z51MASTER','BOXZ51')
    oView:setOwnerView('Z52DETAIL','BOXZ52')

Return oView

/*/{Protheus.doc} modeldef
    Construcao da regra de negocio
    @type  Static Function
    /*/
Static Function modeldef

    Local oModel
    Local oStructZ51
    Local oStructZ52
    Local bModelPre := {|oModel| .T.}
    Local bModelPos := {|oModel| .T.}
    Local bCommit := {|oModel| fwFormCommit(oModel)}
    Local bCancel := {|oModel| fwFormCancel(oModel)}
    Local bLinePre := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,1)}
    Local bGridPre := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,2)}
    Local bLinePos := {|oGridModel,nLine| vGridPos(oGridModel,nLine,1)}
    Local bGridPos := {|oGridModel,nLine| vGridPos(oGridModel,nLine,2)}
    Local bGridload := {|oGridModel,lCopy| vGridLoad(oGridModel,lCopy )}

    oStructZ51 := fwFormStruct(1,'Z51')
    oStructZ52 := fwFormStruct(1,'Z52')

    oModel := mpFormModel():new('MODEL_CGTM002',bModelPre,bModelPos,bCommit,bCancel)
    oModel:setDescription('Contratos')
    oModel:addFields('Z51MASTER',,oStructZ51)
    oModel:setPrimaryKey({'Z51_FILIAL','Z51_NUMERO'})
    oModel:addGrid('Z52DETAIL','Z51MASTER',oStructZ52,bLinePre,bLinePos,bGridPre,bGridPos,bGridLoad)
    oModel:getModel('Z52DETAIL'):setUniqueLine({'Z52_ITEM'})
    oModel:setOptional('Z52DETAIL',.T.)
    oModel:setRelation('Z52DETAIL',{{'Z52_FILIAL','xFilial("Z52")'},{"Z52_NUMERO","Z51_NUMERO"}},Z52->(indexKey(1)))

Return oModel

Static Function vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,nOpc)

    Local lValid

return lValid

/*/{Protheus.doc} vGridPos
    Pos validacao do submodelo grid
    @type  Static Function
    /*/
Static Function vGridPos(oGridModel,nLine,nOpc)

    Local lValid := .T.
    
Return lValid

Static Function vGridLoad(oGridModel,lCopy)

    Local aRetorno := formLoadGrid(oGridModel,lCopy)

return aRetorno

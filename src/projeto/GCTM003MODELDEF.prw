#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} modeldef
    Construcao da regra de negocio
    @type  Static Function
    /*/
Static Function modeldef

	Local oModel
	Local oStrZ53CAB
	Local oStrZ53DET
	Local bModelPre := {|oModel| .T.}
	Local bModelPos := {|oModel| .T.}
	Local bCommit := {|oModel| fCommit(oModel)}
	Local bCancel := {|oModel| fCancel(oModel)}
	Local bLinePre := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,1)}
	Local bGridPre := {|oGridModel,nLine,cAction,cField,xValue,xCurrentValue| vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,2)}
	Local bLinePos := {|oGridModel,nLine| vGridPos(oGridModel,nLine,1)}
	Local bGridPos := {|oGridModel,nLine| vGridPos(oGridModel,nLine,2)}
	Local bGridload := {|oGridModel,lCopy| vGridLoad(oGridModel,lCopy )}

	oStrZ53CAB := fwFormStruct(1,'Z53', {|cCampo|       alltrim(cCampo) $ 'Z53_NUMERO|Z53_NUMMED|Z53_EMISSA|Z53_TIPO'})
	oStrZ53DET := fwFormStruct(1,'Z53', {|cCampo| .not. alltrim(cCampo) $ 'Z53_NUMERO|Z53_NUMMED|Z53_EMISSA|Z53_TIPO'})

	oStrZ53CAB:setProperty('Z53_NUMERO',MODEL_FIELD_VALID,{|| fnValid()})
	
	oModel := mpFormModel():new('MODEL_CGTM003',bModelPre,bModelPos,bCommit,bCancel)
	oModel:setDescription('Apontamento de Medições')
	oModel:addFields('Z53MASTER',,oStrZ53CAB)
	oModel:setPrimaryKey({'Z53_FILIAL','Z53_NUMERO'})
	oModel:addGrid('Z53DETAIL','Z53MASTER',oStrZ53DET,bLinePre,bLinePos,bGridPre,bGridPos,bGridLoad)
	oModel:getModel('Z53DETAIL'):setUniqueLine({'Z53_ITEM'})
	oModel:setRelation('Z53DETAIL',{{'Z53_FILIAL','xFilial("Z53")'},{"Z53_NUMERO","Z53_NUMERO"}},Z53->(indexKey(1)))

Return oModel

Static Function fCommit(oModel)

    Local lCommit := fwFormCommit(oModel)

Return lCommit

Static Function fCancel(oModel)

    Local lCancel := fwFormCancel(oModel)

Return lCancel

Static Function vGridPre(oGridModel,nLine,cAction,cField,xValue,xCurrentValue,nOpcao)

    Local lValid := .T.

Return lValid

Static Function vGridPos(oGridModel,nLine,nOpcao)

    Local lValid := .T.

Return lValid

Static Function vGridLoad(oGridModel,lCopy)

    Local aLoad := formLoadGrid(oGridModel, lCopy)
    
Return aLoad

Static Function fnValid

	Local lValid := .T.
	Local cCampo := StrTran(readvar(),"M->","")		
	Local oModel := fwModelActive()

	DO CASE
		CASE cCampo == 'Z53_NUMERO'
			Z51->(DBSetOrder(1),DBSeek(xFilial(alias())+M->Z53_NUMERO))
			lValid := Z51->(Found())

			If lValid
				oModel:getModel('Z53MASTER'):setValue('Z53_TIPO',Z51->Z51_TIPO)
				return lValid
			EndIf
	ENDCASE

return lValid

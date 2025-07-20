#include 'totvs.ch'
#include 'tbiconn.ch'

/*/{Protheus.doc} U_GCTA002
    Exemplo de programa prototipo modelo 3 - advpl tradicional
    Cadastro de contratos
    @type  Function
	@see https://tdn.totvs.com/display/tec/TDialog
	@see https://tdn.totvs.com/display/framework/MsObjSize+-+Dimensionamento+de+janelas
	@see https://tdn.totvs.com/display/tec/FCount
	@see https://tdn.totvs.com/display/tec/FieldName
	@see https://tdn.totvs.com/display/tec/FieldGet
	@see https://tdn.totvs.com/display/framework/MsmGet
	@see https://tdn.totvs.com/pages/releaseview.action?pageId=6814879 (regToMemory)
	@see https://tdn.totvs.com/display/framework/MsNewGetDados
	@see https://tdn.totvs.com/display/framework/BEGIN+TRANSACTION
    @see https://tdn.totvs.com/display/tec/TFont   
    @see https://tdn.totvs.com/display/tec/TSay     
    @see https://tdn.totvs.com/display/tec/TGet	
    /*/
Function U_GCTA002

	Private cTitulo 	:= 'Cadastro de Contratos - Prototipo Modelo 3'
	Private aRotina[0]	
	
	//-- Montagem do array de itens do menu
	aadd(aRotina,{'Pesquisar'	,'AxPesqui'		,0,1})
	aadd(aRotina,{'Visualizar'	,'U_GCTA002M'	,0,2})
	aadd(aRotina,{'Incluir'		,'U_GCTA002M'	,0,3})
	aadd(aRotina,{'Alterar'		,'U_GCTA002M'	,0,4})
	aadd(aRotina,{'Excluir'		,'U_GCTA002M'	,0,5})	
	
	//-- Montagem da tela principal
	Z51->(dbSetOrder(1),mBrowse(,,,,alias())) 
    
Return 

Function U_GCTA002M(cAlias,nReg,nOpc)

	Local oDlg
	Local aAdvSize := msAdvSize()

	//-- Tela de dialog principal
	oDlg 		:= tDialog():new(0 				,; 	//-- Cordenada inicial, Linha inicial (Pixels)
								 0 				,;	//-- Cordenada inicial, Coluna inicial
								 aAdvSize[6] 	,;  //-- Cordenada final, Coluna final
								 aAdvSize[5] 	,;	//-- Cordenada final, Linha fina
								 cTitulo		,;	//-- Titulo da janela
								 Nil			,; 	//-- Fixo
								 Nil			,;  //-- Fixo
								 Nil			,;  //-- Fixo
								 Nil			,;  //-- Fixo
								 CLR_BLACK		,;  //-- Cor do Texto
								 CLR_WHITE		,;  //-- Cor de fundo da tela
								 Nil			,;  //-- Fixo
								 Nil			,;  //-- Fixo
								 .T.			)   //-- Indica que as coordenadas serao em pixel 

	oDlg:activate()
	
Return aCols

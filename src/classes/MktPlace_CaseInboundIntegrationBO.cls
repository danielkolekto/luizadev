/**
*	@author Diego Moreira
*	@class Classe de negocio para leitura do dados de integração 
*/
public class MktPlace_CaseInboundIntegrationBO {
	/**
	*	Metodo principal de leitura e fechamento do atendimento por solicitação do usuario
	*	CASO Adionado a nota e alterando o status de atendimento para fechado
	*	COMENTARIO Adicionado notas finais do atendimento
	*	@param payload JSON com os dados de fechamento do atendimento
	*/ 
	public static void caseClose( String payload ) {
		Map<String, Object> mapResult = ( Map<String, Object> ) JSON.deserializeUntyped( payload );
		Map<String, Object> mapCloseCaseResult = ( Map<String, Object> ) mapResult.get( 'closingCase' );

		Case caseToUpdate = new Case();
		caseToUpdate.LuizaCode__c 		= Util.getString( mapCloseCaseResult.get( 'idCase' ) );
		caseToUpdate.ServiceRating__c 	= Util.getDecimal( Util.getString( mapCloseCaseResult.get( 'rating' ) ) );
		caseToUpdate.Status 			= 'Fechado Cliente';

		CaseComment__c caseCommentToInsert = new CaseComment__c();
		caseCommentToInsert.Autor__r 				= new Account( LuizaCode__c = Util.getString( mapCloseCaseResult.get( 'idAuthor' ) ) );
		caseCommentToInsert.Caso__r 				= new Case( LuizaCode__c = Util.getString( mapCloseCaseResult.get( 'idCase' ) ) );
		caseCommentToInsert.Comentario__c 			= Util.getString( mapCloseCaseResult.get( 'comment' ) );
		caseCommentToInsert.TipoAutor__c 			= 'Cliente';

		CaseDAO.getInstance().insertData( caseCommentToInsert );
		upsert caseToUpdate LuizaCode__c;
	}

	/**
	*	Cria os dados de atendimento 
	*	@param mapCaseResult mapa com os valores do atendimento
	*/
	public static void caseNew( Map<String, Object> mapCaseResult ) {
		Case caseToUpsert = new Case();
		caseToUpsert.RecordTypeId 				= Schema.SObjectType.Case.getRecordTypeInfosByName().get( Util.getString( mapCaseResult.get( 'caseType' ) ) ).getRecordTypeId();
		caseToUpsert.LuizaCode__c 				= Util.getString( mapCaseResult.get( 'protocolService' ) );
		caseToUpsert.Account 					= new Account( LuizaCode__c = Util.getString( mapCaseResult.get( 'idAccount' ) ) );
		caseToUpsert.Seller__r					= new Account( LuizaCode__c = Util.getString( mapCaseResult.get( 'idSeller' ) ) );
		caseToUpsert.ContactSeller__r			= new Contact( LuizaCode__c = Util.getString( mapCaseResult.get( 'idContactSeller' ) ) );	
		caseToUpsert.ProtocoloAtendimento__c 	= Util.getString( mapCaseResult.get( 'protocolService' ) );
		caseToUpsert.OrderNumber__c 			= Util.getString( mapCaseResult.get( 'orderNumber' ) );
		caseToUpsert.Origin 					= Util.getString( mapCaseResult.get( 'origin' ) );
		caseToUpsert.Subject 					= Util.getString( mapCaseResult.get( 'caseType' ) );
		caseToUpsert.Description 				= Util.getString( mapCaseResult.get( 'caseDescription' ) );

		upsert caseToUpsert LuizaCode__c;
		MktPlace_ProductInboundIntegrationBO.caseProduct( ( List<Object> ) mapCaseResult.get( 'products' ), caseToUpsert.LuizaCode__c );
	}

	/**
	*	Metodo principal de leitura e criação de um novo comentario no chamado 
	*	@param payload JSON com os dados de novo comentario
	*/
	public static void caseComment( String payload ) {
		Map<String, Object> mapResult = ( Map<String, Object> ) JSON.deserializeUntyped( payload );
        Map<String, Object> mapCommentResult = ( Map<String, Object> ) mapResult.get( 'commentCase' );
        
        String ticketNumber = Util.getString(mapCommentResult.get('idCase'));
        String authorType = Util.getString( mapCommentResult.get('authorType') );
        Boolean magMediation = 'true'.equalsIgnoreCase( Util.getString(mapCommentResult.get('magazineMediation')) );
		
		Account commentAuthor = AccountDAO.getAccountByLuizaCode( Util.getString(mapCommentResult.get( 'idAuthor' )) );
		Case caseToUpdate = CaseDAO.getCaseByLuizaCode( ticketNumber );
		
		if(caseToUpdate == null)
			throw new Utils.GenericException('O ticket número ' + ticketNumber + ' não foi encontrado');
        
		CaseComment__c caseCommentToInsert = new CaseComment__c();
		caseCommentToInsert.Autor__c 				= commentAuthor != null ? commentAuthor.Id : null;
		caseCommentToInsert.Caso__c 				= caseToUpdate.Id;
		caseCommentToInsert.Comentario__c 			= Util.getString( mapCommentResult.get('comment') );
		caseCommentToInsert.TipoAutor__c 			= Util.getAuthorType( authorType );
		caseCommentToInsert.MagazineMediation__c 	= magMediation;
		caseCommentToInsert.Private__c  			= Util.getBoolean( mapCommentResult.get('private') );

		CaseDAO.getInstance().insertData( caseCommentToInsert );
	}

}
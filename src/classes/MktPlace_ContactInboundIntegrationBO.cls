/**
*	@author Diego Moreira
*	@class Classe de negocio para leitura do dados de integração 
*/
public class MktPlace_ContactInboundIntegrationBO {
	/**
	* 	Cria/Atualiza contato 
	* 	@param mapContactResult Mapa de objetos do cadastro do contato
	* 	@param idCompany codigo da empresa para relacionamento
	*/
	public static void contactCompany( Map<String, Object> mapContactResult, String idCompany ) {
		Contact contactToUpsert = new Contact();
		contactToUpsert.LuizaCode__c 	= Util.getString( mapContactResult.get( 'idContact' ) );
		contactToUpsert.FirstName 		= Util.getFirstName( Util.getString( mapContactResult.get( 'responsibleName' ) ) );
		contactToUpsert.LastName 		= Util.getLastName( Util.getString( mapContactResult.get( 'responsibleName' ) ) );
		contactToUpsert.NickName__c		= Util.getString( mapContactResult.get( 'responsibleNickName' ) );
		contactToUpsert.Account 		= new Account( LuizaCode__c = idCompany );
		contactToUpsert.CPF_CNPJ__c 	= Util.getString( mapContactResult.get( 'responsibleCpf' ) );
		contactToUpsert.Gender__c 		= Util.getString( mapContactResult.get( 'responsibleSex' ) );
		contactToUpsert.Email 			= Util.getString( mapContactResult.get( 'responsibleEmail' ) );
		contactToUpsert.MobilePhone 	= Util.getString( mapContactResult.get( 'responsibleCellPhoneAreaCode' ) ) + ' ' + Util.getString( mapContactResult.get( 'responsibleCellPhone' ) );

		upsert contactToUpsert LuizaCode__c;
	}	

	/**
	* 	Cria/Atualiza Contatos do seller 
	* 	@param objContactList Lista de objeto com os dados do seller
	* 	@param idSeller codigo do seller para relacionamento
	*/
	public static void contactSeller( List<Object> objContactList, String idSeller ) {
		List<Contact> contactToUpsert = new List<Contact>();

		for( Object objResult : objContactList ) {
            Map<String, Object> mapContact = ( Map<String, Object> ) objResult;

            Contact contact = new Contact();
    		contact.LuizaCode__c 	= Util.getString( mapContact.get( 'idContact' ) );
			contact.FirstName 		= Util.getFirstName( Util.getString( mapContact.get( 'name' ) ) );
			contact.LastName 		= Util.getLastName( Util.getString( mapContact.get( 'name' ) ) );
			contact.Account 		= new Account( LuizaCode__c = idSeller );
			contact.Email 			= Util.getString( mapContact.get( 'email' ) );
			contact.Phone 			= Util.getString( mapContact.get( 'phone_number' ) );

			contactToUpsert.add( contact );
        }

		upsert contactToUpsert LuizaCode__c;
	}
}
/**
*	@author Diego Moreira
*	@class Classe de negocio para leitura do dados de integração 
*/
public class MktPlace_AccountInboundIntegrationBO {
	/**
	* 	Cria/Atualiza a empresa 
	* 	@param mapCompanyResult Mapa de objetos do cadastro do cliente PJ
	*/
	public static void accountCompany( Map<String, Object> mapCompanyResult ) {
		Account accountToUpsert = new Account();
		accountToUpsert.RecordTypeId 				= AccountDAO.RECORDTYPE_CLIENTE_PJ;
		accountToUpsert.LuizaCode__c 				= Util.getString( mapCompanyResult.get( 'idCompany' ) );
		accountToUpsert.Name 						= Util.getString( mapCompanyResult.get( 'name' ) );
		accountToUpsert.NickName__c 				= Util.getString( mapCompanyResult.get( 'nickName' ) );
		accountToUpsert.Email__c 					= Util.getString( mapCompanyResult.get( 'email' ) );
		accountToUpsert.CNPJ__c 					= Util.getString( mapCompanyResult.get( 'cnpj' ) );
		accountToUpsert.InscricaoEstadual__c 		= Util.getString( mapCompanyResult.get( 'stateInscription' ) );
		accountToUpsert.RecebeNewsletter__c 		= Util.getBoolean( mapCompanyResult.get( 'newsletterEnabled' ) );
		accountToUpsert.RecebeInformacoesEmail__c 	= Util.getBoolean( mapCompanyResult.get( 'informationEmailEnabled' ) );
		accountToUpsert.RecebeSMS__c 				= Util.getBoolean( mapCompanyResult.get( 'phoneMessageEnabled' ) );
		accountToUpsert.BillingStreet 				= Util.getString( mapCompanyResult.get( 'address' ) ) + ', N° ' + Util.getString( mapCompanyResult.get( 'number' ) ) + ', ' + Util.getString( mapCompanyResult.get( 'complement' ) ) + '- ' +  Util.getString( mapCompanyResult.get( 'village' ) );
		accountToUpsert.BillingCity 				= Util.getString( mapCompanyResult.get( 'city' ) );
		accountToUpsert.BillingState 				= Util.getString( mapCompanyResult.get( 'state' ) );
		accountToUpsert.BillingCountry 				= 'Brazil';
		accountToUpsert.BillingPostalCode 			= Util.getString( mapCompanyResult.get( 'zipCode' ) );
		accountToUpsert.ShippingStreet 				= Util.getString( mapCompanyResult.get( 'address' ) ) + ', N° ' + Util.getString( mapCompanyResult.get( 'number' ) ) + ', ' + Util.getString( mapCompanyResult.get( 'complement' ) ) + '- ' +  Util.getString( mapCompanyResult.get( 'village' ) );
		accountToUpsert.ShippingCity 				= Util.getString( mapCompanyResult.get( 'city' ) );
		accountToUpsert.ShippingState 				= Util.getString( mapCompanyResult.get( 'state' ) );
		accountToUpsert.ShippingCountry 			= 'Brazil';
		accountToUpsert.ShippingPostalCode 			= Util.getString( mapCompanyResult.get( 'zipCode' ) );
		accountToUpsert.Phone 						= Util.getString( mapCompanyResult.get( 'comercialPhoneAreaCode' ) ) + ' ' + Util.getString( mapCompanyResult.get( 'comercialPhone' ) );
		System.debug('>>>leoleo1');
		upsert accountToUpsert LuizaCode__c;
		System.debug('>>>leoleo2');
		
		MktPlace_ContactInboundIntegrationBO.contactCompany( ( Map<String, Object> ) mapCompanyResult.get( 'contact' ), Util.getString( mapCompanyResult.get( 'idCompany' ) ) );
	}
 
	/**
	* 	Cria/Atualiza conta pessoal 
	* 	@param mapPearsonResult Mapa de objetos do cadastro do cliente PF
	*/
	public static void accountPerson( Map<String, Object> mapPearsonResult ) {
		Account accountToUpsert = new Account();
		accountToUpsert.RecordTypeId 				= AccountDAO.RECORDTYPE_CLIENTE_PF;
		accountToUpsert.LuizaCode__c 				= Util.getString( mapPearsonResult.get( 'idPerson' ) );
		accountToUpsert.FirstName 					= Util.getFirstName( Util.getString( mapPearsonResult.get( 'name' ) ) );
		accountToUpsert.LastName 					= Util.getLastName( Util.getString( mapPearsonResult.get( 'name' ) ) );
		accountToUpsert.NickName__c 				= Util.getString( mapPearsonResult.get( 'nickName' ) );
		accountToUpsert.Email__c 					= Util.getString( mapPearsonResult.get( 'email' ) );
		accountToUpsert.CPF_CNPJ__pc				= Util.getString( mapPearsonResult.get( 'cpf' ) );
		accountToUpsert.RecebeNewsletter__c 		= Util.getBoolean( mapPearsonResult.get( 'newsletterEnabled' ) );
		accountToUpsert.RecebeInformacoesEmail__c 	= Util.getBoolean( mapPearsonResult.get( 'informationEmailEnabled' ) );
		accountToUpsert.RecebeSMS__c 				= Util.getBoolean( mapPearsonResult.get( 'phoneMessageEnabled' ) );
		accountToUpsert.BillingStreet 				= Util.getString( mapPearsonResult.get( 'address' ) ) + ', N° ' + Util.getString( mapPearsonResult.get( 'number' ) ) + ', ' + Util.getString( mapPearsonResult.get( 'complement' ) ) + '- ' +  Util.getString( mapPearsonResult.get( 'village' ) );
		accountToUpsert.BillingCity 				= Util.getString( mapPearsonResult.get( 'city' ) );
		accountToUpsert.BillingState 				= Util.getString( mapPearsonResult.get( 'state' ) );
		accountToUpsert.BillingCountry 				= 'Brazil';
		accountToUpsert.BillingPostalCode 			= Util.getString( mapPearsonResult.get( 'zipCode' ) );
		accountToUpsert.ShippingStreet 				= Util.getString( mapPearsonResult.get( 'address' ) ) + ', N° ' + Util.getString( mapPearsonResult.get( 'number' ) ) + ', ' + Util.getString( mapPearsonResult.get( 'complement' ) ) + '- ' +  Util.getString( mapPearsonResult.get( 'village' ) );
		accountToUpsert.ShippingCity 				= Util.getString( mapPearsonResult.get( 'city' ) );
		accountToUpsert.ShippingState 				= Util.getString( mapPearsonResult.get( 'state' ) );
		accountToUpsert.ShippingCountry 			= 'Brazil';
		accountToUpsert.ShippingPostalCode 			= Util.getString( mapPearsonResult.get( 'zipCode' ) );
		accountToUpsert.PersonHomePhone 			= Util.getString( mapPearsonResult.get( 'homePhoneAreaCode' ) ) + ' ' + Util.getString( mapPearsonResult.get( 'homePhone' ) );
		accountToUpsert.PersonMobilePhone 			= Util.getString( mapPearsonResult.get( 'cellPhoneAreaCode' ) ) + ' ' + Util.getString( mapPearsonResult.get( 'cellPhone' ) );
		accountToUpsert.RG__pc 						= Util.getString( mapPearsonResult.get( 'rg' ) );
		accountToUpsert.Gender__pc 					= Util.getString( mapPearsonResult.get( 'sex' ) );
		accountToUpsert.PersonBirthdate 			= Util.getDate( Util.getString( mapPearsonResult.get( 'birthDate' ) ) );

		upsert accountToUpsert LuizaCode__c;
	}

	/**
	* 	Cria/Atualiza Dados do Seller 
	* 	@param mapSellerResult Mapa de objetos do cadastro do Seller
	*/
	public static void accountSeller( Map<String, Object> mapSellerResult ) {
		Account accountToUpsert = new Account();
		accountToUpsert.RecordTypeId 		= AccountDAO.RECORDTYPE_SELLER;
		accountToUpsert.LuizaCode__c 		= Util.getString( mapSellerResult.get( 'idSeller' ) );
		accountToUpsert.Name 				= Util.getString( mapSellerResult.get( 'companyName' ) );
		accountToUpsert.NomeFantasia__c 	= Util.getString( mapSellerResult.get( 'name' ) );
		accountToUpsert.CNPJ__c 			= Util.getString( mapSellerResult.get( 'cnpj' ) );
		accountToUpsert.Description 		= Util.getString( mapSellerResult.get( 'description' ) );
		accountToUpsert.BillingStreet 		= Util.getString( mapSellerResult.get( 'address' ) ) + ', N° ' + Util.getString( mapSellerResult.get( 'number' ) ) + ', ' + Util.getString( mapSellerResult.get( 'complement' ) ) + '- ' +  Util.getString( mapSellerResult.get( 'district' ) );
		accountToUpsert.BillingCity 		= Util.getString( mapSellerResult.get( 'city' ) );
		accountToUpsert.BillingState 		= Util.getString( mapSellerResult.get( 'state' ) );
		accountToUpsert.BillingCountry 		= 'Brazil';
		accountToUpsert.BillingPostalCode 	= Util.getString( mapSellerResult.get( 'zipCode' ) );
		accountToUpsert.ShippingStreet 		= Util.getString( mapSellerResult.get( 'address' ) ) + ', N° ' + Util.getString( mapSellerResult.get( 'number' ) ) + ', ' + Util.getString( mapSellerResult.get( 'complement' ) ) + '- ' +  Util.getString( mapSellerResult.get( 'district' ) );
		accountToUpsert.ShippingCity 		= Util.getString( mapSellerResult.get( 'city' ) );
		accountToUpsert.ShippingState 		= Util.getString( mapSellerResult.get( 'state' ) );
		accountToUpsert.ShippingCountry 	= 'Brazil';
		accountToUpsert.ShippingPostalCode 	= Util.getString( mapSellerResult.get( 'zipCode' ) );
		AccountDAO.getInstance().upsertData( new List<Account>{ accountToUpsert }, Account.LuizaCode__c );
		MktPlace_ContactInboundIntegrationBO.contactSeller( ( List<Object> ) mapSellerResult.get( 'contacts' ), Util.getString( mapSellerResult.get( 'idSeller' ) ) );
	}
}
@isTest
private class CaseMilestoneDAOTest {
	
	private static Case case01;
	private static Account customer, seller, mktplace;
	
	static {
		String cnpj = Utils.generateCnpj();
		
		customer = AccountBuild.createCustomerAcct();
		seller = AccountBuild.createSellerAcct(cnpj);
		mktplace = AccountBuild.createMktPlaceAcct();
		Database.insert(new List<Account>{customer, seller, mktplace});
		
		Contact contactSeller = new Contact(
			FirstName = 'Suene',
			LastName = 'Souza',
			CPF_CNPJ__c = cnpj,
			Email = 'suene.souza@luizalabs.com',
			AccountId = seller.Id,
			Phone = '11'+Utils.randomNumberAsString(8),
			MobilePhone = '119'+Utils.randomNumberAsString(8),
			Gender__c = 'Feminino'
		);
		Database.insert(contactSeller);
		
		case01 = CaseBuild.createCase('MktPlace_DuvidasProdutos', seller.Id, contactSeller.Id);
		Database.insert(case01);
		
		Database.insert(new CaseComment__c(
			Caso__c = case01.Id,
			Autor__c = customer.Id,
			Name = 'Name',
			Comentario__c = 'Comentario teste cliente',
			TipoAutor__c = 'Cliente',
			Private__c = false
		));
	}
	
	
	@isTest static void test_method_one() {
		CaseMilestoneDAO.getCaseMilestonesByCaseId(new Set<Id>{case01.Id});
	}
	
}
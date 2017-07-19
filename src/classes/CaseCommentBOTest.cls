@isTest
private class CaseCommentBOTest {
	
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
		
		case01 = CaseBuild.createCase('MktPlace_PosicaoEntrega', seller.Id, contactSeller.Id);
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
		Test.startTest();
		
		Database.insert(new CaseComment__c(
			Caso__c = case01.Id,
			Autor__c = seller.Id,
			Name = 'Name',
			Comentario__c = 'Comentario teste seller',
			TipoAutor__c = 'Lojista',
			Private__c = false
		));
		
		Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		Test.startTest();
		
		Database.insert(new CaseComment__c(
			Caso__c = case01.Id,
			Autor__c = mktplace.Id,
			Name = 'Name',
			Comentario__c = 'Comentario teste magazineluiza',
			TipoAutor__c = 'Magazine Luiza',
			Private__c = false
		));
		
		Test.stopTest();
	}
	
	@isTest static void test_method_three() {
		Database.insert(new CaseComment__c(
			Caso__c = case01.Id,
			Autor__c = seller.Id,
			Name = 'Name',
			Comentario__c = 'Comentario teste seller',
			TipoAutor__c = 'Lojista'
		));
		
		Test.startTest();
		
		Database.insert(new CaseComment__c(
			Caso__c = case01.Id,
			Autor__c = customer.Id,
			Name = 'Name',
			Comentario__c = 'Comentario teste cliente mediation',
			TipoAutor__c = 'Cliente',
			Private__c = false,
			MagazineMediation__c = true
		));
		
		Database.insert(new CaseComment__c(
			Caso__c = case01.Id,
			Autor__c = mktplace.Id,
			Name = 'Name',
			Comentario__c = 'Comentario teste magazineluiza mediation',
			TipoAutor__c = 'Magazine Luiza',
			Private__c = false,
			MagazineMediation__c = true
		));
		
		Test.stopTest();
	}
	
}
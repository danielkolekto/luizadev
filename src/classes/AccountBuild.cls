@isTest
public class AccountBuild {
	
	public static Account createCustomerAcct(){
		return getNewAccount(
			'ClientePF',
			'José',
			'da Silva',
			'josedasilva@magazineluiza.com.br',
			'José da Silva',
			'0bee4889-99f6-43ec-8c88-13306f460f04',
			Utils.generateCpf()
		);
	}
	
	public static Account createSellerAcct(String cpfCnpj){
		return getNewAccount(
			'Seller',
			'Vtex',
			'',
			'',
			'',
			'sandboxtestes',
			cpfCnpj
		);
	}
	
	public static Account createMktPlaceAcct(){
		return getNewAccount(
			'Conta_Negocio',
			'magazineluiza',
			'',
			'teste@teste.com',
			'magazineluiza',
			'magazineluiza',
			Utils.generateCnpj()
		);
	}
	
	
	public static Account getNewAccount(String rtName, String firstName, String lastName, String email, String nickName, String luizaCode, String cpfCnpj){
		if('ClientePF'.equals(rtName)){
            return new Account(
            	RecordTypeId = Utils.getRecordTypeId('Account', 'ClientePF'),
                FirstName = firstName,
                LastName = lastName,
                Email__c = email,
                PersonMobilePhone = '11'+Utils.randomNumberAsString(8),
                NickName__c = nickName,
                LuizaCode__c = luizaCode,
                CPF_CNPJ__pc = cpfCnpj
            );
            
		} else {
            return new Account(
            	RecordTypeId = Utils.getRecordTypeId('Account', rtName),
                Name = firstName,
	            NomeFantasia__c = firstName + ' TestClass',
	            Email__c = email,
	            NickName__c = nickName,
                Description = 'testes',
                SellerRating__c = 244,
                TotalCases__c = 214,
                LuizaCode__c = luizaCode,
                CNPJ__c = cpfCnpj
            );
		}
        
	}
	
}
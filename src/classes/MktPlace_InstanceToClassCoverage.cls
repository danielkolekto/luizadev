/*
	@autor Lincoln Soares
	@class Classe de Coberta
*/
public with sharing class MktPlace_InstanceToClassCoverage {
	
	//Create account record
	public static Account 	accountPerson(){
		return new Account(
			//	Name 				= 'Account Test Name',
			FirstName 			= 'Account', 
			LastName 	 		= 'Test Name',
			Phone 				= '1935621233',
			CNPJ__c 			= '45.880.281/0001-52',
			NickName__c			= 'NickName',
			LuizaCode__c		= 'abc12345',
			BillingStreet		= 'BStreet',
			BillingCity			= 'BCity',
			BillingState		= 'São Paulo',
			BillingPostalCode	= '12345-000',
			BillingCountry      = 'Brazil',
			ShippingStreet		= 'SStreet',
			ShippingCity		= 'SCity',
			ShippingState		= 'São Paulo',
			ShippingPostalCode	= '12345-000',
			ShippingCountry     = 'Brazil',
			RecordTypeId 		= 'RECORDTYPE_CLIENTE_PF'
			);
	}

	//Create account record
	public static Account 	accountCompany(){
		return new Account(
		    Name 				= 'Account Company Name',
			Phone 				= '1935621233',
			CNPJ__c 			= '45.880.281/0001-52',
			NomeFantasia__c     = 'Nome Fantasia Teste',
			NickName__c			= 'NickName',
			LuizaCode__c		= 'abc12345',
			BillingStreet		= 'BStreet',
			BillingCity			= 'BCity',
			BillingState		= 'São Paulo',
			BillingPostalCode	= '12345-000',
			BillingCountry      = 'Brazil',
			ShippingStreet		= 'SStreet',
			ShippingCity		= 'SCity',
			ShippingState		= 'São Paulo',
			ShippingPostalCode	= '12345-000',
			ShippingCountry     = 'Brazil',
			RecordTypeId 		= AccountDAO.RECORDTYPE_CLIENTE_PJ
			);
	}

	public static Account 	accountSeller(){
		return new Account(
		    Name 				= 'Account Seller Name',
			Phone 				= '1935621233',
			CNPJ__c 			= '45.880.281/0001-52',
			NomeFantasia__c     = 'Nome Fantasia Teste',
			NickName__c			= 'NickName',
			LuizaCode__c		= 'abc12345',
			BillingStreet		= 'BStreet',
			BillingCity			= 'BCity',
			BillingState		= 'São Paulo',
			BillingPostalCode	= '12345-000',
			BillingCountry      = 'Brazil',
			ShippingStreet		= 'SStreet',
			ShippingCity		= 'SCity',
			ShippingState		= 'São Paulo',
			ShippingPostalCode	= '12345-000',
			ShippingCountry     = 'Brazil',
			RecordTypeId 		= AccountDAO.RECORDTYPE_SELLER
			);
	}
}
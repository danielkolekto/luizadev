/**
*    @author Rogério Oliveira
*    @class Classe DAO do objeto Conta
*/
public with sharing class AccountDAO extends SObjectDAO {
	/*
        Singleton
    */
    private static final AccountDAO instance = new AccountDAO();    
    private AccountDAO(){}    
    public static AccountDAO getInstance() {
        return instance;
    }
    
    public static final String RECORDTYPE_CLIENTE_PJ = Schema.SObjectType.Account.getRecordTypeInfosByName().get( 'Cliente PJ' ).getRecordTypeId();
	public static final String RECORDTYPE_SELLER = Schema.SObjectType.Account.getRecordTypeInfosByName().get( 'Lojista' ).getRecordTypeId();
	public static final String RECORDTYPE_CLIENTE_PF = Schema.SObjectType.Account.getRecordTypeInfosByName().get( 'Cliente PF' ).getRecordTypeId();
    
    public static Account getAccountByLuizaCode(String luizaCode){
        List<Account> acctList = [
            SELECT RecordTypeId
            FROM Account
            WHERE LuizaCode__c = :luizaCode
            LIMIT 1
        ];
        
        return !acctList.isEmpty() ? acctList[0] : null;
    }
    
}
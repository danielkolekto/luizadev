@isTest
public class clsTestContato {
    
    static testMethod void TestContato(){
        
        AtivacaoApex__c at = new AtivacaoApex__c();
        at.Ativo__c = false;
        insert at; 
        
        Account acc = new Account();
        	acc.CNPJ__c = '42.888.814/0001-54';
        	acc.Name = 'Teste';
        	acc.Type = 'Transportadora';
        insert acc;
        
        Contact con = new Contact();
        	con.CPF_CNPJ__c = '432.070.598-05';
        	con.LastName = 'Teste';
        	con.Email = 'teste.teste@teste.com';
        	con.AccountId = acc.Id;
        	con.Gender__c = 'Masculino';
        	con.DateLastUpdate__c = Datetime.now();
        insert con;
        
        try{
        Contact conn = new Contact();
        	conn.CPF_CNPJ__c = '432.070.58-05';
        	conn.LastName = 'Teste2';
        	conn.Email = 'teste.teste@teste.com';
        	conn.AccountId = acc.Id;
        	conn.Gender__c = 'Masculino';
        	conn.DateLastUpdate__c = Datetime.now();
        insert conn;
        }
        catch(Exception e)
        {
            
        }
        
        Contact contato = new Contact();
        	contato.CPF_CNPJ__c = '42.888.814/0001-54';
        	contato.LastName = 'teste1';
        	contato.AccountId = acc.Id;
        	contato.Gender__c = 'Masculino';
        	contato.DateLastUpdate__c = Datetime.now();
        insert contato;
        
    }
}
@isTest
public class clsTestConta {
    	
    static testMethod void TestConta(){
        
        AtivacaoApex__c at = new AtivacaoApex__c();
        at.Ativo__c = false;
        insert at;
        
        Account acc = new Account();
        	acc.CNPJ__c = '42.888.814/0001-54';
        	acc.Name = 'Teste';
        	acc.Type = 'Transportadora';
        insert acc;
        
        try{
        Account ac = new Account();
        	ac.CNPJ__c = '42.888.14/0001-54';
        	ac.Name = 'Teste2';
        	ac.Type = 'Transportadora';
        insert ac;
        }
        catch(Exception e)
        {
            
        }
        
        //Cliente cli = new Cliente();
              
    }
}
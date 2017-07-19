/*
	@autor Lincoln Soares
	@class Classe de negocio do objeto EmailMessage
*/
public class EmailMessageBO {
	private static final EmailMessageBO instance = new EmailMessageBO();    
    private EmailMessageBO(){}
    
    public static EmailMessageBO getInstance() {
        return instance;
    }

    public void updateFieldInCase(){
        
        //disable recursive trigger
        ProcessControl.inFutureContext = true;
        ProcessControl.ignoredByTrigger = true;

        List<Case> qryCaseNotRead = [SELECT Id, E_mail_nao_lido__c FROM Case
                                    WHERE Id IN (SELECT ParentId FROM EmailMessage WHERE Status = '0')
                                  
                                    LIMIT 50];
        
        Case[] msgCaseNotRead = new List<Case>();
        
        for(Case msgNotRead : qryCaseNotRead){
            System.debug('>>> Marca email não lido');
            msgCaseNotRead.add(new Case(Id=msgNotRead.Id, E_mail_nao_lido__c = true));
        }

        update msgCaseNotRead;


        
        List<Case> qryCaseRead = [SELECT Id, E_mail_nao_lido__c FROM Case
                                    WHERE Id IN (SELECT ParentId FROM EmailMessage WHERE Status != '0')
                                    AND Id NOT IN :qryCaseNotRead
                                    AND E_mail_nao_lido__c = true
                                    LIMIT 50];
        
        Case[] msgCaseRead = new List<Case>();
        
        for(Case msgRead : qryCaseRead){
             System.debug('>>> Desmarca email não lido');
            msgCaseRead.add(new Case(Id=msgRead.Id, E_mail_nao_lido__c = false));
        }

        update msgCaseRead;

    }

    public void updateFieldInCase(List<Case> cases){
        
        //disable recursive trigger
        ProcessControl.inFutureContext = true;

        //casos com emails não lidos
        List<Case> qryCaseNotRead = [SELECT Id FROM Case
                                    WHERE Id IN (SELECT ParentId FROM EmailMessage WHERE Status = '0'
                                                    AND ParentId in :cases) Limit 200];
        
        
        List<Case> qryCaseRead = [SELECT Id FROM Case
                                    WHERE Id IN (SELECT ParentId FROM EmailMessage WHERE Status != '0'
                                                    AND ParentId in :cases)
                                    AND Id NOT IN :qryCaseNotRead Limit 200];
        
        
        Case[] msgCaseRead = new List<Case>();
        
        for(Case msgRead : qryCaseRead){
            msgCaseRead.add(new Case(Id=msgRead.Id, E_mail_nao_lido__c = false));
        }

        update msgCaseRead;

    }
}
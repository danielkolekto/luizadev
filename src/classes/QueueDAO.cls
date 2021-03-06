/**
	*@author Diego Moreira
	*@class Classe DAO do objeto queue
*/
public with sharing class QueueDAO extends SObjectDAO {
	/*
		Singleton
    */  
	private static final QueueDAO instance = new QueueDAO();    
    private QueueDAO(){}
    
    public static QueueDAO getInstance() {
        return instance;
    }

    /**
		*Retorna a fila pelo Id
		*@param queueId id da fila para reprocessamento
    */
    public List<Queue__c> getQueueById( String queueId ) {
    	return [SELECT Id, Name, EventName__c, Status__c, Payload__c, IgnoredByTrigger__c, ExceptionStackTrace__c
					FROM Queue__c
					WHERE Id = :queueId];
    } 

    /**
		*Retorna filas por status
		*@param queueStatus Status da fila para filtro
	*/
	public List<Queue__c> getQueueByStatus( String queueStatus ) {
		return [SELECT Id, Name, EventName__c, Status__c, Payload__c, CreatedDate, IgnoredByTrigger__c 
					FROM Queue__c
					WHERE Status__c = :queueStatus
					order by Name desc];
	}

	/**
		*Retorna filas por status
		*@param queueStatus Status da fila para filtro
	*/
	public List<Queue__c> getQueueByStatus( List<String> queueStatus ) {
		return [SELECT Id, Name, EventName__c, Status__c, Payload__c, CreatedDate, IgnoredByTrigger__c
					FROM Queue__c
					WHERE Status__c in :queueStatus
					order by Name desc
					Limit 50];
	}

}
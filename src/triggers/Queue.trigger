/**
*	@author Diego Moreira
*	@trigger Trigger de execução do objeto queue 
*/ 
trigger Queue on Queue__c ( after insert ) {
	
	if( Trigger.isAfter && Trigger.isInsert ) {
		QueueBO.getInstance().executeProcessingQueue( Trigger.new );
	}
	
}
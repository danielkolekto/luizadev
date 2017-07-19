/**
*	@author Diego Moreira
*	@trigger Trigger de execução do objeto comentario do caso 
*/ 
trigger CaseComment on CaseComment__c (before insert, after insert, before update, after update) {
	
	if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
		
		if(Trigger.isInsert){
            CaseCommentBO.getInstance().replicaNovoComentario( trigger.new );
            CaseCommentBO.getInstance().criaFilaIntegracao( trigger.new );
		}
        
        CaseCommentBO.setMktPlaceStatusBandeirinha(Trigger.new);
        
	}
	
}
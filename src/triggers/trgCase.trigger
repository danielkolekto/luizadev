trigger trgCase on Case (before insert, after insert, before update, after update) {
    
    if(!Trigger.isDelete) System.debug('@@@ trgCase Trigger.new INICIO @@@\n' + JSON.serializePretty(Trigger.new));
    
    
    if(Trigger.isBefore && Trigger.isUpdate) {
        CaseBO.caseTreatmentOnBeforeUpdate(Trigger.new, Trigger.oldMap);
        CaseBO.addEntitlementToCase(Trigger.new, Trigger.newMap.keySet());
    }
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        CaseBO.caseTreatmentOnAfterInsertUpdate(Trigger.new);
        
        if( Trigger.isUpdate && !ProcessControl.ignoredByTrigger ) {
            CaseBO.getInstance().atualizaMarco( Trigger.new, Trigger.oldMap );
            CaseBO.getInstance().atualizaAvaliacaoSeller( Trigger.new, Trigger.oldMap );
            CaseBO.getInstance().criaFilaIntegracao( Trigger.new );
        }
    }
    
    
    if(!Trigger.isDelete) System.debug('@@@ trgCase Trigger.new FIM @@@\n' + JSON.serializePretty(Trigger.new));
    
}
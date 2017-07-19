trigger trgConta on Account (before insert, before update, after insert, after update) {

    if(CustomMetadataDAO.isTriggerActive('trgConta')) {
        
        /*if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            for (Account conta : Trigger.new) {
                System.debug('### trgConta - validar CNPJ');
                if(Utils.validateCpfCnpj(conta.CNPJ__C)) {
                    // Adiciona a mascara de CNPJ
                    conta.CNPJ__C = Utils.formatCpfCnpj(conta.CNPJ__C);
                    
                } else {
                    conta.CNPJ__C.addError('Informe um CNPJ válido');
                    return;
                }
            }
        }*/
        
    }
}
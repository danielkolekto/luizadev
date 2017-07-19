/**
*	@author Diego Moreira
*	@class Classe de negocio para o objeto de comentario do caso
*/
public with sharing class CaseCommentBO {
	/*
        Singleton
    */
    private static final CaseCommentBO instance = new CaseCommentBO();
    private CaseCommentBO(){}
    
    public static CaseCommentBO getInstance() {
        return instance;
    }
    
    /**
    *	Replica os comentarios para a estrutura de comentarios padrões do SF
    *	@param newComments Lista de novos comentarios adicionados
    */
    public void replicaNovoComentario( List<CaseComment__c> newComments ) {
    	List<CaseComment> commentsToInsert = new List<CaseComment>();
    	List<String> commentsId = new List<String>();
        
    	for( CaseComment__c comment : newComments )
    		commentsId.add( comment.Id );
            
    	for( CaseComment__c comment : CaseCommentDAO.getInstance().getCaseCommentById( commentsId ) ) {
    		commentsToInsert.add( new CaseComment( 
    			ParentId = comment.Caso__c, 
    			CommentBody = comment.Autor__r.Name + ' (' + comment.TipoAutor__c + ') - ' +  comment.Comentario__c 
			) );
    	}
        
    	insert commentsToInsert;
    }
    
    /**
    *   Cria integração de saida de novo comentario
    *   @param newComments Lista de novos comentarios adicionados
    */
    public void criaFilaIntegracao( List<CaseComment__c> newComments ) {
        List<String> commentsId = new List<String>();
        List<String> jsonList = new List<String>();
        List<Queue__c> queueListInsert = new List<Queue__c>();
        
        for( CaseComment__c comment : newComments ) {
            if( comment.TipoAutor__c.equals( 'Magazine Luiza' ) )
                commentsId.add( comment.Id );
        }
        
        for( CaseComment__c comment : CaseCommentDAO.getInstance().getCaseCommentById( commentsId ) ) {
            jsonList.add( MktPlace_CaseOutboundIntegrationBO.getJsonComment( comment ) );
        }
        
        for( String jsonResult : jsonList ) {
            queueListInsert.add( QueueBO.getInstance().createQueue( QueueEventNames.MKTPLACE_CASE_COMMENT_SALESFORCE_TO_GIBA.name(), jsonResult, false ) );    
        }
        
        Database.insert(queueListInsert);
    }
    
    public static void setMktPlaceStatusBandeirinha(List<CaseComment__c> triggerNew){
        Set<Id> caseIdSet = SetUtils.getCaseCommentCaseIdSet(triggerNew);
        Map<Id, Case> caseMap = CaseDAO.getCaseMapById( caseIdSet );
        List<Case> listCaseUpdate = new List<Case>();
        
        for(CaseComment__c cc : triggerNew){
            if(!caseMap.containsKey(cc.Caso__c)) continue;
            Case commentCase = caseMap.get(cc.Caso__c);
            Boolean underMediation = cc.MagazineMediation__c || commentCase.MagazineDateMediation__c != null;
            Boolean isCustomer = 'Cliente'.equalsIgnoreCase(cc.TipoAutor__c);
            Boolean isSeller = 'Lojista'.equalsIgnoreCase(cc.TipoAutor__c);
            Boolean isMagazine = 'Magazine Luiza'.equalsIgnoreCase(cc.TipoAutor__c);
            String caseBandeirinha;
            String caseStatus;
            
            // Se é comentário privado
            if(cc.Private__c) {
                System.debug('@@@ isPrivate cc.TipoAutor__c: ' + cc.TipoAutor__c);
                caseStatus = commentCase.Status;
                
                if(isSeller) {
                    caseBandeirinha = 'Lojista';
                    
                } else if(isMagazine) {
                    caseBandeirinha = 'Vazio';
                }
                
            } else if(underMediation) { // Se é um comentário sob mediação magazine
                System.debug('@@@ underMediation cc.TipoAutor__c: ' + cc.TipoAutor__c);
                
                if(isCustomer) {
                    caseStatus = 'Aguardando resposta do Magazine Luiza';
                    caseBandeirinha = 'Cliente';
                    
                } else if(isMagazine) {
                    caseStatus = 'Aguardando resposta do Cliente';
                    caseBandeirinha = 'Vazio';
                }
                
            } else { // Se não está sob mediação magazine
                System.debug('@@@ else cc.TipoAutor__c: ' + cc.TipoAutor__c);
                caseBandeirinha = String.isEmpty(commentCase.MktPlaceBandeirinha__c) ? 'Vazio' : commentCase.MktPlaceBandeirinha__c;
                
                if(isCustomer) {
                    caseStatus = 'Aguardando resposta do Lojista';
                    
                } else if(isSeller) {
                    caseStatus = 'Aguardando resposta do Cliente';
                }
            }
            
            listCaseUpdate.add(new Case(Id = commentCase.Id, Status = caseStatus, MktPlaceBandeirinha__c = caseBandeirinha));
        }
        
        
        System.debug('@@@ listCaseUpdate @@@\n' + JSON.serializePretty(listCaseUpdate));
        
        if(!listCaseUpdate.isEmpty())
            Database.update(listCaseUpdate);
    }

}
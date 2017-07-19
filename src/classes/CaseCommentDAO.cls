/**
*    @author Diego Moreira
*    @class Classe DAO para objeto de comentario do caso
*/
public with sharing class CaseCommentDAO extends SObjectDAO {
	/*
		Singleton
    */  
	private static final CaseCommentDAO instance = new CaseCommentDAO();    
    private CaseCommentDAO(){}
    
    public static CaseCommentDAO getInstance() {
        return instance;
    }
    
    
    public static Map<Id, List<CaseComment__c>> getCaseCommentsMapByCaseId(Set<Id> caseIdSet){
        List<CaseComment__c> caseCommentList = getCaseCommentByCaseId(caseIdSet);
        Map<Id, List<CaseComment__c>> mapCommentsByCase = new Map<Id, List<CaseComment__c>>();
        
        for(Id i : caseIdSet){
            List<CaseComment__c> commentList = new List<CaseComment__c>();
            
            for(CaseComment__c cc : caseCommentList){
                if(cc.Caso__c == i) commentList.add(cc);
            }
            
            mapCommentsByCase.put(i, commentList);
        }
        
        return mapCommentsByCase;
    }
    
    
    public static List<CaseComment__c> getCaseCommentByCaseId(Set<Id> caseIdSet) {
        return [
            SELECT  Name,
                    Autor__c,
                    Autor__r.Name,
                    Caso__c,
                    Caso__r.TotalSellerInteractions__c,
                    Comentario__c,
                    TipoAutor__c,
                    Caso__r.LuizaCode__c,
                    Autor__r.LuizaCode__c,
                    Private__c,
                    CancelamentoMagazine__c
            
            FROM    CaseComment__c
            WHERE   Caso__c in :caseIdSet
        ];
    }

    /**
    *	Retorna os dados do comentario e de seus relacionamentos
    *	@param commentsId Id dos comentarios para consulta
    */
    public List<CaseComment__c> getCaseCommentById( List<String> commentsId ) {
    	return [SELECT Id, Name, Autor__c, Autor__r.Name, Caso__c, Caso__r.TotalSellerInteractions__c, Comentario__c, TipoAutor__c,
    			Caso__r.LuizaCode__c, Autor__r.LuizaCode__c, Private__c, CancelamentoMagazine__c
    				FROM CaseComment__c
    				WHERE Id in :commentsId];
    }
    
}
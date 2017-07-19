/**
*    @author Diego Moreira
*    @class Classe de negocio de Caso
*/
public with sharing class CaseDAO extends SObjectDAO {
	/*
		Singleton
    */  
	private static final CaseDAO instance = new CaseDAO();    
    private CaseDAO(){}
    
    public static CaseDAO getInstance() {
        return instance;
    }
    
    public static final String RECORDTYPE_MKTPLACE_CANCELAMENTO_PEDIDO = Schema.SObjectType.Case.getRecordTypeInfosByName().get( 'MktPlace - Cancelamento' ).getRecordTypeId();
	public static final String RECORDTYPE_MKTPLACE_DUVIDA_PRODUTO = Schema.SObjectType.Case.getRecordTypeInfosByName().get( 'MktPlace - Dúvidas gerais' ).getRecordTypeId();
	public static final String RECORDTYPE_MKTPLACE_POSICAO_ENTREGA = Schema.SObjectType.Case.getRecordTypeInfosByName().get( 'MktPlace - Troca' ).getRecordTypeId();
    
    
    public static Map<Id, Case> getCaseMapById(Set<Id> caseIdSet){
        return new Map<Id, Case>( getCaseById(caseIdSet) );
    }
    
    /**
	*	Retorna os dados do caso 
	*	@param luizaCode id do caso para consulta de informações
    */
    public List<Case> getCaseByIntegrationId( String luizaCode ) {
        return [
            SELECT  Id,
                    LuizaCode__c,
                    Account.LuizaCode__c,
                    Status,
                    Seller__r.LuizaCode__c,
                    OrderNumber__c,
                    ProtocoloAtendimento__c,
                    RecordTypeId,
                    RecordType.Name,
                    (SELECT Id, Name, Autor__r.LuizaCode__c, Autor__r.Name, Comentario__c, TipoAutor__c, CreatedDate FROM ComentariosCaso__r),
                    (SELECT Id, Caso__r.LuizaCode__c, Produto__r.LuizaCode__c, Produto__r.Name, Produto__r.Description FROM ProdutosCaso__r)
            
            FROM    Case
            WHERE   LuizaCode__c = :luizaCode Limit 1
        ];
    }
    
    
    /**
    *   Retorna os dados do caso 
    *   @param luizaCode id do caso para consulta de informações
    */
    public static Case getCaseByLuizaCode( String luizaCode ) {
        List<Case> lstCase = [
            SELECT  RecordTypeId,
                    RecordType.Name,
                    LuizaCode__c,
                    Account.LuizaCode__c,
                    Status,
                    Seller__r.LuizaCode__c,
                    OrderNumber__c,
                    ProtocoloAtendimento__c,
                    MagazineDateMediation__c
                    
            FROM    Case
            WHERE   LuizaCode__c = :luizaCode 
            Limit 1
        ];
        
        return !lstCase.isEmpty() ? lstCase[0] : null;
    }


    /**
	*	Retorna os dados do caso 
	*	@param luizaCodes id do caso para consulta de informações
    */
    public List<Case> getCaseByIntegrationId( List<String> luizaCodes ) {
        return [
            SELECT  Id,
                    RecordTypeId,
                    RecordType.Name,
                    LuizaCode__c,
                    Account.LuizaCode__c,
                    Seller__c,
                    Seller__r.SellerRating__c,
                    Seller__r.LuizaCode__c,
                    OrderNumber__c,
                    ProtocoloAtendimento__c,
                    Description,
                    ServiceRating__c,
                    Seller__r.TotalCases__c,
                    (SELECT Id, Name, Autor__r.LuizaCode__c, Autor__r.Name, Comentario__c, TipoAutor__c, CreatedDate FROM ComentariosCaso__r),
                    (SELECT Id, Caso__r.LuizaCode__c, Produto__r.LuizaCode__c, Produto__r.Name, Produto__r.Description FROM ProdutosCaso__r)
            
            FROM    Case
            WHERE   LuizaCode__c in :luizaCodes
        ];
    }

    /**
    *
    *
    */
    public List<Case> getCaseById( List<String> caseId ) {
        return [
            SELECT  Id,
                    LuizaCode__c,
                    Account.LuizaCode__c,
                    Seller__c,
                    Seller__r.SellerRating__c,
                    Seller__r.LuizaCode__c,
                    OrderNumber__c,
                    ProtocoloAtendimento__c,
                    Description,
                    RecordTypeId,
                    RecordType.Name,
                    Status,
                    IsClosed
            
            FROM    Case
            WHERE   Id in :caseId
        ];
    }

    /**
    *
    *
    */
    public static List<Case> getCaseById(Set<Id> caseIdSet) {
        return [
            SELECT  Id,
                    LuizaCode__c,
                    Account.LuizaCode__c,
                    Seller__c,
                    Seller__r.SellerRating__c,
                    Seller__r.LuizaCode__c,
                    OrderNumber__c,
                    ProtocoloAtendimento__c,
                    Description,
                    RecordTypeId,
                    RecordType.Name,
                    Status,
                    IsClosed,
                    MagazineDateMediation__c,
                    MktPlaceBandeirinha__c
            
            FROM    Case
            WHERE   Id in :caseIdSet
        ];
    }

}
/**
*   @author Diego Moreira
*   @class Classe de negocio para geração de fila de integração e leitura de dados
*/
public class MktPlace_CaseIntegrationBO implements IProcessingQueue {
    /** 
    *    Processa a fila de dados do caso 
    *    @param queueId Id da fila de processamento 
    *    @param eventName nome do evento de processamento
    *    @param payload JSON com o item da fila para processamento
    */     
    public static void executeQueue( String queueId, String eventName, String payload ) {
        Savepoint sp = Database.setSavepoint();
        try {
            if( eventName.equals( QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name() ) ) {
               createCase( payload );
            } else if( eventName.equals( QueueEventNames.MKTPLACE_CASE_COMMENT_TO_SALESFORCE.name() ) ) {
               MktPlace_CaseInboundIntegrationBO.caseComment( payload );   
            } else if( eventName.equals( QueueEventNames.MKTPLACE_CASE_CLOSE_GIBA_TO_SALESFORCE.name() ) ) {
               MktPlace_CaseInboundIntegrationBO.caseClose( payload );
            } 
            QueueBO.getInstance().updateQueue( queueId, '' );
        } catch( DmlException ex ) {
            Database.rollback(sp);
            QueueBO.getInstance().updateQueue( queueId, eventName + ' / ' + ex.getMessage() + ' / ' + ex.getStackTraceString() );
        } catch( Exception ex ) {
            Database.rollback(sp);
            QueueBO.getInstance().updateQueue( queueId, eventName + ' / ' + ex.getMessage() + ' / ' + ex.getStackTraceString() );
        }
    }

    /**
    *   Metodo principal que executa a leitura do JSON com dados de abertura de atendimento
    *   @param payload JSON com os dados de abertura de chamado
    */
    private static void createCase( String payload ) {
        Map<String, Object> mapResult = ( Map<String, Object> ) JSON.deserializeUntyped( payload );
        Map<String, Object> mapCaseResult = ( Map<String, Object> ) mapResult.get( 'Case' );
        Boolean isPerson = Util.getBoolean( mapCaseResult.get( 'isPerson' ) );

        if(isPerson) {
            MktPlace_AccountInboundIntegrationBO.accountPerson( ( Map<String, Object> ) mapCaseResult.get( 'person' ) );
        } else {
            MktPlace_AccountInboundIntegrationBO.accountCompany( ( Map<String, Object> ) mapCaseResult.get( 'company' ) );
        }
        MktPlace_AccountInboundIntegrationBO.accountSeller( ( Map<String, Object> ) mapCaseResult.get( 'seller' ) );
        MktPlace_ProductInboundIntegrationBO.product( ( List<Object> ) mapCaseResult.get( 'products' ) );  
        MktPlace_CaseInboundIntegrationBO.caseNew( mapCaseResult );
    }
    
    /**
    *   Consulta de dados de caso aberto
    *   @param caseId codigo do caso que deve ser pesquisado    
    */
    public static String getCaseData( String caseId ) {
        List<Case> caseResultList = CaseDAO.getInstance().getCaseByIntegrationId( caseId );
        if(caseResultList.isEmpty()) return '';
        
        Case caseResult = caseResultList[0];
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
            gen.writeFieldName( 'result' );
            gen.writeStartObject();
                gen.writeStringField( 'idCase',             Util.getString( caseResult.LuizaCode__c ) );
                gen.writeStringField( 'idAccount',          Util.getString( caseResult.Account.LuizaCode__c ) );
                gen.writeStringField( 'idSeller',           Util.getString( caseResult.Seller__r.LuizaCode__c ) );
                gen.writeStringField( 'orderNumber',        Util.getString( caseResult.OrderNumber__c ) );
                gen.writeStringField( 'serviceProtocol',    Util.getString( caseResult.ProtocoloAtendimento__c ) );
                gen.writeFieldName( 'products' );
                gen.writeStartArray();
                for( CaseProduct__c caseProduct : caseResult.ProdutosCaso__r ) {
                    gen.writeStartObject();
                    gen.writeStringField( 'productId',          Util.getString( caseProduct.Produto__r.LuizaCode__c ) );
                    gen.writeStringField( 'productName',        Util.getString( caseProduct.Produto__r.Name ) );
                    gen.writeStringField( 'productDescription', Util.getString( caseProduct.Produto__r.Description ) );
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeFieldName( 'comments' );
                gen.writeStartArray();
                for( CaseComment__c comentariosCaso : caseResult.ComentariosCaso__r ) {
                    gen.writeStartObject();
                    gen.writeStringField( 'idAuthor',       Util.getString( comentariosCaso.Autor__r.LuizaCode__c ) );
                    gen.writeStringField( 'nameAuthor',     Util.getString( comentariosCaso.Autor__r.Name ) );
                    gen.writeStringField( 'comment',        Util.getString( comentariosCaso.Comentario__c ) );
                    gen.writeStringField( 'createdDate',    Util.getString( comentariosCaso.CreatedDate ) );
                    gen.writeEndObject();
                }
                gen.writeEndArray();
            gen.writeEndObject();
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    
    /**
    *   Consulta de dados de caso aberto
    *   @param caseObj registro do objeto Caso que deve pegar o horário do SLA
    */
    public static String getCaseSlaDueDate(Case caseObj) {
        if(caseObj == null) return '';
        
        List<CaseMilestone> caseMilestonesList = CaseMilestoneDAO.getCaseMilestonesByCaseId(new Set<Id>{caseObj.Id});
        Map<String, MilestoneManager__mdt> milestoneManagerMap = CustomMetadataDAO.getMilestonesManagerMap();
        String slaDueDate = '';
        
        if( milestoneManagerMap.containsKey((caseObj.Status + caseObj.RecordType.Name).trim()) ) {
            MilestoneManager__mdt milestoneInfo = milestoneManagerMap.get( (caseObj.Status + caseObj.RecordType.Name).trim() );
            
            for(CaseMilestone cm : caseMilestonesList) {
                if(milestoneInfo.Milestone__c.equalsIgnoreCase(cm.MilestoneType.Name)) {
                    slaDueDate = Util.getISODatetime(cm.TargetDate);
                    break;
                }
            }
        }
        
        return slaDueDate;
    }
}
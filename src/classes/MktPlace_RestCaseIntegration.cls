/**
*   @author Diego Moreira
*   @class Classe de serviço integração SITE -> SF
*/
@RestResource ( urlMapping='/v1/mktplace/case/*' )
global class MktPlace_RestCaseIntegration {
    
    global class RestResponseJson {
        public String status {get;set;}
        public String message {get;set;}
        public String ticketStatus {get;set;}
        public String slaDueDate {get;set;}
    }
    
    
    /*
        Serviço de recebimento de dados para abertura do caso
    */
    @HttpPost
    global static RestResponseJson doPost() {
        RestResponseJson response = new RestResponseJson();
        
        String jsonResult = RestContext.request.requestBody.toString();
        
        try {
            Queue__c queueInsert = QueueBO.getInstance().createQueue( QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name(), jsonResult, false );
            Database.insert(queueInsert);
            
            Queue__c result = QueueDAO.getInstance().getQueueById( queueInsert.Id )[0];
            
            Map<String, Object> mapResult = ( Map<String, Object> ) JSON.deserializeUntyped( result.Payload__c );
            Map<String, Object> mapCaseResult = ( Map<String, Object> ) mapResult.get( 'Case' );
            
            Case responseCase = CaseDAO.getCaseByLuizaCode( (String) mapCaseResult.get('protocolService') );
            
            response.status = result.Status__c;
            response.message = Util.getString( result.ExceptionStackTrace__c );
            if(responseCase != null) {
                response.ticketStatus = Util.getCaseGibaStatus(responseCase.Status);
                response.slaDueDate = MktPlace_CaseIntegrationBO.getCaseSlaDueDate(responseCase);
            }
            
        } catch ( Exception ex ) {
            response.status = 'ERROR';
            response.message = ex.getMessage();
            response.ticketStatus = '';
            response.slaDueDate = '';
        }
        
        System.debug('@@@ doPost response.status: ' + response.status);
        System.debug('@@@ doPost response.message: ' + response.message);
        System.debug('@@@ doPost response.ticketStatus: ' + response.ticketStatus);
        System.debug('@@@ doPost response.slaDueDate: ' + response.slaDueDate);
        
        return response;
    }
    
    /*
        Serviço de recebimento de dados das interações entre Seller e Cliente
    */
    @HttpPut 
    global static RestResponseJson doPut() {
        RestResponseJson response = new RestResponseJson();
        
        String jsonResult = RestContext.request.requestBody.toString();
        
        try {
            Queue__c queueInsert;
            if( jsonResult.contains( 'closingCase' ) ) {
                queueInsert = QueueBO.getInstance().createQueue( QueueEventNames.MKTPLACE_CASE_CLOSE_GIBA_TO_SALESFORCE.name(), jsonResult, false );
            } else if( jsonResult.contains( 'commentCase' ) ) {
                queueInsert = QueueBO.getInstance().createQueue( QueueEventNames.MKTPLACE_CASE_COMMENT_TO_SALESFORCE.name(), jsonResult, false );
            }
            Database.insert(queueInsert);
            
            Queue__c result = QueueDAO.getInstance().getQueueById( queueInsert.Id )[0];
            
            Map<String, Object> mapResult = ( Map<String, Object> ) JSON.deserializeUntyped( result.Payload__c );
            Map<String, Object> mapCaseResult;
            if(mapResult.containsKey('closingCase')) {
                mapCaseResult = ( Map<String, Object> ) mapResult.get( 'closingCase' );
            } else {
                mapCaseResult = ( Map<String, Object> ) mapResult.get( 'commentCase' );
            }
            
            List<Case> integrationCase = CaseDAO.getInstance().getCaseByIntegrationId( (String) mapCaseResult.get('idCase'));
            Case responseCase = !integrationCase.isEmpty() ? integrationCase[0] : null;
            
            response.status = result.Status__c;
            response.message = Util.getString( result.ExceptionStackTrace__c );
            if(responseCase != null) {
                response.ticketStatus = Util.getCaseGibaStatus(responseCase.Status);
                response.slaDueDate = MktPlace_CaseIntegrationBO.getCaseSlaDueDate(responseCase);
            }
            
        } catch ( Exception ex ) {
            response.status = 'ERROR';
            response.message = ex.getMessage();
            response.ticketStatus = '';
            response.slaDueDate = '';
        }
        
        System.debug('@@@ doPut response.status: ' + response.status);
        System.debug('@@@ doPut response.message: ' + response.message);
        System.debug('@@@ doPut response.ticketStatus: ' + response.ticketStatus);
        System.debug('@@@ doPut response.slaDueDate: ' + response.slaDueDate);
        
        return response;
    }

    /*
        Serviço de consulta do atendimento
    */
    @HttpGet
    global static String doGet() {
        String jsonResult;

        try {
            String idCase = RestContext.request.requestURI.substring( RestContext.request.requestURI.lastIndexOf('/')+1 );
            jsonResult = MktPlace_CaseIntegrationBO.getCaseData( idCase );
        } catch( Exception ex ) {
            jsonResult = Util.jsonResponse( 'ERROR', ex.getMessage() );
        }       
        
        return jsonResult;
    }
}
/**
*	@author Diego Moreira
*	@class Classe de integração de Saida de casos
*/
public class MktPlace_CaseOutboundIntegrationBO implements IProcessingQueue {
	/** 
    *    Processa a fila de envio de dados para Novo comentario Marketplce ou Fechamento automatico
    *    @param queueId Id da fila de processamento 
    *    @param eventName nome do evento de processamento
    *    @param payload JSON com o item da fila para processamento
    */     
    public static void executeQueue( String queueId, String eventName, String payload ) {
		syncToServer( queueId, eventName, payload );
	}

	@future( Callout=true )
    private static void syncToServer( String queueId, String eventName, String payload ) {
		try {			 
			String jsonError = MktPlace_GibaIntegrationService.getInstance().createMessage( payload );
            QueueBO.getInstance().updateQueue( queueId, jsonError );
        } catch( DmlException ex ) {
            QueueBO.getInstance().updateQueue( queueId, eventName + ' / ' + ex.getMessage() + ' / ' + ex.getStackTraceString() );
        } catch( CalloutException ex ) {
            QueueBO.getInstance().updateQueue( queueId, eventName + ' / ' + ex.getMessage() + ' / ' + ex.getStackTraceString() );
        } catch( Exception ex ) {
            QueueBO.getInstance().updateQueue( queueId, eventName + ' / ' + ex.getMessage() + ' / ' + ex.getStackTraceString() );
        }
    }
    
    /**
    *   Cria JSON de saida com os dados de integração
    *   @param comment Dados de entrada de comentario
    */
    /*public static String getJsonOpen(Case caseResult, Account caseSeller, Account caseCustomer, Product2 caseProduct) {
        JSONGenerator gen = JSON.createGenerator(true);
        // Inicia Generator
        gen.writeStartObject();
        
        // Inicia Case
        gen.writeFieldName('Case');
        gen.writeStartObject();
        
        // Inicia Seller
        gen.writeFieldName('seller');
        gen.writeStartObject();
        
        // Campos de Seller
        gen.writeStringField('name', caseSeller.NomeFantasia__c);
        gen.writeStringField('cnpj', caseSeller.CNPJ__c);
        gen.writeStringField('address', caseSeller.BillingStreet);
        //gen.writeNumberField('number', '');
        //gen.writeStringField('complement', '');
        //gen.writeStringField('district', '');
        gen.writeStringField('city', caseSeller.BillingCity);
        gen.writeStringField('state', caseSeller.BillingState);
        gen.writeStringField('country', 'Brazil');
        gen.writeStringField('description', caseSeller.Description);
        gen.writeStringField('idSeller', caseSeller.LuizaCode__c);
        gen.writeStringField('companyName', caseSeller.Name);
        gen.writeStringField('zipcode', caseSeller.BillingPostalCode);
        
        // Contatos do seller
        gen.writeFieldName('contacts');
        gen.writeStartArray();
        for(Contact cont : caseSeller.Contacts){
            gen.writeStartObject();
            
            gen.writeStringField('idContact', cont.LuizaCode__c);
            gen.writeStringField('phone_number', cont.Phone);
            gen.writeStringField('name', (cont.FirstName + ' ' + cont.LastName));
            gen.writeStringField('email', cont.Email);
            
            gen.writeEndObject();
        }
        gen.writeEndArray();
        
        gen.writeEndObject();
        // Finaliza Seller
        
        
        
        gen.writeEndObject();
        // Finaliza Case
        
        gen.writeEndObject();
        // Finaliza Generator
        
        return gen.getAsString();
    }*/

    /**
    *	Cria JSON de saida com os dados de integração
    *	@param comment Dados de entrada de comentario
    */
    public static String getJsonClose(Case caseResult) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        gen.writeStringField( 'ticket', Util.getString(caseResult.LuizaCode__c) );
        gen.writeStringField( 'message', 'Fechamento automático de chamado devido a ausência de resposta' );
        gen.writeStringField( 'role', 'marketplace' );
        gen.writeBooleanField( 'closing', true );
        
        gen.writeEndObject();
        
        return gen.getAsString();
    }

    /**
    *	Cria JSON de saida com os dados de integração
    *	@param comment Dados de entrada de comentario do marketplace
    */
    public static String getJsonComment(CaseComment__c comment) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        
        gen.writeStringField( 'ticket', Util.getString(comment.Caso__r.LuizaCode__c) );
        gen.writeStringField( 'message', Util.getString(comment.Comentario__c) );
        gen.writeStringField( 'role', 'marketplace' );
        gen.writeBooleanField( 'private', comment.Private__c );
        if( !comment.Private__c )
            gen.writeStringField( 'status', 'waiting_customer' );
        else if( comment.Private__c )
            gen.writeStringField( 'status', 'waiting_seller' );
        else if( comment.CancelamentoMagazine__c )
            gen.writeStringField( 'status', 'item_return_authorized' );
        
        gen.writeEndObject();
        
        return gen.getAsString();
    }
    
}
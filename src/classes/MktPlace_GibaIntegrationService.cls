/**
*	@author Diego Moreira
*	@class Classe de integração com o GIBA
*/
public class MktPlace_GibaIntegrationService {
	/*
        Singleton
    */
    private static final MktPlace_GibaIntegrationService instance = new MktPlace_GibaIntegrationService();    
    private MktPlace_GibaIntegrationService(){}
    
    public static MktPlace_GibaIntegrationService getInstance() {
        return instance;
    }

    /**
	*	Envia dados para o pagar.me criar o Assinatura de pagamento
	*	@param payload JSON com os dados de Assinatura
	*/
	public String createMessage( String payload ) {
		HttpRequest req = new HttpRequest();
		req.setEndpoint( IntegrationSetup__c.getValues( 'MESSAGES' ).Endpoint__c );
		req.setMethod( 'POST' );
		req.setHeader( 'content-type', 'application/json' );
		req.setHeader( 'Accept', 'application/json' );
		req.setHeader( 'Authorization', 'Bearer ' + IntegrationSetup__c.getValues( 'MESSAGES' ).Token__c );
		req.setTimeout( 120000 );
		req.setBody( payload );	 
		
		Http h = new Http();
		HttpResponse res = h.send( req );
		
		if( res.getStatusCode() == 201 ) return '';
		return res.getBody();
	}
}
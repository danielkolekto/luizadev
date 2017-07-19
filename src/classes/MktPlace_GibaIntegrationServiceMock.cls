/**
*
*
*/
@isTest(SeeAllData=true)
global class MktPlace_GibaIntegrationServiceMock implements HttpCalloutMock {
	/**
	*
	*
	*/
    global HTTPResponse respond( HTTPRequest req ) {
        System.assertEquals( IntegrationSetup__c.getValues( 'MESSAGES' ).Endpoint__c, req.getEndpoint() );
        System.assertEquals( 'POST', req.getMethod() );
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader( 'Content-Type', 'application/json' );
        res.setBody( '' );
        //res.setStatusCode( 201 );
        res.setStatusCode( 200 );
        return res;
    }
}
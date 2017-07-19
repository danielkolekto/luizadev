@isTest(SeeAllData=true)
private class MktPlace_GibaIntegrationServiceTest {
	@isTest static void testGibaIntegrationComment() { 
		CaseComment__c comment = new CaseComment__c();
		comment.MagazineMediation__c 	= true;
		comment.Private__c  			= true;
		comment.CancelamentoMagazine__c	= true;

		String jsonResult = MktPlace_CaseOutboundIntegrationBO.getJsonComment( comment );

        Test.setMock( HttpCalloutMock.class, new MktPlace_GibaIntegrationServiceMock() );
        
        Queue__c queue = QueueBO.getInstance().createQueue( QueueEventNames.MKTPLACE_CASE_COMMENT_SALESFORCE_TO_GIBA.name(), jsonResult, false );
        Database.insert(queue);
        
        MktPlace_CaseOutboundIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );
    }

    @isTest static void testGibaIntegrationCommentError() { 
        CaseComment__c comment = new CaseComment__c();
        comment.MagazineMediation__c    = true;
        comment.Private__c              = true;
        comment.CancelamentoMagazine__c = true;

        String jsonResult = MktPlace_CaseOutboundIntegrationBO.getJsonComment( comment );

        Test.setMock( HttpCalloutMock.class, new MktPlace_GibaIntegrationServiceMock() );
        
        Queue__c queue = QueueBO.getInstance().createQueue( QueueEventNames.MKTPLACE_CASE_COMMENT_SALESFORCE_TO_GIBA.name(), jsonResult, false );
        Database.insert(queue);

        MktPlace_CaseOutboundIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );
    }

    @isTest static void testGibaIntegrationClose() { 
		Case caseResult = new Case();

		String jsonResult = MktPlace_CaseOutboundIntegrationBO.getJsonClose( caseResult );

        Test.setMock( HttpCalloutMock.class, new MktPlace_GibaIntegrationServiceMock() );        

        Queue__c queue = QueueBO.getInstance().createQueue( QueueEventNames.MKTPLACE_CASE_COMMENT_SALESFORCE_TO_GIBA.name(), jsonResult, false );
        Database.insert(queue);

        MktPlace_CaseOutboundIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );
    }
}
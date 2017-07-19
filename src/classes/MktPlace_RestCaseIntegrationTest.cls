@isTest
private class MktPlace_RestCaseIntegrationTest {

    @isTest static void testGetSuccess() {
        test_PostPF();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/v1/mktplace/case/111';
        req.httpMethod = 'GET';

        MktPlace_RestCaseIntegration.doGet();

    }

    @isTest static void testGetError() {

      RestRequest req = new RestRequest();
      RestResponse res = new RestResponse();

      req.requestURI = '/services/apexrest/v1/mktplace/case/111';
      req.httpMethod = 'GET';

      MktPlace_RestCaseIntegration.doGet();

  }
	@isTest static void test_PutComment() {		//MktPlace_RestCaseIntegration.doPut();
        test_PostPF();
        RestRequest req = new RestRequest();

      	//req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'PUT';

        String JSONMsg='{"commentCase": {"comment": "oi oi oi", "idCase": "111", "private": false, "authorType": "customer", "idAuthor": "0bee4889-99f6-43ec-8c88-13306f460f04", "magazineMediation": false, "status": "item_return_authorized"}}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPut() );
        System.debug('>>> ' + jsonResult);
        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_COMMENT_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );


    }


    @isTest static void test_CreateCaseComment() {     //MktPlace_RestCaseIntegration.doPut();
        Case caso = new Case();
        caso.Status='Aguardando resposta do Lojista';
        caso.Description='Description';
        caso.ProtocoloAtendimento__c='123456';
        caso.RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get( 'MktPlace - Cancelamento' ).getRecordTypeId();
        insert caso;

        CaseComment__c comentario = new CaseComment__c();
        comentario.Name='00001';
        comentario.Caso__c=caso.Id;
        comentario.Comentario__c='Erros';
        comentario.EmailNotificacao__c='leonardo@beecloud.com.br';
        comentario.Private__c=false;
        comentario.TipoAutor__c='Lojista';
        comentario.MagazineMediation__c=false;
        insert comentario;


    }

		@isTest static void test_PutCommentMagazine() {		//MktPlace_RestCaseIntegration.doPut();
					test_PostPF();
					RestRequest req = new RestRequest();

					//req.addParameter('brand', 'brand1');
					req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
					req.requestURI = '/services/apexrest/v1/mktplace/case/';
					req.httpMethod = 'PUT';

					String JSONMsg='{"commentCase": {"comment": "oi oi oi", "idCase": "111", "private": false, "authorType": "marketplace", "idAuthor": "0bee4889-99f6-43ec-8c88-13306f460f04", "magazineMediation": false, "status": "waiting_seller"}}';
					req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

					RestResponse res = new RestResponse();
					RestContext.request = req;
					RestContext.response = res;
					String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPut() );
					System.debug('>>> ' + jsonResult);
					Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_COMMENT_TO_SALESFORCE.name() and status__c ='created' limit 1];
					MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );


			}

    @isTest static void test_PostPF() {

      RestRequest req = new RestRequest();
      	//req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'POST';

        String JSONMsg = '{"Case": {"seller": {"name": "VTex (Sandbox Integração)", "cnpj": "01239313000240", "address": '+
        '"Rua miguel mentem", "number": "100", "complement": "", "district": "Vila Guilherme", "city": "São Paulo"'+
        ', "state": "São Paulo", "country": "Brasil", "description": "loja de testes com coleção da época cosméticos",'+
        ' "idSeller": "sandboxintegracao", "companyName": "Vtex", "zipcode": "00000-000", "contacts": [{"name": "Suene Souza", "phone_number": "11 5555-5555", "email": "suene.souza@luizalabs.com", "idContact": "Suene Souza"}]}, "orderNumber": "2147271178578654", "protocolService": "111", "products": [{"productId": "310115361", "productDescription": "", "productName": "Hypnotic Poison Eau de Toilette Dior - Perfume Fem"}], "idSeller": "sandboxintegracao", "idContactSeller": "Suene Souza", "person": {"name": "José da Silva", "email": "teste@magazineluiza.com.br", "nickName": "Labs PF", "newsletterEnabled": true, "informationEmailEnabled": false, "phoneMessageEnabled": true, "homePhoneAreaCode": 16, "homePhone": "32366808", "zipCode": "14020260", "address": "Av Presidente Vargas", "number": "2121", "complement": "", "village": "Jardim América", "city": "Ribeirão Preto", "state": "São Paulo", "idPerson": "0bee4889-99f6-43ec-8c88-13306f460f04", "cpf": "82017812609", "cellPhoneAreaCode": 16, "cellPhone": "997259746", "sex": "male", "rg": "", "birthDate": "1985-06-13"}, "caseType": "MktPlace - Cancelamento", "caseDescription": "Troca ou cancelamento de um ou mais itens de um único pedido", "idAccount": "0bee4889-99f6-43ec-8c88-13306f460f04", "isPerson": true}}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPost() );
        System.debug('>>> ' + jsonResult);

        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );


    }
    @isTest static void test_PostPFDuvidaProduto() {

        RestRequest req = new RestRequest();
        //req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'POST';

        String JSONMsg = '{"Case": {"seller": {"name": "VTex (Sandbox Integração)", "cnpj": "01239313000240", "address": '+
        '"Rua miguel mentem", "number": "100", "complement": "", "district": "Vila Guilherme", "city": "São Paulo"'+
        ', "state": "São Paulo", "country": "Brasil", "description": "loja de testes com coleção da época cosméticos",'+
        ' "idSeller": "sandboxintegracao", "companyName": "Vtex", "zipcode": "00000-000", "contacts": [{"name": "Suene Souza", "phone_number": "11 5555-5555", "email": "suene.souza@luizalabs.com", "idContact": "Suene Souza"}]}, "orderNumber": "2147271178578654", "protocolService": "111", "products": [{"productId": "310115361", "productDescription": "", "productName": "Hypnotic Poison Eau de Toilette Dior - Perfume Fem"}], "idSeller": "sandboxintegracao", "idContactSeller": "Suene Souza", "person": {"name": "José da Silva", "email": "teste@magazineluiza.com.br", "nickName": "Labs PF", "newsletterEnabled": true, "informationEmailEnabled": false, "phoneMessageEnabled": true, "homePhoneAreaCode": 16, "homePhone": "32366808", "zipCode": "14020260", "address": "Av Presidente Vargas", "number": "2121", "complement": "", "village": "Jardim América", "city": "Ribeirão Preto", "state": "São Paulo", "idPerson": "0bee4889-99f6-43ec-8c88-13306f460f04", "cpf": "82017812609", "cellPhoneAreaCode": 16, "cellPhone": "997259746", "sex": "male", "rg": "", "birthDate": "1985-06-13"}, "caseType": "MktPlace - Troca", "caseDescription": "Troca ou cancelamento de um ou mais itens de um único pedido", "idAccount": "0bee4889-99f6-43ec-8c88-13306f460f04", "isPerson": true}}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPost() );
        System.debug('>>> ' + jsonResult);

        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );


    }

    @isTest static void test_PostPFPosicaoEntrega() {

        RestRequest req = new RestRequest();
        //req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'POST';

        String JSONMsg = '{"Case": {"seller": {"name": "VTex (Sandbox Integração)", "cnpj": "01239313000240", "address": '+
        '"Rua miguel mentem", "number": "100", "complement": "", "district": "Vila Guilherme", "city": "São Paulo"'+
        ', "state": "São Paulo", "country": "Brasil", "description": "loja de testes com coleção da época cosméticos",'+
        ' "idSeller": "sandboxintegracao", "companyName": "Vtex", "zipcode": "00000-000", "contacts": [{"name": "Suene Souza", "phone_number": "11 5555-5555", "email": "suene.souza@luizalabs.com", "idContact": "Suene Souza"}]}, "orderNumber": "2147271178578654", "protocolService": "111", "products": [{"productId": "310115361", "productDescription": "", "productName": "Hypnotic Poison Eau de Toilette Dior - Perfume Fem"}], "idSeller": "sandboxintegracao", "idContactSeller": "Suene Souza", "person": {"name": "José da Silva", "email": "teste@magazineluiza.com.br", "nickName": "Labs PF", "newsletterEnabled": true, "informationEmailEnabled": false, "phoneMessageEnabled": true, "homePhoneAreaCode": 16, "homePhone": "32366808", "zipCode": "14020260", "address": "Av Presidente Vargas", "number": "2121", "complement": "", "village": "Jardim América", "city": "Ribeirão Preto", "state": "São Paulo", "idPerson": "0bee4889-99f6-43ec-8c88-13306f460f04", "cpf": "82017812609", "cellPhoneAreaCode": 16, "cellPhone": "997259746", "sex": "male", "rg": "", "birthDate": "1985-06-13"}, "caseType": "MktPlace - Dúvidas gerais", "caseDescription": "Troca ou cancelamento de um ou mais itens de um único pedido", "idAccount": "0bee4889-99f6-43ec-8c88-13306f460f04", "isPerson": true}}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPost() );
        System.debug('>>> ' + jsonResult);

        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );

    }

    @isTest static void test_PostPFPosicaoEntrega1() {

        RestRequest req = new RestRequest();
        //req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'POST';

        String JSONMsg = '{"Case": {"seller": {"name": "VTex (Sandbox Integração)", "cnpj": "01239313000240", "address": '+
        '"Rua miguel mentem", "number": "100", "complement": "", "district": "Vila Guilherme", "city": "São Paulo"'+
        ', "state": "São Paulo", "country": "Brasil", "description": "loja de testes com coleção da época cosméticos",'+
        ' "idSeller": "sandboxintegracao", "companyName": "Vtex", "zipcode": "00000-000", "contacts": [{"name": "Suene Souza", "phone_number": "11 5555-5555", "email": "suene.souza@luizalabs.com", "idContact": "Suene Souza"}]}, "orderNumber": "2147271178578654", "protocolService": "111", "products": [{"productId": "310115361", "productDescription": "", "productName": "Hypnotic Poison Eau de Toilette Dior - Perfume Fem"}], "idSeller": "sandboxintegracao", "idContactSeller": "Suene Souza", "person": {"name": "José da Silva", "email": "teste@magazineluiza.com.br", "nickName": "Labs PF", "newsletterEnabled": true, "informationEmailEnabled": false, "phoneMessageEnabled": true, "homePhoneAreaCode": 16, "homePhone": "32366808", "zipCode": "14020260", "address": "Av Presidente Vargas", "number": "2121", "complement": "", "village": "Jardim América", "city": "Ribeirão Preto", "state": "São Paulo", "idPerson": "0bee4889-99f6-43ec-8c88-13306f460f04", "cpf": "82017812609", "cellPhoneAreaCode": 16, "cellPhone": "997259746", "sex": "male", "rg": "", "birthDate": "1985-06-13"}, "caseType": "MktPlace - Dúvidas gerais", "caseDescription": "Troca ou cancelamento de um ou mais itens de um único pedido", "idAccount": "0bee4889-99f6-43ec-8c88-13306f460f04", "status":"Fechado Automático", "isPerson": true}}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPost() );
        System.debug('>>> ' + jsonResult);

        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );


    }

    @isTest static void test_PutFechaCaso() {
        test_PostPF();
        RestRequest req = new RestRequest();
        //req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'PUT';

        String JSONMsg = '{"closingCase" : {"idCase" : "111","idAuthor" : "0bee4889-99f6-43ec-8c88-13306f460f04", "rating" : 3.0, "comment" : "obrigado"  }}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPut() );
        System.debug('>>> ' + jsonResult);

        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_CLOSE_GIBA_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );


    }

    @isTest static void test_PutFechaCasoNota0() {
        test_PostPF();
        RestRequest req = new RestRequest();
        //req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'PUT';

        String JSONMsg = '{"closingCase" : {"idCase" : "111","idAuthor" : "0bee4889-99f6-43ec-8c88-13306f460f04", "rating" : 0.0, "comment" : "obrigado"  }}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPut() );
        System.debug('>>> ' + jsonResult);

        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_CLOSE_GIBA_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );


    }

    @isTest static void test_PostPJ() {

        RestRequest req = new RestRequest();
        //req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'POST';

        String JSONMsg = '{"Case": {"seller": {"name": "VTex (Sandbox Integração)"'+
        ', "cnpj": "01239313000240", "address": "Rua miguel mentem", "number": "100"'+
        ', "complement": "", "district": "Vila Guilherme", "city": "São Paulo", "state"'+
        ': "São Paulo", "country": "Brasil", "description": "loja de testes com coleção da'+
        ' época cosméticos", "idSeller": "sandboxintegracao", "companyName": "Vtex", "zipco'+
        'de": "00000-000", "contacts": [{"name": "Suene Souza", "idContact": "Suene Souza", '+
        '"email": "suene.souza@luizalabs.com", "phone_number": "11 5555-5555"}]}, "orderNumber'+
        '": "5858002393281693", "protocolService": "2016050407002", "products": [{"productId":'+
        ' "9769500", "productDescription": "Diabólico, mágico, provocante e enfeitiçador. Hypno'+
        'tic Poison é dedicado aos tempos modernos, para a mulher de mistérios e encantos. Um '+
        'perfume magnético que detém o poder mágico de nos tornarmos inesquecíveis. Suas notas'+
        ' combinam amêndoas, jasmim, musgo, baunilha e almíscar", "productName": "Hypnotic Poi'+
        'son Eau de Toilette Dior - 30ml"}], "idSeller": "sandboxintegracao", "idContactSeller"'+
        ': "Suene Souza", "company" : { "idCompany" : "pj00012","name" : "beeCoud", "nickName" '+
        ': "beeCloud", "email" : "contato@beecloud.com.br", "cnpj" : "64.574.412/0001-18","sta'+
        'teInscription" : "ISENTO", "newsletterEnabled" : false, "informationEmailEnabled" : false, '+
        '"phoneMessageEnabled" : false, "address" : "Av Padre Roque", "number" : "1135","complement" : "Sala 12",'+
        '"village" : "Centro", "city" : "Mogi Mirim", "state" : "São Paulo","zipCode" : "13800-033", '+
        '"homePhoneAreaCode" : "19", "homePhone" : "3862 7733", "comercialPhoneAreaCode" : "19",'+
        '"comercialPhone" : "3862 7733", "contact" : { "idContact" : "contact12345", "responsibl'+
        'eName" : "Diego Moreira", "responsibleNickName" : "dmoreira", "responsibleCpf"'+
        ' : "325.243.048-76", "responsibleSex" : "M", "responsibleEmail" : "diego@beecloud.com.br",'+
        '"responsibleCellPhoneAreaCode" : "19", "responsibleCellPhone" : "99102 2030" } },'+
        ' "caseType": "MktPlace - Dúvidas gerais", "caseDescription": "Duvida sobre um '+
        'ou mais produtos de um único pedido ", "idAccount": "pj00012", "isPerson": false}}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPost() );
        System.debug('>>> ' + jsonResult);

        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );

    }

    @isTest static void test_PostPJErrorOne() {

        RestRequest req = new RestRequest();
        //req.addParameter('brand', 'brand1');
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/services/apexrest/v1/mktplace/case/';
        req.httpMethod = 'POST';

        String JSONMsg = '{"Case": {"seller": {"name": "DTex (Sandbox Integração)", "cnpj": "23249313000240", "address": '+
        '"Rua miguel mentem", "number": "100", "complement": "", "district": "Vila Guilherme", "city": "São Paulo"'+
        ', "state": "São Paul", "country": "Brasil", "description": "loja testes com coleção da época cosméticos",'+
        ' "idSeller": "sandboxintegracao", "companyName": "Vtex", "zipcode": "00000-000", "contacts": [{"name": " ", "phone_number": "11 5555-5555", "email": "suene.souza@luizalabs.com", "idContact": "Suene Souza"}]}, "orderNumber": "2147271178578654", "protocolService": "", "products": [{"productId": "", "productDescription": "", "productName": "Hypnotic Poison Eau de Toilette Dior - Perfume Fem"}], "idSeller": "sandboxintegracao", "idContactSeller": "Suene Souza", "company": {"companyName": "teste da Silva", "email": "teste@magazineluiza.com.br", "nickName": "Labs PF","cnpj":"34212343232", "newsletterEnabled": true, "informationEmailEnabled": false, "phoneMessageEnabled": true, "homePhoneAreaCode": 16, "homePhone": "32366808", "zipCode": "14020260", "address": "Av Presidente Vargas", "number": "2121", "complement": "", "village": "Jardim América", "city": "Ribeirão Preto", "state": "São Paulo", "idPerson": "0bee4889-99f6-43ec-8c88-13306f460f04", "cpf": "82017812609", "cellPhoneAreaCode": 16, "cellPhone": "997259746", "sex": "male", "rg": "", "birthDate": "1985-06-13"}, "caseType": "MktPlace - Troca", "caseDescription": "Troca ou cancelamento de um ou mais itens de um único pedido", "idAccount": "0bee4889-99f6-43ec-8c88-13306f460f04", "isPerson": false}}';
        req.requestBody = Blob.valueof(JSONMsg); // Add JSON Message as a POST

        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        String jsonResult = JSON.serializePretty( MktPlace_RestCaseIntegration.doPost() );
        System.debug('>>> ' + jsonResult);

        Queue__C queue = [SELECT Id, EventName__c, PayLoad__c From Queue__c Where EventName__c = :QueueEventNames.MKTPLACE_CASE_OPEN_GIBA_TO_SALESFORCE.name() and status__c ='created' limit 1];
        MktPlace_CaseIntegrationBO.executeQueue( queue.Id, queue.EventName__c, queue.Payload__c );
    }


}
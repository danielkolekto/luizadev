@isTest
global class MockHTTPBuscaCep implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req)
    {
         System.assertEquals('http://m.correios.com.br/movel/buscaCepConfirma.do', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String Corpo='';
        Corpo='<div class="caixacampobranco"><span class="resposta">Logradouro: </span><span class="respostadestaque">Rua Jairo de Almeida Machado';
        corpo=corpo+'</span><br/>';
        corpo=corpo+'<span class="resposta">Bairro: </span><span class="respostadestaque">Jaraguá</span><br/><span class="resposta">Localidade / UF: </span>';
        corpo=corpo+'<span class="respostadestaque"> São Paulo/SP</span><br/><span class="resposta">CEP: </span><span class="respostadestaque">02998060</span><br/>';
        corpo=corpo+'<span class="respostadestaque"> São Paulo/SP</span><br/><span class="resposta">CEP: </span><span class="respostadestaque">02998060</span><br/>';
        corpo=corpo+'<div style="text-align: right;" class="mopcoes orientacao"><span>Opções <img style="position: relative right:0px;" src="images/template/mais.png"/></span></div> </div>';
        res.setBody(corpo);
        res.setStatusCode(200);
        return res;
    }
}
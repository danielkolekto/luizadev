@isTest(SeeAllData=true)
public class clsTestTrgResolucao
{
    static testMethod void testaResolucao()
    {
        RecordType recTypeCase = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND Name = 'Cadastro e seu espaço'];
        Case csTest = new Case();
        csTest.RecordTypeId = recTypeCase.Id;
        csTest.PhoneNumber_1__c = '1126251414';
        csTest.PhoneNumber_2__c = '11986521400';
        csTest.CustomerEmail__c = 'filipe.marino@makeitsimple.com.br';
        csTest.ProblemTypeRegistration__c = 'Cliente não consegue modificar o e-mail';
        csTest.Level_1__c = 'Cadastro e seu espaço';
        csTest.Level_2__c = 'Produto diferente do que constava no site';
        csTest.Description = 'Teste';
        csTest.NewEmailAlteration__c='rafael.souza@teste.com.br';
        
        insert csTest;
    
        Set<String> tiposReg = new Set<String>();
        tiposReg.add('Produto Devolvido');
        tiposReg.add('Pendencia Entrega');
        tiposReg.add('Análise do Produto');
        tiposReg.add('Erro de Cadastro');
        tiposReg.add('Garantia Estendida');
        
        List<RecordType> recTypeCaseList = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'CaseResolution__c' AND Name IN :tiposReg];
        
        String idProdDev = '';
        String idPendEnt = '';
        String idAnProd = '';
        String idErrCad = '';
        String idGarantEst = '';
        
        for(RecordType recType : recTypeCaseList)
        {
            if (recType.Name == 'Produto Devolvido')
            {
                idProdDev = recType.Id;
            }
            
            if (recType.Name == 'Pendencia Entrega')
            {
                idPendEnt = recType.Id;
            }
            
            if (recType.Name == 'Análise do Produto')
            {
                idAnProd = recType.Id;
            }
            
            if (recType.Name == 'Erro de Cadastro')
            {
                idErrCad = recType.Id;
            }
            
            if (recType.Name == 'Garantia Estendida')
            {
                idGarantEst = recType.Id;
            }
        }
        
        //CaseResolution__c csResol = new CaseResolution__c();
        CaseResolution__c csResol = new CaseResolution__c();
        csResol.RecordTypeId = idPendEnt;
        csResol.WhatResolved__c = 'Fechar fluxo | Cliente confirmou recebimento do produto';
        csResol.Action__c = 'Acompanhar solução';
        csResol.Caso__c = csTest.Id;
        csResol.FinalPositionCustomer__c = 'Teste';
        insert csResol;
        
        update csResol;
        
        csResol = new CaseResolution__c();
        csResol.RecordTypeId = idPendEnt;
        csResol.WhatResolved__c = 'Reenviar produto';
        csResol.Action__c = 'Acompanhar solução';
        csResol.Caso__c = csTest.Id;
        csResol.FinalPositionCustomer__c = 'Teste';
        insert csResol;
        
        update csResol;
        
        csResol = new CaseResolution__c();
        csResol.RecordTypeId = idGarantEst;
        csResol.Action__c = 'Enviar para ativo posicionar cliente';
        csResol.Caso__c = csTest.Id;
        insert csResol;
        
        update csResol;
        
        csResol.Action__c = 'Acompanhar solução';
        csResol.PosicionamentoFinalSobreErro__c = 'Teste';
        update csResol;
        
        //csResol = new CaseResolution__c();
        //csResol.RecordTypeId = idAnProd;
        //csResol.Action__c = 'Enviar para ativo posicionar cliente';
        //csResol.Caso__c = csTest.Id;
        //csResol.ResponsibleForError__c = 'Fornecedor';
        //csResol.CorrectItemCode__c = 141414;
        //csResol.ErrorCausedRating__c = 'Erro na cor';
        //csResol.ProposedSolutionforComercialSuport__c = 'Fornecedor enviará peça ou produto';
        //insert csResol;
        
        //update csResol;
    }	
}
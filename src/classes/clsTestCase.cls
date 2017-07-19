@isTest
public with sharing class clsTestCase {

    static testMethod void TestCase() {
        Case cs = new Case();
        cs.Origin = 'E-Mail (S/Tratativa)';
        cs.Level_1__c='Casos abertos pelo CD';
        cs.Level_2__c='Produto devolvido ao CD';
        insert cs;
        cs.Origin = 'E-Mail (S/Tratativa)';
        cs.Level_1__c='Casos abertos pelo CD';
        cs.Level_2__c='Produto devolvido ao CD';
        cs.Subject='Teste';
        update cs;
        
        
    }
    
    private static Case cs = new Case();
    
    static {
        Case cs = new Case();
        cs.Origin = 'Telefone';
        cs.Level_1__c='Casos abertos pelo CD';
        cs.Level_2__c='Produto devolvido ao CD';
        insert cs;
    }
    
    
    static testMethod void TestCaseValidacao01(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = 'Boleto (PREENCHER O Bloco 2 - Boleto';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao02(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='Transportes (PREENCHER O "Bloco 3" - Transportes)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao03(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='Coleta - Devolução atrasada com comprovante ("Bloco 3" - Transportes: PREENCHER 2. E 4.)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao04(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='Coleta - Recontato ("Bloco 3" - Transportes: PREENCHER 3. E 4.)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao05(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='Embalagem interna com dados de outro cliente (PREENCHER "Bloco 4")';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao06(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='Cliente não consegue modificar a senha (NÃO PREENCHER NOVO E-MAIL)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao07(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='Cliente não consegue modificar a senha (NÃO PREENCHER NOVO E-MAIL)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao08(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='Cliente não consegue modificar a senha (NÃO PREENCHER NOVO E-MAIL)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao09(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='';
            cs.TypeDelevery__c='Agendada (PREENCHER DATA DO AGENDAMENTO - próxima pergunta)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao10(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='';
            cs.TypeDelevery__c='';
            cs.CustomerWinsBrandModel__c='Sim (PREENCHER PREFERÊNCIA DO CLIENTE - próxima pergunta)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao11(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='';
            cs.TypeDelevery__c='';
            cs.CustomerWinsBrandModel__c='';
            cs.ThereDifferenceCharged__c='Sim (PREENCHER VALOR DA DIFERENÇA - próxima pergunta)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao12(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='';
            cs.TypeDelevery__c='';
            cs.CustomerWinsBrandModel__c='';
            cs.ThereDifferenceCharged__c='';
            cs.ProposedSolutionCommercialSupport__c='Efetue a troca para o cliente pelo produto correto ("Bloco 2": PREENCHER A PERGUNTA 1)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao13(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='';
            cs.TypeDelevery__c='';
            cs.CustomerWinsBrandModel__c='';
            cs.ThereDifferenceCharged__c='';
            cs.ProposedSolutionCommercialSupport__c='Previsão de recebimento do item ("Bloco 2": PREENCHER AS PERGUNTAS 2., 3. E 4.)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao14(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='';
            cs.TypeDelevery__c='';
            cs.CustomerWinsBrandModel__c='';
            cs.ThereDifferenceCharged__c='';
            cs.ProposedSolutionCommercialSupport__c='Indisponível no fornecedor/ Fora de linha ("Bloco 2": PREENCHER AS PERGUNTAS DE 3. A 8.)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao15(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='';
            cs.TypeDelevery__c='';
            cs.CustomerWinsBrandModel__c='';
            cs.ThereDifferenceCharged__c='';
            cs.ProposedSolutionCommercialSupport__c='';
            cs.StopShippingProduct__c='Não (PREENCHER ENDEREÇO - próxima pergunta)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
    static testMethod void TestCaseValidacao16(){
        Test.startTest();
        
        try {
            cs.PaymentForm__c = '';
            cs.AreaCausingException__c='';
            cs.ReasonException__c='';
            cs.ProblemTypeRegistration__c='';
            cs.TypeDelevery__c='';
            cs.CustomerWinsBrandModel__c='';
            cs.ThereDifferenceCharged__c='';
            cs.ProposedSolutionCommercialSupport__c='';
            cs.StopShippingProduct__c='';
            cs.TypeNFRecharged__c='Coleta (PREENCHER Número NF Coleta)';
            update cs;
        } catch(Exception ex) {
        
        }
        
        Test.stopTest();
    }
    
}
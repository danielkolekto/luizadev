@isTest (SeeAllData=true)
private class  clsTestPesquisaCliente {
     static testMethod void testaPesquisaADMSite() {
        Test.setMock(WebServiceMock.class, new MockServiceFindClienteCodigoADMSite());
        clsPesquisaCliente cl = new clsPesquisaCliente();
        cl.getTipoChave();
        cl.getDDLNivel_1();
        cl.Nivel_1='Casos abertos pelo CD';
        cl.updateNivel_2();
        cl.getDDLNivel_2();
        cl.id='';
        Pagereference testePage = Page.PesquisaCliente;
        Test.setCurrentPage(testePage);
        clsPesquisaCliente controller = new clsPesquisaCliente();
        controller.tpChave='3';
        controller.Chave='21857647228036';
        test.startTest();
        controller.PesquisarCliente();
        controller.Nivel_1='Casos abertos pelo CD';
        controller.Nivel_2='Produto devolvido ao CD';
        controller.isTest=true;
        clsSincronizarMagazine Sinc = new clsSincronizarMagazine();
        clsSincronizarMagazine.Cliente cliente= new clsSincronizarMagazine.Cliente();
        cliente  = Sinc.RetornoCliente(controller.tpChave, controller.Chave);
        controller.cli = cliente; 
        controller.CriarCaso();
        test.stopTest();         
     }
    
    static testMethod void testaPesquisaCPF() {
        Test.setMock(WebServiceMock.class, new MockServiceFindClienteCPF());
        clsPesquisaCliente cl = new clsPesquisaCliente();
        cl.getTipoChave();
        cl.Nivel_1='Casos abertos pelo CD';
        cl.updateNivel_2();
        Pagereference testePage = Page.PesquisaCliente;
        Test.setCurrentPage(testePage);
        clsPesquisaCliente controller = new clsPesquisaCliente();
        controller.tpChave='1';
        controller.Chave='06375160440';
        test.startTest();
        controller.PesquisarCliente();
        controller.Chave='06375160448';
        controller.PesquisarCliente();
        controller.Nivel_1='Casos abertos pelo CD';
        controller.Nivel_2='Produto devolvido ao CD';
        controller.isTest=true;
        controller.CriarCaso();
        test.stopTest();         
     }
    
    static testMethod void testaPesquisaEMAIL() {
        Test.setMock(WebServiceMock.class, new MockServiceFindClienteEmail());
        clsPesquisaCliente cl = new clsPesquisaCliente();
        cl.getTipoChave();
        cl.Nivel_1='Casos abertos pelo CD';
        cl.updateNivel_2();
        Pagereference testePage = Page.PesquisaCliente;
        Test.setCurrentPage(testePage);
        clsPesquisaCliente controller = new clsPesquisaCliente();
        controller.tpChave='2';
        controller.Chave='rafael.com.br';
        test.startTest();
        controller.PesquisarCliente();
        controller.Chave='rafael.souza@make.com.br';
        controller.PesquisarCliente();
        controller.Nivel_1='Casos abertos pelo CD';
        controller.Nivel_2='Produto devolvido ao CD';
        controller.isTest=true;
        controller.CriarCaso();
        test.stopTest();         
     }
    
    static testMethod void testaPesquisaGemco() {
        Test.setMock(WebServiceMock.class, new MockServiceFindClienteCodigoGemco());
        clsPesquisaCliente cl = new clsPesquisaCliente();
        cl.getTipoChave();
        cl.Nivel_1='Casos abertos pelo CD';
        cl.updateNivel_2();
        Pagereference testePage = Page.PesquisaCliente;
        Test.setCurrentPage(testePage);
        clsPesquisaCliente controller = new clsPesquisaCliente();
        controller.tpChave='4';
        controller.Chave='21857647228036';
        test.startTest();
        controller.PesquisarCliente();
        controller.Nivel_1='Casos abertos pelo CD';
        controller.Nivel_2='Produto devolvido ao CD';
        controller.isTest=true;
        controller.CriarCaso();
        test.stopTest();         
     }

}
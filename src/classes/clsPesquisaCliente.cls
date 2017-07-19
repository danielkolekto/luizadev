public class clsPesquisaCliente {
    public String tpChave {get;set;}
    public String Chave {get;set;}
    public String id {get;set;}
    public String MsgError {get;set;}
    public String Nivel_1 {get;set;}
    public String Nivel_2 {get;set;}
    public Integer MostrarTab {get;set;}
    public Integer MostrarCliente {get;set;}
    public Integer MostrarBotaoPesq {get;set;}
    public Integer MostrarBotaoNext {get;set;}
    public String ParentCaseID {get;set;}
    public Boolean isTest {get;set;}
    public List<SelectOption> Nivel_2_Novo {get; set;}  
    public clsSincronizarMagazine.Cliente cli {get;set;}
    public Integer error {get;set;}
    private final Case csAtualizar;
    
    public clsPesquisaCliente(ApexPages.StandardController controller){
        MostrarTab = 1;
        MostrarCliente = 0;
        MostrarBotaoPesq = 1;
        MostrarBotaoNext = 1;
        MsgError = '';
        Nivel_2_Novo = new List<SelectOption>();
        cli = new clsSincronizarMagazine.Cliente();
        isTest = false;
        error = 0;
        id = ApexPages.currentPage().getParameters().get('id');
        ParentCaseID = ApexPages.currentPage().getParameters().get('ParentCaseID');
        
        if(id != ''){
            this.csAtualizar = (Case)controller.getRecord();
        }
    }
    
    public clsPesquisaCliente(){
        MostrarTab = 1;
        MostrarCliente = 0;
        MostrarBotaoPesq = 1;
        MostrarBotaoNext = 1;
        MsgError = '';
        isTest = false;
        cli = new clsSincronizarMagazine.Cliente();
        error = 0;
        this.csAtualizar = new Case();
    }
    
    public String CriaContato(clsSincronizarMagazine.Cliente cli){
        clsMetodosuteis cls = new clsMetodosuteis();
        String IDCont = '';
        String nome = Util.getString( cli.nome ).equals( '' ) ? cli.empresaTrab.razaoSocial : cli.nome;
        String cpf_cnpj = cli.CPF != null ? cli.CPF : cli.empresaTrab.cnpj;

        Contact cont = new Contact();
        cont.Firstname = Util.getFirstName( nome );
        cont.Lastname = Util.getLastName( nome );        
        cont.CPF_CNPJ__c = cls.formataCPFCNPJ(cpf_cnpj);
        cont.Email = cli.email;
        
        Account conta = [SELECT Id FROM Account WHERE Name LIKE '%Samsung%'];
        cont.AccountId = conta.id;
        
        if(cli.telefoneCelular != null){
            cont.MobilePhone = '(' + cli.telefoneCelular.codigoArea + ')' + cli.telefoneCelular.fone;
        }
        if(cli.telefoneComercial != null){
            cont.Phone = '(' + cli.telefoneComercial.codigoArea + ')' + cli.telefoneComercial.fone;
        }
        if(cli.telefonePrincipal != null){
            cont.HomePhone = '(' + cli.telefonePrincipal.codigoArea + ')' + cli.telefonePrincipal.fone;
        }
        
        cont.MailingPostalCode = cli.CEP;
        cont.MailingStreet = cli.endereco +( cli.numero != '' ? ', ' + cli.numero : '') + ( cli.bairro != '' ? ' - ' + cli.bairro : '');
        cont.MailingCountry = 'Brazil';
        cont.MailingCity = cli.cidade;

        cont.MailingState = cls.RetornaEstado(cli.estado);
        cont.MailingComplement__c = cli.complemento;
        cont.Gender__c = (cli.sexo == 'M' ? 'Masculino' : 'Feminino');
        cont.Birthdate = Date.valueOf(cli.dataNascimento);
        cont.DateLastUpdate__c = System.now();
        //String CPFFormat = cls.formataCPFCNPJ(cli.CPF);
        //cont.CPF_CNPJ__c = (cont.CPF_CNPJ__c == '' ? cli.CPF : cont.CPF_CNPJ__c);
        
        upsert cont CPF_CNPJ__c;
        IdCont = cont.Id;
        return IdCont;
    }
    
    public String CriaPedido(clsSincronizarMagazine.pedido objPed, String objContato){
        Order Pedido = new Order();
        Account conta = [SELECT Id FROM Account WHERE Name LIKE '%Samsung%'];
        pedido.AccountId = conta.Id;
        pedido.Date_of_Purchase__c = objPed.data;
        pedido.Date_Delivery__c = objPed.dataEntrega;
        pedido.Payment__c = objped.condicaoPagamento;
        pedido.OrderContact__c = objContato;
        pedido.ShippingStreet__c = objPed.EnderecoEntrega;
        pedido.ShippingCity__c = objPed.EnderecoEntrega;
        pedido.ShippingCountry__c = objPed.paisEnderecoEntrega;
        pedido.ShippingState__c = objPed.estadoEnderecoEntrega;
        pedido.ShippingPostalCode__c = objped.CEPEnderecoEntrega;
        pedido.Sale_Processing_Date__c = objped.dataFaturamento;
        pedido.EffectiveDate = Date.today();
        pedido.Status = 'Draft';
        pedido.Number_of_Order__c = objped.id;
        upsert pedido Number_of_Order__c;
        return  Pedido.id;
    }
    
    public string CriaProduto(clsSincronizarMagazine.ItemPedido ip, String objPedido,String objPedidoGemco){
        if( ip.Id != null ) {
            Order_Item__c objOrderItem = new Order_Item__c();
            objOrderItem.Color__c = ip.Itemproduto.cor;
            objOrderItem.Description__c = ip.Itemproduto.descricao;
            objOrderItem.AccountProvider__c = ip.Itemproduto.CNPJFornecedor;
            objOrderItem.Quantity__c = ip.quantidadeSolicitada;
            objOrderItem.Setor__c = ip.Itemproduto.Grupo;
            objOrderItem.Value__c = ip.precoUnitarioLiquido;
            objOrderItem.IdItem__c = String.valueof(ip.id);
            objOrderItem.Name = String.valueof(ip.id);
            objOrderItem.Order__c = objPedido;
            System.debug('O retorno do id Item: ' +  String.valueof(ip.id));
            if(objPedidoGemco != ''){
                objOrderItem.OrderGemco__c = objPedidoGemco;
            }
            
            upsert objOrderItem IdItem__c;
            return objOrderItem.id;
            //objOrderItem.Voltage__c=ip.Itemproduto.cor;
        }    
        return null;        
    }
    
    public String CriaPedidoGemco(clsSincronizarMagazine.PedidoGemco Pg,String objPedido,String objContato){
        Order_Gemco__c og = new Order_Gemco__c();
        
        if(pg.id != null){
            
            if(pg.notaFiscalSaida != null){
                og.Invoice__c = Integer.valueOf(pg.notaFiscalSaida.id);
            }
            
            og.Numero_do_Pedido__c = objpedido;
            og.SLIP__c = pg.IdSlip;
            og.Status_Order__c = pg.StatusSlip;
            og.IDPedidoGemco__c = pg.id;
            upsert og IDPedidoGemco__c;
            return og.Id;
        }
        
        return null;
    }
    //AQUI
    public Pagereference CriarCaso(){
        Pagereference reference;
        String IDContato = '';
        List<String> ARIdPedido = new List<String>();
        List<String> ARIdItem = new List<String>();
        List<String> ARIdPedidoGemco = new List<String>();
        
        List<String> ARStrIDPedido = new List<String>();
        List<String> ARStrPedidoGemco = new List<String>();
        String PedidoGemco = '';
        String NF = '';
        String SLIP = '';
        String dataCompra = '';
        String dataCompraURL = '';
		String numeroPedidoControle = '';
        
        System.debug('o Valor do nivel__1: ' + Nivel_1 );
        System.debug('o Valor do Nivel_2: ' + Nivel_2 );
        
        if(Nivel_2 == '0' || Nivel_1 == '0'){
            cli.codRetorno = '1';
            error = 1;
            cli.Mensagem = 'Selecione o primeiro e o segundo nivel para que possa ser criado o caso';
            return reference;
        }
        
       //Procura o tipo de registro atrelado ao caso para criar o caso e abrir o layout correto de caso:
        Case_Configuration__c cf = [SELECT      Register_Type__c,
                                    			Workflow__c
                                    FROM        Case_Configuration__c 
                                    WHERE Level_1__c = :Nivel_1
                                    AND Level_2__c = :Nivel_2];
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE name = :cf.Register_Type__c AND SobjectType = 'Case'];
        //Verifica se houve seleçã	o de um registro de pedido e afins para criar o contato e os pedidos:
        
        //IDContato = (IDContato == '' ? CriaContato(cli) : IDContato);

        if(cli.pedido != null){
            
            for(clsSincronizarMagazine.pedido ped : cli.pedido){
                String strPedido = '';
                String strIdPedido = '';
                dataCompra = String.valueOf(ped.data);
                dataCompraURL = (ped.data.day() < 10 ? '0' + ped.data.day() : String.valueOf(ped.data.day())) + '/';
                dataCompraURL += (ped.data.month() < 10 ? '0' + ped.data.month() : String.valueOf(ped.data.month())) + '/';
                dataCompraURL += String.valueOf(ped.data.year());
                numeroPedidoControle = String.valueOf(ped.id);
                
                if(ped.Selected == true || isTest == true){
                    //Cria o contato e o pedido do contato
                    IDContato = (IDContato == '' ? CriaContato(cli) : IDContato);
                    //Cria os pedidos para o contato
                    
                    if(IDContato != ''){
                        strPedido = CriaPedido(Ped,IDContato);
                        ARIdPedido.add(strPedido);
                        ARStrIDPedido.add(numeroPedidoControle);
                    }
                }
                
                for (clsSincronizarMagazine.ItemPedido prod : ped.itens) {
                    String strItempedido = '';
                    String strPedidoGemco = '';
                    String strIdPedidoGemco = '';
                    
                    if (prod.selected == true || ped.selected == true || isTest == true){
                        //Cria o contato e o pedido do contato
                        IDContato = (IDContato == '' ? CriaContato(cli) : IDContato);
                        /*if(IDContato==''){
IDContato=CriaContato(cli);
}*/
                        if(IDContato != ''){
                            
                            if(strPedido == ''){
                                strPedido = CriaPedido(Ped,IDContato);
                                //strIdPedido = ped.id;
                                strIdPedido = numeroPedidoControle;
                                ARIdPedido.add(strPedido);
                                ARStrIDPedido.add(strIdPedido);
                            }
                            system.debug('prod.pedidoGemcoItem: ' + prod.pedidoGemcoItem);
                            if(prod.pedidoGemcoItem != null){
                                strPedidoGemco=CriaPedidoGemco(prod.pedidoGemcoItem,strPedido,IDContato);
                                ARIdPedidoGemco.add(strPedidoGemco);
                                strIdPedidoGemco=prod.pedidoGemcoItem.id;
                                ARStrPedidoGemco.add(strIdPedidoGemco);
                                if (prod.pedidoGemcoItem.notaFiscalSaida != null){
                                	NF = (prod.pedidoGemcoItem.notaFiscalSaida.id != null ? String.valueOf(prod.pedidoGemcoItem.notaFiscalSaida.id) : '');
                                }
                                
                            }
                            strItempedido=CriaProduto(prod,strPedido,strPedidoGemco);
                            PedidoGemco = (prod.pedidoGemcoItem!=null?prod.pedidoGemcoItem.id:'');
                            SLIP =(prod.IdSlip!=null?String.valueof(prod.IdSlip):'');
                            System.debug('O valor do Id produto é: ' + strItempedido);
                            if( strItempedido != null )
                                ARIdItem.add(strItempedido);
                        }
                    }
                }
            }
        }
        
        //Cria o caso atrelando os pedidos e afins selecionados na pagina e retorna 
        Case caso = new Case();
        /*
        Mapa dos campos:
		00Nj0000008zq8N = Level_1__c
		00Nj0000008zq8O = Level_2__c
		00Nj0000008zq8i = Order__c
		00Nm0000000kDrQ = Pedido_Admsite__c
		00Nj0000008zq8A = DatePurchase__c
		00Nj0000008zq8h = Order_Gemco__c
		00Nm0000000kDrV = Pedido_Gemco__c
		00Nj0000008zq97 = SlipText__c
		00Nj0000008zq8L = InvoiceText__c
        00Nm0000000knyH = CodigoIdentificador__c
        
		Mapa de Campos Produção:
		00Nj0000008zq8N = Level_1__c
		00Nj0000008zq8O = Level_2__c
		00Nj0000008zq8i = Order__c
		
		00Nj0000009Ixpy = Pedido_Admsite__c
		
		00Nj0000008zq8A = DatePurchase__c
		00Nj0000008zq8h = Order_Gemco__c
		
		00Nj0000009Ixq8 = Pedido_Gemco__c
		
		00Nj0000008zq97 = SlipText__c
		00Nj0000008zq8L = InvoiceText__c
		00Nj0000009fKow = CodigoIdentificador__c
		*/
        if(csAtualizar.Id != null){
            caso.id = csAtualizar.id;
            caso.Origin = csAtualizar.Origin;
        }
        
        caso.RecordTypeId = rt.id;
        
        if(IDContato != ''){
            caso.ContactId = IDContato;
        }
        
        System.debug('nivel 1 : ' + nivel_1);
        System.debug('nivel 2 : ' + nivel_2);
        System.debug('Tipo de registro : ' + cf.Register_Type__c);
        
        caso.Level_1__c = nivel_1;
        caso.Level_2__c = nivel_2;
        caso.Origin = (caso.Origin == 'E-Mail (S/Tratativa)' || caso.Origin == 'E-Mail' ? 'E-mail' : 'Telefone');
        String strOrigin = (caso.Origin == 'E-Mail (S/Tratativa)' || caso.Origin == 'E-Mail' ? 'E-mail' : 'Telefone');
        
        if(ARIdPedido.size() > 0){
            caso.Order__c = ARIdPedido[0];
            caso.Pedido_Admsite__c = ARStrIDPedido[0];
        }
        if(dataCompra != ''){
            caso.DatePurchase__c = Date.valueOf(dataCompra);
        }
        if(ARIdPedidoGemco.size() > 0){
            System.debug('O valor do Array é: ' + ARIdPedidoGemco[0]);
            
            if(ARIdPedidoGemco[0] != null){
                caso.Order_Gemco__c = ARIdPedidoGemco[0];
                caso.Pedido_Gemco__c = ARStrPedidoGemco[0];
                //Atualiza as informações de Nota fiscal e slip
                Order_Gemco__c og = [SELECT id,SLIP__c,Invoice__c FROM Order_Gemco__c WHERE id = :ARIdPedidoGemco[0]];
                //caso.Sliptext__c=String.valueof(og.SLIP__c);
                //caso.Invoicetext__c=String.valueof(og.Invoice__c);
            }
        }
        
        caso.SlipText__c = SLIP;
        caso.Invoicetext__c = NF;
        
        //caso.Slip__c=double.valueOf(SLIP);
        //caso.Invoice__c=double.valueOf(NF);
        caso.Pedido_Gemco__c = PedidoGemco;
        caso.status = (cf.Workflow__c == false ? 'Fechado' : 'Novo');
        String strStatus = (cf.Workflow__c == false ? 'Fechado' : 'Novo');
        //String retURL = (csAtualizar.Id!=null ? '/'+caso.id+'/e?retURL=' + caso.id : '/500/e?retURL=/500/o&RecordType='+rt.id+'&ent=Case'); 
        String retURL = '';
        
        String codigoIDProd = clsMetodosUteis.gerarStringRandomica(10);
        
        system.debug('StringRand: ' + codigoIDProd);
        
        if(csAtualizar.Id != null){
            upsert(caso);
            retURL = '/' + caso.id + '/e?retURL=' + caso.id;
            
        }
        else{
            String idCasoPai = (ApexPages.currentPage().getParameters().get('idCasoPai') != null ? ApexPages.currentPage().getParameters().get('idCasoPai') : '');
            String numCasoPai = (ApexPages.currentPage().getParameters().get('numeroCasoPai') != null ? ApexPages.currentPage().getParameters().get('numeroCasoPai') : '');
            
            system.debug('codigoIDProd_val: ' + codigoIDProd);
            
            retURL = '/500/e?retURL=/apex/PesquisaCliente&RecordType=' + rt.id + '&ent=Case&cas3_lkid='+IDContato+'&cas3_lkold='+IDContato;
            retURL += '&cas7=' + strStatus + '&cas11=' + strOrigin + '&00Nj0000008zq8N=' + caso.Level_1__c + '&00Nj0000008zq8O=' + caso.Level_2__c;
            retURL += '&00Nj0000008zq8i=' + caso.Order__c + '&00Nj0000009Ixpy=' + caso.Pedido_Admsite__c + '&00Nj0000008zq8A=' + dataCompraURL + '&00Nj0000008zq8h=' + caso.Order_Gemco__c;
            retURL += '&00Nj0000009Ixq8=' + caso.Pedido_Gemco__c + '&00Nj0000008zq97=' + caso.SlipText__c + '&00Nj0000008zq8L=' + caso.InvoiceText__c + '&00Nj0000009fKow=' + codigoIDProd;
            retURL += '&cas28_lkid=' + idCasoPai + '&cas28=' + numCasoPai;
        }  
          //Vincula os produtos ao caso
        List<ItemCaso__c> arIC = new list<itemCaso__c>();
        
        system.debug('Contagem ARIdItem: ' + ARIdItem.size());
        
        for(String str : ARIdItem){
            ItemCaso__c ic = new ItemCaso__c();
            //ic.Caso__c = caso.id;
            ic.Item_Pedido__c = str;
            ic.CodigoIdentificador__c = codigoIDProd;
            arIC.add(ic);
        }
        
        if(arIC.size() > 0){
            insert arIC;
        }
        
        reference = new Pagereference(retURL);
        return reference;
        
    }
    
    public Pagereference PesquisarCliente(){
        Nivel_1 = '';
        Nivel_2 = '';
        Nivel_2_Novo = new List<SelectOption>();
        
        String idCasoPai = (ApexPages.currentPage().getParameters().get('idCasoPai') != null ? ApexPages.currentPage().getParameters().get('idCasoPai') : '');
        String numCasoPai = (ApexPages.currentPage().getParameters().get('numeroCasoPai') != null ? ApexPages.currentPage().getParameters().get('numeroCasoPai') : '');
        
        
        
        Pagereference reference = new PageReference('/apex/PesquisaCliente?idCasoPai=' + idCasoPai + '&numeroCasoPai=' + numCasoPai);
        clsMetodosUteis Util = new clsMetodosUteis();
        Boolean validarDados = true;
        
        if(tpChave == '1'){
            validarDados = util.validaCpfCnpj(Chave);
            
            if(validarDados == false){
                MsgError = 'CPF / CNPJ Invalidos';
                cli.codRetorno = '1';
                error = 1;
                MostrarTab = 0;
                MostrarCliente = 0;
                MostrarBotaoNext = 1;
                MostrarBotaoPesq = 1;
                cli.Mensagem = MsgError;
                return reference;
            }
        }
        else if (tpChave == '2'){
            
            validarDados = util.ValidarEmail(Chave);
            
            if(validarDados == false){
                MsgError = 'Informe um Email validado';
                cli.codRetorno = '1';
                error = 1;
                cli.Mensagem = MsgError;
                return reference;
            }
        }
        /*
Chama a pagina de sincronização para criar o cliente e os pedidos dele
*/
        //try{
        clsSincronizarMagazine Sinc = new clsSincronizarMagazine();
        cli = new clsSincronizarMagazine.Cliente();
        cli = Sinc.RetornoCliente(tpChave, Chave);
        
        if(Integer.valueOf(Cli.CodRetorno) > 0){
            MsgError = 'Houve erro na chamada entre os sistemas: ';
            MsgError += ' ' + Cli.Mensagem;
            MostrarTab = 1;
            MostrarCliente = 0;
            MostrarBotaoNext = 1;
            MostrarBotaoPesq = 1;
            error = 1;
        }
        else{
            MsgError = 'Comunicação realizada com sucesso';
            MostrarTab = 1;
            MostrarCliente = 1;
            MostrarBotaoNext = 1;
            MostrarBotaoPesq = 0;
            error = 0;
        }
        
        //reference = new PageReference('/' + id);
        //}
        
        /*catch(Exception ex){
MsgError=' Houve um erro na chamada : ' + Ex.getMessage();
cli.codRetorno='1';
cli.Mensagem=MsgError;
MostrarTab=1;
MostrarCliente=0;
MostrarBotaoNext=1;
MostrarBotaoPesq=1;
error=1;
}*/
        
        //Envia email do erro:
        // Contact[] con = [SELECT ID FROM CONTACT WHERE NAME LIKE '%ADM Magazine%'];           
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'leonardo@beecloud.com.br'};                        
            //email.setTargetObjectId(con[0].id);
        String subject = 'Erro web-service Magazine';
        email.setCharset('UTF-8');
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody(MsgError + ' ' + ' O tipo de chave foi: ' + tpChave + ' A chave foi: ' + Chave);
        //email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        
        if(cli.codRetorno != '0'){
            Contact[] con = [SELECT Id FROM Contact WHERE Name LIKE '%ADM Magazine%'];
            email.setTargetObjectId(con[0].id);
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }

        return reference;
    }
    
    //Carrega tipos de chave
    public List<selectOption> getTipoChave() {
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('0', '--Selecione--'));
        options.add(new selectOption('1', 'CPF / CNPJ'));
        options.add(new selectOption('2', 'Email'));
        options.add(new selectOption('3', 'Número do Pedido ADM Site'));
        options.add(new selectOption('4', 'Número do Pedido ADM GEMCO'));
        return options;
    }
    
    //Carrega o Nivel_1
    public List<selectOption> getDDLNivel_1() {
        //Captura os tipos de niveis de acordo com o tipo de registro:
        AggregateResult[] groupedResults = [SELECT      Level_1__c 
                                            FROM        Case_Configuration__c 
                                            GROUP BY Level_1__c ORDER BY Level_1__c];
        
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('0', '--Selecione--'));
        
        for (AggregateResult ar : groupedResults)  {
            String Nivel_1 = String.valueOf(ar.get('Level_1__c'));
            //String TipoRegistro=String.valueof(ar.get('Register_Type__c'));
            options.add(new selectOption(Nivel_1, Nivel_1));
        }
        return options;
    }
    
    //Carrega o Nivel_2
    public List<selectOption> getDDLNivel_2() {
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('0', '--Selecione--'));
        return options;
    }
    
    public void updateNivel_2() {
        Nivel_2_Novo = new List<SelectOption>();
        
        //Captura os tipos de niveis de acordo com o tipo de registro:
        AggregateResult[] groupedResults = [SELECT      Level_2__c,workflow__c 
                                            FROM        Case_Configuration__c 
                                            WHERE   Level_1__c = :Nivel_1
                                            GROUP BY Level_2__c, workflow__c ORDER BY Level_2__c];
        
        //List<selectOption> options = new List<selectOption>(); 
        //options.add(new selectOption('0', '--Selecione--'));
        system.debug('O valor do nivel 1 é: ' + Nivel_1);
        
        Nivel_2_Novo.add(new selectOption('0', '--Selecione--'));
        
        for (AggregateResult ar : groupedResults)  {
            String Nivel_2 = String.valueOf(ar.get('Level_2__c'));
            String workflow = String.valueOf(ar.get('workflow__c'));
            
            System.debug('O retorno do cliente é: ' + cli.CodRetorno );
            System.debug('O Valor do Workflow é: ' + workflow );
            
            if(cli.CodRetorno == '0' && workflow == 'true'){
                Nivel_2_Novo.add(new selectOption(Nivel_2, Nivel_2));
            }
            else if(workflow == 'false'){
                Nivel_2_Novo.add(new selectOption(Nivel_2, Nivel_2));
            }
        }
        //return options;
    }
}
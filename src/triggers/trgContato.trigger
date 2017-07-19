trigger trgContato on Contact (before insert,before update)
{   
    AtivacaoApex__c settings = AtivacaoApex__c.getInstance();
    clsMetodosUteis util = new clsMetodosUteis();
    if( settings.Ativo__c==false)
    {
        for (Contact contato : Trigger.new)
        {    	
            if(contato.cpf_cnpj__C != null && contato.cpf_cnpj__C!='')
            {
                String msgError='';
                system.debug('validar CPF');
                String sCpf = contato.cpf_cnpj__C;
                sCpf=sCpf.replace('.','');
                sCpf=sCpf.replace('-','');
                sCpf=sCpf.replace('/','');
                if( util.validaCpfCnpj(contato.cpf_cnpj__C) == false )
                {
                    MsgError = ((sCpf.length() <= 11 ) && MsgError==''  ? 'Informe um CPF válido' : MsgError);
                    MsgError = ((sCpf.length() > 11 ) && MsgError==''  ? 'Informe um CNPJ válido': MsgError);
                    contato.addError(MsgError);
                    return;
                }
                
                
                string sCpfOK='';
                
                if(sCpf.length() == 11){
                    String  parte1 = sCpf.Substring(0,3), parte2 = sCpf.Substring(3,6), parte3 = sCpf.Substring(6,9),
                        parte4 = sCpf.Substring(9,11);
                    sCpfOK = parte1 + '.' + parte2 + '.' + parte3 + '-' + parte4;
                }
                else if(sCpf.length() == 14){
                    
                    string  parte1 = sCpf.Substring(0,2), parte2 = sCpf.Substring(2,5), parte3 = sCpf.Substring(5,8),
                        parte4 = sCpf.Substring(8,12), parte5 = sCpf.Substring(12,14);
                    sCpfOK = parte1 + '.' + parte2 + '.' + parte3 + '/' + parte4 + '-' + parte5;
                    
                }
                
                
                
                contato.cpf_cnpj__C=sCpfOK;
            }
        }
    }
}
public with sharing class clsMetodosUteis
{
	// --- Construtor
	public clsMetodosuteis() { }
	// -- Construtor
    public static void AtualizaProprietariosCaseResolution(List<CaseResolution__c> CR,String UserID,String Area,String strStatus){if(CR.size()>0){Datetime dt = System.Datetime.now();List<CaseResolution__c> UPDResolucao = new List<CaseResolution__c>();for(CaseResolution__c objCR : Cr){if(objCR.Formulario_Preenchido__c==false && objCR.Status_Resolucao__c!='Fechado' ){objCR.OwnerId=Userid;objCR.Area_solucionadora__c=Area;objCR.Status_Resolucao__c=strStatus;objCR.data_de_inicio__c=(objCR.data_de_inicio__c==null && strStatus== 'Em tratativa' ? dt : objCR.data_de_inicio__c);UPDResolucao.add(objCR);}else if (objCR.Formulario_Preenchido__c==true && objCR.Status_Resolucao__c!='Fechado') {objCR.Status_Resolucao__c='Fechado';UPDResolucao.add(objCR);}}if(UPDResolucao.size()>0){update UPDResolucao; }}}
    public static void AtualizaProprietariosTask(List<Task> tarefa,String UserID,String Area,String strStatus){if(tarefa.size()>0){List<Task> UPDTarefa = new List<Task>();Datetime dt = System.Datetime.now();for(Task objTask : tarefa){String assunto=objTask.Subject;if(objTask.Tarefa_Respondida__c==false && objTask.Status !='Concluído' && assunto.indexOf('Anexar')<=0){objTask.OwnerId=(strStatus== 'Em tratativa' ? UserID : '005j000000C0QIy');objTask.Area_solucionadora__c=Area;objTask.Status_Tarefa__c=strStatus;objTask.data_de_inicio__c=(objTask.data_de_inicio__c==null && strStatus== 'Em tratativa' ? dt : objTask.data_de_inicio__c);UPDTarefa.add(objTask);}else if (objTask.Tarefa_Respondida__c==true && objTask.Status !='Concluído') {objTask.Status='Concluído';objTask.Status_Tarefa__c='Fechado';UPDTarefa.add(objTask);}}if(UPDTarefa.size()>0){update UPDTarefa;}}}
	public static String gerarStringRandomica(Integer len) {final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz#$%!';String randStr = '';while (randStr.length() < len) {Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());randStr += chars.substring(idx, idx+1);}return randStr; }
	public String RetornaEstado(String UF){String Estado='';if(UF=='') return Estado;UF = UF.substring(0,2);if(UF=='AC'){Estado='Acre';}else if(UF=='AL'){Estado='Alagoas';}else if(UF=='AP'){Estado='Amapá';}else if(UF=='AM'){Estado='Amazonas';}else if(UF=='BA'){Estado='Bahia';}else if(UF=='CE'){Estado='Ceará';}else if(UF=='DF'){Estado='Distrito Federal';}else if(UF=='ES'){Estado='Espírito Santo';}else if(UF=='GO'){Estado='Goiás';}else if(UF=='MA'){Estado='Maranhão';}else if(UF=='MT'){Estado='Mato Grosso';}else if(UF=='MS'){Estado='Mato Grosso do Sul';}else if(UF=='MG'){Estado='Minas Gerais';}else if(UF=='PA'){Estado='Pará';}else if(UF=='PB'){Estado='Paraíba';}else if(UF=='PR'){Estado='Paraná';}else if(UF=='PE'){Estado='Pernambuco';}else if(UF=='PI'){Estado='Piauí';}else if(UF=='RJ'){Estado='Rio de Janeiro';}else if(UF=='RN'){Estado='Rio Grande do Norte';}else if(UF=='RS'){Estado='Rio Grande do Sul';}else if(UF=='RO'){Estado='Rondônia';}else if(UF=='RR'){Estado='Roraima';}else if(UF=='SC'){Estado='Santa Catarina';}else if(UF=='SP'){Estado='São Paulo';}else if(UF=='SE'){Estado='Sergipe';}else if(UF=='TO'){Estado='Tocantins';}return Estado;}
	public static String RetornaDiaUtil(Integer qtd_dia ){String dtNovo = '';Integer total_FDS = 0;Integer total = 0;List<Holiday> lstFeriados=[Select ActivityDate From Holiday];for(Integer i = 1;i <= qtd_dia;i++){dtNovo = String.valueOf(System.now().addDays(i));Datetime Date2 = Datetime.valueof(dtNovo);Datetime Date1 = Datetime.valueOf('1900-01-07 00:00:00');Integer rest = Integer.valueOf((Date2.getTime() - Date1.getTime())/(1000*60*60*24));Integer Mod = math.mod(rest , 7);if(mod == 0){qtd_dia = qtd_dia + 1;continue;}try{system.debug('Data do feriado é: ' + string.valueOf(Date.valueOf(dtNovo)));for(Integer count=0;count<lstFeriados.size();count++){if( string.valueOf(Date.valueOf(dtNovo)) == string.valueOf(Date.valueOf(lstFeriados[count].ActivityDate)) ){qtd_dia = qtd_dia + 1;continue;}}}catch(Exception e){system.debug('Erro no feriado: ' + e.getMessage());}}  return dtNovo;}
    Public String RemoverAcentos (String str){  str = str.replaceAll('[ÂÀÁÄÃ]','A');  str = str.replaceAll('[âãàáä]','a');  str = str.replaceAll('[ÊÈÉË]','E');  str = str.replaceAll('[êèéë]','e');  str = str.replaceAll('ÎÍÌÏ','I');  str = str.replaceAll('îíìï','i');  str = str.replaceAll('[ÔÕÒÓÖ]','O');  str = str.replaceAll('[ôõòóö]','o');  str = str.replaceAll('[ÛÙÚÜ]','U');  str = str.replaceAll('[ûúùü]','u');  str = str.replaceAll('Ç','C');  str = str.replaceAll('ç','c');   str = str.replaceAll('[ýÿ]','y');  str = str.replaceAll('Ý','Y');  str = str.replaceAll('ñ','n');  str = str.replaceAll('Ñ','N');  return str;  }
	public static String RetornaDiaUtil(Integer qtd_dia,Datetime dt ){String dtNovo = '';Integer total_FDS = 0;Integer total = 0;Datetime dataI = dt;List<Holiday> lstFeriados=[Select ActivityDate From Holiday];for(Integer i = 1;i <= qtd_dia;i++){dataI = dataI.addDays(1);dtNovo = String.valueOf(dataI);Datetime Date2 = Datetime.valueof(dtNovo);Datetime Date1 = Datetime.valueOf('1900-01-07 00:00:00');Integer rest = Integer.valueOf((Date2.getTime() - Date1.getTime())/(1000*60*60*24));Integer Mod = math.mod(rest , 7);if(mod == 0){qtd_dia = qtd_dia + 1;System.debug('A quantidade de dias é: ' + String.valueOf(qtd_dia));continue;}try{system.debug('Data do feriado é: ' + string.valueOf(Date.valueOf(dtNovo)));for(Integer count=0;count<lstFeriados.size();count++){if( string.valueOf(Date.valueOf(dtNovo)) == string.valueOf(Date.valueOf(lstFeriados[count].ActivityDate)) ){qtd_dia = qtd_dia + 1;continue;}}}catch(Exception e){system.debug('Erro no feriado: ' + e.getMessage());}}return dtNovo;}
    public String formataCPFCNPJ(String sCpf){string sCpfOK='';sCpf = sCpf.trim();System.debug('O tamanho do cpf é: ' + sCpf.length());if(sCpf.length() == 11){String  parte1 = sCpf.Substring(0,3), parte2 = sCpf.Substring(3,6), parte3 = sCpf.Substring(6,9),parte4 = sCpf.Substring(9,11);sCpfOK = parte1 + '.' + parte2 + '.' + parte3 + '-' + parte4;}else if(sCpf.length() == 14){string  parte1 = sCpf.Substring(0,2), parte2 = sCpf.Substring(2,5), parte3 = sCpf.Substring(5,8),parte4 = sCpf.Substring(8,12), parte5 = sCpf.Substring(12,14);sCpfOK = parte1 + '.' + parte2 + '.' + parte3 + '/' + parte4 + '-' + parte5;}return sCpfOK;}
    public  Boolean ValidarEmail(String strEmail){strEmail = strEmail.toLowerCase();Boolean Validado = true;if(strEmail != null && strEmail.trim() != ''){String ER_Email = '[a-zA-Z0-9]+[a-zA-Z0-9_.-]+@{1}[a-zA-Z0-9_.-]*\\.+[a-z]{2,4}';Pattern EmailPattern = Pattern.compile(ER_Email);Matcher EmailMatcher = EmailPattern.matcher(strEmail);if (!EmailMatcher.matches()){Validado = false;}}else{Validado = false;}return validado;}
	public Boolean validaCpfCnpj(String sCpfCnpj){Boolean isValido;if(sCpfCnpj==null)return false;if(	sCpfCnpj.trim()=='' || sCpfCnpj.length() < 11 )return false;sCpfCnpj = sCpfCnpj.replace('.','');sCpfCnpj = sCpfCnpj.replace('-','');sCpfCnpj = sCpfCnpj.replace('/','');sCpfCnpj = sCpfCnpj.replace(' ','');if((sCpfCnpj.length() < 11) ){return false;}else if((sCpfCnpj.length() > 11 ) && (sCpfCnpj.length() < 14 ) ){return false;}if(sCpfCnpj.length() < 11){return false;}if(sCpfCnpj.length() == 11)isValido=validaCpf(sCpfCnpj);else if(sCpfCnpj.length() == 14)isValido=validaCnpj(sCpfCnpj);system.debug('Valido= ' + string.valueOf(isValido) + '; Tamanho= ' + string.valueOf(sCpfCnpj.length()));return isValido;}
	
    public String ajustaTelefone(String telefone){String telefoneFormatado = telefone, ddd = '', parte1 = '', parte2 = '';if(telefoneFormatado==null)telefoneFormatado='';telefoneFormatado = telefoneFormatado.replace('.','');telefoneFormatado = telefoneFormatado.replace('/','');telefoneFormatado = telefoneFormatado.replace('-','');telefoneFormatado = telefoneFormatado.replace('(','');telefoneFormatado = telefoneFormatado.replace(')','');telefoneFormatado = telefoneFormatado.replace(' ','');telefoneFormatado = telefoneFormatado.replace('+','');Integer numeroDigitos = telefoneFormatado.Length();if(numeroDigitos == 8){parte1 = telefoneFormatado.Substring(0,4);parte2 = telefoneFormatado.Substring(4,8);telefoneFormatado = parte1 + '-' + parte2;}else if(numeroDigitos == 9){parte1 = telefoneFormatado.Substring(0,5);parte2 = telefoneFormatado.Substring(5,9);telefoneFormatado = parte1 + '-' + parte2;}else if(numeroDigitos == 10){ddd = telefoneFormatado.Substring(0,2);parte1 = telefoneFormatado.Substring(2,6);parte2 = telefoneFormatado.Substring(6,10);telefoneFormatado = '(' + ddd + ')' + parte1 + '-' + parte2;}else if(numeroDigitos == 11){ddd = telefoneFormatado.Substring(0,2);parte1 = telefoneFormatado.Substring(2,7);parte2 = telefoneFormatado.Substring(7,11);telefoneFormatado = '(' + ddd + ')' + parte1 + '-' + parte2;}else{telefoneFormatado = telefone;}return telefoneFormatado;}
	
	private static Boolean validaCnpj(string vrCNPJ)
	{
		String CNPJ = vrCNPJ, ftmt='6543298765432';
		Integer[] digitos;
		Integer[] soma;
		Integer[] resultado;
		Integer nrDig;
		
		Boolean[] CNPJOk;
		
		digitos = new Integer[14];
		
		soma = new Integer[2];
		soma[0] = 0;
		soma[1] = 0;
		
		resultado = new Integer[2];
		resultado[0] = 0;
		resultado[1] = 0;
		
		CNPJOk = new Boolean[2];
		CNPJOk[0] = false;
		CNPJOk[1] = false;

		try
		{
			for ( nrDig = 0; nrDig < 14; nrDig++)
			{
				system.debug('Pos: ' + nrDig + ' Numero: ' + CNPJ.Substring(nrDig, nrDig+1));
				digitos[nrDig] = Integer.valueof(CNPJ.Substring(nrDig, nrDig+1));
				String num='';
				
				if (nrDig <= 11)
				{
					system.debug( 'Valor FMT menor que 11:' + ftmt.Substring(nrDig + 1, nrDig+2));
					
					if(ftmt.Substring(nrDig + 1, nrDig+2)=='' ||ftmt.Substring(nrDig + 1, nrDig+2)==null )num='0';
					else num=ftmt.Substring(nrDig + 1, nrDig+2);
					
					system.debug( 'Valor Num menor que 11:' + num);
					
					soma[0] += (digitos[nrDig] * Integer.valueof(num));
				}
				
				if (nrDig <= 12)
				{
					system.debug( 'Valor FMT menor que 12:' + ftmt.Substring(nrDig, nrDig+1));
					
					if(ftmt.Substring(nrDig, nrDig+1).trim()=='' ||ftmt.Substring(nrDig, nrDig+1)==null )num='0';
					else num=ftmt.Substring(nrDig, nrDig+1);
					
					system.debug( 'Valor Num menor que 12:' + num);
					
					soma[1] += (digitos[nrDig] * Integer.valueof(num));
				}
			}

			for ( nrDig = 0; nrDig < 2; nrDig++)
			{
				resultado[nrDig] = ( math.mod(soma[nrDig] , 11));

				if ((resultado[nrDig] == 0) || (resultado[nrDig] == 1))	 CNPJOk[nrDig] = (digitos[12 + nrDig] == 0);
				else CNPJOk[nrDig] = (digitos[12 + nrDig] == (11 - resultado[nrDig]));
			}

			return (CNPJOk[0] && CNPJOk[1]);
		}
		catch(Exception e)
		{
			system.debug(e);
			return false;
		}
	}
	
	/*
		Método: validaCpf
		Objetivo: Validar o CPF passado por param
		Autor: Matheus Apolonio
		Data: 30/12/2014
	*/
	private static Boolean validaCpf(String vrCPF)
	{
		if(vrCPF=='00000000000'){return false;}
		else if(vrCPF=='11111111111'){return false;}
		else if(vrCPF=='2222222222'){return false;}
		else if(vrCPF=='33333333333'){return false;}
		else if(vrCPF=='44444444444'){return false;}
		else if(vrCPF=='55555555555'){return false;}
		else if(vrCPF=='66666666666'){return false;}
		else if(vrCPF=='77777777777'){return false;}
		else if(vrCPF=='88888888888'){return false;}
		else if(vrCPF=='99999999999'){return false;}

		string valor = vrCPF;

		String[] arValor = new String[11];
		arValor[0]=valor.substring(0, 1);
		arValor[1]=valor.substring(1, 2);
		arValor[2]=valor.substring(2, 3);
		arValor[3]=valor.substring(3, 4);
		arValor[4]=valor.substring(4, 5);
		arValor[5]=valor.substring(5, 6);
		arValor[6]=valor.substring(6, 7);
		arValor[7]=valor.substring(7, 8);
		arValor[8]=valor.substring(8, 9);
		arValor[9]=valor.substring(9, 10);
		arValor[10]=valor.substring(10, 11);

		Integer[] numeros = new Integer[11];
		for (Integer i = 0; i < 11; i++){numeros[i] = Integer.valueOf(arValor[i]);}

		Integer soma = 0;
		for (Integer i = 0; i < 9; i++){soma += (10 - i) * numeros[i];}

		Integer resultado = math.mod(soma , 11);
		if (resultado == 1 || resultado == 0){if (numeros[9] != 0){system.debug('numeros[9] != 0');return false;}}
		else if (numeros[9] != 11 - resultado){system.debug('numeros[9] != 11 - resultado');return false;}

		soma = 0;

		for (Integer i = 0; i < 10; i++){soma += (11 - i) * numeros[i];}

		resultado = math.mod(soma , 11);
		if (resultado == 1 || resultado == 0){if (numeros[10] != 0){system.debug('numeros[10] != 0');return false;}}
		else{if (numeros[10] != 11 - resultado){system.debug('numeros[10] != 11 - resultado');return false;}}
		return true;
	}
}
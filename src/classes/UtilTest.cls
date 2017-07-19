@isTest
public class UtilTest {
	
	static testMethod void test_01(){
		Double doubleValue = 10.5;
		Decimal decimalValue = 10.5;
		
		Util.getId('');
		Util.getString('');
		Util.getDouble(doubleValue);
		Util.getDecimal(decimalValue);
		Util.getDecimal('10.5');
		Util.getBoolean('true');
		Util.getDate('');
		Util.getFirstName('Daniel Soares');
		Util.getLastName('Daniel Soares');
		Util.getISODatetime(Date.today());
		Util.getISODatetime(Datetime.now());
		Util.getCaseGibaStatus('Aguardando resposta do Lojista');
		Util.getAuthorType('seller');
		Util.jsonResponse('waiting_customer', '');
	}
	
}
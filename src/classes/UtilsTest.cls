@isTest
public class UtilsTest {
	
	static testMethod void shouldGetBaseUrl(){
        System.assert( URL.getCurrentRequestUrl().toExternalForm().contains( Utils.baseURL ) );
    }
    
    static testMethod void testGetResourceURL(){
        Utils.getResourceURL('JqueryUI');
    }
    
    static testMethod void getImageUrl(){
        Case cse=new Case();
        insert cse;
 
        Attachment attach=new Attachment();
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cse.id;
        Database.insert( attach);
        
       String aux =  Utils.getImageUrl(attach.Id);
        System.assert(String.isNotEmpty(aux));
    }

    static testMethod void deveLimparFormatacaoTel() {
        System.assertEquals('2112341234', Utils.limparFormatacaoTel('(21)1234-1234'));
    }
    
    static testMethod void deveLimparFormatacaoCpfCnpj() {
        System.assertEquals('68249355300', Utils.limparFormatacaoCpfCnpj('682.493.553-00'));
    }
    
    static testMethod void testLimparFormatacaoEspecial(){
        Utils.limparFormatacaoEspecial('04270-002');
    }
    
    static testMethod void deveLimparFormatacaoGeral() {
        System.assertEquals('teste de metodo na utils', Utils.limparFormatacaoGeral('(teste) [de]/ metodo- na {utils}.'));
    }
    
    static testMethod void testReplaceSpecialCharacters(){
        System.assertEquals('Anderson Pedro da Silva Xavier', Utils.replaceSpecialCharacters('Ândérson Pëdró dã Sílvä Xãviér'));
    }
    
    static testMethod void testCapitalize(){
        String aux = Utils.capitalize(null);
        String aux2 = Utils.capitalize('');
        String aux3 = Utils.capitalize('Teste Teste');
    }
    
    static testMethod void testRoundNumberAsString(){
        Test.startTest();
        
        System.assertEquals('25,65', Utils.roundNumberAsString(25.646));
        System.assertEquals('33,49', Utils.roundNumberAsString(33.495));
        System.assertEquals('-40,87', Utils.roundNumberAsString(-40.873));
        System.assertEquals('-59,97', Utils.roundNumberAsString(-59.97));
        System.assertEquals('60,00', Utils.roundNumberAsString(59.997));
        
        Test.stopTest();
    }
    
    static testMethod void shouldParseException(){
        String exceptionMessage = 'ERROR MESSAGE';
        System.assertEquals( exceptionMessage, Utils.parseErrorMessage( new Utils.GenericException( exceptionMessage ) ) );
    }

    static testMethod void shouldParseExceptionMessage(){
        String exceptionMessage = 'ERROR MESSAGE';
        System.assertEquals( exceptionMessage, Utils.parseErrorMessage( new Utils.GenericException( exceptionMessage ).getMessage() ) );
    }

    static testMethod void shouldReturnValue(){
        String value = 'value';
        System.assertEquals( value, Utils.valueOrBlank( value ) );
    }

    static testMethod void shouldReturnBlank(){
        Integer value;
        System.assertEquals( '', Utils.valueOrBlank( value ) );
    }
    
    static testMethod void testChangeNumbersToLetters(){
        Utils.changeNumbersToLetters('12345');
    }

    static testMethod void getRecordTypeIdExceptionOnInvalidArguments(){
        try{
            Utils.getRecordTypeId( null, null );
        }catch (Exception e){
            System.assertEquals( 'You must provide valid SObject type and developer name arguments.', Utils.parseErrorMessage( e ) );
        }
        try{
            Utils.getRecordTypeId( 'invalid SObject', 'invalid record type' );

        }catch (Exception e){
            System.assertEquals( 'Invalid SObject type.', Utils.parseErrorMessage( e ) );
        }

        RecordType recType = [select DeveloperName, SObjectType from RecordType limit 1];
        try{
            Utils.getRecordTypeId( recType.SObjectType, 'invalid record type' );

        }catch (Exception e){
            System.assertEquals( 'Invalid developer name "invalid record type" for SObject type "' + recType.SObjectType + '".', Utils.parseErrorMessage( e ) );
            
        }
    }
    
    static testMethod void testGetRecordType(){
        Utils.getRecordType('teste', 'teste');
        Utils.getRecordType('teste');
        Id idTest = [SELECT Id FROM RecordType LIMIT 1].Id;
        Utils.getRecordType(idTest);
        Utils.getMapRecordType('teste');
    }

    static testMethod void shouldGetRecordTypeId(){
        RecordType recType = [select Id, DeveloperName, SObjectType from RecordType limit 1];
        System.assertEquals( recType.Id, Utils.getRecordTypeId( recType.SObjectType, recType.DeveloperName ) );
    }

    static testMethod void getProfileIdExceptionOnInvalidArguments(){
        try{
            Utils.getProfileId( null );
        }catch (Exception e){
            System.assertEquals( 'You must provide a valid profile name argument.', Utils.parseErrorMessage( e ) );
        }
        try{
            Utils.getProfileId( 'invalid profile' );
        }catch (Exception e){
            System.assertEquals( 'Invalid profile name.', Utils.parseErrorMessage( e ) );
        }
    }

    static testMethod void shouldGetProfileId(){
        Profile prf = [select Id, Name from Profile limit 1];
        System.assertEquals( prf.Id, Utils.getProfileId( prf.Name ) );
    }

    static testMethod void getUserRoleIdExceptionOnInvalidArguments(){
        try{
            Utils.getUserRoleId( null );
        }catch (Exception e){
            System.assertEquals( 'You must provide a valid user role name argument.', Utils.parseErrorMessage( e ) );
        }
        try{
            Utils.getUserRoleId( 'invalid user role' );
        }catch (Exception e){
            System.assertEquals( 'Invalid user role name.', Utils.parseErrorMessage( e ) );
        }
    }

    static testMethod void shouldGetUserRoleId(){
        UserRole role = [select Id, Name from UserRole limit 1];
        System.assertEquals( role.Id, Utils.getUserRoleId( role.Name ) );
    }

    static testMethod void shouldGetAdminProfileId(){
        Profile adminProfile = [select Id, UserType, PermissionsAuthorApex from Profile where Id = :Utils.getSystemAdminProfileId()];
        System.assert( adminProfile.UserType == 'Standard' && adminProfile.PermissionsAuthorApex );
    }
    
    static testMethod void testGetUserPermissionSet(){
        Set<Id> userIdSet = new Set<Id>{UserInfo.getUserId()};
        test.startTest();
        
        Utils.getUserPermissionSetsMap(userIdSet);
        Utils.getUsersPermissionSetsIds(userIdSet);
        
        test.stopTest();
    }
    
    static testMethod void getPicklistValuesExceptionOnInvalidArguments(){
        try{
            Utils.getPicklistValues( null, null );
        }catch (Exception e){
            System.assertEquals( 'You must provide valid SObject name and field name arguments.', Utils.parseErrorMessage( e ) );
        }
        try{
            Utils.getPicklistValues( 'invalid SObject', 'invalid field' );
        }catch (Exception e){
            System.assertEquals( 'Could not get describe information for SObject "invalid SObject".', Utils.parseErrorMessage( e ) );
        }
        try{
            Utils.getPicklistValues( 'Lead', 'invalid field' );
        }catch (Exception e){
            System.assertEquals( 'Could not get describe information for "invalid field" field of "Lead" SObject.', Utils.parseErrorMessage( e ) );
            
        }
    }

    static testMethod void shouldGetPicklistValues(){
        Set< String > picklistValues = new Set< String >();
        for( Schema.PicklistEntry ple : Lead.Rating.getDescribe().getPicklistValues() )
            picklistValues.add( ple.getValue() );

        for( SelectOption option : Utils.getPicklistValues( 'Lead', 'Rating' ) )
            System.assert( picklistValues.contains( option.getValue() ) );
    }  
    
    static testMethod void buildSelectOptions(){
        List<SObject> ls2 = new List<SObject>();
        ls2.add(new Account(Name='teste'));
        List<SelectOption> sl = Utils.buildSelectOptions(ls2,'Name','Name');
    }
    
    static testMethod void testGetMapLabelPicklist(){
        test.startTest();
        
        Utils.getMapLabelPicklist('Lead', 'Status');
        
        test.stopTest();
    }
    
    static testMethod void testGetMapLabelFields(){
        test.startTest();
        
        Utils.getMapLabelFields('Lead');
        
        test.stopTest();
    }
    
    static testMethod void testGetSObjectMap1(){
        test.startTest();
        
        Utils.getSObjectMap('Lead', 'Id', '');
        
        test.stopTest();
    }
    
    static testMethod void testGetSObjectMap2(){
        test.startTest();
        
        Utils.getSObjectMap('Lead', 'Id', 'Id', new Set<Id>());
        
        test.stopTest();
    }
    
    static testMethod void testGetSObjectMap3(){
        test.startTest();
        
        Utils.getSObjectMap('Lead', 'Id', 'LastName', new Set<String>{'Silva', 'Pinto'});
        
        test.stopTest();
    }
    
    static testMethod void testDatetime(){
        test.startTest();
        
        Utils.now();
        Utils.userDatetime(datetime.now());
        
        test.stopTest();
    }
    
    static testMethod void shouldGenerateAndValidateCpfCnpj(){
        test.startTest();
        
        System.assert(!Utils.validateCpfCnpj('12345'));
        
        System.assert(Utils.validateCpfCnpj(Utils.generateCpf()));
        System.assert(Utils.validateCpfCnpj(Utils.generateCnpj()));
        
        test.stopTest();
    }
    
    static testMethod void testValidateId(){
        test.startTest();
        
        System.assertEquals('00Q7A0000033vOb', Utils.validateId('00Q7A0000033vOb'));
        System.assertEquals(null, Utils.validateId('negative'));
        
        test.stopTest();
    }
    
    static testMethod void searchCEP(){
        String aux = Utils.searchCEP('');
        String aux2 = Utils.searchCEP('07910080');
        String aux3 = Utils.searchCEP('00000000');
        
    }
    
    static testMethod void testGetBusinessHoursId(){
        Id bhId = Utils.getBusinessHoursId('Default');
    }
    
    static testMethod void shouldGetDefaultBusinessHoursId(){
        Id bhId = Utils.getDefaultBusinessHoursId();
    }
    
    /*
    static testMethod void testSObjectSorter(){
        Utils.SObjectSorter newSort1 = new Utils.SObjectSorter(new Account(), 'Name', 'String');
        newSort1.compareTo(newSort1);
        
        Utils.SObjectSorter newSort2 = new Utils.SObjectSorter(new Account(), 'PersonBirthdate', 'Date');
        newSort2.compareTo(newSort2);
        
        Utils.SObjectSorter newSort3 = new Utils.SObjectSorter(new Account(), 'CreatedDate', 'Datetime');
        newSort3.compareTo(newSort3);
        
        Utils.SObjectSorter newSort4 = new Utils.SObjectSorter(new Account(), 'NumberOfEmployees', 'Integer');
        newSort4.compareTo(newSort4);
        
        Utils.SObjectSorter newSort5 = new Utils.SObjectSorter(new Account(), 'Setor_Regional__c', 'Decimal');
        newSort5.compareTo(newSort5);
    }
    */
    static testMethod void testSortSObjListString(){
        List<Account> lstNewAccts = new List<Account>();
        
        for(Integer i=0 ; i<5 ; i++){
            lstNewAccts.add(
                new Account(
                    Name = (i+1) + 'ª Conta Test'
                )
            );
        }
        
        test.startTest();
        Utils.sortSObjList(lstNewAccts, 'Name', 'String');
        test.stopTest();
    }
    
    static testMethod void testSortSObjListDate(){
        List<Account> lstNewAccts = new List<Account>();
        
        for(Integer i=0 ; i<5 ; i++){
            lstNewAccts.add(
                new Account(
                    Name = (i+1) + 'ª Conta Test'
                )
            );
        }
        
        test.startTest();
        //Utils.sortSObjList(lstNewAccts, 'PersonBirthdate', 'Date');
        test.stopTest();
    }
    
    static testMethod void testSortSObjListDatetime(){
        List<Account> lstNewAccts = new List<Account>();
        
        for(Integer i=0 ; i<5 ; i++){
            lstNewAccts.add(
                new Account(
                    Name = (i+1) + 'ª Conta Test'
                )
            );
        }
        
        test.startTest();
        Utils.sortSObjList(lstNewAccts, 'CreatedDate', 'Datetime');
        test.stopTest();
    }
    
    static testMethod void testSortSObjListInteger(){
        List<Account> lstNewAccts = new List<Account>();
        
        for(Integer i=0 ; i<5 ; i++){
            lstNewAccts.add(
                new Account(
                    Name = (i+1) + 'ª Conta Test'
                )
            );
        }
        
        test.startTest();
        Utils.sortSObjList(lstNewAccts, 'NumberOfEmployees', 'Integer');
        test.stopTest();
    }
    
    static testMethod void testSortSObjListDecimal(){
        List<Account> lstNewAccts = new List<Account>();
        
        for(Integer i=0 ; i<5 ; i++){
            lstNewAccts.add(
                new Account(
                    Name = (i+1) + 'ª Conta Test'
                )
            );
        }
        
        test.startTest();
        //Utils.sortSObjList(lstNewAccts, 'Setor_Regional__c', 'Decimal');
        test.stopTest();
    }
    
    
}
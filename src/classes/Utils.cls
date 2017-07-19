/**
* Classe responsavel pelos os metodos utils reutilizados
* por todo o projeto.
*/
global without sharing class Utils {

    private static Map< String, Map< String, Id > > recordTypeMap;
    private static Map< String, Id > profileMap;
    private static Map< String, Id > userRoleMap;
    private static Map< String, Schema.SObjectType > mapGlobalDescribe = Schema.getGlobalDescribe();
    private static Map< String, Id > businessHoursMap;
    private static Map< Id, Group > queueMapById;
    private static Id adminProfileId;
    private static Id defaultBusinessHoursId;
    
    
    public static String baseURL{
        get{
            return Utils.baseURL();
        }
    }
    
    public static String baseURL(){
        return URL.getCurrentRequestUrl().toExternalForm().substringBefore( '/apex' );
    }

    public static String getResourceURL(String resourceName) {
        List<StaticResource> resourceList = [
            SELECT Name, NamespacePrefix, SystemModStamp
            FROM StaticResource
            WHERE Name = :resourceName
        ];
        
        if(resourceList.size() == 1) {
            String namespace = resourceList[0].NamespacePrefix;
            
            String response ='/resource/'
            + resourceList[0].SystemModStamp.getTime() + '/'
            + (namespace != null && namespace != '' ? namespace + '__' : '')
            + resourceName;
            System.debug('Utils.getResourceURL Response>>>>>>>'+response);
            return response;
        } else
            return '';
    }
    
    public static String getImageUrl (Id documentId){
        return URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + documentId + '&oid=' + UserInfo.getOrganizationId();
    }
    
    
    // Formatação de strings
    
    public static String limparFormatacaoTel(String param) {
        if(String.isEmpty(param)) return '';
        param = param.replace(' ', '');
        return param.replaceAll('[)(-]', '');
    }
    
    public static String limparFormatacaoCpfCnpj(String param) {
        if(String.isEmpty(param)) return '';
        param = param.replace(' ', '');
        return param.replaceAll('[/\\.-]', '');
    }
    
    public static String limparFormatacaoEspecial(String param){
        if(String.isEmpty(param)) return '';
        param = param.replaceAll(' ', '');
        return param.replaceAll('(?i)[^0-9a-záéíóúàèìòùâêîôûãõç]', '');
    }
    
    public static String limparFormatacaoGeral(String param) {
        if(String.isEmpty(param)) return '';
        Set<String> removeChars = new Set<String> {')', '/', '-', '.', '[', ']', '{', '}'};
        removeChars.add('(');
        
        for(String s : removeChars)
            param = param.remove(s);
            
        return param;
    }
    
    public static String replaceSpecialCharacters(String value){
        Map<String, String> regex = new Map<String, String>{
            'á' => 'a',
            'Á' => 'A',
            'ã' => 'a',
            'Ã' => 'A',
            'â' => 'a',
            'Â' => 'A',
            'ä' => 'a',
            'Ä' => 'A',
            'é' => 'e',
            'É' => 'E',
            'ê' => 'e',
            'Ê' => 'E',
            'ë' => 'e',
            'Ë' => 'E',
            'í' => 'i',
            'Í' => 'I',
            'ó' => 'o',
            'Ó' => 'O',
            'õ' => 'o',
            'Õ' => 'O',
            'ô' => 'o',
            'Ô' => 'O',
            'ö' => 'o',
            'Ö' => 'O',
            'ú' => 'u',
            'Ú' => 'U',
            'ü' => 'u',
            'Ü' => 'U',
            'ç' => 'c',
            'Ç' => 'C',
            'ñ' => 'n',
            'Ñ' => 'N'
        };
        
        for(String str : regex.keySet()){
            value = value.replace(str, regex.get(str));
        }
        
        return value;
    }
    
    public static String formatCpfCnpj(String cpfCnpj){
        if(String.isEmpty(cpfCnpj)) return '';
        
        cpfCnpj = Utils.limparFormatacaoCpfCnpj(cpfCnpj);
        
        if(cpfCnpj.isNumeric() && cpfCnpj.length() == 14){
            return cpfCnpj.substring(0, 2) + '.' + cpfCnpj.substring(2, 5) + '.' + cpfCnpj.substring(5, 8) + '/' + cpfCnpj.substring(8, 12) + '-' + cpfCnpj.substring(12, 14);
            
        } else if(cpfCnpj.isNumeric() && cpfCnpj.length() == 11){
            return cpfCnpj.substring(0, 3) + '.' + cpfCnpj.substring(3, 6) + '.' + cpfCnpj.substring(6, 9) + '-' + cpfCnpj.substring(9, 11);
            
        } else {
            return cpfCnpj;
        }
    }
    
    public static String capitalize (String value){
        if(value == null) return '';
        List<String> words = new List<String>();
        for(String word : value.split(' ')) words.add(word.toLowerCase().capitalize());
        return String.join(words, ' ');
    }
    
    public static String roundNumberAsString(Decimal num){
        if(num == null) return '0';
        String numStr = String.valueOf(num).remove('-');
        String sinal = num <= 0 ? '-' : '';
        
        List<String> numberList = numStr.splitByCharacterType();
        System.debug('@@@ numberList: ' + numberList);
        
        if(numberList.size() == 3){
            String strAfterComma = numberList[2];
            List<String> parts = strAfterComma.split('');
            
            Integer numBefComma = Integer.valueOf(numberList[0]);
            Integer parts1 = Integer.valueOf(parts[0]);
            Integer parts2 = parts.size() > 1 ? Integer.valueOf(parts[1]) : null;
            Integer parts3 = parts.size() > 2 ? Integer.valueOf(parts[2]) : null;
            
            if(parts2 == null)
                return sinal+String.valueOf(numBefComma)+','+String.valueOf(parts1)+'0';
            
            if(parts3 != null && parts3 > 5) {
                if(parts2 == 9) {
                    parts2 = 0;
                    if(parts1 == 9) {
                        parts1 = 0;
                        numBefComma += 1;
                    } else {
                        parts1 += 1;
                    }
                } else {
                    parts2 += 1;
                }
                
            } 
            
            return sinal+String.valueOf(numBefComma)+','+String.valueOf(parts1)+String.valueOf(parts2);
            
        } else if(numberList.size() == 1){
            return numStr;
            
        } else {
            throw new Utils.GenericException('Algo de errado não está certo');
        }
    }
    
    public static String parseErrorMessage (Exception e){
        return Utils.parseErrorMessage( e.getMessage() );
    }

    public static String parseErrorMessage (String msg){
       // Pattern p = Pattern.compile( '.* [A-Z|_]+, (.*): \\[(.*)]' );
        Pattern p = Pattern.compile( '.* [A-Z|_]+, ([^\\[|\\]|:]*): \\[(.*)]' );
        Matcher m = p.matcher( msg );

        return m.matches() && m.find( 1 ) ? m.group( 1 ) : msg;
    }

    public static String valueOrBlank (String value){
        return String.isEmpty( value ) ? '' : value;
    }

    public static String valueOrBlank(Object value){
      return value == null ? '' : String.valueOf(value);
    }
    
    public static String changeNumbersToLetters(String value){
        List<String> lettersList = new List<String>{'a','b','c','d','e','f','g','h','i','k','l'};
            for(integer i=0; i<10;i++){
                if(value.contains(''+i)){
                    value = value.replaceAll(''+i, lettersList.get(i));
                }
            }
        return value;
    }
    
    
    // Métodos de Record Type
    
    public static Id getRecordTypeId(String SObjectType, String DeveloperName) {
        if(String.isEmpty(SObjectType) || String.isEmpty(DeveloperName))
            throw new FetchException('You must provide valid SObject type and developer name arguments.');
            
        if(recordTypeMap == null) {
            recordTypeMap = new Map< String, Map< String, Id > >();
            for(RecordType recType : [select Id, SObjectType, DeveloperName from RecordType]) {
                Map< String, Id > SObjectMap = recordTypeMap.get(recType.SObjectType);
                if(SObjectMap == null) {
                    SObjectMap = new Map< String, Id > {recType.DeveloperName => recType.Id};
                    recordTypeMap.put(recType.SObjectType, SObjectMap);
                } else SObjectMap.put(recType.DeveloperName, recType.Id);
            }
        }
        
        Map< String, Id > SObjectMap = recordTypeMap.get(SObjectType);
        if(SObjectMap == null) throw new FetchException('Invalid SObject type.');
        
        Id recTypeId = SObjectMap.get(DeveloperName);
        if(recTypeId == null) throw new FetchException('Invalid developer name "' + DeveloperName + '" for SObject type "' + SObjectType + '".');
        
        return recTypeId;
    }

    public static String getRecordTypeDeveloperName(Id idRecordType){
        String ret = '';
        if(String.isNotEmpty(idRecordType)){
            for(RecordType rt : [select DeveloperName from RecordType where id=:idRecordType])
                ret = rt.DeveloperName;
        }
        return ret;
    }
    
    public static List<RecordType> getRecordType (String SObjectType, String developerName){
        String url = 'select Id, SObjectType, DeveloperName, Name from RecordType where SObjectType = \''+SObjectType+'\' and DeveloperName = \''+developerName+'\' order by  Name limit 300 ';
        return Database.query(url);
    }
    
    public static List<RecordType> getRecordType (String SObjectType){
        return [ select Id, SObjectType, DeveloperName, Name from RecordType where SObjectType =:SObjectType ];
    }
    
    public static List<RecordType> getRecordType(Id idRecordType){
        String url = 'select Id, SObjectType, DeveloperName, Name from RecordType where Id = \''+idRecordType+'\'';
        return Database.query(url);        
    }
    
    public static Map<Id,RecordType> getMapRecordType(String sObjectT){
        String url = 'select Id, SObjectType, DeveloperName, Name from RecordType where SObjectType = \''+sObjectT+'\' ';
        List<RecordType> lsRec =Database.query(url);
        Map<Id,RecordType> mapRecordType = new Map<Id,RecordType>(lsRec);
        return mapRecordType;
    }
    
    
    // User utils
    
    public static Id getProfileId(String profileName) {
        if( String.isEmpty( profileName ) )
            throw new FetchException( 'You must provide a valid profile name argument.' );

        if( profileMap == null ){
            profileMap = new Map< String, Id >();
            for( Profile prof : [select Id, Name from Profile] )
                profileMap.put( prof.Name, prof.Id );
        }

        Id profileId = profileMap.get( profileName );
        if( profileId == null ) throw new FetchException( 'Invalid profile name.' );

        return profileId;
    }

    public static Id getUserRoleId (String userRoleName){
        if( String.isEmpty( userRoleName ) )
            throw new FetchException( 'You must provide a valid user role name argument.' );

        if( userRoleMap == null ){
            userRoleMap = new Map< String, Id >();
            for( UserRole role : [select Id, Name from UserRole] )
                userRoleMap.put( role.Name, role.Id );
        }

        Id userRoleId = userRoleMap.get( userRoleName );
        if( userRoleId == null ) throw new FetchException( 'Invalid user role name.' );

        return userRoleId;
    }

    public static Id getSystemAdminProfileId(){
        try{
            if(String.isNotEmpty(adminProfileId)) return adminProfileId;
            else return adminProfileId = [select Id from Profile where UserType = 'Standard' and PermissionsAuthorApex = true order by CreatedDate asc limit 1].Id;
        }catch (Exception e){
            throw new FetchException( 'Could not determine system admin profile. This is bad.' );
        }
    }
    
    public static Group getQueueById(Id queueId){
        if(queueMapById == null){
            queueMapById = new Map<Id, Group>();
            for(Group queue : [SELECT Id, Name FROM Group WHERE Type = 'Queue']) queueMapById.put(queue.Id, queue);
        }
        if(!queueMapById.containsKey(queueId)) throw new FetchException( 'Invalid Queue Id.' );
        return queueMapById.get(queueId);
    }
    
    public static Set<Id> getUsersPermissionSetsIds(Set<Id> usersIds){
        Set<Id> permissionSetsIds = new Set<Id>();
        
        List<PermissionSetAssignment> listPermissionAssigment = [
            SELECT AssigneeId, PermissionSetId 
            FROM PermissionSetAssignment 
            WHERE AssigneeId in :usersIds
        ];
        
        for(PermissionSetAssignment psa : listPermissionAssigment)
            permissionSetsIds.add(psa.PermissionSetId);
        
        return permissionSetsIds;
    }
    
    public static Map<Id, List<PermissionSet>> getUserPermissionSetsMap(Set<Id> usersIds){
        Map<Id, List<PermissionSet>> mapPermissions = new Map<Id, List<PermissionSet>>();
        Map<Object, SObject> mapPermissionSets = getSObjectMap('PermissionSet', 'Id', 'Id', getUsersPermissionSetsIds(usersIds));
        
        List<PermissionSetAssignment> listPermissionAssigment = [
            SELECT AssigneeId, PermissionSetId 
            FROM PermissionSetAssignment 
            WHERE AssigneeId in :usersIds
        ];
        
        for(Id userId : usersIds){
            List<PermissionSet> userPermissions = new List<PermissionSet>();
            
            for(PermissionSetAssignment psa : listPermissionAssigment){
                if(userId == psa.AssigneeId && mapPermissionSets.containsKey(psa.PermissionSetId))
                    userPermissions.add( (PermissionSet) mapPermissionSets.get(psa.PermissionSetId) );
            }
            
            mapPermissions.put(userId, userPermissions);
        }
        
        
        return mapPermissions;
    }
    
    
    // Select Option Utils
    
    public static List< SelectOption > getPicklistValues(String sObjectName, String fieldName) {
        if( String.isBlank( sObjectName ) || String.isBlank( fieldName ) )
            throw new FetchException( 'You must provide valid SObject name and field name arguments.' );
        List< SelectOption > retList = new List< SelectOption >();
        Schema.SObjectType SObjType = Schema.getGlobalDescribe().get( sObjectName );

        if( SObjType == null ) throw new FetchException( 'Could not get describe information for SObject "' + SObjectName + '".' );
        Schema.SObjectField field = SObjType.getDescribe().fields.getMap().get( fieldName );

        if( field == null ) throw new FetchException( 'Could not get describe information for "' + fieldName + '" field of "' + SObjectName + '" SObject.' );

        for( Schema.PicklistEntry entry : field.getDescribe().getPicklistValues() )
            retList.add( new SelectOption( entry.getValue(), entry.getLabel() ) );

        return retList;
    }

    public static List<SelectOption> buildSelectOptions(List<SObject> sObjList, String value, String label){
        system.debug('@@@ buildSelectOptions sObjList: ' + sObjList);
        List<SelectOption> retList = new List<SelectOption>();
        for(SObject sObj : sObjList)
            retList.add(new SelectOption(String.valueOf(sObj.get(value)), String.valueOf(sObj.get(label))));
        return retList;
    }
    
    
    // Criação de maps
    
    //Monta Map Valor / Label de campos picklist
    public static Map<String, String> getMapLabelPicklist(String objeto, String campo){
        Map<String, String> mapLabel = new Map<String, String>();
        
        try {
            //Schema.DescribeFieldResult fieldDescribe
            Map<String, Schema.SObjectField> fieldMap = mapGlobalDescribe.get(objeto).getDescribe().fields.getMap();
            
            List<Schema.PicklistEntry> pickList = fieldMap.get(campo).getDescribe().getPicklistValues();
            
            //Schema.getGlobalDescribe().get(objeto).getDescribe().fields.getMap().get(campo).getDescribe().getPicklistValues()
            
            for(Schema.PicklistEntry pick : pickList){
                mapLabel.put(pick.getValue(), pick.getLabel());
            }
            
        } catch(Exception e){
            system.debug('@@@ getMapLabelPicklist fail: ' + e.getMessage());
        }
        
        return mapLabel;
    }
    
    //Monta Map API / Label dos campos de um objeto
    public static Map<String, String> getMapLabelFields(String objeto){
        Map<String, String> mapLabel = new Map<String, String>();
        
        try {
            Map<String, Schema.SObjectField> mapSObjectFields = mapGlobalDescribe.get(objeto).getDescribe().fields.getMap();
            
            for(String nomeCampo : mapSObjectFields.keySet())
                mapLabel.put(nomeCampo, mapSObjectFields.get(nomeCampo).getDescribe().getLabel());
            
            
        } catch(Exception e){
            system.debug('@@@ getMapLabelFields fail: ' + e.getMessage());
        }
        
        return mapLabel;
    }
    
    //Monta map de qualquer objeto
    public static Map<Object, SObject> getSObjectMap(String objeto, String campoChave, String whereCondition){
        if(!mapGlobalDescribe.containsKey(objeto))
            throw new GenericException('É necessário um nome de objeto válido.');
        
        Map<Object, SObject> sObjectMap = new Map<Object, SObject>();
        
        Map<String, Schema.SObjectField> fieldMap = mapGlobalDescribe.get(objeto).getDescribe().fields.getMap();
        
        if(!fieldMap.containsKey(campoChave))
            throw new GenericException('É necessário um nome de campo válido.');
        
        String query = 'SELECT ';
        
        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }
        
        query = query.substring(0, query.length()-1) + ' FROM ' + objeto + ' ' + whereCondition;
        
        system.debug('@@@ getSObjectMap query: ' + query);
        
        
        for(SObject obj : Database.query(query))
            sObjectMap.put(obj.get(fieldMap.get(campoChave)), obj);
        
        
        return sObjectMap;
    }
    
    public static Map<Object, SObject> getSObjectMap(String objeto, String campoChave, String idField, Set<Id> setIds){
        if(!mapGlobalDescribe.containsKey(objeto))
            throw new GenericException('É necessário um nome de objeto válido.');
        
        Map<Object, SObject> sObjectMap = new Map<Object, SObject>();
        
        Map<String, Schema.SObjectField> fieldMap = mapGlobalDescribe.get(objeto).getDescribe().fields.getMap();
        
        if(!fieldMap.containsKey(campoChave))
            throw new GenericException('É necessário um nome de campo válido.');
        
        String query = 'SELECT ';
        
        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }
        
        String whereCondition = '';
        
        if(!setIds.isEmpty()){
            whereCondition = 'WHERE ' + idField + ' in (';
            
            for(Id i : setIds){
                whereCondition += '\''+i+'\',';
            }
            
            whereCondition = whereCondition.substring(0, whereCondition.length()-1) + ')';
        }
        
        query = query.substring(0, query.length()-1) + ' FROM ' + objeto + ' ' + whereCondition;
        
        system.debug('@@@ getSObjectMap query: ' + query);
        
        
        for(SObject obj : Database.query(query))
            sObjectMap.put(obj.get(fieldMap.get(campoChave)), obj);
        
        
        return sObjectMap;
    }
    
    public static Map<Object, SObject> getSObjectMap(String objeto, String campoChave, String keyField, Set<String> setField){
        if(!mapGlobalDescribe.containsKey(objeto))
            throw new GenericException('É necessário um nome de objeto válido.');
        
        Map<Object, SObject> sObjectMap = new Map<Object, SObject>();
        
        Map<String, Schema.SObjectField> fieldMap = mapGlobalDescribe.get(objeto).getDescribe().fields.getMap();
        
        if(!fieldMap.containsKey(campoChave))
            throw new GenericException('É necessário um nome de campo válido.');
        
        String query = 'SELECT ';
        
        for(String fieldName : fieldMap.keySet()){
            query += fieldName + ',';
        }
        
        String whereCondition = '';
        
        if(!setField.isEmpty()){
            whereCondition = 'WHERE ' + keyField + ' in (';
            
            for(String str : setField){
                whereCondition += '\''+str+'\',';
            }
            
            whereCondition = whereCondition.substring(0, whereCondition.length()-1) + ')';
        }
        
        query = query.substring(0, query.length()-1) + ' FROM ' + objeto + ' ' + whereCondition;
        
        system.debug('@@@ getSObjectMap query: ' + query);
        
        
        for(SObject obj : Database.query(query)){
            Object mapkey = obj.get(fieldMap.get(campoChave));
            if(mapkey != null)
                sObjectMap.put(mapkey, obj);
        }
        
        
        return sObjectMap;
    }
    
    
    // Datetime local
    
    public static Datetime now(){
        Datetime now = Datetime.now();
        return now.addSeconds( UserInfo.getTimeZone().getOffset( now ) / 1000 );
    }
    
    public static Datetime userDatetime(Datetime dt){
        return dt.addSeconds( UserInfo.getTimeZone().getOffset( dt ) / 1000 );
    }
    
    
    
    public static Boolean validateCpfCnpj(String cpfCnpj){
        cpfCnpj = limparFormatacaoCpfCnpj(cpfCnpj);
        
        if(String.isNotEmpty(cpfCnpj) && cpfCnpj.isNumeric()) {
            if(cpfCnpj.length() == 11) {
                return getCpfVerifyingDigits(cpfCnpj.substring(0, 9)) == cpfCnpj;
                
            } else if(cpfCnpj.length() == 14) {
                return getCnpjVerifyingDigits(cpfCnpj.substring(0, 12)) == cpfCnpj;
                
            } else {
                return false;
            }
            
        } else {
            return false;
        }
    }
    
    public static String generateCpf(){
        return getCpfVerifyingDigits(randomNumberAsString(9));
    }
    
    private static String getCpfVerifyingDigits(String cpfNumber){
        List<String> cpfAsList = new List<String>();
        List<Integer> multiplyNumber;
        Integer cpfSum;
        Integer verificatorX;
        Integer verificatorY;
        
        
        
        system.debug('@@@ cpfNumber 9: ' + cpfNumber);
        
        cpfAsList = cpfNumber.split('');
        for(Integer i=0 ; i<cpfAsList.size() ; i++){
            if(!cpfAsList[i].isNumeric())
                cpfAsList.remove(i);
        }
        system.debug('@@@ cpfAsList in X: ' + cpfAsList);
        
        multiplyNumber = new List<Integer>{10, 9, 8, 7, 6, 5, 4, 3, 2};
        cpfSum = 0;
        
        if(cpfAsList.size() != multiplyNumber.size())
            throw new Utils.GenericException('Algo de errado não está certo');
        
        for(Integer i=0 ; i<9 ; i++){
            cpfSum += Integer.valueOf(cpfAsList[i]) * multiplyNumber[i];
        }
        system.debug('@@@ cpfSum in X: ' + cpfSum);
        
        Integer modCpfSum = Math.mod(cpfSum, 11);
        system.debug('@@@ modCpfSum in X: ' + modCpfSum);
        
        verificatorX = modCpfSum < 2 ? 0 : 11 - modCpfSum;
        system.debug('@@@ verificatorX: ' + verificatorX);
        
        
        
        cpfNumber += String.valueOf(verificatorX);
        system.debug('@@@ cpfNumber 10: ' + cpfNumber);
        
        cpfAsList = cpfNumber.split('');
        for(Integer i=0 ; i<cpfAsList.size() ; i++){
            if(!cpfAsList[i].isNumeric())
                cpfAsList.remove(i);
        }
        system.debug('@@@ cpfAsList in Y: ' + cpfAsList);
        
        multiplyNumber = new List<Integer>{11, 10, 9, 8, 7, 6, 5, 4, 3, 2};
        cpfSum = 0;
        
        if(cpfAsList.size() != multiplyNumber.size())
            throw new Utils.GenericException('Algo de errado não está certo');
        
        for(Integer i=0 ; i<10 ; i++){
            cpfSum += Integer.valueOf(cpfAsList[i]) * multiplyNumber[i];
        }
        system.debug('@@@ cpfSum in Y: ' + cpfSum);
        
        modCpfSum = Math.mod(cpfSum, 11);
        system.debug('@@@ modCpfSum in Y: ' + modCpfSum);
        
        verificatorY = modCpfSum < 2 ? 0 : 11 - modCpfSum;
        system.debug('@@@ verificatorY: ' + verificatorY);
        
        
        
        cpfNumber += String.valueOf(verificatorY);
        system.debug('@@@ cpfNumber 11: ' + cpfNumber);
        
        
        
        return cpfNumber;
    }
    
    public static String generateCnpj(){
        return getCnpjVerifyingDigits(randomNumberAsString(8) + '0001');
    }
    
    private static String getCnpjVerifyingDigits(String cnpjNumber){
        List<String> cnpjAsList = new List<String>();
        List<Integer> multiplyNumber;
        Integer cnpjSum;
        Integer verificatorX;
        Integer verificatorY;
        
        
        
        system.debug('@@@ cnpjNumber 12: ' + cnpjNumber);
        
        cnpjAsList = cnpjNumber.split('');
        for(Integer i=0 ; i<cnpjAsList.size() ; i++){
            if(!cnpjAsList[i].isNumeric())
                cnpjAsList.remove(i);
        }
        system.debug('@@@ cnpjAsList in X: ' + cnpjAsList);
        
        multiplyNumber = new List<Integer>{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
        cnpjSum = 0;
        
        if(cnpjAsList.size() != multiplyNumber.size())
            throw new Utils.GenericException('Algo de errado não está certo');
        
        for(Integer i=0 ; i<12 ; i++){
            cnpjSum += Integer.valueOf(cnpjAsList[i]) * multiplyNumber[i];
        }
        system.debug('@@@ cnpjSum in X: ' + cnpjSum);
        
        Integer modCnpjSum = Math.mod(cnpjSum, 11);
        system.debug('@@@ modCnpjSum in X: ' + modCnpjSum);
        
        verificatorX = modCnpjSum < 2 ? 0 : 11 - modCnpjSum;
        system.debug('@@@ verificatorX: ' + verificatorX);
        
        
        
        cnpjNumber += String.valueOf(verificatorX);
        system.debug('@@@ cnpjNumber 13: ' + cnpjNumber);
        
        cnpjAsList = cnpjNumber.split('');
        for(Integer i=0 ; i<cnpjAsList.size() ; i++){
            if(!cnpjAsList[i].isNumeric())
                cnpjAsList.remove(i);
        }
        system.debug('@@@ cnpjAsList in Y: ' + cnpjAsList);
        
        multiplyNumber = new List<Integer>{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
        cnpjSum = 0;
        
        if(cnpjAsList.size() != multiplyNumber.size())
            throw new Utils.GenericException('Algo de errado não está certo');
        
        for(Integer i=0 ; i<13 ; i++){
            cnpjSum += Integer.valueOf(cnpjAsList[i]) * multiplyNumber[i];
        }
        system.debug('@@@ cnpjSum in Y: ' + cnpjSum);
        
        modCnpjSum = Math.mod(cnpjSum, 11);
        system.debug('@@@ modCnpjSum in Y: ' + modCnpjSum);
        
        verificatorY = modCnpjSum < 2 ? 0 : 11 - modCnpjSum;
        system.debug('@@@ verificatorY: ' + verificatorY);
        
        
        
        cnpjNumber += String.valueOf(verificatorY);
        system.debug('@@@ cnpjNumber 14: ' + cnpjNumber);
        
        
        
        return cnpjNumber;
    }
    
    public static String randomNumberAsString(Integer size){
        
        String randomNumber = '';
        Boolean validSize = false;
        
        while(!validSize){
            String randomGenerator = String.valueOf(Math.random());
            system.debug('### randomGenerator generated -> ' + randomGenerator);
            
            randomGenerator = randomGenerator.removeStart('0');
            randomGenerator = randomGenerator.removeStart('.');
            system.debug('### randomGenerator removed -> ' + randomGenerator);
            
            randomNumber += randomGenerator.isNumeric() ? randomGenerator : '';
            
            if(randomNumber.length() >= size){
                randomNumber = randomNumber.substring(0, size);
                validSize = true;
            }
        }
        
        system.debug('@@@ randomNumber: ' + randomNumber);
        return randomNumber;
    }
    
    
    
    public static String validateId(String Idparam){
        String idEscape = String.escapeSingleQuotes(Utils.valueOrBlank(Idparam));
        if((idEscape.length() == 15 || idEscape.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', idEscape))
            return idEscape;
       
        return null;
    }
    
    public static String searchCEP(String CEP){

        String message = '', rua = '', bairro = '', cidade = '', uf = '', complemento2 = '';
        try{
            System.debug('### CEP '+CEP);
            if(String.isNotEmpty(CEP) && CEP.isNumeric() && CEP.length() == 8){

                // xml de chamada webservice dos Correios
                String xml = '<soapenv:Envelope xmlns:soapenv='+
                    '"http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">' +
                    '<soapenv:Header/>' +
                    '<soapenv:Body>' +
                    '<cli:consultaCEP>' +
                    '<cep>'+CEP+'</cep>' +
                    '</cli:consultaCEP>' +
                    '</soapenv:Body>' +
                    '</soapenv:Envelope>';

                // Método de envio de requisição
                HttpRequest req = new HttpRequest();
                //verificar as configurações abaixo pois são a que estão no soapui
                req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
                req.setHeader('Content-Length','324');
                req.setHeader('SOAPAction', '');
                req.setHeader('Host','apps.correios.com.br');
                //selecionar a url do servidor
                req.setEndpoint('https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente');
                req.setMethod('POST');
                //setar o xml
                req.setBody(xml);

                //envio da requisição e obtenção da resposta
                HttpResponse res = new HttpResponse();
                Http http = new Http();
                res = http.send(req);

                // Log the XML content
                System.debug('### res.getBody(): ' + res.getBody());

                if(!res.getBody().contains('CEP NAO ENCONTRADO')){

                    String body = res.getBody();

                    rua = body.split('<end>')[1].split('</end>')[0];
                    bairro = body.split('<bairro>')[1].split('</bairro>')[0];
                    cidade = body.split('<cidade>')[1].split('</cidade>')[0];
                    uf = body.split('<uf>')[1].split('</uf>')[0];
                    complemento2 = body.split('<complemento2>')[1].split('</complemento2>')[0];

                    JSONGenerator generator = JSON.createGenerator(true);
                    generator.writeStartObject();
                    generator.writeStringField('rua', rua+' '+complemento2);
                    generator.writeStringField('bairro', bairro);
                    generator.writeStringField('cidade', cidade);
                    generator.writeStringField('uf', uf);
                    generator.writeStringField('cep', CEP);
                    generator.writeEndObject();
                    message = generator.getAsString();

                }else{
                    message = 'CEP NÃO ENCONTRADO';
                }

            }else{
                message = 'DIGITE UM CEP VÁLIDO';
            }
            
        } catch(Exception e){

        }


        return message;
    }
    
    public static Id getBusinessHoursId(String nameBusinessHours){
        if(businessHoursMap == null){
            businessHoursMap = new Map<String, Id>();
            for(BusinessHours bh : [
                SELECT  Id, Name
                FROM    BusinessHours
            ]) businessHoursMap.put(bh.Name, bh.Id);
        }
        
        if(!businessHoursMap.containsKey(nameBusinessHours))
            throw new FetchException('You must provide a valid Business Hours name argument.');
        
        return businessHoursMap.get(nameBusinessHours);
    }
    
    public static Id getDefaultBusinessHoursId(){
        try {
            if(String.isNotEmpty(defaultBusinessHoursId)) return defaultBusinessHoursId;
            else return defaultBusinessHoursId = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1].Id;
            
        } catch(Exception e){
            throw new FetchException( 'Could not determine default Business Hours: ' + e.getMessage() );
        }
    }

    
    
    // Sort lists of sobjects
    
    public static List<SObject> sortSObjList(List<SObject> sObjList, String sortingField, String sortType){
        List<SObjectSorter> sObjSorterList = new List<SObjectSorter>();
        for(SObject sObj : sObjList) sObjSorterList.add(new SObjectSorter(sObj, sortingField, sortType));
        sObjSorterList.sort();

        List<SObject> sortedSObjList = new List<SObject>();
        for(SObjectSorter sObjSorter : sObjSorterList) sortedSObjList.add(sObjSorter.sObj);

        return sortedSObjList;
    }
    //Classe utilizada para ordenação customizada de SObjects
    public class SObjectSorter implements Comparable{

        public SObject sObj{
            get{
                return this.self;
            }
        }

        private SObject self;
        private String sortingField;
        private String sortType;

        public Integer compareTo(Object targetObject){
            SObjectSorter other = (SObjectSorter)targetObject;
            if(this.sortType == 'String') return this.compareToString(other);
            if(this.sortType == 'Date') return this.compareToDate(other);
            if(this.sortType == 'Datetime') return this.compareToDatetime(other);
            if(this.sortType == 'Integer') return this.compareToInteger(other);
            if(this.sortType == 'Decimal') return this.compareToDecimal(other);

            return 0;
        }

        private Integer compareToString(SObjectSorter other){
            if((String)this.self.get(this.sortingField) == (String)other.self.get(this.sortingField)) return 0;
            if((String)this.self.get(this.sortingField) > (String)other.self.get(this.sortingField)) return 1;
            return -1;
        }

        private Integer compareToDate(SObjectSorter other){
            if((Date)this.self.get(this.sortingField) == (Date)other.self.get(this.sortingField)) return 0;
            if((Date)this.self.get(this.sortingField) > (Date)other.self.get(this.sortingField)) return 1;
            return -1;
        }

        private Integer compareToDatetime(SObjectSorter other){
            if((Datetime)this.self.get(this.sortingField) == (Datetime)other.self.get(this.sortingField)) return 0;
            if((Datetime)this.self.get(this.sortingField) > (Datetime)other.self.get(this.sortingField)) return 1;
            return -1;
        }

        private Integer compareToInteger(SObjectSorter other){
            if((Integer)this.self.get(this.sortingField) == (Integer)other.self.get(this.sortingField)) return 0;
            if((Integer)this.self.get(this.sortingField) > (Integer)other.self.get(this.sortingField)) return 1;
            return -1;
        }

        private Integer compareToDecimal(SObjectSorter other){
            if((Decimal)this.self.get(this.sortingField) == (Decimal)other.self.get(this.sortingField)) return 0;
            if((Decimal)this.self.get(this.sortingField) > (Decimal)other.self.get(this.sortingField)) return 1;
            return -1;
        }

        public SObjectSorter(SObject target, String sortingField, String sortType){
            this.sortingField = sortingField;
            this.self = target;
            this.sortType = sortType;
        }
    }
    
    
    private class FetchException extends Exception{}
    public class GenericException extends Exception{}
    
}
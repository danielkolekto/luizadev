/**
*	@author Diego Moreira
*	@class Classe de metodos utilitarios
*/
public class Util {
    /**
     *  Retorna uma String a partir de um Object. 
     *  Se o objeto for igual a NULL, retorna uma String vazia, caso contrário, faz a conversão e retorna uma String sem os espaços iniciais e finais(trim()). 
     *  @param obj Um Object qualquer.
     *  @return O objeto convertido em String.
     */

     public static String getId( Object obj ) { 
        return ( String.valueOf( obj ).equals( '' ) ? null : String.valueOf( obj ) );
    }

    public static String getString( Object obj ) { 
        return ( obj == null ? '' : String.valueOf( obj ) );
    }

    public static Double getDouble( Double valor ) {
        return ( valor == null ? 0 : valor );
    }

    public static Decimal getDecimal( Decimal valor ) {
        return ( valor == null ? 0 : valor );
    }

    /**
     * Retorna o próprio Decimal recebido se ele for diferente de VAZIO.
     * Se for igual a vazio retorna ZERO.
     * @param valor Uma string qualquer.
     * @return A conversão da string em Decimal ou ZERO.
     */
    public static Decimal getDecimal( String valor ) {
        return ( valor == '' ? 0 : Decimal.valueOf( valor ) );
    }

    /**
     * Retorna um boolean
     * Se for igual a NULL retorna FALSE.
     * @param valor de uma objeto qualquer
     * @return O próprio Boolean recebido ou false.
     */
    public static Boolean getBoolean( Object obj ) {
        return ( obj == null ? false : Boolean.valueOf( obj ) );
    }
    /**
     * Retorna uma data
     * Se for igual a NULL retorna NULL.
     * @param valor de uma objeto qualquer
     * @return A data recebido ou NULL.
     */
    public static Date getDate( String value ) {
        return ( value == '' ? null : Date.valueOf( value ) );
    }


	/**
     * 	Retorna o primeiro nome de uma string
     * 	@param name nome que deseja separar
     */ 
    public static String getFirstName( String name ) {
        Integer i = name.indexOf(' ');
        return i >= 0 ? name.substring( 0, i ) : name;
    }
    
    /**
     *	Retorna o Sobrenome de uma string
     * 	@param name nome que deseja separar
     */ 
    public static String getLastName( String name ) {
        String result = name.replace( getFirstName( name ), '' ).trim();
        return result.equals( '' ) ? 'N/A' : result;
    }
    
    public static String getISODatetime(Date d){
        if(d == null) return '';
        return getISODatetime(Datetime.newInstance(d, Time.newInstance(0, 0, 0, 0)));
    }
    
    public static String getISODatetime(Datetime dt){
        if(dt == null) return '';
        String year   = String.valueOf(dt.year());
        String month  = dt.month()  < 10 ? '0'+String.valueOf(dt.month())   : String.valueOf(dt.month());
        String day    = dt.day()    < 10 ? '0'+String.valueOf(dt.day())     : String.valueOf(dt.day());
        String hour   = dt.hour()   < 10 ? '0'+String.valueOf(dt.hour())  : String.valueOf(dt.hour());
        String minute = dt.minute() < 10 ? '0'+String.valueOf(dt.minute())  : String.valueOf(dt.minute());
        String second = dt.second() < 10 ? '0'+String.valueOf(dt.second())  : String.valueOf(dt.second());
        
        return year+'-'+month+'-'+day+'T'+hour+':'+minute+':'+second+'Z';
    }

    /**
     * Retorna os status de integração
     */ 
    /*public static Map<String, String> getCaseStatus() {
        Map<String, String> mapIntegrationStatus = new Map<String, String>();
        mapIntegrationStatus.put( 'waiting_seller', 'Aguardando resposta do Lojista' );
        mapIntegrationStatus.put( 'waiting_customer', 'Aguardando resposta do Cliente' );
        mapIntegrationStatus.put( 'waiting_marketplace', 'Aguardando resposta do Magazine Luiza' );
        mapIntegrationStatus.put( 'item_return_denied', 'Devolução negada' );       
        mapIntegrationStatus.put( 'item_return_authorized', 'Devolução autorizada - aguardando envio' );
        mapIntegrationStatus.put( 'item_delivered_to_seller', 'Lojista recebeu o produto - aguar. análi' );
        mapIntegrationStatus.put( 'refund_denied', 'Estorno recusado' );     
        mapIntegrationStatus.put( 'refund_authorized', 'Estorno autorizado' );
        mapIntegrationStatus.put( 'closed', 'Fechado Cliente' );

        return mapIntegrationStatus;
    }*/
    
    /**
     * Retorna os status de integração como é no GIBA
     */
    public static String getCaseGibaStatus(String sfStatus) {
        Map<String, String> mapCaseGibaStatus = getCaseGibaStatus();
        
        if(mapCaseGibaStatus.containsKey(sfStatus)) {
            return mapCaseGibaStatus.get(sfStatus);
        } else {
            return '';
        }
    }
    
    /**
     * Retorna os status de integração como é no GIBA
     */
    public static Map<String, String> getCaseGibaStatus() {
        Map<String, String> mapIntegrationStatus = new Map<String, String>();
        mapIntegrationStatus.put(  'Aguardando resposta do Lojista', 'waiting_seller' );
        mapIntegrationStatus.put(  'Aguardando resposta do Cliente', 'waiting_customer' );
        mapIntegrationStatus.put(  'Aguardando resposta do Magazine Luiza', 'waiting_marketplace' );
        mapIntegrationStatus.put(  'Devolução negada', 'item_return_denied' );
        mapIntegrationStatus.put(  'Devolução autorizada - aguardando envio', 'item_return_authorized' );
        mapIntegrationStatus.put(  'Lojista recebeu o produto - aguar. análi', 'item_delivered_to_seller' );
        mapIntegrationStatus.put(  'Estorno recusado', 'refund_denied' );
        mapIntegrationStatus.put(  'Estorno autorizado', 'refund_authorized' );
        mapIntegrationStatus.put(  'Fechado Cliente', 'closed' );

        return mapIntegrationStatus;
    }

    /**
     * Retorna os status de integração
     */ 
    public static String getAuthorType(String authorType) {
        Map<String, String> mapAuthor = new Map<String, String>();
        mapAuthor.put( 'seller', 'Lojista' );
        mapAuthor.put( 'customer', 'Cliente' );
        mapAuthor.put( 'marketplace', 'Magazine Luiza' );

        return mapAuthor.get(authorType);
    }

    /**
    *    Retorna modelo dados apos integração
    *    @param status de retorno do serviço
    *    @param mensagem de retorno do serviço
    */
    public static String jsonResponse( String status, String mensagem ) {
        //return '{"status" : "' + status + '", "message" : "' + mensagem + '"}';
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField( 'status', status ); 
        gen.writeStringField( 'message', mensagem ); 
        gen.writeEndObject(); 

        return gen.getAsString();
    }

}
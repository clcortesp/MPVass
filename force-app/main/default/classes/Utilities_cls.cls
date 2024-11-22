/**
 * @description       : 
 * @author            : Juan Felipe Muriel
 * @group             : 
 * @last modified on  : 24-08-2024
 * @last modified by  : Juan Felipe Muriel
**/
public class Utilities_cls {

    public static final String SUCCESS_GP_VALUE ='Success';
    public static final String ERROR_GP_VALUE ='Error';
    public static final String INPROGRESS_GP_VALUE ='InProgress';
    public static final String EMPTY = '';
    public static final String SCRIPT = '-';
    public static final String QUESTION_MARK = ' ? ';
    public static final String SPACE = ' ';

    public static List<String> getAllFields(String SobjectApiName){        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
        List<String> lstFields = new List<String>();
        for(String fieldApiName : fieldMap.keyset() )
        {
            lstFields.add(fieldApiName);
            //system.debug('fieldApiName->>'+fieldApiName);
        }
        return lstFields;
    }
    
    public static String getQueryFields(List<String> lstFields){        
        String strQueryFields = '';
        for(String field : lstFields){
            strQueryFields = strQueryFields+','+field;
        }
        if(strQueryFields != ''){
            strQueryFields=strQueryFields.right(strQueryFields.length()-1);
        }
        return strQueryFields;
    }

    /**
     * @description Método que guarda logs de la llamada a la API en un objeto de Salesforce
     * @author Juan Felipe Muriel | 05-08-2024 
     * @param args [0]: Id Salesforce, [1]: ParentId, [2]: Status, [3]: Request, [4]: RequestDateTime, [5]: Response, [6]: ResponseDateTime, [7]: Params, [8]:Integración
     * @return newLog Registro de log de la transacción
     **/
    public static MPIntegrationStatus__c createIntegrationStatusRecord(String[] args) {
        MPIntegrationStatus__c newLog = new MPIntegrationStatus__c();
        String idText = args[NumbersEnum.CERO.ordinal()];

        newLog.MPParentId__c         = args[NumbersEnum.UNO.ordinal()];
        newLog.MPStatus__c           = args[NumbersEnum.DOS.ordinal()];
        newLog.MPRequest__c          = args[NumbersEnum.TRES.ordinal()];
        newLog.MPRequestDateTime__c  = parseDateTime(args[NumbersEnum.CUATRO.ordinal()]);
        newLog.MPResponse__c         = args[NumbersEnum.CINCO.ordinal()];
        newLog.MPResponseDateTime__c = parseDateTime(args[NumbersEnum.SEIS.ordinal()]);
        newLog.MPParams__c           = args[NumbersEnum.SIETE.ordinal()];
        newLog.MPIntegrationName__c  = args[NumbersEnum.OCHO.ordinal()];

        if(!String.isBlank(idText)){
            newLog.Id  =  Id.valueOf(idText);
            upsert newLog;
        }else{
            insert newLog;
        }
        return newLog;
    }

    public static MPIntegrationStatus__c updateIntegrationStatus(MPIntegrationStatus__c integrationStatus){
        update integrationStatus;

        return integrationStatus;
    }

    /**
     * @description Método auxiliar para convertir un String a DateTime, manejando nulos.
     * @param dateTimeString Cadena que representa la fecha y hora
     * @return DateTime convertido o null si la cadena está vacía
     **/
    private static DateTime parseDateTime(String dateTimeString) {
        return String.isNotBlank(dateTimeString) ? DateTime.valueOf(dateTimeString) : null;
    }

    /**
     * @description Método para obtener el valor de una picklist global basada en el API Name de un campo de objeto.
     * @param sObjectName Nombre del objeto de Salesforce (API Name).
     * @param fieldApiName Nombre del campo picklist en el objeto (API Name).
     * @param picklistValueName Nombre del valor de la picklist (API Name).
     * @return String Valor de la picklist correspondiente al API Name.
     */
    public static String getGlobalPicklistValue(String sObjectName, String fieldApiName, String picklistValueName) {
        // Obtener la descripción del campo de picklist en el objeto
        Schema.DescribeFieldResult fieldResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(fieldApiName).getDescribe();

        // Verificar si el campo es una picklist
        if (fieldResult.getType() == Schema.DisplayType.Picklist) {
            // Obtener los valores de la picklist
            List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();

            // Recorrer los valores de la picklist para encontrar el que coincida con el API Name
            for (Schema.PicklistEntry value : picklistValues) {
                if (value.getValue() == picklistValueName) {
                    return value.getValue();
                }
            }
        }
        
        // Si no se encuentra el valor, retornar null o lanzar una excepción
        return null;
    }

    /**
     * @description Método que retorna el valor "Success" de la picklist global especificada.
     * @param sObjectName Nombre del objeto de Salesforce (API Name).
     * @param fieldApiName Nombre del campo picklist en el objeto (API Name).
     * @return String Valor de "Success" en la picklist global.
     */
    public static String getSuccessValue(String sObjectName, String fieldApiName) {
        return getGlobalPicklistValue(sObjectName, fieldApiName, SUCCESS_GP_VALUE);
    }

    /**
     * @description Método que retorna el valor "InProgress" de la picklist global especificada.
     * @param sObjectName Nombre del objeto de Salesforce (API Name).
     * @param fieldApiName Nombre del campo picklist en el objeto (API Name).
     * @return String Valor de "InProgress" en la picklist global.
     */
    public static String getInProgressValue(String sObjectName, String fieldApiName) {
        return getGlobalPicklistValue(sObjectName, fieldApiName, INPROGRESS_GP_VALUE);
    }

    /**
     * @description Método que retorna el valor "Error" de la picklist global especificada.
     * @param sObjectName Nombre del objeto de Salesforce (API Name).
     * @param fieldApiName Nombre del campo picklist en el objeto (API Name).
     * @return String Valor de "Error" en la picklist global.
     */
    public static String getErrorValue(String sObjectName, String fieldApiName) {
        return getGlobalPicklistValue(sObjectName, fieldApiName, ERROR_GP_VALUE);
    }

    public static String getSalesforceStackTrace(Exception e) {
        return e.getMessage() + '\n' + '\n'  + 'StackTrace:'+ '\n' + e.getStackTraceString();
    }

    public static void handleCalloutRetries(ICallManager callManager, Integer secondsBetweenRetries, String integrationName){
        // Armar el Cron
        Datetime sysTime = System.now().addSeconds(secondsBetweenRetries);
        String cronExpression = EMPTY + sysTime.second() + SPACE + sysTime.minute() + SPACE + sysTime.hour() + SPACE + sysTime.day() + SPACE + sysTime.month() + QUESTION_MARK + sysTime.year();
        // Nombre del job
        String processName = integrationName + SPACE + cronExpression + SCRIPT + String.valueOf(sysTime.millisecond());
        // Programar el job
        System.schedule(processName, cronExpression, new CallManagerSchedule(callManager));
    }

    public static List<Integer> getSuccessfulHttpCodes(String text){
        List<Integer> successfulCodes = new List<Integer>();
        for (String code : text.split(';')) {
            successfulCodes.add(Integer.valueOf(code));
        }
        return successfulCodes;
    }
}
/**
 * @description
 * @group Proyecto MP
 * @author Miller
 * @since 28-08-2024 - Creación
 */
public with sharing class GetContractAPIUtils {

    /** Nombre de la integración */
    public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPGETContract').DeveloperName;
    public static final String AM15_STRING = 'AM15';
    public static final String AM90_STRING = 'AM90';

    /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Miller Mora | 20-08-2024 
    * @param callManager Instancia del callManager
    * @return updatedIntStat Registro de log de la transacción actualizado
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(GetContractAPICallManager callManager){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getParentId();
        updatedIntStat.MPStatus__c             = callManager.getContractAPIWrapper().status;
        updatedIntStat.MPRequest__c            = JSON.serialize(callManager.getContractAPIWrapper().request);
        updatedIntStat.MPRequestDateTime__c    = callManager.getContractAPIWrapper().requestDateTime;
        updatedIntStat.MPResponse__c           = callManager.getContractAPIWrapper().response.message;
        updatedIntStat.MPResponseDateTime__c   = callManager.getContractAPIWrapper().requestDateTime;
        updatedIntStat.MPParams__c             = JSON.serialize(callManager.getContractAPIWrapper().params);
        updatedIntStat.MPSalesforceException__c= callManager.getContractAPIWrapper().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.getContractAPIWrapper().httpCode;
        System.debug('updatedIntStat' + updatedIntStat);
        return updatedIntStat;
    }

    public static void updateOpportunityWithEndDate(Opportunity opp, String jsonResponse) {
        System.debug('JSON Response: ' + jsonResponse);
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        String endDateStr = (String)jsonMap.get('endDate');
        
        if (endDateStr != null) {           
            Date endDate = Date.valueOf(endDateStr.split('T')[0]);
            System.debug('Parsed endDate: ' + endDate);

            Date startDate = Date.today();
            System.debug('Start Date (Fecha de Creación de la Oportunidad): ' + startDate);
            
            // Calcular diferencia en meses entre la fecha de inicio y la fecha de fin
            Integer monthsDifference = calculateMonthsDifference(startDate, endDate);
            System.debug('Months Difference: ' + monthsDifference);
            
            // Actualizar el campo MPContractPeriodYears__c con la diferencia de meses
            opp.MPContractPeriodYears__c = monthsDifference;
            
            // Asignar el valor del campo 'MPUpdateByGetContractIntegration__c' a true
            opp.MPUpdateByGetContractIntegration__c = TRUE;

            opp.MPContractEndDate__c = endDate;
            update opp;
            System.debug('Opportunity updated with MPContractEndDate__c, MPContractPeriodYears__c, and MPTermType__c.' + monthsDifference);

        }else {
            System.debug('No endDate found in JSON response.');
        }
    }

    // Método auxiliar para calcular la diferencia en meses entre dos fechas
    public static Integer calculateMonthsDifference(Date startDate, Date endDate) {
      
        System.debug('Start Date (Fecha de inicio): ' + startDate);
        System.debug('End Date (Fecha de fin): ' + endDate);
        
        Integer monthsDifference = startDate.monthsBetween(endDate);
        
        System.debug('Months Difference (Diferencia en meses): ' + monthsDifference);
        return monthsDifference;
    }

    /**
    * @description Modify Order details after every Get Contract CallOut
    * @author Juan Felipe | 10-21-2024 
    * @param parentId Order Id
    * @param getContractAPIWrapper Get Contract API Response
    **/
    public static void updateOrder(Id parentId, String responseJson) {

        TerminationOrderWrapper terminationOrderWrapper = (TerminationOrderWrapper) JSON.deserialize(responseJson, TerminationOrderWrapper.class);
        Order orderTemp = new Order();
        orderTemp.Id = parentId;
        orderTemp.MPContractEndDate__c = String.isNotBlank(terminationOrderWrapper.endDate) ? Date.valueOf(terminationOrderWrapper.endDate) : null;
        orderTemp.MPLastInvoiceDate__c = String.isNotBlank(terminationOrderWrapper.lastInvoiceDate) ? Date.valueOf(terminationOrderWrapper.lastInvoiceDate) : null;
        
        if(terminationOrderWrapper.condition != null) {
            for(ContractWrapper.Condition condition : terminationOrderWrapper.condition){
                if(condition.type == AM15_STRING || condition.type == AM90_STRING) {
                    orderTemp.MPContractAM__c = condition.unitPrice;
                    continue;
                }
            }
        }

        update orderTemp;
    }

    public class TerminationOrderWrapper {
        String endDate;
        List<ContractWrapper.Condition> condition;
        String lastInvoiceDate;
    }
}
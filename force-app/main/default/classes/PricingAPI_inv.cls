/**
 * @description Clase usada en Trigger Flow de MPQuoteCondition__c para invocar la integración de precios.
 * @group Proyecto MP
 * @author Marco Guevara (MG)
 * @since 05-08-2024 - Creación
 */
public with sharing class PricingAPI_inv {

    public static final String IN_PROGRESS_STATUS = Utilities_cls.getInprogressValue('MPQuoteCondition__c', 'MPPricingApiStatus__c');
    public static final Boolean IS_RETRY_ENABLED = MPIntegrationSetting__mdt.getInstance('MPPricing').MPRetry__c;// Obtener valor por defecto si se deben hacer reintentos
    private static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPPricing').DeveloperName;

    /**
     * @description Método encargado de ejecutar la integración de precios.
     * @author Juan Felipe Muriel | 05-08-2024 
     * @param lstMPQuoteCondition Lista de condicioines de presupuesto filtradas las cuales deben obtener el valor
     * sugerido desde la API de precios.
     */
    @InvocableMethod(label='Call the Pricing API' description='Call the Pricing API in order to obtain the suggested value for the condition class' category='Quote Condition')
    public static void callPricingAPI(List<MPQuoteCondition__c> lstMPQuoteCondition) {   
        Set<Id> quoteConditionIdSet = new Set<Id>();
        List<Quote> quoteToUpdateList = new List<Quote>();
        Map<Id,MPIntegrationStatus__c> intStatusByMpqcIdMap = new Map<Id,MPIntegrationStatus__c>();
        List<MPQuoteCondition__c> mpqcToUpdateList = new List<MPQuoteCondition__c>();
        
        // Obtener Ids de Condiciones de presupuesto (MPQuoteCondition__c)
        for(MPQuoteCondition__c mpqc : lstMPQuoteCondition){
            quoteConditionIdSet.add(mpqc.Id);
        }

        // Obtener presupuestos (Quote) a actualizar en estado en progreso y organizar en un mapa con los logs
        for(MPQuoteCondition__c mpqc : [SELECT Id, MPQuote__c FROM MPQuoteCondition__c WHERE Id IN :quoteConditionIdSet]){
            quoteToUpdateList.add(new Quote(Id=mpqc.MPQuote__c, MPPricingApiStatus__c = IN_PROGRESS_STATUS));
            if(!intStatusByMpqcIdMap.containsKey(mpqc.Id)){
                MPIntegrationStatus__c newLog = getIntStatus(mpqc.Id);
                intStatusByMpqcIdMap.put(mpqc.Id, newLog);
            }
        }

        // Insertar logs de la integración (MPIntegrationStatus__c)
        if(!intStatusByMpqcIdMap.isEmpty()){
            insert intStatusByMpqcIdMap.values();
        }

        // Actualizar Condiciones de presupuesto (MPQuoteCondition__c)
        for(MPQuoteCondition__c mpqc : lstMPQuoteCondition ){
            MPQuoteCondition__c mpqcTemp = new MPQuoteCondition__c();
            mpqcTemp.Id = mpqc.Id;
            mpqcTemp.MPPricingApiStatus__c = IN_PROGRESS_STATUS;
            if(intStatusByMpqcIdMap.containsKey(mpqcTemp.Id)){
                mpqcTemp.MPIntegrationStatus__c = intStatusByMpqcIdMap.get(mpqcTemp.Id).Id;
            }
            mpqcToUpdateList.add(mpqcTemp);
        }

        if(!mpqcToUpdateList.isEmpty()){
           update mpqcToUpdateList;
        }

        // Actualizar presupuesto (MPQuoteCondition__c)
        if(!quoteToUpdateList.isEmpty()){
            update quoteToUpdateList;
        }

        // Encolar trabajos para ejecutar la integración
        for(MPQuoteCondition__c mpqc : lstMPQuoteCondition ){
            if(intStatusByMpqcIdMap.containsKey(mpqc.Id) && !Test.isRunningTest()){
                PricingAPICallManager callManager = new PricingAPICallManager(mpqc,IS_RETRY_ENABLED,intStatusByMpqcIdMap.get(mpqc.Id));
                System.enqueueJob(new CallManagerQueueable(callManager));
            }
        }
    }

    /**
     * @description Método encargado de crear una nueva instancia del objeto 'MPIntegrationStatus__c'
     * @author Juan Felipe Muriel | 05-08-2024 
     * @param mpqcId Id de una condición de presupuesto (MPQuoteCondition__c)
     * @return Nueva instancia de 'MPIntegrationStatus__c'
     */
    private static MPIntegrationStatus__c getIntStatus(Id mpqcId) {
        MPIntegrationStatus__c newLog = new MPIntegrationStatus__c();
        newLog.MPIntegrationName__c    = INTEGRATION_NAME;
        newLog.MPParentId__c           = String.valueOf(mpqcId);
        newLog.MPStatus__c             = IN_PROGRESS_STATUS;
        return newLog;
    }
}
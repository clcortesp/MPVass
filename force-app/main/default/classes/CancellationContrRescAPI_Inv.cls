/**
 * @description Clase tipo invocable que llama la clase manager de la intergracion 4.6 de Cancelación Termino Contrato
 * @group Proyecto MP
 * @author Miller Mora
 * @since 29-10-2024 - Creación
 */
public with sharing class CancellationContrRescAPI_Inv {

     /** Estado inicial de la integración */
     private static final String IN_PROGRESS_STATUS = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
     /** Nombre de la integración */
     public static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPCancellationContractRescission').DeveloperName;
     /** Número máximo de reintentos a la API */
     public static final Boolean RETRY = MPIntegrationSetting__mdt.getInstance('MPCancellationContractRescission').MPRetry__c;
 
     /**
      * @description Método invocable para ser llamado desde un Flow.
      * Este método encola un trabajo Queueable que ejecutará la lógica del CancellationContrRescAPICallManager.
      * @author Miller Mora | 29-08-2024 
      * @param OrderIds List<Id> - Lista de IDs de las ordenes que serán procesadas.
      */
     @InvocableMethod(label='Invoke Call Manager from Flow CancellationContrRescAPI' description='Invokes the Call Manager Queueable from Flow')
     public static void invokeFromFlowCancellationContrRescAPI(List<Order> lstorders) {
 
         Order orderRescission = lstorders[NumbersEnum.CERO.ordinal()];
         if(orderRescission != null){
             // Creación del log de integración
             MPIntegrationStatus__c intStatus = getIntStatus(orderRescission.Id);
             insert intStatus;
 
             System.debug('intStatus intStatus' + intStatus.MPStatus__c);
             // Ejecutar integración
             CancellationContrRescAPICallManager callManager = new CancellationContrRescAPICallManager(orderRescission,RETRY,intStatus);
             System.enqueueJob(new CallManagerQueueable(callManager));
         }
 
    }
 
 
     /**
      * @description Método encargado de crear una nueva instancia del objeto 'MPIntegrationStatus__c'
      * @author Miller Mora | 29-08-2024 
      * @param orderId Id de la Orden
      * @return Nueva instancia de 'MPIntegrationStatus__c'
      */
     private static MPIntegrationStatus__c getIntStatus(Id orderId) {
         MPIntegrationStatus__c newLog = new MPIntegrationStatus__c();
         newLog.MPIntegrationName__c    = INTEGRATION_NAME;
         newLog.MPParentId__c           = String.valueOf(orderId);
         newLog.MPStatus__c             = IN_PROGRESS_STATUS;
         return newLog;
     }

}
/**
 * @description Clase usada desde 'Screen Flows' para invocar la integración de Modificación de contratos.
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 26-08-2024 - Creación
 */
public with sharing class ContractModificationAPI_Inv {
    /** Estado inicial de la integración */
    private static final String IN_PROGRESS_STATUS = Utilities_cls.getInProgressValue('MPIntegrationStatus__c', 'MPStatus__c');
    /** Nombre de la integración */
    private static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPContractModification').DeveloperName;
    /** Permitir o no hacer reintentos */
    public static final Boolean IS_RETRY_ENABLED = false;

    /**
     * @description Método encargado de ejecutar la integración de Modificación de contratos
     * @author Juan Felipe Muriel | 29-08-2024 
     * @param contractList Contratos a activar.
     */
    @InvocableMethod(label='Call the Contract Modification API' description='Call the Contract Modification API.' category='Contract')
    public static void contractModificationAPI(List<Contract> contractList) {

        Map<Id,MPIntegrationStatus__c> intStatusByContractIdMap = new Map<Id,MPIntegrationStatus__c>();
        List<Contract> contractsToUpdateList = new List<Contract>();

        // Recorrer todos los contratos y organizar mapa
        for(Contract contract : contractList){
            if(!intStatusByContractIdMap.containsKey(contract.Id)){
                MPIntegrationStatus__c newLog = getIntStatus(contract.Id);
                intStatusByContractIdMap.put(contract.Id, newLog);
            }
        }
        
        // Insertar logs de la integración (MPIntegrationStatus__c)
        if(!intStatusByContractIdMap.isEmpty()){
            insert intStatusByContractIdMap.values();
        }

        // asignar a los contratos la lupa al log de integraciones
        for(Contract contract : contractList){
            if(intStatusByContractIdMap.containsKey(contract.Id)){
                Contract contractTemp = new Contract(
                    id = contract.Id,
                    MPContractModificationStatus__c = intStatusByContractIdMap.get(contract.Id).Id
                );
                contractsToUpdateList.add(contractTemp);
            }
        }

        // Actualizar contratos
        if(!contractsToUpdateList.isEmpty()){
            update contractsToUpdateList;
        }

        // Recorrer contratos y encolar trabajos
        for(Contract contract : contractList ){
            if(intStatusByContractIdMap.containsKey(contract.Id) && !Test.isRunningTest()){
                ContractModificationAPICallManager callManager = new ContractModificationAPICallManager(contract,IS_RETRY_ENABLED,intStatusByContractIdMap.get(contract.Id));
                System.enqueueJob(new CallManagerQueueable(callManager));
            }
        }
    }

    /**
     * @description Método encargado de crear una nueva instancia del objeto 'MPIntegrationStatus__c'
     * @author Juan Felipe Muriel | 26-08-2024 
     * @param contractId Id de un contrato
     * @return Nueva instancia de 'MPIntegrationStatus__c'
     */
    private static MPIntegrationStatus__c getIntStatus(Id contractId) {
        MPIntegrationStatus__c newLog = new MPIntegrationStatus__c();
        newLog.MPIntegrationName__c    = INTEGRATION_NAME;
        newLog.MPParentId__c           = String.valueOf(contractId);
        newLog.MPStatus__c             = IN_PROGRESS_STATUS;
        return newLog;
    }
    
}
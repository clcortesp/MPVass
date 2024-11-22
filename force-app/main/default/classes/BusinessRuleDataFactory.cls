/**
 * @description Clase para hacer mineria de datos para hacer llamadas a servicios externos
 * @group Proyecto MP
 * @author Juan Felipe Muriel
 * @since 05-08-2024 - Creación
 */
public with sharing class BusinessRuleDataFactory {

    /** Developer name del tipo de registro de los objetos de alquiler*/
    public static final String  RENTAL_OBJECT_RT_ID = Schema.SObjectType.MPStore__c.getRecordTypeInfosByDeveloperName().get('MPRentalObject').getRecordTypeId();
    public static final String EMPTY = '';
    /**
    * @description Método que recolecta toda la información necesaria para hacer la llamada a la API de 
    * precios. 
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param mpqc Registro al cual se debe asignar el valor de la respuesta de la API.
    * @return Payload serializado a JSON desde el tipo PricingAPIWrapper.Request
    */
    public static PricingAPIWrapper.Request getPricingData(MPQuoteCondition__c mpqc){ 
        MPQuoteCondition__c mpqcData = new MPQuoteCondition__c();
        PricingAPIWrapper.Request requestData = new PricingAPIWrapper.Request();
        
        // Obtener datos relacionados al MPQuoteCondition__c
        mpqcData =[
            SELECT  MPQuote__r.MPStore__c, MPQuote__r.Opportunity.MPMall__r.MPExternalCode__c, 
            MPQuote__r.MPStore__r.MPCeBe__c, MPQuote__r.MPStore__r.MPFootage__c,
            MPQuote__r.Opportunity.MPBrand__r.MPSector__r.MPCategory__c,
            MPQuote__r.Opportunity.MPBrand__r.MPSector__r.MPExternalCode__c
            FROM    MPQuoteCondition__c WHERE Id =: mpqc.Id  LIMIT   1
            ];
        if(mpqcData == null){
            return requestData;
        }
        // Obtener los external Id's de los objetos de alquiler relacionados a la tienda
        Set<String> relatedROExtIdSet = new Set<String>();
        for (MPRentalObjectByStore__c ro : [
            SELECT MPRentalObject__r.MPExternalCode__c FROM   MPRentalObjectByStore__c
            WHERE  MPStore__c =: mpqcData.MPQuote__r.MPStore__c
            AND    MPRentalObject__r.RecordType.Id =: RENTAL_OBJECT_RT_ID
        ]) {
            relatedROExtIdSet.add(ro.MPRentalObject__r.MPExternalCode__c);
        }
        // Armar estructura de datos para usar en el request 
        requestData.mallCode = mpqcData.MPQuote__r.Opportunity != null 
                               && mpqcData.MPQuote__r.Opportunity.MPMall__r != null
                               && mpqcData.MPQuote__r.Opportunity.MPMall__r.MPExternalCode__c != null
                               ?  mpqcData.MPQuote__r.Opportunity.MPMall__r.MPExternalCode__c : EMPTY;
        requestData.ceBe     = mpqcData.MPQuote__r.MPStore__r != null 
                               && mpqcData.MPQuote__r.MPStore__r.MPCeBe__c != null
                               ? mpqcData.MPQuote__r.MPStore__r.MPCeBe__c : EMPTY;
        requestData.category = mpqcData.MPQuote__r.Opportunity != null 
                               && mpqcData.MPQuote__r.Opportunity.MPBrand__r != null 
                               && mpqcData.MPQuote__r.Opportunity.MPBrand__r.MPSector__r != null
                               && mpqcData.MPQuote__r.Opportunity.MPBrand__r.MPSector__r.MPCategory__c != null
                               ? mpqcData.MPQuote__r.Opportunity.MPBrand__r.MPSector__r.MPCategory__c : EMPTY;
        requestData.sector   = mpqcData.MPQuote__r.Opportunity != null 
                               && mpqcData.MPQuote__r.Opportunity.MPBrand__r != null 
                               && mpqcData.MPQuote__r.Opportunity.MPBrand__r.MPSector__r != null
                               && mpqcData.MPQuote__r.Opportunity.MPBrand__r.MPSector__r.MPExternalCode__c != null
                               ? mpqcData.MPQuote__r.Opportunity.MPBrand__r.MPSector__r.MPExternalCode__c : EMPTY;
        requestData.areaM2   = mpqcData.MPQuote__r.MPStore__r != null ? mpqcData.MPQuote__r.MPStore__r.MPFootage__c : null;
        requestData.rentalObjects = relatedROExtIdSet.isEmpty() ? null : relatedROExtIdSet;
        
        return requestData;
    }

    /**
    * @description Método que recolecta toda la información del request para hacer la llamada a la API de 
    * Actualizacion de fecha de contratos. 
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param contract Registro al cual se debe extraer la información.
    * @return Payload serializado a JSON desde el tipo ContractDatesUpdateAPIWrapper.Request
    */
    public static ContractDatesUpdateAPIWrapper.Request getContractDatesUpdateAPIRequest(Contract contract){
        Contract contractData = new Contract();
        contractData = [SELECT Id, MPRentalStartDate__c, MPProbableOpeningDate__c  FROM Contract WHERE Id =: contract.Id LIMIT 1];
        ContractDatesUpdateAPIWrapper.Request requestData = new ContractDatesUpdateAPIWrapper.Request();
        requestData.invoiceDate = contractData.MPRentalStartDate__c  ;
        requestData.deliveryActDate = contractData.MPProbableOpeningDate__c ;
        requestData.openingDate = contractData.MPProbableOpeningDate__c ;

        return requestData;
    }

    /**
    * @description Método que recolectar los parámetros para hacer el llamado a la API de 
    * Actualizacion de fecha de contratos. 
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param contract Registro al cual se debe extraer la información.
    * @return Payload serializado a JSON desde el tipo ContractDatesUpdateAPIWrapper.Params
    */
    public static ContractDatesUpdateAPIWrapper.Params getContractDatesUpdateAPIParams(Contract contract){
        Contract contractData = new Contract();
        contractData = [
            SELECT MPExternalCode__c, MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c 
            FROM   Contract 
            WHERE  Id =: contract.Id 
            LIMIT  1
        ];

        ContractDatesUpdateAPIWrapper.Params params = new ContractDatesUpdateAPIWrapper.Params();
        params.companyCode   = contractData.MPCurrentOrder__r != null 
                            && contractData.MPCurrentOrder__r.MP_Local__r != null 
                            && contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r != null
                            && contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = contractData.MPExternalCode__c != null ? contractData.MPExternalCode__c : EMPTY ;

        return params;
    }

    /**
    * @description Método que recolectar los parámetros para hacer el llamado a la API de 
    * Activación de fecha de contratos. 
    * @author Juan Felipe Muriel | 22-08-2024 
    * @param contract Registro al cual se debe extraer la información.
    * @return Payload serializado a JSON desde el tipo ContractActivationAPICallManager.Params
    */
    public static ContractActivationAPIWrapper.Params getContractActivationAPIParams(Contract contract){
        Contract contractData = new Contract();
        contractData = [
            SELECT MPExternalCode__c, MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c 
            FROM   Contract 
            WHERE  Id =: contract.Id 
            LIMIT  1
        ];

        ContractActivationAPIWrapper.Params params = new ContractActivationAPIWrapper.Params();
        params.companyCode   = contractData.MPCurrentOrder__r != null 
                            && contractData.MPCurrentOrder__r.MP_Local__r != null 
                            && contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r != null
                            && contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = contractData.MPExternalCode__c != null ? contractData.MPExternalCode__c : EMPTY ;

        return params;
    }

    /**
    * @description Método que recolectar los parámetros para hacer el llamado a la API de 
    * modificación de contratos. 
    * @author Juan Felipe Muriel | 28-08-2024 
    * @param contract contrato al cual se debe extraer la información.
    * @return Payload serializado a JSON desde el tipo ContractDatesUpdateAPIWrapper.Params
    */
    public static ContractWrapperSAP.Params getContractModificationAPIParams(Contract contract){
        Contract contractData = new Contract();
        contractData = [
            SELECT MPExternalCode__c, MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c 
            FROM   Contract 
            WHERE  Id =: contract.Id
            LIMIT  1
        ];

        ContractWrapperSAP.Params params = new ContractWrapperSAP.Params();
        params.companyCode   = contractData.MPCurrentOrder__r != null 
                            && contractData.MPCurrentOrder__r.MP_Local__r != null 
                            && contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r != null
                            && contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  contractData.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = contractData.MPExternalCode__c != null ? contractData.MPExternalCode__c : EMPTY ;

        return params;
    }

    /**
    * @description Método donde se construye y Mapea todo el Wrapper
    * @author Miller Mora | 19-08-2024 
    * @param contractIds Ids de los contratos creados.
    * @return Mapeo del contractList Warpper completo.
    */
    public static List<ContractWrapperSAP.Request> getContractDetails(List<Id> contractIds) {

        List<Contract> lstContracts = getContracts(contractIds);

        // Obtener las órdenes relacionadas y los mapas
        Map<Id, Order> relatedOrdersMap = getRelatedOrdersMap(contractIds);
        Map<Id, List<MPOrderCondition__c>> orderConditionsMap = getOrderConditionsMap(relatedOrdersMap.keySet());
        Map<Id, List<MPOrderCondition__c>> orderVolumeConditionsMap = getVolumeOrderConditionsMap(relatedOrdersMap.keySet());
        Map<Id, List<MPRentalObjectByStore__c>> rentalObjectsMap = getRentalObjectsMap(relatedOrdersMap);
        Map<Id, Account> accountMap = getAccountMap(lstContracts);
        //Map<Id, List<Contact>> contactsMap = getContactsMap(accountMap.keySet(), relatedOrdersMap);
        Map<Id, List<MPOrderCondition__c>> apConditionsMap = getAPConditionsForContracts(new Set<Id>(contractIds));


        System.debug('relatedOrdersMap::::::::'+ relatedOrdersMap);
        System.debug('orderConditionsMap::::::::'+ orderConditionsMap);
        System.debug('orderVolumeConditionsMap::::::::'+ orderVolumeConditionsMap);
        System.debug('rentalObjectsMap::::::::'+ rentalObjectsMap);
        System.debug('accountMap::::::::'+ accountMap);
        //System.debug('contactsMap::::::::'+ contactsMap);
        System.debug('apConditionsMap::::::::'+ apConditionsMap);

        List<ContractWrapperSAP.Request> contractList = new List<ContractWrapperSAP.Request>();

        // Itera sobre los contratos para llenar los detalles
        for (Contract objContract : lstContracts) {
            ContractWrapperSAP.Request contractWrapper = new ContractWrapperSAP.Request();
            
            // Llenar data del contrato
            fillBasicContractDetails(contractWrapper, objContract, apConditionsMap.get(objContract.Id));
    
            // Llenar condiciones de orden
            Order relatedOrder = relatedOrdersMap.get(objContract.Id);
            System.debug('relatedOrder::::::::'+ relatedOrder);

            if (relatedOrder != null && orderConditionsMap.containsKey(objContract.Id)) {
                contractWrapper.condition = fillConditions(orderConditionsMap.get(objContract.Id)); 
                contractWrapper.termAdjust = fillTermAdjustDetails(orderConditionsMap.get(objContract.Id));
            }

            if (relatedOrder != null && orderVolumeConditionsMap.containsKey(objContract.Id)) {
                contractWrapper.salesBasedRentAgreement = fillSalesBasedRentAgreement(orderVolumeConditionsMap.get(objContract.Id));
            }
    
            // Llenar objetos de alquiler
            if (relatedOrder != null && rentalObjectsMap.containsKey(relatedOrder.MP_Local__c)) { 
                contractWrapper.rentalObject = fillRentalObjects(rentalObjectsMap.get(relatedOrder.MP_Local__c));
            }
    
            // Llenar los datos de la cuenta principal, contactos y contactos asociados al contrato
            contractWrapper.partner = fillPartnerDetails(objContract, accountMap.get(objContract.AccountId), relatedOrder);
            contractList.add(contractWrapper);
        }
        
        System.debug('contractList::::::::'+ JSON.serialize(contractList) );

        return contractList;
        
    }

    /**
    * @description Método para obtener todos los datos que se necesitan de los contratos desde Salesforce
    * @author Miller Mora | 19-08-2024 
    * @param contractIds lista de los contratos.
    * @return Consulta de los contratos obtenidos.
    */
    private static List<Contract> getContracts(List<Id> contractIds) {
        return [SELECT Id, Name, AccountId, MPCurrentOrder__r.MP_Local__r.MPContractType__r.MPExternalCode__c, MPMall__r.MPExternalCode__c, MPBrand__r.name, ContractNumber,
                       MPCurrentOrder__r.MP_Local__r.MPCeBe__c,StartDate, CurrencyIsoCode, EndDate, MPCurrentOrder__r.MP_Local__r.MPContractType__r.MPPaymentCondition__c,
                       MPBrand__r.MPSector__r.MPExternalCode__c, MPCurrentOrder__r.MP_Local__r.MPContractType__r.MPIsProRataMethod__c, MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c,
                       MPCurrentOrder__r.MPContractStartDate__c, MPCurrentOrder__r.MPContractEndDate__c
                FROM Contract 
                WHERE Id IN :contractIds];
    }

    /**
    * @description Método para obtener las órdenes relacionadas a los contratos 
    * @author Miller Mora | 19-08-2024 
    * @param contractIds lista de los contratos.
    * @return Consultad e las ordenes obtenidos.
    */
    private static Map<Id, Order> getRelatedOrdersMap(List<Id> contractIds) {
        Map<Id, Order> relatedOrdersMap = new Map<Id, Order>();
    
        List<Order> orders = [
            SELECT Id, MP_Local__c, ContractId, MP_Local__r.MPSociety__c, MP_Local__r.MPExternalCode__c
            FROM Order 
            WHERE ContractId IN :contractIds
        ];
        
        for (Order ord : orders) {
            relatedOrdersMap.put(ord.ContractId, ord);
        }
        
        System.debug('relatedOrdersMap contents: ' + relatedOrdersMap);
        return relatedOrdersMap;
    }

    /**
    * @description Método para obtener las condiciones de las órdenes  
    * @author Miller Mora | 19-08-2024 
    * @param contractIds Set de Ids de los contratos que tienen relacion a la Orden.
    * @return mapa orderConditionsMap lleno.
    */
    private static Map<Id, List<MPOrderCondition__c>> getOrderConditionsMap(Set<Id> contractIds) {
        

        Map<Id, List<MPOrderCondition__c>> orderConditionsMap = new Map<Id, List<MPOrderCondition__c>>();

        List<MPOrderCondition__c> lstOrderConditions = [
            SELECT Id,MPExternalPurpose__c, MPOrder__c, MPCalculationRule__r.MPExternalCode__c, MPConditionClass__r.MPExternalCode__c, MPOrder__r.MPContractStartDate__c, MPOrder__r.MPContractEndDate__c, 
                MPOrder__r.Contract.CurrencyIsoCode, MPConditionClass__r.Name, MPConditionClass__r.ProductCode, MPOrder__r.Contract.MPEndDate__c,
                MPStartDate__c, MPEndDate__c, MPValue__c, MPAdjustment__r.MPExternalCode__c, MPAdjustment__r.MPAdjustmentType__c, MPOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c,
                MPTimeFrequency__c
            FROM MPOrderCondition__c
            WHERE MPOrder__r.ContractId IN :contractIds ORDER BY MPEndDate__c ASC
        ];
        for (MPOrderCondition__c condition : lstOrderConditions) {
            Id contractId = condition.MPOrder__r.ContractId;
            if (!orderConditionsMap.containsKey(contractId)) {
                orderConditionsMap.put(contractId, new List<MPOrderCondition__c>());
            }
            orderConditionsMap.get(contractId).add(condition);
        }

        System.debug('orderConditionsMap contents: ' + orderConditionsMap);
        return orderConditionsMap;
    }

    /**
    * @description Método para obtener las condiciones de las órdenes  
    * @author Miller Mora | 19-08-2024 
    * @param contractIds Set de Ids de los contratos que tienen relacion a la Orden.
    * @return mapa orderVolumeConditionsMap lleno.
    */
    private static Map<Id, List<MPOrderCondition__c>> getVolumeOrderConditionsMap(Set<Id> contractIds) {

        Map<Id, List<MPOrderCondition__c>> orderVolumeConditionsMap = new Map<Id, List<MPOrderCondition__c>>();
        
        List<MPOrderCondition__c> lstOrderConditions = [
            SELECT Id,MPExternalPurpose__c, MPOrder__c, MPCalculationRule__r.MPExternalCode__c, MPConditionClass__r.MPExternalCode__c, 
                MPOrder__r.Contract.CurrencyIsoCode, MPConditionClass__r.Name, MPConditionClass__r.ProductCode, 
                MPStartDate__c, MPEndDate__c, MPValue__c, MPAdjustment__r.MPExternalCode__c, MPAdjustment__r.MPAdjustmentType__c, MPOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c,
                MPInitialVolume__c, MPFinalVolume__c, MPVolumenValue__c
            FROM MPOrderCondition__c
            WHERE MPOrder__r.ContractId IN :contractIds AND  MPConditionClass__r.MPExternalCode__c LIKE '%AP%' 
                  AND (MPInitialVolume__c != NULL OR MPFinalVolume__c != NULL OR  MPVolumenValue__c != NULL) ORDER BY MPConditionClass__r.MPExternalCode__c ASC
        ];
        for (MPOrderCondition__c condition : lstOrderConditions) {
            Id contractId = condition.MPOrder__r.ContractId;
            if (!orderVolumeConditionsMap.containsKey(contractId)) {
                orderVolumeConditionsMap.put(contractId, new List<MPOrderCondition__c>());
            }
            orderVolumeConditionsMap.get(contractId).add(condition);
        }

        System.debug('orderVolumeConditionsMap contents: ' + orderVolumeConditionsMap);
        return orderVolumeConditionsMap;
    }

    private static Map<Id, List<MPOrderCondition__c>> getAPConditionsForContracts(Set<Id> contractIds) {
    // Mapa para almacenar la condición AP de menor valor para cada contrato
        Map<Id, List<MPOrderCondition__c>> apConditionsMap = new Map<Id, List<MPOrderCondition__c>>();
        
        List<MPOrderCondition__c> apConditions = [
            SELECT Id,MPExternalPurpose__c, MPOrder__r.ContractId, MPConditionClass__r.MPExternalCode__c, MPStartDate__c, MPValue__c
            FROM MPOrderCondition__c
            WHERE MPOrder__r.ContractId IN :contractIds AND MPConditionClass__r.MPExternalCode__c LIKE 'AP%'
            ORDER BY MPOrder__r.ContractId, MPConditionClass__r.MPExternalCode__c ASC
        ];
        System.debug('lstapConditions' + apConditions);
      
        for (MPOrderCondition__c condition : apConditions) {
            Id contractId = condition.MPOrder__r.ContractId;
            if (!apConditionsMap.containsKey(contractId)) {
                apConditionsMap.put(contractId, new List<MPOrderCondition__c>());
            }
            apConditionsMap.get(contractId).add(condition);
        }
        
        System.debug('apConditionsMap' + apConditionsMap);

        return apConditionsMap;
    }

    /**
    * @description Método para obtener los objetos de alquiler
    * @author Miller Mora | 19-08-2024 
    * @param relatedOrdersMap mapa con las ordenes del contrato.
    * @return mapa rentalObjectsMap lleno.
    */
    private static Map<Id, List<MPRentalObjectByStore__c>> getRentalObjectsMap(Map<Id, Order> relatedOrdersMap) {
        Set<Id> localIds = new Set<Id>();
        for (Order order : relatedOrdersMap.values()) {
            if (order.MP_Local__c != null) {
                localIds.add(order.MP_Local__c);
            }
        }

        List<MPRentalObjectByStore__c> lstRentalObjects = [
            SELECT Id, MPStore__c, MPRentalObject__r.MPExternalCode__c
            FROM MPRentalObjectByStore__c
            WHERE MPStore__c IN :localIds
        ];

        Map<Id, List<MPRentalObjectByStore__c>> rentalObjectsMap = new Map<Id, List<MPRentalObjectByStore__c>>();
        for (MPRentalObjectByStore__c rentalObject : lstRentalObjects) {
            if (!rentalObjectsMap.containsKey(rentalObject.MPStore__c)) {
                rentalObjectsMap.put(rentalObject.MPStore__c, new List<MPRentalObjectByStore__c>());
            }
            rentalObjectsMap.get(rentalObject.MPStore__c).add(rentalObject);
        }
        return rentalObjectsMap;
    }

    /**
    * @description Método para obtener las cuentas principales
    * @author Miller Mora | 19-08-2024 
    * @param contracts lista de contratos.
    * @return mapa getAccountMap lleno.
    */
    private static Map<Id, Account> getAccountMap(List<Contract> contracts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contract objContract : contracts) {
            accountIds.add(ObjContract.AccountId);
        }

        return new Map<Id, Account>([
            SELECT Id, MPExternalCode__c, Type
            FROM Account
            WHERE Id IN :accountIds
        ]);
    }

    /**
    * @description Método para obtener los contactos relacionados
    * @author Miller Mora | 19-08-2024 
    * @param accountIds Set de cuanta asociada al contrato.
    * @param relatedOrdersMap mapa con las ordenes del contrato.
    * @return mapa contactsMap lleno.
    */
    /*
    private static Map<Id, List<Contact>> getContactsMap(Set<Id> accountIds, Map<Id, Order> relatedOrdersMap) { 
        Set<Id> societyIds = new Set<Id>();
        for (Order order : relatedOrdersMap.values()) {
            if (order.MP_Local__r != null && order.MP_Local__r.MPSociety__c != null) {
                societyIds.add(order.MP_Local__r.MPSociety__c);
            }
        }

        List<Contact> lstContacts = [
            SELECT Id, Name, AccountId
            FROM Contact
            WHERE AccountId IN :accountIds OR AccountId IN :societyIds
        ];

        Map<Id, List<Contact>> contactsMap = new Map<Id, List<Contact>>();
        for (Contact contact : lstContacts) {
            if (!contactsMap.containsKey(contact.AccountId)) {
                contactsMap.put(contact.AccountId, new List<Contact>());
            }
            contactsMap.get(contact.AccountId).add(contact);
        }
        return contactsMap;
    }*/

    
    /**
    * @description Método para Mapear el wrapper del contrato
    * @author Miller Mora | 19-08-2024 
    * @param contractWrapper wrapper del contrato.
    * @param ObjContract contrato actual.
    * @return Mapeo del wrapper de contrato.
    */
    private static void fillBasicContractDetails(ContractWrapper contractWrapper, Contract ObjContract, List<MPOrderCondition__c> apConditions) {

        contractWrapper.otype =  ObjContract.MPCurrentOrder__c != null && ObjContract.MPCurrentOrder__r.MP_Local__c != null && ObjContract.MPCurrentOrder__r.MP_Local__r.MPContractType__c != null
                                 ?  ObjContract.MPCurrentOrder__r.MP_Local__r.MPContractType__r.MPExternalCode__c : EMPTY;
        contractWrapper.id = EMPTY;//////No esta en el JSON de ellos
        /**---------Inicia lógica para capturar el nombre Requerido por eL CLIENTE */
        String brandName = ObjContract.MPBrand__c != null ?  ObjContract.MPBrand__r.Name : EMPTY; 
        String contractNumber = ObjContract.ContractNumber;
        String mallExternalCode = ObjContract.MPMall__c != null ?  ObjContract.MPMall__r.MPExternalCode__c : EMPTY; 
        contractWrapper.Name = brandName + '_' + contractNumber + '_' + mallExternalCode;
        /** --------Temina lógica */
        contractWrapper.cebe = ObjContract.MPCurrentOrder__c != null && ObjContract.MPCurrentOrder__r.MP_Local__c != null ? ObjContract.MPCurrentOrder__r.MP_Local__r.MPCeBe__c : EMPTY;   

        /** Inicio logica fechas */       
        String formattedStartDate = ObjContract.startDate != null ? BusinessRuleDataFactory.formatDateToDateTimeString(ObjContract.startDate) : EMPTY;
        String formattedEndDate = ObjContract.MPCurrentOrder__r.MPContractEndDate__c != null ? BusinessRuleDataFactory.formatDateToDateTimeString(ObjContract.MPCurrentOrder__r.MPContractEndDate__c) : EMPTY;

        contractWrapper.startDate = formattedStartDate;
        contractWrapper.endDate = formattedEndDate;
        contractWrapper.adjmFirstDate = formattedStartDate;//////No esta en el JSON de ellos
        contractWrapper.indexFirstDate = formattedStartDate;//////No esta en el JSON de ellos
        /** --------Temina lógica */


        /** Inicio Logica para llenar el campo salesStartDate */
        //Si tiene escala se va null y trae escala valor del AP
        if (apConditions != null && apConditions.size() > 1) {
            contractWrapper.percSalesAsRent = null;
            System.debug('Más de una condición AP encontrada para el contrato ' + objContract.Id + '. percSalesAsRent se establece en null.');
            contractWrapper.isSalesRelated = true;
        } else if (apConditions != null && apConditions.size() == 1) {
            contractWrapper.percSalesAsRent = apConditions[0].MPValue__c != null ? apConditions[0].MPValue__c : 0;
            System.debug('Una sola condición AP encontrada para el contrato ' + objContract.Id + '. percSalesAsRent se establece en ' + contractWrapper.percSalesAsRent);
            contractWrapper.isSalesRelated = true;
        } else {
            contractWrapper.percSalesAsRent = null;
            contractWrapper.isSalesRelated =  null;
            System.debug('No se encontró ninguna condición AP para el contrato ' + objContract.Id + '. percSalesAsRent se establece en null.');
        }

        System.debug('percSalesAsRent ' + contractWrapper.percSalesAsRent);

        if (apConditions != null && !apConditions.isEmpty()) {
            MPOrderCondition__c selectedCondition;
            Integer minCode = 99999999;  // Iniciar con un valor alto
    
            for (MPOrderCondition__c condition : apConditions) {
                Integer currentCode = Integer.valueOf(condition.MPConditionClass__r.MPExternalCode__c.replace('AP', ''));
                if (currentCode < minCode) {
                    minCode = currentCode;
                    selectedCondition = condition;
                }
            }
    
            if (selectedCondition != null) {
                contractWrapper.salesStartDate = selectedCondition.MPStartDate__c != null ? formatDateToDateTimeString(selectedCondition.MPStartDate__c) : EMPTY;
                System.debug('Condición AP seleccionada - salesStartDate: ' + contractWrapper.salesStartDate);
            }
        } else {
            contractWrapper.salesStartDate = EMPTY;
            System.debug('No se encontró ninguna condición AP para el contrato ' + objContract.Id + '. salesStartDate se establece en vacío.');
        }
        /** --------Temina lógica */
        
        contractWrapper.currencyIsoCode = ObjContract.CurrencyIsoCode;
        contractWrapper.offerId = ObjContract.ContractNumber;
        
        contractWrapper.adjustmentRule = 'IND_PE_C/3';
        contractWrapper.salesCurrencyIsoCode = ObjContract.CurrencyIsoCode;
        
        /**---------Inicia lógica para capturar el Año del contrato*/
        Integer year = ObjContract.StartDate.year();
        contractWrapper.indexSeriesBaseYear = String.valueOf(year);
        /** --------Temina lógica */
        contractWrapper.indexSeries = 'IPC_P';
        contractWrapper.paymentCondition = ObjContract.MPCurrentOrder__c != null && ObjContract.MPCurrentOrder__r.MP_Local__c != null && ObjContract.MPCurrentOrder__r.MP_Local__r.MPContractType__c != null 
                                           ? ObjContract.MPCurrentOrder__r.MP_Local__r.MPContractType__r.MPPaymentCondition__c : EMPTY;         
        contractWrapper.sector = ObjContract.MPBrand__c != null && ObjContract.MPBrand__r.MPSector__c != null ?  ObjContract.MPBrand__r.MPSector__r.MPExternalCode__c : EMPTY;  
        contractWrapper.isMainContract = true;
        contractWrapper.note = EMPTY;
        
        contractWrapper.lastInvoiceDate = EMPTY;//////No esta en el JSON de ellos
        contractWrapper.isProRataMethod = ObjContract.MPCurrentOrder__c != null && ObjContract.MPCurrentOrder__r.MP_Local__c != null && ObjContract.MPCurrentOrder__r.MP_Local__r.MPContractType__c != null 
        ? ObjContract.MPCurrentOrder__r.MP_Local__r.MPContractType__r.MPIsProRataMethod__c : null;
        contractWrapper.companyCode =  ObjContract.MPCurrentOrder__c != null && ObjContract.MPCurrentOrder__r.MP_Local__c != null && ObjContract.MPCurrentOrder__r.MP_Local__r.MPSociety__c != null 
                                       ? ObjContract.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY;   
        
    }


    
    /**
    * @description Métodos Para Mapear el objeto conditions
    * @author Miller Mora | 19-08-2024 
    * @param lstOrderConditions lista de order Conditions.
    * @return el Wrapper Conditions mapeado.
    */
    private static List<ContractWrapper.Condition> fillConditions(List<MPOrderCondition__c> lstOrderConditions) {
        List<ContractWrapper.Condition> conditions = new List<ContractWrapper.Condition>();
        for (MPOrderCondition__c objOrderConditions : lstOrderConditions) {
            ContractWrapper.Condition condition = new ContractWrapper.Condition();
            condition.calcRule = objOrderConditions.MPCalculationRule__c != null ? objOrderConditions.MPCalculationRule__r.MPExternalCode__c : EMPTY;
            condition.otype = objOrderConditions.MPConditionClass__c != null ? objOrderConditions.MPConditionClass__r.MPExternalCode__c : EMPTY; 
            condition.currencyIsoCode = objOrderConditions.MPOrder__c != null ? objOrderConditions.MPOrder__r.Contract.CurrencyIsoCode : EMPTY;  
            condition.distributionRule = 'MP01';
            condition.externalPurpose = objOrderConditions.MPExternalPurpose__c;  
            condition.unitPrice = objOrderConditions.MPValue__c; 
             /** Inicio logica fechas */
            String formattedStartDate = objOrderConditions.MPStartDate__c != null ? BusinessRuleDataFactory.formatDateToDateTimeString(objOrderConditions.MPStartDate__c) : EMPTY;
            String formattedEndDate = objOrderConditions.MPEndDate__c != null ? BusinessRuleDataFactory.formatDateToDateTimeString(objOrderConditions.MPEndDate__c) : EMPTY; 
           
            if (objOrderConditions.MPTimeFrequency__c == 'Única') {
                condition.validFrom = formattedStartDate;
                condition.validTo = formattedEndDate;
                System.debug('Condition set as Única - validFrom: ' + condition.validFrom + ', validTo: ' + condition.validTo);

            } else {
         
                condition.validFrom = formattedStartDate;
                
                if (objOrderConditions.MPEndDate__c == objOrderConditions.MPOrder__r.Contract.MPEndDate__c) {
                    condition.validTo = EMPTY;  // Última condición, validTo se deja vacío
                    System.debug('Last condition in list - validFrom: ' + condition.validFrom + ', validTo: EMPTY');

                } else {
                    condition.validTo = formattedEndDate;
                    System.debug('Intermediate condition - validFrom: ' + condition.validFrom + ', validTo: ' + condition.validTo);

                }
            }
            /** --------Temina lógica */

            conditions.add(condition);
        }
        return conditions;
    }

    
    /**
    * @description Método Para Mapear el objeto RentalObject
    * @author Miller Mora | 19-08-2024 
    * @param rentalObjectsByStore lista de RentalObject.
    * @return el Wrapper RentalObject mapeado.
    */
    private static List<ContractWrapper.RentalObject> fillRentalObjects(List<MPRentalObjectByStore__c> rentalObjectsByStore) {
        List<ContractWrapper.RentalObject> rentalObjects = new List<ContractWrapper.RentalObject>();
        for (MPRentalObjectByStore__c objRentalObjectByStore : rentalObjectsByStore) {
            ContractWrapper.RentalObject rentalObject = new ContractWrapper.RentalObject();
            rentalObject.id = objRentalObjectByStore.MPRentalObject__c != null ? objRentalObjectByStore.MPRentalObject__r.MPExternalCode__c : EMPTY;   
            rentalObject.otype = 'IM';
            rentalObject.isInfo = false;
            rentalObjects.add(rentalObject);
        }
        return rentalObjects;
    }
    
    /**
    * @description Método Para Mapear las cuentas principales
    * @author Miller Mora | 19-08-2024 
    * @param contract lista de contratos.
    * @param mainAccount mainAccount del contrato.
    * @param contactsMap Mapa de los contactos asociados a la mainAccount del contrato.
    * @param relatedOrder orden relacionada al contrato.
    * @return el Wrapper Partner mapeado.
    */
    private static List<ContractWrapper.Partner> fillPartnerDetails(Contract contract, Account mainAccount, Order relatedOrder) {
        List<ContractWrapper.Partner> partners = new List<ContractWrapper.Partner>();
    
        // Agregar información de la cuenta del contrato
        if (mainAccount != null) {
            ContractWrapper.Partner accountPartner = new ContractWrapper.Partner();
            accountPartner.id = mainAccount.MPExternalCode__c != NULL ? mainAccount.MPExternalCode__c : EMPTY;
            accountPartner.otype = 'TR0600';
            /** Inicio logica fechas */
            String formattedStartDate = contract.MPCurrentOrder__r.MPContractStartDate__c != null ? BusinessRuleDataFactory.formatDateToDateTimeString(contract.MPCurrentOrder__r.MPContractStartDate__c) : EMPTY;
            String formattedEndDate = contract.MPCurrentOrder__r.MPContractEndDate__c != null ? BusinessRuleDataFactory.formatDateToDateTimeString(contract.MPCurrentOrder__r.MPContractEndDate__c) : EMPTY;
           
            accountPartner.validFrom = formattedStartDate;
            accountPartner.validTo = EMPTY;
            partners.add(accountPartner);
        }
    
        /** Agregar información de los contactos, Se agregrara esta funcionalidad en un futuro
        if (relatedOrder != null && contactsMap.containsKey(relatedOrder.MP_Local__r.MPSociety__c)) {
            for (Contact objContact : contactsMap.get(relatedOrder.MP_Local__r.MPSociety__c)) {
                ContractWrapper.Partner contactPartner = new ContractWrapper.Partner();
                contactPartner.id = objContact.Id;
                contactPartner.otype = 'Contact';

                String formattedStartDate = BusinessRuleDataFactory.formatDateToDateTimeString(contract.StartDate);
                contactPartner.validFrom = formattedStartDate;

                String formattedEndDate = BusinessRuleDataFactory.formatDateToDateTimeString(contract.EndDate);
                contactPartner.validTo = formattedEndDate;

                partners.add(contactPartner);
            }
        }*/
    
        return partners;
    }

    
    /**
    * @description Método Para Mapear SalesBasedRentAgreement
    * @author Miller Mora | 19-08-2024 
    * @param lstOrderConditions lista de OrderConditions.
    * @return el Wrapper SalesBasedRentAgreement mapeado.
    */
     private static List<ContractWrapper.SalesBasedRentAgreement> fillSalesBasedRentAgreement(List<MPOrderCondition__c> lstOrderConditions) {

        List<ContractWrapper.SalesBasedRentAgreement> salesBasedRentAgreements = new List<ContractWrapper.SalesBasedRentAgreement>();
        for (MPOrderCondition__c objOrderConditions : lstOrderConditions) {
            ContractWrapper.SalesBasedRentAgreement salesBasedRentAgreement = new ContractWrapper.SalesBasedRentAgreement();
            salesBasedRentAgreement.valueFrom = objOrderConditions.MPInitialVolume__c;
            salesBasedRentAgreement.valueTo = objOrderConditions.MPFinalVolume__c;
            salesBasedRentAgreement.percent = objOrderConditions.MPVolumenValue__c;
            salesBasedRentAgreements.add(salesBasedRentAgreement);
        }
        return salesBasedRentAgreements;
    }

   /**
    * @description Métodos Para Mapear TermAdjust
    * @author Miller Mora | 19-08-2024 
    * @param lstOrderConditions lista de OrderConditions.
    * @return el Wrapper TermAdjust mapeado.
    */
    private static List<ContractWrapper.TermAdjust> fillTermAdjustDetails(List<MPOrderCondition__c> lstOrderConditions) { 

        List<ContractWrapper.TermAdjust> termAdjusts = new List<ContractWrapper.TermAdjust>();
        Integer termCounter = 10;

        for (MPOrderCondition__c objOrderConditions : lstOrderConditions) {
                if (objOrderConditions.MPAdjustment__c != null) {
                    ContractWrapper.TermAdjust termAdjust = new ContractWrapper.TermAdjust();
        
                    termAdjust.termText = objOrderConditions.MPAdjustment__r.MPExternalCode__c; 
                    termAdjust.adjustmentRule = objOrderConditions.MPAdjustment__r.MPExternalCode__c; 
                    termAdjust.elementaryAdjRule = objOrderConditions.MPAdjustment__r.MPExternalCode__c;
                    termAdjust.indexSeries = objOrderConditions.MPAdjustment__r.MPAdjustmentType__c; 
        
                    termAdjust.termNo = String.valueOf(termCounter);
                    termAdjust.conditionType = objOrderConditions.MPConditionClass__c != null ? objOrderConditions.MPConditionClass__r.MPExternalCode__c : EMPTY; 
                    
                    // Inicio lógica fechas
                    String formattedStartDate = objOrderConditions.MPOrder__r.MPContractStartDate__c != null ? BusinessRuleDataFactory.formatDateToDateTimeString(objOrderConditions.MPOrder__r.MPContractStartDate__c) : EMPTY;           
                    termAdjust.indexPointsAdoptionDate = formattedStartDate;
                    termAdjust.firstAdjustmentDate = formattedStartDate; 
                    // Fin lógica fechas
                    
                    termAdjusts.add(termAdjust); // Añadir solo si MPAdjustment__c no es null
                    termCounter += 10;
                }           
            }           
            
        System.debug('termAdjusts::::::::'+ termAdjusts);
        return termAdjusts;

    }

    /**
    * @description Método que convierte una fecha de tipo Date a un string en el formato "yyyy-MM-dd'T'HH:mm:ss"
    * @author Miller Mora | 19-08-2024 
    * @param dateToFormat Cualquier Fecha.
    * @return el fecha formateada.
    */
    public static String formatDateToDateTimeString(Date dateToFormat) {
            if (dateToFormat == null) {
                return null;             }

            String formattedDate = (dateToFormat != null) 
                                    ? DateTime.newInstance(dateToFormat.year(), dateToFormat.month(), dateToFormat.day(), 0, 0, 0).format('yyyy-MM-dd\'T\'HH:mm:ss')
                                    : EMPTY;

            return formattedDate;
        }


    /**
    * @description Método que retorna los parametros necesarios en la integracion 4.1 Get Contract
    * @author Miller Mora | 19-08-2024 
    * @param opportunity Oportunidad.
    * @return parametros del servicio.
    */
    public static GetContractAPIWrapper.Params getContractAPIParams(Opportunity opportunity){
        Opportunity contractData = new Opportunity();
        contractData = [
            SELECT Id,ContractId,Contract.MPExternalCode__c, Contract.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c
            FROM   Opportunity 
            WHERE  Id =: opportunity.Id 
            LIMIT  1
        ];

        GetContractAPIWrapper.Params params = new GetContractAPIWrapper.Params();
        params.companyCode   = contractData.Contract != null 
                            && contractData.Contract.MPCurrentOrder__c != null 
                            && contractData.Contract.MPCurrentOrder__r.MP_Local__c != null
                            && contractData.Contract.MPCurrentOrder__r.MP_Local__r.MPSociety__c != null
                            && contractData.Contract.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  contractData.Contract.MPCurrentOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = contractData.Contract.MPExternalCode__c != null ? contractData.Contract.MPExternalCode__c : EMPTY ;

        return params;
    }
/**
    * @description Método que retorna los parametros necesarios en la integracion 4.1 Get Contract
    * @author Juan Felipe | 16-10-2024 
    * @param order Orden de termino de contrato.
    * @return parametros del servicio.
    */
    public static GetContractAPIWrapper.Params getContractAPIParams(Order order){
        Order contractData = new Order();
        contractData = [
            SELECT Id, Contract.MPExternalCode__c, MP_Local__r.MPSociety__r.MPExternalCode__c
            FROM   Order 
            WHERE  Id =: order.Id 
            LIMIT  1
        ];

        GetContractAPIWrapper.Params params = new GetContractAPIWrapper.Params();
        params.companyCode   = contractData.MP_Local__c != null
                            && contractData.MP_Local__r.MPSociety__c != null
                            && contractData.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  contractData.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = contractData.Contract.MPExternalCode__c != null ? contractData.Contract.MPExternalCode__c : EMPTY ;

        return params;
    }

    /**
    * @description Método que retorna los parametros necesarios en la integracion 4.5 Solicitud Termino de Contrato
    * @author Miller Mora | 17-10-2024 
    * @param order Orden de termino de contrato.
    * @return parametros del servicio.
    */
    public static ContractRescissionAPIWrapper.Params ContractRescissionAPIParams(Order order){
        Order contractData = new Order();
        contractData = [
            SELECT Id, Contract.MPExternalCode__c, MP_Local__r.MPSociety__r.MPExternalCode__c
            FROM   Order 
            WHERE  Id =: order.Id 
            LIMIT  1
        ];

        ContractRescissionAPIWrapper.Params params = new ContractRescissionAPIWrapper.Params();
        params.companyCode   = contractData.MP_Local__c != null
                            && contractData.MP_Local__r.MPSociety__c != null
                            && contractData.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  contractData.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = contractData.Contract.MPExternalCode__c != null ? contractData.Contract.MPExternalCode__c : EMPTY ;

        return params;
    }

     /**
    * @description Método que recolecta toda la información del request para hacer la llamada a la API de 
    * Terminación de contratos. 
    * @author Miller Mora | 17-10-2024 
    * @param order Orden de termino de contrato.
    * @return Payload serializado a JSON desde el tipo ContractRescissionAPIWrapper.Request
    */
   public static ContractRescissionAPIWrapper.Request getContractRescissionAPIRequest(Order order){
        Order orderData = new Order();
        orderData = [SELECT Id,MPExitDate__c,Owner.Name,Owner.Email FROM Order WHERE Id =: order.Id LIMIT 1];
        ContractRescissionAPIWrapper.Request requestData = new ContractRescissionAPIWrapper.Request();
        requestData.closeDate = orderData.MPExitDate__c  ;
        requestData.doCalculation = true  ;
        requestData.doContractBlocking = true  ;
        requestData.requester.fullName = orderData.Owner.Name ;
        requestData.requester.email = orderData.Owner.Email ;

        return requestData;
    }


    /**
    * @description Método que retorna los parametros necesarios en la integracion 4.9 Termino de Contrato Rechazo
    * @author Miller Mora | 22-10-2024 
    * @param ftc Ficha termino de contrato.
    * @return parametros del servicio.
    */
    public static RejectContrRescissionAPIWrapper.Params RejectContrRescissionAPIParams(MPContractTerminationRecords__c ftc){
        MPContractTerminationRecords__c ftcData = new MPContractTerminationRecords__c();
        ftcData = [
            SELECT Id, MPOrder__r.Contract.MPExternalCode__c, MPOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c 
            FROM MPContractTerminationRecords__c
            WHERE  Id =: ftc.Id 
            LIMIT  1
        ];

        RejectContrRescissionAPIWrapper.Params params = new RejectContrRescissionAPIWrapper.Params();
        params.companyCode   = ftcData.MPOrder__c != null
                            && ftcData.MPOrder__r.MP_Local__c != null
                            && ftcData.MPOrder__r.MP_Local__r.MPSociety__c != null
                            && ftcData.MPOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  ftcData.MPOrder__r.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = ftcData.MPOrder__r.Contract.MPExternalCode__c != null ? ftcData.MPOrder__r.Contract.MPExternalCode__c : EMPTY ;

        return params;
    }

     /**
    * @description Método que recolecta toda la información del request para hacer la llamada a la API 4.9 de 
    * Termino de Contrato Rechazo 
    * @author Miller Mora | 22-10-2024 
    * @param ftc Ficha termino de contrato.
    * @return Payload serializado a JSON desde el tipo RejectContrRescissionAPIWrapper.Request
    */
   public static RejectContrRescissionAPIWrapper.Request RejectContrRescissionAPIRequest(MPContractTerminationRecords__c ftc){
        MPContractTerminationRecords__c ftcData = new MPContractTerminationRecords__c();
        ftcData = [
            SELECT Id, MPRejectionReason__c, MPOrder__r.Contract.MPExternalCode__c 
            FROM MPContractTerminationRecords__c 
            WHERE Id = :ftc.id
            LIMIT 1
        ];
        List<MPTerminationRecord__c> rejectedItems = [
            SELECT MPItemCode__c, MPCategory__c 
            FROM MPTerminationRecord__c 
            WHERE FTC__c = :ftc.id AND MPStatus__c = 'Rejected'
        ];
        RejectContrRescissionAPIWrapper.Request requestData = new RejectContrRescissionAPIWrapper.Request();
        //requestData.description = ftcData.MPRejectionReason__c;
        requestData.description = 'Rechazada por Items';

        
        for (MPTerminationRecord__c item : rejectedItems) {
            requestData.itemCodes.add(item.MPItemCode__c);
            requestData.categories.add(item.MPCategory__c);
        }
    
        requestData.closeContractSheetId = ftcData.MPOrder__r.Contract.MPExternalCode__c ;

        return requestData;
    }


    /**
    * @description Método que retorna los parametros necesarios en la integracion 4.8 Termino de Contrato Acuerdo
    * @author Miller Mora | 22-10-2024 
    * @param order Orden de termino de contrato.
    * @return parametros del servicio.
    */
    public static AgreementContRescissionAPIWrapper.Params AgreementContRescissionAPIParams(Order order){
        Order contractData = new Order();
        contractData = [
            SELECT Id, Contract.MPExternalCode__c, MP_Local__r.MPSociety__r.MPExternalCode__c
            FROM   Order 
            WHERE  Id =: order.Id 
            LIMIT  1
        ];

        AgreementContRescissionAPIWrapper.Params params = new AgreementContRescissionAPIWrapper.Params();
        params.companyCode   = contractData.MP_Local__c != null
                            && contractData.MP_Local__r.MPSociety__c != null
                            && contractData.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  contractData.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = contractData.Contract.MPExternalCode__c != null ? contractData.Contract.MPExternalCode__c : EMPTY ;

        return params;
    }


    /**
    * @description Método que recolecta toda la información del request para hacer la llamada a la API 
    * 4.8 Termino de Contrato Acuerdo 
    * @author Miller Mora | 28-10-2024 
    * @param order Orden de termino de contrato.
    * @return Payload serializado a JSON desde el tipo AgreementContRescissionAPIWrapper.Request
    */
    public static AgreementContRescissionAPIWrapper.Request getAgreementContRescissionAPIRequest(Order order) {
    
        Order orderData = [
            SELECT Id, Contract.MPMall__r.Name, Owner.Name, MPLastInvoiceDate__c, MPNumberOfInstalments__c, CurrencyIsoCode, Account.Name, MPContractEndDate__c, 
                   Contract.Name, Contract.MPExternalCode__c, MPExitDate__c, MPFTCPrincipal__c,  MPFTCPrincipal__r.MPCloseContractTotal__c, 
                   MPPaymentMethod__c, MPSpecialConditionToApply__c, Account.MPIdentificationNumber__c,MPSpecialConditionAmount__c,MPSpecialConditionInFavorOf__c, 
                   Contract.MPBrand__r.Name, MPWarrantyUse__c 
            FROM Order 
            WHERE Id = :order.Id 
            LIMIT 1
        ];

        // Consulta para obtener el manager del owner de la orden
        User ownerManager = [
            SELECT Manager.Manager.Name, Manager.Name 
            FROM User 
            WHERE Id = :orderData.OwnerId
            LIMIT 1
        ];
    
        // Consulta de ítems relacionados (MPTerminationRecord__c) con estado y FTC
        List<MPTerminationRecord__c> items = [
            SELECT MPDocumentType__c, MPDocumentNumber__c, MPItemCode__c, MPDescription__c, MPOperationType__c, 
                   MPReferenceDocument__c, MPCategory__c, MPItemValue__c, CurrencyIsoCode 
            FROM MPTerminationRecord__c 
            WHERE FTC__c = :orderData.MPFTCPrincipal__c
        ];
    
        // Consulta de representantes legales (Contactos de tipo Representante Legal) relacionados a la cuenta de la orden
        List<Contact> legalRepresentatives = [
            SELECT Name, MailingStreet, MailingCity, MailingState, MailingCountry, MPContactRole__c 
            FROM Contact 
            WHERE AccountId = :orderData.AccountId AND (MPContactRole__c INCLUDES ('Representante legal 1') OR MPContactRole__c INCLUDES ('Representante legal 2'))
        ];

        System.debug('legalRepresentatives::::::::::' +  legalRepresentatives); 
    
        // Crear instancia de la clase Request
        AgreementContRescissionAPIWrapper.Request requestData = new AgreementContRescissionAPIWrapper.Request();
    
        // Asignación de valores del JSON al objeto requestData
        requestData.mallName = orderData.Contract.MPMall__c != null ? orderData.Contract.MPMall__r.Name : EMPTY ;
        requestData.closeContractTotal = new AgreementContRescissionAPIWrapper.CloseContractTotal();
        requestData.closeContractTotal.oValue = orderData.MPFTCPrincipal__c != null ? orderData.MPFTCPrincipal__r.MPCloseContractTotal__c : null ;
        requestData.closeContractTotal.currencyIsoCode = orderData.CurrencyIsoCode != null ? orderData.CurrencyIsoCode : EMPTY ; 
        requestData.manager = ownerManager.Manager != null
                              && ownerManager.Manager.Manager != null 
                              ? ownerManager.Manager.Manager.Name : EMPTY ;
        requestData.companyName = orderData.Account != null ? orderData.Account.Name : EMPTY ; 
        requestData.assistantManager = ownerManager.Manager != null ? ownerManager.Manager.Name : EMPTY ;

         // Agregar compensaciones
        AgreementContRescissionAPIWrapper.compensation compensationData = new AgreementContRescissionAPIWrapper.compensation();
        compensationData.oValue = orderData.MPSpecialConditionAmount__c != null ? orderData.MPSpecialConditionAmount__c : 0;
        compensationData.operationType = orderData.MPSpecialConditionInFavorOf__c != null &&orderData.MPSpecialConditionInFavorOf__c == 'Mallplaza' ? 'Debe' : 'Haber';
        compensationData.currencyIsoCode = orderData.CurrencyIsoCode != null ? orderData.CurrencyIsoCode : EMPTY;
        requestData.compensation.add(compensationData);
    
        // Detalles del contrato
        requestData.contract = new AgreementContRescissionAPIWrapper.Contract();
        requestData.contract.terminationDate = orderData.MPContractEndDate__c;
        requestData.contract.name = orderData.Contract != null ? orderData.Contract.Name : EMPTY ; 
        requestData.contract.pdfUrl = EMPTY; 
        requestData.contract.id = orderData.Contract != null ? orderData.Contract.MPExternalCode__c : EMPTY ; 
    
        requestData.collectionExecutive = '';
        requestData.validFrom = orderData.MPExitDate__c; 
        requestData.closeContractSheetId = orderData.MPFTCPrincipal__c != null ? orderData.MPFTCPrincipal__c : EMPTY ; 
        requestData.invoiceLastDate = orderData.MPLastInvoiceDate__c != null ? orderData.MPLastInvoiceDate__c : null ;  
        requestData.commercialManager = orderData.Owner.Name; 
        requestData.installments = orderData.MPNumberOfInstalments__c != null ? orderData.MPNumberOfInstalments__c : null ; 
        requestData.methodOfPayment = orderData.MPPaymentMethod__c != null ? orderData.MPPaymentMethod__c : EMPTY ; 
        requestData.applyWarranty = orderData.MPWarrantyUse__c != null &&orderData.MPWarrantyUse__c == 'Aplicar Garantías' ? True : False;
        requestData.taxId = orderData.Account != null ? orderData.Account.MPIdentificationNumber__c : EMPTY ; 
        requestData.brand = orderData.Contract != null ? orderData.Contract.MPBrand__r.Name : EMPTY ; 
        requestData.applicationDate = orderData.MPExitDate__c != null ? orderData.MPExitDate__c : null ;    // Valor quemado MPExitDate__c
    
        // Llenado de la lista de ítems
        for (MPTerminationRecord__c item : items) {
            AgreementContRescissionAPIWrapper.Item itemData = new AgreementContRescissionAPIWrapper.Item();
            itemData.documentType = item.MPDocumentType__c != null ? item.MPDocumentType__c : EMPTY ;
            itemData.documentNumber = item.MPDocumentNumber__c != null ? item.MPDocumentNumber__c : EMPTY ;
            itemData.itemCode = item.MPItemCode__c != null ? item.MPItemCode__c : EMPTY ;
            itemData.description = item.MPDescription__c != null ? item.MPDescription__c : EMPTY ;
            itemData.operationType = item.MPOperationType__c != null ? item.MPOperationType__c : EMPTY ;
            itemData.documentReference = item.MPReferenceDocument__c != null ? item.MPReferenceDocument__c : EMPTY ;
            itemData.category = item.MPCategory__c != null ? item.MPCategory__c : EMPTY ;
    
            // Llenado de la lista de valores del ítem
            AgreementContRescissionAPIWrapper.ItemValue itemValue = new AgreementContRescissionAPIWrapper.ItemValue();
            itemValue.oValue = item.MPItemValue__c != null ? item.MPItemValue__c : null ;
            itemValue.currencyIsoCode = item.CurrencyIsoCode != null ? item.CurrencyIsoCode : EMPTY ;
            itemData.itemValues.add(itemValue);
    
            requestData.items.add(itemData);
        }
    
        // Llenado de la lista de representantes legales
        for (Contact legalRep : legalRepresentatives) {
            System.debug('ENTRO AL FOR::::::::::'); 
                AgreementContRescissionAPIWrapper.LegalRepresentative legalRepData = new AgreementContRescissionAPIWrapper.LegalRepresentative();
                legalRepData.fullName = legalRep.Name;
                legalRepData.address =  (legalRep.MailingStreet != null ? legalRep.MailingStreet + ', ' : EMPTY) +
                                        (legalRep.MailingCity != null ? legalRep.MailingCity + ', ' : EMPTY) +
                                        (legalRep.MailingState != null ? legalRep.MailingState + ', ' : EMPTY) +
                                        (legalRep.MailingCountry != null ? legalRep.MailingCountry : EMPTY);
                legalRepData.taxId = '8736573-5';  // Valor quemado
                requestData.legalRepresentative.add(legalRepData);
        }
    
        return requestData;
    }


    /**
    * @description Método que retorna los parametros necesarios en la integracion 4.6 de Cancelación Termino Contrato
    * @author Miller Mora | 29-10-2024 
    * @param order Orden de termino de contrato.
    * @return parametros del servicio.
    */
    public static CancellationContrRescAPIWrapper.Params CancellationContrRescAPIParams(Order order){
        Order contractData = new Order();
        contractData = [
            SELECT Id, Contract.MPExternalCode__c, MP_Local__r.MPSociety__r.MPExternalCode__c
            FROM   Order 
            WHERE  Id =: order.Id 
            LIMIT  1
        ];

        CancellationContrRescAPIWrapper.Params params = new CancellationContrRescAPIWrapper.Params();
        params.companyCode   = contractData.MP_Local__c != null
                            && contractData.MP_Local__r.MPSociety__c != null
                            && contractData.MP_Local__r.MPSociety__r.MPExternalCode__c != null
                            ?  contractData.MP_Local__r.MPSociety__r.MPExternalCode__c : EMPTY ;
        params.contractId = contractData.Contract.MPExternalCode__c != null ? contractData.Contract.MPExternalCode__c : EMPTY ;

        return params;
    }


}
/**
 * @description Clase que contiene métodos utilitarios usados desde la clase PricingAPICallManager 
 * @author Juan Felipe Muriel
 * @since 05-08-2024 - Creación
 */
public with sharing class PricingAPIUtils {

    private static final String EMPTY = '';
    /** Nombre de la integración */
    private static final String INTEGRATION_NAME = MPIntegrationSetting__mdt.getInstance('MPPricing').DeveloperName;
    /** Mensaje de error cuando el precio sugerido no es valido */
    public static final String SUGGESTED_PRICE_NOT_VALID_MESSAGE = Label.MPSuggestedPriceNotValid;

    /**
    * @description Método el cual modifica los valores del log de integracion antes de hacer UPDATE
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param callManager Instancia de la clase PricingAPICallManager
    * @param applyUpdateDMLOperation Boolean que indica si se debe hacer o no UPDATE
    * @return updatedIntStat Registro de log de la transacción actualizado
    **/
    public static MPIntegrationStatus__c modifyIntegrationLog(PricingAPICallManager callManager, Boolean applyUpdateDMLOperation){
        MPIntegrationStatus__c updatedIntStat  = callManager.getIntegrationStatus();
        updatedIntStat.MPIntegrationName__c    = INTEGRATION_NAME;
        updatedIntStat.MPParentId__c           = callManager.getMpqc().Id;
        updatedIntStat.MPStatus__c             = callManager.getPricingWrapper().status;
        updatedIntStat.MPRequest__c            = callManager.getPricingWrapper().requestData != null ? JSON.serialize(callManager.getPricingWrapper().requestData) : null ;
        updatedIntStat.MPRequestDateTime__c    = callManager.getPricingWrapper().requestDateTime;
        updatedIntStat.MPResponseDateTime__c   = callManager.getPricingWrapper().requestDateTime;
        updatedIntStat.MPSalesforceException__c= callManager.getPricingWrapper().salesforceErrorMessage;
        updatedIntStat.MPHttpCode__c           = callManager.getPricingWrapper().httpCode;

        // Si la transacción está marcada como error, solo agregar en la respuesta el error de callOut
        if(callManager.getPricingWrapper().status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')){
            updatedIntStat.MPResponse__c = callManager.getPricingWrapper().callOutErrorMessage != null ? callManager.getPricingWrapper().callOutErrorMessage : null;
        }else{
            updatedIntStat.MPResponse__c = callManager.getPricingWrapper().responseData != null ? JSON.serialize(callManager.getPricingWrapper().responseData) : null ;
        }

        if(applyUpdateDMLOperation){
            update updatedIntStat;
        }

        return updatedIntStat;
    }

    /**
    * @description Método que actualiza el registro de tipo Quote si hubo un error
    * proveniente de la API de precios.
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param callManager Instancia de la clase PricingAPICallManager
    **/
    public static void updateQuote(PricingAPICallManager callManager){
        Quote quoteToUpdate = new Quote();
        MPQuoteCondition__c mpqcWithQuote = new MPQuoteCondition__c();

        // Garantizar que el id de MPQuoteCondition__c existe, y que la llamada a la API fué fallida
        if (callManager.getMpqc().Id == null && callManager.getPricingWrapper().status != Utilities_cls.getSuccessValue('MPIntegrationStatus__c', 'MPStatus__c')) {
            return; 
        }

        // Obtener el registro MPQuoteCondition__c con la cotización relacionada
        mpqcWithQuote = [
            SELECT Id, MPQuote__c, MPQuote__r.MPPricingApiStatus__c 
            FROM MPQuoteCondition__c 
            WHERE Id = :callManager.getMpqc().Id 
            LIMIT 1
        ];

        // Verificar que la cotización existe en el objeto
        if (mpqcWithQuote.MPQuote__c == null) {
            return; 
        }

        quoteToUpdate = mpqcWithQuote.MPQuote__r;

        // NO Actualizar la cotización solo si el campo MPPricingApiStatus__c es 'Error' y el nuevo estado seria Error tambien.
        if (mpqcWithQuote.MPQuote__r.MPPricingApiStatus__c == Utilities_cls.getErrorValue('Quote', 'MPPricingApiStatus__c') && callManager.getPricingWrapper().status == Utilities_cls.getErrorValue('MPIntegrationStatus__c', 'MPStatus__c')) {return;}
        quoteToUpdate.MPPricingApiStatus__c = callManager.getPricingWrapper().status;
        update quoteToUpdate;
    }

    /**
    * @description Método que actualiza el registro de tipo MPQuoteCondition__c con la información
    * proveniente de la API de precios.
    * @author Juan Felipe Muriel | 05-08-2024 
    * @param callManager Instancia de la clase PricingAPICallManager
    * @param applyUpdateDMLOperation Boolean que indica si se debe hacer o no UPDATE
    * @return MPQuoteCondition__c actualizado
    **/
    public static MPQuoteCondition__c updateQuoteCondition(PricingAPICallManager callManager, Boolean applyUpdateDMLOperation){
        MPQuoteCondition__c mpqcToUpdate = new MPQuoteCondition__c();
        mpqcToUpdate.id = callManager.getMpqc().Id;
        mpqcToUpdate.MPIntegrationStatus__c = callManager.getIntegrationStatus().id;
        // Se actualizan los valores en quoteCondition con respecto al estado de la transacción
        if(callManager.getPricingWrapper().status == Utilities_cls.getSuccessValue('MPQuoteCondition__c', 'MPPricingApiStatus__c')){
            mpqcToUpdate.MPSuggestedValue__c = callManager.getPricingWrapper().responseData.pricing;
            mpqcToUpdate.MPNegotiatedValue__c = callManager.getPricingWrapper().responseData.pricing;
            mpqcToUpdate.MPPricingApiStatus__c = Utilities_cls.getSuccessValue('MPQuoteCondition__c', 'MPPricingApiStatus__c');
        }else{
            mpqcToUpdate.MPPricingApiStatus__c = Utilities_cls.getErrorValue('MPQuoteCondition__c', 'MPPricingApiStatus__c');
            mpqcToUpdate.MPSuggestedValue__c = null;
            mpqcToUpdate.MPNegotiatedValue__c = null;
        }

        if(applyUpdateDMLOperation){
            update mpqcToUpdate;
        }

        return mpqcToUpdate;
    }

    /**
    * @description Método que valida el precio obtenido desde la API
    * @author Juan Felipe Muriel | 05-08-2024
    * @param responseData Objeto que contiene la respuesta de la API
    **/
    public static void validateResponse(PricingAPIWrapper.Response responseData){
        if(responseData.pricing == null || responseData.pricing == NumbersEnum.CERO.ordinal()){
            throw new IntegrationExceptions.ValidationException(SUGGESTED_PRICE_NOT_VALID_MESSAGE);
        }
    }
}
/**
 * @description Automatic creation of Order Condition when the contract is created
 * @group Proyecto MP
 * @author Marco Guevara (MG)
 * @since 29-08-2024 - Creación
 */
public class createOrderCondition_cls {
    /**
     * @description Invocable Method that call the cration of the order conditions
     * @author Marco Guevara | 29-08-2024 
     * @param lstContractId List of contract ids
     */
    @InvocableMethod(label='Call the Pricing API' description='Call the Pricing API in order to obtain the suggested value for the condition class' category='Quote Condition')
    public static void createOrderCondition(List<Id> lstContractId) {
        createOrderCondition_cls.transformQuoteCondition(lstContractId);
    }
    
    public static void transformQuoteCondition(List<ID> lstContractId){        
        map<id,MPQuoteCondition__C> mapQuoteCondition = new map<id,MPQuoteCondition__C>();
        
        List<Contract> lstContract = new List<Contract>();
        List<MPScale__c> lstScale = new List<MPScale__c>();
        List<MPOrderCondition__c> lstOrderCondition = new List<MPOrderCondition__c>();
        
        Set<id> setQuoteId = new Set<id>();
        
        lstContract = [select id,MPOpportunity__r.SyncedQuoteId,MPCurrentOrder__c from contract where id in: lstContractId];
        for(Contract iContract : lstContract){
            setQuoteId.add(iContract.MPOpportunity__r.SyncedQuoteId);
        }
        
        mapQuoteCondition = new map<id,MPQuoteCondition__C>([select id,MPContractCondition__r.MPExternalPurpose__c,MPStartDate__c,MPEndDate__c,MPContractCondition__r.MPTimeFrequency__c,MPNegotiatedValue__c,MPNegotiatedAdjustment__c,MPQuote__r.opportunityid,MPApplyTimeScale__c,MPApplyVolumeScale__c,MPConditionClass__c,MPNegotiatedCalculationRule__c from MPQuoteCondition__C where MPQuote__c in: setQuoteId ]);
        lstScale = [select id,MPQuoteCondition__c,recordtype.name,MPEndDate__c,MPStartDate__c,MPValue__c,MPFinalVolume__c,MPInitialVolume__c,Escala__c from MPScale__c where MPQuoteCondition__c in: mapQuoteCondition.keyset() or Escala__r.MPQuoteCondition__c in: mapQuoteCondition.keyset()];
        system.debug('createOrderCondition Scale Conunt: '+lstScale.size());
        system.debug('createOrderCondition Quote COndition Conunt: '+mapQuoteCondition.size());
        for(Contract iContract : lstContract){
            for(MPQuoteCondition__C jQuoteCondition : mapQuoteCondition.values()){
                if(jQuoteCondition.MPQuote__c == iContract.MPOpportunity__r.SyncedQuoteId){
                    Boolean blnWithouteRecord = true;
                    if(jQuoteCondition.MPApplyTimeScale__c || jQuoteCondition.MPApplyVolumeScale__c){
                        for(MPScale__c kScale : lstScale){
                            if(kScale.MPQuoteCondition__c == jQuoteCondition.id){    
                                
                                if(!jQuoteCondition.MPApplyTimeScale__c && jQuoteCondition.MPApplyVolumeScale__c){                                    
                                    blnWithouteRecord=false;
                                    //Case #1 The Quote Condition has volume scale but no time scale
                                    MPOrderCondition__c objOrderCondition = createOrderCondition_cls.getOrderCondition(iContract, jQuoteCondition);
                                    objOrderCondition.MPValue__c = kScale.MPValue__c;
                                    objOrderCondition.MPEndDate__c = jQuoteCondition.MPEndDate__c;
                                    objOrderCondition.MPStartDate__c=jQuoteCondition.MPStartDate__c;                                                                                                
                                    objOrderCondition.MPFinalVolume__c = kScale.MPFinalVolume__c;
                                    objOrderCondition.MPInitialVolume__c = kScale.MPInitialVolume__c;                                
                                    lstOrderCondition.add(objOrderCondition);
                                } else if(jQuoteCondition.MPApplyTimeScale__c){
                                    Boolean blnWithouteRecord2 = true;
                                    if(jQuoteCondition.MPApplyVolumeScale__c){
                                        for(MPScale__c nScale : lstScale){
                                            if(nScale.Escala__c == kScale.id){
                                                blnWithouteRecord=false;
                                                blnWithouteRecord2 = false;
                                                //Case #2 The Quote Condition has time scale and the time scale has Volume scale
                                                MPOrderCondition__c objOrderCondition = createOrderCondition_cls.getOrderCondition(iContract, jQuoteCondition);
                                                objOrderCondition.MPValue__c = kScale.MPValue__c;                                
                                                objOrderCondition.MPEndDate__c = kScale.MPEndDate__c;
                                                objOrderCondition.MPStartDate__c=kScale.MPStartDate__c;                                                                                                
                                                objOrderCondition.MPFinalVolume__c = nScale.MPFinalVolume__c;
                                                objOrderCondition.MPInitialVolume__c = nScale.MPInitialVolume__c;                                
                                                lstOrderCondition.add(objOrderCondition);
                                            }
                                        }
                                    }
                                    
                                    if(blnWithouteRecord2){
                                        blnWithouteRecord=false;
                                        //Case #3 The Quote Condition has time scale and the time scale has no Volume scale
                                        MPOrderCondition__c objOrderCondition = createOrderCondition_cls.getOrderCondition(iContract, jQuoteCondition);
                                        objOrderCondition.MPValue__c = kScale.MPValue__c;                                
                                        objOrderCondition.MPEndDate__c = kScale.MPEndDate__c;
                                        objOrderCondition.MPStartDate__c=kScale.MPStartDate__c;                                                                    
                                        lstOrderCondition.add(objOrderCondition);
                                    }
                                } 
                            }
                        }
                    }
                    
                    if(blnWithouteRecord){
                        //Case #4 The Quote Condition has no scales
                        MPOrderCondition__c objOrderCondition = createOrderCondition_cls.getOrderCondition(iContract, jQuoteCondition);
                        objOrderCondition.MPValue__c = jQuoteCondition.MPNegotiatedValue__c;
                        objOrderCondition.MPEndDate__c = jQuoteCondition.MPEndDate__c;
                        objOrderCondition.MPStartDate__c=jQuoteCondition.MPStartDate__c;                                                                     
                        lstOrderCondition.add(objOrderCondition);
                    }                    
                }                
            }
            
        }
        
        if(lstOrderCondition.size()>0)
            insert lstOrderCondition;
    }
    
    public static MPOrderCondition__c getOrderCondition(Contract objContract,MPQuoteCondition__C objQuoteCondition){
        MPOrderCondition__c objOrderCondition = new MPOrderCondition__c();
        objOrderCondition.MPOrder__c = objContract.MPCurrentOrder__c;
        objOrderCondition.MPConditionClass__c = objQuoteCondition.MPConditionClass__c;
        objOrderCondition.MPCalculationRule__c = objQuoteCondition.MPNegotiatedCalculationRule__c;
        objOrderCondition.MPAdjustment__c = objQuoteCondition.MPNegotiatedAdjustment__c;
        objOrderCondition.MPTimeFrequency__c = objQuoteCondition.MPContractCondition__r.MPTimeFrequency__c;
        objOrderCondition.MPExternalPurpose__c = objQuoteCondition.MPContractCondition__r.MPExternalPurpose__c;
        return objOrderCondition;
    }
    
}
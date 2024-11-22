global with sharing class CreateQuoteCondition_inv {
    global class FlowInputs{
    
        @InvocableVariable
        global  quote objQuote;
        
        @InvocableVariable
        global  MPContractCondition__c objContractCondition;
        
    }
    
     global class FlowOutputs{
        
        @InvocableVariable
        global MPQuoteCondition__c objQuoteCondition;
      
    }
    
    @InvocableMethod(label='Create Quote Condition')
    global static List<FlowOutputs> createQuoteCondition_InvMth(List<FlowInputs> lstFlowInputs) {
        List<FlowOutputs> lstRSFlowOutputs = new List<FlowOutputs>();
        
        List<MPQuoteCondition__c> lstQuoteCondition = new List<MPQuoteCondition__c>();
        for(FlowInputs iFlowInputs : lstFlowInputs){ 
            MPQuoteCondition__c objQuoteCondition = CreateQuoteCondition_inv.createQuoteCondition(iFlowInputs.objQuote,iFlowInputs.objContractCondition);
            lstQuoteCondition.add(objQuoteCondition);
            
            FlowOutputs rsFlowOutputs = new FlowOutputs();
            rsFlowOutputs.objQuoteCondition = objQuoteCondition;
            lstRSFlowOutputs.add(rsFlowOutputs);
        }        
        insert lstQuoteCondition;       
        return lstRSFlowOutputs;
        
    }
    
    global static MPQuoteCondition__c createQuoteCondition(Quote objQuote , MPContractCondition__c objContractCondition){  
        Quote Quote = [select id,mpstore__r.MPContractType__c,Opportunityid,Opportunity.MPContractStartDate__c,Opportunity.MPContractDate__c,Opportunity.MPContractEndDate__c from Quote where id =: objQuote.id];              
        MPQuoteCondition__c objQuoteCondition = new MPQuoteCondition__c();
        objQuoteCondition.MPQuote__c = objQuote.id;
        objQuoteCondition.MPContractCondition__c = objContractCondition.id;
        objQuoteCondition.MPConditionClass__c= objContractCondition.MPConditionClass__c;
        objQuoteCondition.MPAdjustmentType__c = objContractCondition.MPAdjustmentType__c;
        objQuoteCondition.MPSuggestedAdjustment__c = objContractCondition.MPSuggestedAdjustment__c;
        objQuoteCondition.MPNegotiatedAdjustment__c = objContractCondition.MPSuggestedAdjustment__c;
        objQuoteCondition.MPSuggestedCalculationRule__c = objContractCondition.MPSuggestedCalculationRule__c;
        objQuoteCondition.MPNegotiatedCalculationRule__c = objContractCondition.MPSuggestedCalculationRule__c;
        objQuoteCondition.MPSuggestedValue__c = objContractCondition.MPSuggestedValue__c;
        objQuoteCondition.MPNegotiatedValue__c = objContractCondition.MPSuggestedValue__c;
        objQuoteCondition.MPApplyTimeScale__c=objContractCondition.MPApplyTimeScale__c;
        objQuoteCondition.MPApplyVolumeScale__c=objContractCondition.MPApplyVolumeScale__c;
        objQuoteCondition.MPIsModifiable__c = objContractCondition.MPIsModifiable__c;
        objQuoteCondition.MPStartDate__c=Quote.Opportunity.MPContractStartDate__c;
        objQuoteCondition.MPEndDate__c=Quote.Opportunity.MPContractEndDate__c;
        return objQuoteCondition;
    }
}
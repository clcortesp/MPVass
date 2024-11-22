public with sharing class CalculateDefautConditions_inv {
     
    @InvocableMethod(label='Create Default Quote Condition')
    public static void createDefaultQuoteCondition_invmth(List<id> lstQuoteId) {
        CalculateDefautConditions_inv.createDefaultQuoteCondition(lstQuoteId);
    }
    public static void createDefaultQuoteCondition(List<id> lstQuoteId){
        List<Quote> lstQuote = new List<Quote>();
        List<MPContractCondition__c> lstContractCondition = new List<MPContractCondition__c>();
        List<MPQuoteCondition__c> lstQuoteCondition = new List<MPQuoteCondition__c>();
        
        set<id> setContractTypeId = new set<id>();       
        
        lstQuote = [select id,mpstore__r.MPContractType__c,Opportunityid,Opportunity.MPContractStartDate__c,Opportunity.MPContractDate__c,Opportunity.MPContractEndDate__c from Quote where id in: lstQuoteId];
        for(Quote iQuote : lstQuote){            
            setContractTypeId.add(iQuote.mpstore__r.MPContractType__c);
        }        
        String strQueryFields = Utilities_cls.getQueryFields(Utilities_cls.getAllFields('MPContractCondition__c'));
        lstContractCondition = Database.query('Select '+strQueryFields+' From MPContractCondition__c where MPContractType__c in: setContractTypeId and MPIsDefault__c = true and MPUsabilityStatus__c = \'Use\'');
        
        for(Quote iQuote : lstQuote){
            for(MPContractCondition__c jContractCondition: lstContractCondition){
                if(iQuote.mpstore__r.MPContractType__c == jContractCondition.MPContractType__c){                                                            
                    lstQuoteCondition.add(CreateQuoteCondition_inv.createQuoteCondition(iQuote,jContractCondition));
                }
            }
        } 
        insert lstQuoteCondition;
    }
    

}
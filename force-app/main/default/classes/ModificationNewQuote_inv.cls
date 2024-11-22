global with sharing class ModificationNewQuote_inv {
    
    
    @InvocableMethod(label='Calculate Quote Condition of Mod Opp')
    global static void createQuoteConditionModOpp_InvMth(List<id> lstQuoteId) {
        system.debug('*************** ModificationNewQuote_inv createQuoteConditionModOpp_InvMth: '+lstQuoteId.size());
        
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        List<Quote> lstQuote = new List<Quote>();
        set<id> setOppId = new set<id>();
        lstQuote = [select id,opportunityid,Opportunity.MPContractStartDate__c,Opportunity.MPContractEndDate__c from quote where id in: lstQuoteId];
        
        for(Quote Quotei : lstQuote){ 
            setOppId.add(Quotei.opportunityid);
        }        
        lstOpportunity = [select id,MPGetContract41API__r.MPResponse__c,Contract.MPCurrentOrder__r.MP_Local__c,Contract.MPCurrentOrder__r.MP_Local__r.MPContractType__c from Opportunity where id in: setOppId];
        DefaultQuote_cls.getConditionsFromContract(lstOpportunity,lstQuote);
         
    }
    
}
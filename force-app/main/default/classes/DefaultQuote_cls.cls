/**
 * @description Creation of the defalt quote when a opportunity of contrat modification changed from the stage "Exploration" to "Negotiation"
 * @author Marco Guevara
 * @since 28-08-2024 - Creation
 */
public class DefaultQuote_cls {    
    /**
    * @description Wrapper for the condition information
    * @author Marco Guevara | 28-08-2024 
    **/
    public class RSGetContractCondition{
        public List<DefaultQuote_cls.Condition> Condition { get; set; }
    }
    public class Condition {
        public String calcRule { get; set; }
        public String type { get; set; }
        public String currencyIsoCode { get; set; }
        public String distributionRule { get; set; }
        public String externalPurpose { get; set; }
        public Double unitPrice { get; set; }
        public String validFrom { get; set; }
        public String validTo { get; set; }
    }
    
    @InvocableMethod(label='Create Default Quote' description='Create the defalt quote when a opportunity of contrat modification changed from the stage "Exploration" to "Negotiation"' category='Quote')
    public static void CreateDefaultQuote(List<Id> lstOpportunityId) {        
        system.debug('*************** DefaultQuote_cls CreateDefaultQuote: '+lstOpportunityId.size());
        DefaultQuote_cls.readCurrentContractInformation(lstOpportunityId);
    }
    
    
    public static List<Quote> createQuoteFromContract(List<Opportunity> lstOpportunity){
        List<Quote> lstQuote = new List<Quote>();        
        for(Opportunity i : lstOpportunity){                        
            if(i.MPGetContract41API__c!= null && i.MPGetContract41API__r.MPResponse__c != null){  
                Quote objQuote = new Quote();
                objQuote.name = 'Cotización 1';
                objQuote.MPStore__c = i.Contract.MPCurrentOrder__r.MP_Local__c;
                objQuote.OpportunityId = i.id;
                lstQuote.add(objQuote);
            }
        }
        if(lstQuote.size() > 0){
            insert lstQuote;    
        }
        return lstQuote;
    }
    
    public static void getConditionsFromContract(List<Opportunity> lstOpportunity, List<Quote> lstQuote){
        List<MPContractCondition__c> lstContractCondition = new List<MPContractCondition__c>();
        List<MPCalculationRule__c> lstCalculationRule = new List<MPCalculationRule__c>();
        List<MPQuoteCondition__c> lstQuoteCondition = new List<MPQuoteCondition__c>();
        
        map<id,DefaultQuote_cls.RSGetContractCondition> mapRSGetContractCondition = new map<id,DefaultQuote_cls.RSGetContractCondition>();
        
        Set<String> setConditionClassCode = new Set<String>();
        Set<String> setCalculationRuleCode = new Set<String>();
        map<id,id> mapContractType = new map<id,id>();
        
        
        
        
        for(Opportunity i : lstOpportunity){                        
            if(i.MPGetContract41API__c!= null && i.MPGetContract41API__r.MPResponse__c != null){  
                DefaultQuote_cls.RSGetContractCondition objRSContractCondition = new DefaultQuote_cls.RSGetContractCondition();
                String strJSONResponse = '';                
                
                // Taking from the JSON the condition information 
                strJSONResponse = i.MPGetContract41API__r.MPResponse__c;
                //strJSONResponse = '{"id": "0000000035083","companyCode": "1200","name": "ALDO_XI_PTR","isMainContract": false,"currencyIsoCode": "UF","startDate": "2022-03-08","endDate": "2027-03-07","sector": "SR421","note": "","offerId": "SF0002","adjustmentRule": "","salesCurrencyIsoCode": "UF","salesStartDate": "2022-03-08","indexSeriesBaseYear": "","indexSeries": "","percSalesAsRent": 0,"paymentCondition": "MP12","cebe": "0001201602","isSalesRelated":false,"isProRataMethod":false,"type": "M101","condition": [{"calcRule": "MPAD","currencyIsoCode": "UF","distributionRule": "MP01","externalPurpose": "AMD","unitPrice": "1.0","validFrom": "2023-01-01","validTo": "9999-12-31","type": "AD10"},{"calcRule": "MP02","currencyIsoCode": "UF","distributionRule": "MP01","externalPurpose": "AM","unitPrice":"5.0","validFrom": "2022-12-01","validTo": "9999-12-31","type": "AM10"},{"calcRule": "MP05","currencyIsoCode": "UF","distributionRule": "MP01","externalPurpose": "AP","unitPrice": "1.0","validFrom": "2022-12-01","validTo": "9999-12-31","type": "AP10"}],"salesBasedRentAgreement": [{"from": 0,"to": 100000,"percent": 6.0},{"from": 100001,"to": 0,"percent": 8.0}],"termAdjust": [],"rentalObject": [{"isInfo": false,"id": "1200/1201/00443495","type": "IM"}],"partner": [{"id": "0023095730","type": "TR0600","validFrom": "2022-03-01","validTo": "9999-12-31"}],"subClause": [],"meas": []}';
                system.debug(strJSONResponse);
                strJSONResponse=strJSONResponse.right(strJSONResponse.length()-strJSONResponse.indexOf('"condition"'));
                strJSONResponse='{'+strJSONResponse.left(strJSONResponse.indexOf(']')+1)+'}';
                system.debug(strJSONResponse);
                
                objRSContractCondition = (DefaultQuote_cls.RSGetContractCondition) System.JSON.deserialize(strJSONResponse , DefaultQuote_cls.RSGetContractCondition.class);
                
                mapRSGetContractCondition.put(i.id,objRSContractCondition);
                
                for(DefaultQuote_cls.Condition j:objRSContractCondition.condition){
                    setConditionClassCode.add(j.type);
                    setCalculationRuleCode.add(j.calcRule); 
                }
                mapContractType.put(i.id,i.Contract.MPCurrentOrder__r.MP_Local__r.MPContractType__c);            
            }
            
        }
        
        
        // Geting the information of ContractCondition and CalculationRule using information of the json
        lstContractCondition = [select id,MPConditionClass__c,MPAdjustmentType__c,MPSuggestedAdjustment__c,MPSuggestedCalculationRule__c,
                                MPSuggestedValue__c,MPApplyTimeScale__c,MPApplyVolumeScale__c,MPIsModifiable__c,MPConditionClass__r.MPExternalCode__c,MPContractType__c 
                                from MPContractCondition__c where MPConditionClass__r.MPExternalCode__c in:setConditionClassCode and MPContractType__c in:mapContractType.values()];            
        lstCalculationRule = [select id,MPExternalCode__c from MPCalculationRule__c where MPExternalCode__c in: setCalculationRuleCode];
        
        system.debug('*************** lstContractCondition: '+lstContractCondition.size());
        // Creation of Quote Conditions based on the information of each JSON 
        //map<id,Quote> mapQuote = new map<id,Quote>(lstQuote);
        //lstQuote = [select id,opportunityid,Opportunity.MPContractStartDate__c,Opportunity.MPContractEndDate__c from Quote where id in: mapQuote.keyset()];
        //system.debug(lstQuote[0].Opportunity.MPContractEndDate__c);
        
        for(Quote iQuote : lstQuote){
            for(DefaultQuote_cls.Condition jAPICondition : mapRSGetContractCondition.get(iQuote.opportunityid).condition){ 
                MPQuoteCondition__c objQuoteCondition;
                system.debug('*************** API Condition Code:'+jAPICondition.type+' Quote Contract Type: '+mapContractType.get(iQuote.opportunityid));
                for(MPContractCondition__c kContractCondition:lstContractCondition){
                    system.debug('*************** kContractCondition ----> Condition Code:'+kContractCondition.MPConditionClass__r.MPExternalCode__c+' Contract Type: '+kContractCondition.MPContractType__c);                                        
                    if(kContractCondition.MPConditionClass__r.MPExternalCode__c==jAPICondition.type && kContractCondition.MPContractType__c == mapContractType.get(iQuote.opportunityid)){                                                
                        objQuoteCondition = CreateQuoteCondition_inv.createQuoteCondition(iQuote, kContractCondition);                        
                    }
                }  
                
                if(objQuoteCondition != null){
                    objQuoteCondition.MPContractValue__c = jAPICondition.unitPrice;
                    for(MPCalculationRule__c kCalculationRule : lstCalculationRule){
                        if(kCalculationRule.MPExternalCode__c == jAPICondition.calcRule){
                            objQuoteCondition.MPContractCalculationRule__c = kCalculationRule.id;
                        }
                    } 
                    lstQuoteCondition.add(objQuoteCondition); 
                }                
            }
        }
        if(lstQuoteCondition.size()>0){
            insert lstQuoteCondition;
        }
        
    }
    
    /**
    * @description Reed the get contract integration response in order to extract the condition information and create with it a default quote and the respective quoteconditions
    * @author Marco Guevara | 28-08-2024 
    * @param setOpportunityId Set<Id> Array of opportunity ids
    **/
    Static void readCurrentContractInformation(List<Id> lstOpportunityId ){
        system.debug('*************** DefaultQuote_cls readCurrentContractInformation: '+lstOpportunityId.size());
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        List<Quote> lstQuote = new List<Quote>();
		
		lstOpportunity = [select id,MPGetContract41API__r.MPResponse__c,Contract.MPCurrentOrder__r.MP_Local__c,Contract.MPCurrentOrder__r.MP_Local__r.MPContractType__c from Opportunity where id in: lstOpportunityId];        
        // Creation and Insertion of the default quote 
        lstQuote = DefaultQuote_cls.createQuoteFromContract(lstOpportunity);
        DefaultQuote_cls.getConditionsFromContract(lstOpportunity,lstQuote);
        
    }    
}
/**
 * @description Class that is responsible for analyzing the information to generate the quote PDF
 * @group Proyecto MP
 * @author Marco Guevara
**/
public class QuotePDFController_cls {
    public String strRecordId { get; set; } 
    public Double dblADTotalValue { get; set; }
    public List<Quote> lstQuote { get; set; }
    public List<MPQuoteCondition__c> lstQuoteCondition { get; set; } 
    public List<MPScale__c> lstTimeAndVolumeScale { get; set; }
    public List<QuotePDFController_cls.Scale> lstAMTimeScale { get; set; }
    public List<QuotePDFController_cls.Scale> lstAPTimeScale { get; set; }
    public MPQuoteCondition__c objAM16 { get; set; } 
    public Double dblG0TotalMount { get; set; }
    public Double dblCITotalMount { get; set; }
    public Double dblMonthRentalValue { get; set; }
    public Double dblOtherCosts { get; set; }
    public Double dblPromotionFoundValue { get; set; }
    public Double dblEstimatedMonthlyTotal { get; set; }
    public Double dblValueO050 { get; set; }
    public Double dblValueGAR0 { get; set; }
    public Date dteAjusment { get; set; }
    public String strWithAM16 { get; set; }

    /**
     * @description Class representing a scale in the system
     * @group Proyecto MP
     * @author Marco Guevara | 25-08-2024 
    **/
    public class Scale{          
        public Scale(Decimal strValue,Date strStartDate,Date strEndDate,String strAdjustmentPeriod,Decimal strAdjustmentValue){
            this.strValue=strValue;
            this.strStartDate=strStartDate;
            this.strEndDate=strEndDate;
            this.strAdjustmentPeriod=strAdjustmentPeriod;
            this.strAdjustmentValue=strAdjustmentValue;            
        }
        
        public Double strValue { get; set; } 
        public Date strStartDate { get; set; }
        public Date strEndDate { get; set; }
        public String strAdjustmentPeriod { get; set; }
        public Double strAdjustmentValue { get; set; }
        public Double dblFinalVolume { get; set; }
        public Double dblInitialVolume { get; set; }
    }
    
    public QuotePDFController_cls(){
        this.lstAMTimeScale = new List<QuotePDFController_cls.Scale>();     
        this.lstAPTimeScale = new List<QuotePDFController_cls.Scale>();
        this.objAM16 = new MPQuoteCondition__c();
        this.dblADTotalValue = 0;
        this.dblCITotalMount = 0;
        this.dblG0TotalMount = 0;
        this.dblMonthRentalValue=0;
        this.dblOtherCosts = 0;
        this.dblPromotionFoundValue = 0; 
        this.dblEstimatedMonthlyTotal=0;
        this.dblValueO050 = 0;
        this.dblValueGAR0 = 0;
        this.strWithAM16='display:none;';
        this.strRecordId=ApexPages.currentPage().getParameters().get('id'); 
        this.lstQuote = this.getQuote(this.strRecordId);
        this.lstQuoteCondition = this.getQuoteCondition(this.strRecordId);
        this.lstTimeAndVolumeScale = this.getTimeAndVolumeScale(this.strRecordId);
        this.getQuoteConditionByTimeScale(this.lstTimeAndVolumeScale,this.lstQuoteCondition);         
    }

    /**
    * @description Method that obtains the quote record with all the fields of the object and some relationships 
    * @author Marco Guevara | 25-08-2024 
    * @param strQuoteId Quote Id to get
    * @return List of quotes, The list only contains one record that matches the Id passed by parameter
    */
    public List<Quote> getQuote(String strQuoteId){
        List<Quote> lstQuote = new List<Quote>();
        List<String> lstFields = new List<String>();
        String strQueryFields = '';
        
        lstFields = Utilities_cls.getAllFields('Quote');
        strQueryFields = Utilities_cls.getQueryFields(lstFields);
                
        lstQuote = Database.query('Select '+strQueryFields+',Opportunity.MPBrand__r.name,Opportunity.MPMall__r.name,opportunity.MPTermType__c,opportunity.MPContractPeriodYears__c,opportunity.MPNegotiatedWarranty__c,opportunity.CurrencyIsoCode,opportunity.MPContractStartDate__c,opportunity.MPProbableOpeningDate__c,MPStore__r.MPFootage__c From Quote Where id=:strQuoteId');        
        return lstQuote;
    }
    
    /**
    * @description Method that obtains a quote condition associated with a specific quote.
    * @author Marco Guevara | 25-08-2024 
    * @param strQuoteId Quote id to filter quote conditions
    * @return List of quote conditions
    */
    public List<MPQuoteCondition__c> getQuoteCondition(String strQuoteId){        
        
        List<MPQuoteCondition__c> lstQuoteCondition = new List<MPQuoteCondition__c>();        
        List<String> lstFields = new List<String>();
        String strQueryFields = '';
        
        lstFields = Utilities_cls.getAllFields('MPQuoteCondition__c');
        strQueryFields = Utilities_cls.getQueryFields(lstFields);
        lstQuoteCondition = Database.query('Select '+strQueryFields+',MPNegotiatedAdjustment__r.MPPeriod__c,MPNegotiatedAdjustment__r.MPValue__c From MPQuoteCondition__c Where MPQuote__c=:strQuoteId');        
        return lstQuoteCondition;
    }
    
    /**
    * @description Method that obtains volume scales and time scales associated with a quote
    * @author Marco Guevara | 25-08-2024 
    * @param strQuoteId Quote id to filter scales
    * @return List of scales
    */
    public List<MPScale__c> getTimeAndVolumeScale(String strQuoteId){
        List<MPScale__c> lstScale = new List<MPScale__c>();
        List<String> lstFields = new List<String>();
        String strQueryFields = '';
        
        lstFields = Utilities_cls.getAllFields('MPScale__c');
        strQueryFields = Utilities_cls.getQueryFields(lstFields);
        lstScale = Database.query('Select '+strQueryFields+',RECORDTYPE.NAME,MPQuoteCondition__r.MPConditionClassCode__c,MPQuoteCondition__r.MPNegotiatedAdjustment__r.MPPeriod__c,MPQuoteCondition__r.MPNegotiatedAdjustment__r.MPValue__c From MPScale__c Where MPQuoteCondition__r.MPQuote__c=:strQuoteId or Escala__r.MPQuoteCondition__r.MPQuote__c =: strQuoteId order by MPQuoteCondition__r.MPConditionClassCode__c,MPStartDate__c asc' );        
        return lstScale;
    }
    
    /**
    * @description Method that analyzes quote conditions by time scale and the results of the analysis are assigned
      directly to instance variables of the class that are later displayed in a visualforce page.
    * @author Marco Guevara | 25-08-2024 
    * @param lstScale Scale list
    * @param lstQuoteCondition Quote condition list
    */
    public void getQuoteConditionByTimeScale(List<MPScale__c> lstScale,List<MPQuoteCondition__c> lstQuoteCondition){          
        Double dblG010 = 0;
        Double dblG030 = 0;
        Double dblG050 = 0;
        Double dblAM90 = 0;
        Double dblG600 = 0;

        for(MPQuoteCondition__c i : lstQuoteCondition){
            String strConditionClass = i.MPConditionClassCode__c;            
            if(strConditionClass == 'AM15' || strConditionClass == 'AM90'){                 
                List<QuotePDFController_cls.Scale> a = this.getScale(lstScale,i);
                a[a.size()-1].strEndDate=null;
                this.lstAMTimeScale.addAll(a);
                if(strConditionClass == 'AM90' && i.MPNegotiatedValue__c != null){
                    dblAM90 = dblAM90+i.MPNegotiatedValue__c;   
                }
            }else if(strConditionClass == 'AM16'){                
                this.objAM16=i;
                this.dteAjusment = (lstQuote[0].Opportunity.MPContractStartDate__c).addMonths(integer.valueof(i.MPNegotiatedAdjustment__r.MPPeriod__c));                
                this.strWithAM16 = '';
            }else if(strConditionClass.startsWith('AP')){
                this.lstAPTimeScale.addAll(this.getScale(lstScale,i));
            }else if(strConditionClass.startsWith('AD') && i.MPNegotiatedValue__c != null){
                this.dblADTotalValue = (this.dblADTotalValue+i.MPNegotiatedValue__c);
            }else if(strConditionClass.startsWith('CI')){
                this.dblCITotalMount = (dblCITotalMount + i.MPNegotiatedValue__c);
            }
            // else if(strConditionClass.startsWith('G0') && i.MPNegotiatedValue__c != null){
            //      this.dblG0TotalMount = (dblG0TotalMount + i.MPNegotiatedValue__c);
            // }
            else if(strConditionClass == 'G010' && i.MPNegotiatedValue__c != null){
                dblG010 = dblG010+i.MPNegotiatedValue__c;
            }else if(strConditionClass == 'G030' && i.MPNegotiatedValue__c != null){
                dblG030 = dblG030+i.MPNegotiatedValue__c;
            }else if(strConditionClass == 'G050' && i.MPNegotiatedValue__c != null){
                dblG050 = dblG050+i.MPNegotiatedValue__c;
            }else if(strConditionClass.startsWith('FP20')){
                this.dblPromotionFoundValue = this.dblPromotionFoundValue+i.MPNegotiatedValue__c;
            }else if(strConditionClass == 'O050'){
                this.dblValueO050 = i.MPNegotiatedValue__c;
            }else if(strConditionClass == 'GAR0'){
                this.dblValueGAR0 = i.MPNegotiatedValue__c;
            }else if(strConditionClass == 'G600'){
                dblG600 = dblG600+i.MPNegotiatedValue__c;
            }
        }
        
        if(lstQuote.size()>0 && this.lstAMTimeScale.size()>0 && this.lstAMTimeScale[0].strValue!= null){
            this.dblMonthRentalValue = (lstQuote[0].MPStore__r.MPFootage__c * this.lstAMTimeScale[0].strValue);    
        }
        
        // this.dblOtherCosts = (dblG010+dblG030)*lstQuote[0].MPStore__r.MPFootage__c;
        this.dblOtherCosts = (dblG010*lstQuote[0].MPStore__r.MPFootage__c+(dblG050/100)*(dblAM90))*(1+dblG600/100);
        this.dblPromotionFoundValue = (this.dblPromotionFoundValue/100) * this.dblMonthRentalValue;
        this.dblEstimatedMonthlyTotal = (this.dblMonthRentalValue+this.dblOtherCosts+this.dblPromotionFoundValue);
        this.dblG0TotalMount = (dblG010+(dblG050/100)*(dblAM90/lstQuote[0].MPStore__r.MPFootage__c))*(1+dblG600/100);        
    }

    /**
    * @description Method that analyzes scales associated with a specific quote condition, the results of the analysis 
      are assigned to an object of type 'QuotePDFController_cls.Scale' that is returned at the end.
    * @author Marco Guevara | 25-08-2024 
    * @param lstScale Scale list
    * @param objQuoteCondition Quote condition
    * @return object list QuotePDFController_cls.Scale
    */
    public List<QuotePDFController_cls.Scale> getScale(List<MPScale__c> lstScale,MPQuoteCondition__c objQuoteCondition){
        List<QuotePDFController_cls.Scale> lstAMScale = new List<QuotePDFController_cls.Scale>();
        integer intScaleCont = 0;
        for(MPScale__c j : lstScale){              
            if(objQuoteCondition.id == j.MPQuoteCondition__c && j.RECORDTYPE.NAME == 'Time'){  
                integer intScaleVolCont = 0;
                for(MPScale__c k : lstScale){     
                    if(j.id == k.Escala__c && k.RECORDTYPE.NAME == 'Volume'){                        
                        intScaleVolCont++;
                        intScaleCont++;
                        QuotePDFController_cls.Scale volume = new QuotePDFController_cls.Scale(k.MPValue__c,J.MPStartDate__c,J.MPEndDate__c,objQuoteCondition.MPNegotiatedAdjustment__r.MPPeriod__c,objQuoteCondition.MPNegotiatedAdjustment__r.MPValue__c);
                        volume.dblFinalVolume = k.MPFinalVolume__c;
                        volume.dblInitialVolume = k.MPInitialVolume__c;
                        lstAMScale.add(volume);
                    }
                }
                if(intScaleVolCont == 0){
                    intScaleCont++;
                    lstAMScale.add(
                    	new QuotePDFController_cls.Scale(j.MPValue__c,j.MPStartDate__c,j.MPEndDate__c,objQuoteCondition.MPNegotiatedAdjustment__r.MPPeriod__c,objQuoteCondition.MPNegotiatedAdjustment__r.MPValue__c)
                    );
                }                                
            }                    
        }
        
        if(intScaleCont == 0){
            lstAMScale.add(
                new QuotePDFController_cls.Scale(objQuoteCondition.MPNegotiatedValue__c,objQuoteCondition.MPStartDate__c,objQuoteCondition.MPEndDate__c,objQuoteCondition.MPNegotiatedAdjustment__r.MPPeriod__c,objQuoteCondition.MPNegotiatedAdjustment__r.MPValue__c)
            );
        }
        
        return lstAMScale;
    }
}
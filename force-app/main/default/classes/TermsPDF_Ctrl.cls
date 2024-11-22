/**
 * @description Controller of TermsPDF.vfp
 * @group Proyecto MP
 * @author Marco Guevara (MG)
 * @since 29-10-2024 - Creación
 */
public class TermsPDF_Ctrl {
    public List<User> lstOwner { get; set; }
    public List<Order> lstOrder { get; set; }

    public List<Contact> lstContact { get; set; }

    public List<MPTerminationRecord__c> lstTerminationRecord { get; set; }
    public List<MPTerminationRecord__c> lstTerminationRecordIssued { get; set; }
    public List<MPTerminationRecord__c> lstTerminationRecordOperationalDebt { get; set; }
    public List<MPTerminationRecord__c> lstTerminationRecordComercialDebt { get; set; }
    public List<MPTerminationRecord__c> lstTerminationRecordAnticipatedConceptsAdjustment { get; set; }
    public List<MPTerminationRecord__c> lstTerminationRecordWarranty { get; set; }

    public String strLocalCode { get; set; }
    public String strRecordId { get; set; }
    public Double dblTotalDebt { get; set; }
    public Double dblSubTotalOperationalDebt { get; set; }
    public Double dblSubTotalComercialDebt { get; set; }
    public Double dblSubTotalAnticipatedConceptsAdjustment { get; set; }
    public Double dblSubTotalIssuedDebt { get; set; }

    public Boolean blnIsDraft { get; set; }

    public TermsPDF_Ctrl(){
        this.blnIsDraft = true;
        this.lstOwner = new List<User>();
        this.lstContact = new List<Contact>();
        this.lstOrder = new List<Order>();

        this.lstTerminationRecord = new List<MPTerminationRecord__c>();
        this.lstTerminationRecordIssued = new List<MPTerminationRecord__c>();
        this.lstTerminationRecordOperationalDebt = new List<MPTerminationRecord__c>();
        this.lstTerminationRecordComercialDebt = new List<MPTerminationRecord__c>();
        this.lstTerminationRecordAnticipatedConceptsAdjustment = new List<MPTerminationRecord__c>();
        this.lstTerminationRecordWarranty = new List<MPTerminationRecord__c>();

        this.dblSubTotalOperationalDebt = this.dblSubTotalComercialDebt = this.dblSubTotalAnticipatedConceptsAdjustment = this.dblSubTotalIssuedDebt = this.dblTotalDebt = 0;
        this.strLocalCode = '';        

        // get order id from the parammeter
        this.strRecordId=ApexPages.currentPage().getParameters().get('id');

		this.lstOrder = [select id,MPExitDate__c,ownerid,toLabel(MPPaymentMethod__c),MPContractStartDate__c,Contract.MPMall__r.name,Contract.MPMall__r.MPExternalCode__c,Contract.MPBrand__r.name,
                         Contract.accountid,Contract.account.name,Contract.account.MPIdentificationNumber__c,Contract.account.MPIdentificationType__c,Contract.account.billingStreet,
                         Contract.account.billingCity,Contract.account.billingCountry,Contract.account.billingState,contract.MPExternalCode__c,MPSpecialConditionToApply__c,MPExceptionApproval__c,
                         Contract.CurrencyIsoCode,toLabel(MPSpecialConditionInFavorOf__c),MPSpecialConditionAmount__c,MPWarrantyUse__c,MPNumberOfInstalments__c,MP_Local__c,MPFTCPrincipal__r.MPStatus__c,
                         MPLastInvoiceDate__c
                         from Order where id =: strRecordId];
        if(this.lstOrder.size()>0){
            if(this.lstOrder[0].MPFTCPrincipal__r.MPStatus__c != 'Socialized'){
                this.blnIsDraft = false;
            }
            
            this.lstContact = [select id,name,MPIdentificationType__c,MPIdentificationNumber__c from contact where accountid =:this.lstOrder[0].Contract.accountid and MPContactRole__c includes ('Representante legal 1','Representante legal 2')];
            
            this.lstOwner = [select id,name,manager.name,manager.manager.name from user where id =:this.lstOrder[0].ownerid];
            
            this.lstTerminationRecord = [select id,MPCategory__c,MPItemCode__c,MPDescription__c,MPReferenceDocument__c,MPStatus__c,MPDocumentDueDate__c,MPDocumentDate__c,FTC__c,
                                         MPDocumentNumber__c,MPSubcategory__c,MPDocumentType__c,MPOperationType__c,MPItemValue__c
                                         from MPTerminationRecord__c where FTC__r.MPOrder__c =: this.strRecordId];
            
            List<MPRentalObjectByStore__c> lstRentalObjectByStore = [select id,MPRentalObject__r.MPExternalCode__c from MPRentalObjectByStore__c where MPStore__c =: this.lstOrder[0].MP_Local__c];
            
            for(MPRentalObjectByStore__c iRentalObjectByStore:lstRentalObjectByStore){
                strLocalCode += (','+iRentalObjectByStore.MPRentalObject__r.MPExternalCode__c);
            }
            strLocalCode = strLocalCode.right(strLocalCode.length()-1);
            
            if(lstOrder[0].MPSpecialConditionAmount__c != null){
                this.dblTotalDebt = ((lstOrder[0].MPSpecialConditionInFavorOf__c=='Mallplaza'?1:-1)*lstOrder[0].MPSpecialConditionAmount__c);   
            }            	
            
            for(MPTerminationRecord__c i : this.lstTerminationRecord){
                if(i.MPCategory__c =='Emitida'){
                    this.lstTerminationRecordIssued.add(i);
                    this.dblSubTotalIssuedDebt += i.MPItemValue__c;
                    if(lstOrder[0].MPExceptionApproval__c != 'Aprobado'){
                        this.dblTotalDebt += i.MPItemValue__c;
                    }
                }else if(i.MPCategory__c =='Garantia'){
                    this.lstTerminationRecordWarranty.add(i);
                }else if(i.MPCategory__c =='PorEmitir' && i.MPSubcategory__c=='DEUDAOPE'){
                    this.dblSubTotalOperationalDebt += i.MPItemValue__c;
                    this.lstTerminationRecordOperationalDebt.add(i);
                    this.dblTotalDebt += i.MPItemValue__c;
                }else if(i.MPCategory__c =='PorEmitir' && i.MPSubcategory__c=='DEUDACOM'){
                    this.dblSubTotalComercialDebt += i.MPItemValue__c;
                    this.lstTerminationRecordComercialDebt.add(i);
                    this.dblTotalDebt += i.MPItemValue__c;
                }else if(i.MPCategory__c =='PorEmitir' && i.MPSubcategory__c=='AJUSCANT'){
                    this.dblSubTotalAnticipatedConceptsAdjustment += i.MPItemValue__c;
                    this.lstTerminationRecordAnticipatedConceptsAdjustment.add(i);
                    this.dblTotalDebt += i.MPItemValue__c;
                }
            }
        }
    }
}
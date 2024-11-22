import { LightningElement,track,api } from 'lwc';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTerminationRecords from '@salesforce/apex/ManageTerminationItems_ctrl.getTerminationRecord';
import saveInformationClass from '@salesforce/apex/ManageTerminationItems_ctrl.saveInformationClass';
 
const columns = [
    { label: 'Documento', fieldName: 'MPDocumentNumber__c', type: 'text' },
    { label: 'Descripción', fieldName: 'MPDescription__c', type: 'text' },
    { label: 'Categoria', fieldName: 'MPCategory__c', type: 'text' },
    { label: 'Subcategoria', fieldName: 'MPSubcategory__c', type: 'text' },
    { label: 'Valor', fieldName: 'MPItemValue__c', type: 'currency' }
];
 
export default class ManageTerminationItems extends LightningElement {

    @api recordId;
    @track categoryOptions = [];
    @track categoryValue = '';
    @track subCategoryOptions = [];
    @track subCategoryValue = '';
    @track columns = columns
    @track lstTerminationRecords;
    @track lstOriginalTerminationRecords;
    @track rejectionReason;
    @track lstSelectedTerminationRecords;
    @track idFTC = 'a0LDy000002XoY0MAK';
    @track loaded = false;
    @track lstRejectedRecords = [];

    connectedCallback() {        
        getTerminationRecords({
            idFTC:this.recordId
        }).then((result)=>{
            this.getTerms(result);
        }).catch((error) => {
            error;
        });
    }

    handleChangeCategory(event) {
        this.loaded = false;
        this.categoryValue = event.detail.value;        
        let records = [];
        let lstRejectedRecords = [];
        this.lstOriginalTerminationRecords.forEach(element => {
            if((!this.categoryValue || element.MPCategory__c == this.categoryValue) && (!this.subCategoryValue || element.MPSubcategory__c == this.subCategoryValue)){
                records.push(element);                
            }
            if(element.MPStatus__c == 'Rejected'){
                lstRejectedRecords.push(element.Id);                
            }
        });
        this.lstRejectedRecords= lstRejectedRecords;
        this.lstTerminationRecords = records;
        this.loaded = true;
    }

    handleChangeSubCategory(event) {
        this.loaded = false;
        this.subCategoryValue = event.detail.value;
        let records = [];
        let lstRejectedRecords = [];
        this.lstOriginalTerminationRecords.forEach(element => {
            if((!this.categoryValue || element.MPCategory__c == this.categoryValue) && (!this.subCategoryValue || element.MPSubcategory__c == this.subCategoryValue)){
                records.push(element);                
            }
            if(element.MPStatus__c == 'Rejected'){
                lstRejectedRecords.push(element.Id);                
            }
        });
        this.lstRejectedRecords= lstRejectedRecords;
        this.lstTerminationRecords = records;
        this.loaded = true;
    }

    handleSaveClick() {     
        this.loaded = false;   
        console.log('handleSaveClick 1',this.rejectionReason);
        console.log('handleSaveClick 2',this.lstSelectedTerminationRecords.length);
        if((this.lstSelectedTerminationRecords.length>0 && this.rejectionReason) || this.lstSelectedTerminationRecords.length==0){
            if(this.lstSelectedTerminationRecords.length==0){
                this.rejectionReason = '';  
            }

            saveInformationClass({
                lstRejectedRecords:this.lstSelectedTerminationRecords,
                strRejectedReason:this.rejectionReason,
                idFTC:this.recordId
            }).then((result)=>{
                this.getTerms(result);
                this.dispatchEvent(new RefreshEvent());
            }).catch((error) => {
                
            });            
        }else if(this.lstSelectedTerminationRecords.length>0 && !this.rejectionReason){
            this.loaded = true;
            console.log('Method clicked...');
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Para poder guardar los registros se debe diligenciar la razon de rechazo',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }                
    }

    getTerms(result){
        let lstCategoriesOption = [{ label: null, value: null }];
        let lstCategories = [];
        let lstSubCategoriesOption = [{ label: null, value: null }];
        let lstSubCategories = [];
        let lstRejectedRecords = [];
        let data = JSON.parse(JSON.stringify(result));
        this.lstOriginalTerminationRecords = data;
        this.lstTerminationRecords = data;
        this.lstTerminationRecords.forEach(element => {
            if(!lstCategories.includes(element.MPCategory__c)){
                lstCategories.push(element.MPCategory__c);
                lstCategoriesOption.push({ label: element.MPCategory__c, value: element.MPCategory__c });
            }
            if(!lstSubCategories.includes(element.MPSubcategory__c)){
                lstSubCategories.push(element.MPSubcategory__c);
                lstSubCategoriesOption.push({ label: element.MPSubcategory__c, value: element.MPSubcategory__c });
            }
            if(element.MPStatus__c == 'Rejected'){
                lstRejectedRecords.push(element.Id);
                this.rejectionReason = element.FTC__r.MPRejectionReason__c;
            }
            
        });            
        this.categoryOptions = lstCategoriesOption;
        this.subCategoryOptions = lstSubCategoriesOption;
        this.lstRejectedRecords= lstRejectedRecords;
        this.loaded = true;
    }

    handleChangeReason(event){
        this.rejectionReason = event.detail.value;        
    }

    handleRowSelection(event){             
        let lstRecords = [];
        const selectedRows = event.detail.selectedRows;
        console.log('handleRowSelection',selectedRows.length);
        for (let i = 0; i < selectedRows.length; i++) {
            lstRecords.push(selectedRows[i]);            
        }
        this.lstSelectedTerminationRecords = lstRecords;
    }
}
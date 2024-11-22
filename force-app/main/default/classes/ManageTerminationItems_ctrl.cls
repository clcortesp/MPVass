public class ManageTerminationItems_ctrl {    

    @AuraEnabled(cacheable=true)
    public static List<MPTerminationRecord__c> getTerminationRecord(String idFTC) {
        List<MPTerminationRecord__c> lstTerminationRecord = new List<MPTerminationRecord__c>();
        List<order> lstorder = [select id,MPFTCPrincipal__c from order where id =: idFTC];
        if(lstorder.size()>0 && lstorder[0].MPFTCPrincipal__c != null){
            lstTerminationRecord = [SELECT id,MPDocumentNumber__c,MPDescription__c,MPCategory__c,
            MPSubcategory__c,MPItemValue__c,MPStatus__c,FTC__r.MPRejectionReason__c 
            FROM MPTerminationRecord__c WHERE FTC__c =: lstorder[0].MPFTCPrincipal__c order by MPStatus__c desc];
        }
        return lstTerminationRecord;
    }

    @AuraEnabled
    public static List<MPTerminationRecord__c> saveInformationClass(List<MPTerminationRecord__c> lstRejectedRecords,String strRejectedReason,String idFTC) {
        System.debug('ManageTerminationItems_ctrl  saveInformationClass 1: '+lstRejectedRecords.size()  );
        List<MPTerminationRecord__c> lstTerminationRecord = new List<MPTerminationRecord__c>();
        List<MPTerminationRecord__c> lstTerminationRecordToUpdate = new List<MPTerminationRecord__c>();

        List<order> lstorder = [select id,MPFTCPrincipal__c from order where id =: idFTC];
        System.debug('ManageTerminationItems_ctrl  saveInformationClass 2: '+lstorder.size()  );
        if(lstorder.size()>0 && lstorder[0].MPFTCPrincipal__c != null){
            MPContractTerminationRecords__c objContractTerminationRecords = new MPContractTerminationRecords__c();
            objContractTerminationRecords.id = lstorder[0].MPFTCPrincipal__c;
            objContractTerminationRecords.MPRejectionReason__c = strRejectedReason;
            update objContractTerminationRecords;

            lstTerminationRecord = [SELECT id,MPDocumentNumber__c,MPDescription__c,MPCategory__c,
            MPSubcategory__c,MPItemValue__c,MPStatus__c,FTC__r.MPRejectionReason__c 
            FROM MPTerminationRecord__c WHERE FTC__c =: lstorder[0].MPFTCPrincipal__c order by MPStatus__c desc];

            System.debug('ManageTerminationItems_ctrl  saveInformationClass 3: '+lstTerminationRecord.size());

            map<id,MPTerminationRecord__c> mapRejectedRecords = new map<id,MPTerminationRecord__c>(lstRejectedRecords);
            for(MPTerminationRecord__c iTerminationRecord : lstTerminationRecord){
                System.debug('ManageTerminationItems_ctrl  saveInformationClass 4: '+mapRejectedRecords.containsKey(iTerminationRecord.id));
                if(!mapRejectedRecords.containsKey(iTerminationRecord.id) && iTerminationRecord.MPStatus__c == 'Rejected'){
                    iTerminationRecord.MPStatus__c = 'Approved';
                    lstTerminationRecordToUpdate.add(iTerminationRecord);
                }else if(mapRejectedRecords.containsKey(iTerminationRecord.id) && iTerminationRecord.MPStatus__c != 'Rejected'){
                    iTerminationRecord.MPStatus__c = 'Rejected';
                    lstTerminationRecordToUpdate.add(iTerminationRecord);
                }
            }
        }

        update lstTerminationRecordToUpdate;
        return lstTerminationRecord;
    }
}
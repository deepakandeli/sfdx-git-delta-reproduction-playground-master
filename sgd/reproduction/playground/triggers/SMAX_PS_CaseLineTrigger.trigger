/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-06-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-06-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
trigger SMAX_PS_CaseLineTrigger on SVMXC__Case_Line__c (after insert,after update,after delete) {
    Set<id> caseIdSet = new Set<id>();

    List<SVMXC__Case_Line__c> caseLineList = new List<SVMXC__Case_Line__c>();
    List<Case> CaseList = new List<Case>();
    map<id,List<SVMXC__Case_Line__c>> caseIdCaseLinesListMap = new map<id,List<SVMXC__Case_Line__c>>();
     
    if(((Trigger.isAfter && Trigger.isUpdate))||(Trigger.isAfter && Trigger.isInsert)){
        
        for(SVMXC__Case_Line__c caseLineRec: Trigger.new) {
            if(((Trigger.isAfter && Trigger.isUpdate) &&((Trigger.oldMap.get(caseLineRec.Id).SVMXC__Installed_Product__c <> caseLineRec.SVMXC__Installed_Product__c) || (Trigger.oldMap.get(caseLineRec.Id).SVMXC__Product__c <> caseLineRec.SVMXC__Product__c))) || ((Trigger.isAfter && Trigger.isInsert))){
        
                caseIdSet.add(caseLineRec.SVMXC__Case__c);
            }   
        }

    }
    if((Trigger.isAfter && Trigger.isDelete)){
        for(SVMXC__Case_Line__c caseLineRec: Trigger.old) {
        
            caseIdSet.add(caseLineRec.SVMXC__Case__c);
        }
    }
      
    if(caseIdSet.size()>0){
        caseLineList = [SELECT id,SVMXC__Installed_Product__c,SVMXC__Product__c,Name,SVMXC__Case__c FROM SVMXC__Case_Line__c WHERE SVMXC__Case__c IN: caseIdSet ORDER BY Name ASC];
        CaseList = [SELECT id,SVMXC__Component__c,SVMXC__Product__c FROM Case WHERE id IN:caseIdSet];
    }
    if(caseLineList.size()>0){
        for(SVMXC__Case_Line__c clInstance:caseLineList){
            if(caseIdCaseLinesListMap.containsKey(clInstance.SVMXC__Case__c) && caseIdCaseLinesListMap.get(clInstance.SVMXC__Case__c) != null){
                List<SVMXC__Case_Line__c> clList = caseIdCaseLinesListMap.get(clInstance.SVMXC__Case__c);
                clList.add(clInstance);
                
            }else{
                caseIdCaseLinesListMap.put(clInstance.SVMXC__Case__c,new list<SVMXC__Case_Line__c>{clInstance});
            }
        }
        for(Case caseInstance:CaseList){
            //List<SVMXC__Case_Line__c> clList = caseIdCaseLinesListMap.get(caseInstance.Id);
            caseInstance.SVMXC__Component__c = (caseIdCaseLinesListMap.get(caseInstance.Id))[0].SVMXC__Installed_Product__c;
            caseInstance.SVMXC__Product__c = (caseIdCaseLinesListMap.get(caseInstance.Id))[0].SVMXC__Product__c;
        }
        
        
    }else{
        for(Case caseInstance:CaseList){
            //List<SVMXC__Case_Line__c> clList = caseIdCaseLinesListMap.get(caseInstance.Id);
            caseInstance.SVMXC__Component__c =null;
            caseInstance.SVMXC__Product__c = null;
        }
    }
    //DML
    if(CaseList.size()>0)
        UPDATE CaseList;
    
    
    
    

}
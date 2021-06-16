/**
* @description       : Trigger for the Quote Line Object.
* @author            : Vishnu Chandrasekar (SpringFive)
* @group             : 
* @last modified on  : 04-12-2021
* @last modified by  : Vishnu Chandrasekar (SpringFive)
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   04-12-2021   Vishnu Chandrasekar (SpringFive)   Initial Version
**/
trigger SMAX_PS_Quote on SVMXC__Quote__c (before insert,after insert,before update,after update,before delete,after delete,after undelete) {
   
   set<Id> quoteIdPriceListChangeSet = new set<Id>();
       
    for(SVMXC__Quote__c quoterec : Trigger.new) {
        
        if ((Trigger.isAfter && Trigger.isUpdate && ((Trigger.oldMap.get(quoterec.Id).SMAX_PS_Parts_Price_Book__c <> quoterec.SMAX_PS_Parts_Price_Book__c) || (Trigger.oldMap.get(quoterec.Id).SMAX_PS_Service_Pricebook__c <> quoterec.SMAX_PS_Service_Pricebook__c))))
        {
            quoteIdPriceListChangeSet.add(quoterec.id);
        }
       
    }

    if(quoteIdPriceListChangeSet.size() > 0){
        list<SMAX_PS_Quote_Lines__c> QuoteLinestoUpdatePriceList = [select id,SMAX_PS_Activity__c,SMAX_PS_Quote__c,SMAX_PS_Service_PBE__c,SMAX_PS_Line_Type__c,SMAX_PS_Service_Quote_IP_Line__c,SMAX_PS_Product__c,SMAX_PS_Customer_Procured__c,SMAX_PS_Quote__r.SMAX_PS_Parts_Price_Book__c, SMAX_PS_Activity_Type__c from SMAX_PS_Quote_Lines__c where SMAX_PS_Quote__c in :quoteIdPriceListChangeSet];
        
        SVMX_PS_ServiceQuotePricing.UpdateQuoteLinePriceAfterUpdate(QuoteLinestoUpdatePriceList,Trigger.oldMap,Trigger.newMap);
    }
    
    
}
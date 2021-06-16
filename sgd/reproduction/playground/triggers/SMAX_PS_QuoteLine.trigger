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
trigger SMAX_PS_QuoteLine on SMAX_PS_Quote_Lines__c (before insert,after insert,before update,after update,after undelete) {
  if(SVMX_PS_ServiceQuotePricing.triggerfromQuote)
  {
   List<SMAX_PS_Quote_Lines__c> QuoteLinestoUpdatePriceList = new List<SMAX_PS_Quote_Lines__c>();
   
       
    for(SMAX_PS_Quote_Lines__c quoteLinerec : Trigger.new) {
    //system.debug('SVMX_PS_ServiceQuotePricing.triggerfromQuote' +SVMX_PS_ServiceQuotePricing.checkTriggerCanRun());
        
        if ( (Trigger.isBefore && Trigger.isInsert) || 
             (Trigger.isBefore && Trigger.isUpdate && 
                 ((Trigger.oldMap.get(quoteLinerec.Id).SMAX_PS_Customer_Procured__c<> quoteLinerec.SMAX_PS_Customer_Procured__c) || 
                  (Trigger.oldMap.get(quoteLinerec.Id).SMAX_PS_Product__c <> quoteLinerec.SMAX_PS_Product__c) || 
                  (Trigger.oldMap.get(quoteLinerec.Id).SMAX_PS_Refer_PB__c<> quoteLinerec.SMAX_PS_Refer_PB__c) ) ))
        {
            QuoteLinestoUpdatePriceList.add(quoteLinerec);
        }
       
    }

    if(QuoteLinestoUpdatePriceList.size() > 0)
        SVMX_PS_ServiceQuotePricing.UpdateQuoteLinePriceBeforeInsertUpdate(QuoteLinestoUpdatePriceList,trigger.oldMap,trigger.newMap);
   } 
    
}
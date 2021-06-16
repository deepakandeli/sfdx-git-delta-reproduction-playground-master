/**
* @description       : Trigger for the Service Quote IP Line Object.
* @author            : Vishnu Chandrasekar (SpringFive)
* @group             : 
* @last modified on  : 04-09-2021
* @last modified by  : Vishnu Chandrasekar (SpringFive)
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   04-09-2021   Vishnu Chandrasekar (SpringFive)   Initial Version
**/
trigger SVMX_PS_QIPLine on SMAX_PS_Service_Quote_IP_Line__c (before insert,after insert,before update,after update,before delete,after delete,after undelete) {
   //List<SMAX_PS_Service_Quote_IP_Line__c> QuoteIPLineList = new List<SMAX_PS_Service_Quote_IP_Line__c>();
   set<id> quoteIpIdSet = new set<id>();
    Map<id,id> clonedFromIdQuoteIpLineMap = new Map<id,id>();
    Map<id,id> quoteIpLineIdQuoteIdMap = new Map<id,id>();
    map<id,id> oldquoteipIdNewquoteipIdMap =new map<id,id>();
    map<id,id> newquoteIPIdQuoteIdMap =new map<id,id>();
    set<id> oldquoteLineIdset = new set<id>();
    
    if(!Trigger.isDelete && !Trigger.isUndelete)
    {
    for(SMAX_PS_Service_Quote_IP_Line__c quoteIPLinerec : Trigger.new) {
        
        if (quoteIPLinerec.SMAX_PS_Task_Template__c != null && ((Trigger.isAfter && Trigger.isInsert) || (Trigger.isAfter && Trigger.isUpdate && Trigger.oldMap.get(quoteIPLinerec.Id).SMAX_PS_Task_Template__c <> quoteIPLinerec.SMAX_PS_Task_Template__c)) ){

                quoteIpIdSet.add(quoteIPLinerec.id);
        }
        /*if((Trigger.isAfter && Trigger.isInsert) && quoteIPLinerec.SMAX_PS_ClonedFromServiceQuoteIPLine__c != null){
            clonedFromIdQuoteIpLineMap.put(quoteIPLinerec.SMAX_PS_Cloned_From__c,quoteIPLinerec.id);
            quoteIpLineIdQuoteIdMap.put(quoteIPLinerec.id,quoteIPLinerec.SMAX_PS_Service_Quote__c);
            
        }*/
        if((Trigger.isAfter && Trigger.isInsert) && quoteIPLinerec.SMAX_PS_ClonedFromServiceQuoteIPLine__c != null)
        
        {

            oldquoteLineIdset.add(quoteIPLinerec.SMAX_PS_ClonedFromServiceQuoteIPLine__c);
            //NewquoteipIdoldquoteipIdMap.put(newquoteIP.id,newquoteIP.SMAX_PS_ClonedFromServiceQuoteIPLine__c);
            oldquoteipIdNewquoteipIdMap.put(quoteIPLinerec.SMAX_PS_ClonedFromServiceQuoteIPLine__c,quoteIPLinerec.id);
            newquoteIPIdQuoteIdMap.put(quoteIPLinerec.id,quoteIPLinerec.SMAX_PS_Service_Quote__c );
    
         }
        
    }
    }
    //system.debug('quoteIpIdSet' +quoteIpIdSet);
    if(quoteIpIdSet.size() > 0)
        SVMX_PS_ServiceQuotePricing.CreateQuoteLine(quoteIpIdSet);
    if(oldquoteipIdNewquoteipIdMap.size()>0 && newquoteIPIdQuoteIdMap.size()>0 && oldquoteLineIdset.size()>0 )
        SVMX_PS_ServiceQuotePricing.CreateQuoteLinesForClonedQuote(oldquoteipIdNewquoteipIdMap,newquoteIPIdQuoteIdMap,oldquoteLineIdset);
    
}
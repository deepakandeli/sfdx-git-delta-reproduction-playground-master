/**
* @description       : This class will handle the Service Quote Price calculation
* @author            : Vishnu Chandrasekar (SpringFive)
* @group             : Servicemax PS
* @last modified on  : 04-22-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   10-22-2020   Vishnu Chandrasekar                   Initial Version
**/   
public class SVMX_PS_ServiceQuotePricing {
    
    public static boolean triggerfromQuote = true;
    public static boolean triggerfromQuoteLine = true;
    
    public static void CreateQuoteLine(set<Id> QuoteIPId )
    {

        system.debug('HI');
        List<SMAX_PS_Service_Quote_IP_Line__c> QuoteIPLine = [select id,SMAX_PS_Service_Quote__c,SMAX_PS_Service_Quote__r.SMAX_PS_Parts_Price_Book__c,SMAX_PS_Service_Quote__r.SMAX_PS_Service_Pricebook__c, SMAX_PS_Task_Template__c from SMAX_PS_Service_Quote_IP_Line__c where Id in :QuoteIPId];
        system.debug('QuoteIPLine' +QuoteIPLine);
        set<id> TTSetId = new set<id>();
        //map<id,id> QuoteIdPriceBookIdMap = new map<id,id>();
        //map<id,id> QuoteIdServicePriceBookIdMap = new map<id,id>();
        set<id> priceBookIdSet = new set<id>();
        set<id> servicePriceBookIdSet = new set<id>();
        map<id,SMAX_PS_Service_Quote_IP_Line__c> QuoteIPIdTTSetId = new map<id,SMAX_PS_Service_Quote_IP_Line__c>();
        system.debug('QuoteIPLine'+QuoteIPLine);
        for(SMAX_PS_Service_Quote_IP_Line__c qip : QuoteIPLine)
        {
            system.debug('insedie');
            TTSetId.add(qip.SMAX_PS_Task_Template__c);
            if(qip.SMAX_PS_Service_Quote__r.SMAX_PS_Parts_Price_Book__c != null )
                priceBookIdSet.add(qip.SMAX_PS_Service_Quote__r.SMAX_PS_Parts_Price_Book__c);
            if(qip.SMAX_PS_Service_Quote__r.SMAX_PS_Service_Pricebook__c != null)
                servicePriceBookIdSet.add(qip.SMAX_PS_Service_Quote__r.SMAX_PS_Service_Pricebook__c);
            QuoteIPIdTTSetId.put(qip.id,qip);
            system.debug('QuoteIPIdTTSetId'+QuoteIPIdTTSetId);
            
        }
        
        
        //map<id,PricebookEntry> PBEIdRecMap = new map<id,PricebookEntry>([SELECT Id,UnitPrice,Product2Id,Pricebook2Id FROM PricebookEntry where Pricebook2Id in :priceBookIdSet ]);
        //map<id,SVMXC__Service_Pricebook_Entry__c> SPBEIdRecMap = new map<id,SVMXC__Service_Pricebook_Entry__c>([SELECT Id,SVMXC__Regular_Rate__c,SVMXC__Price_Book__c,SVMXC__Activity__c,SVMXC__Activity_Product__c,SVMXC__Activity_Type__c FROM SVMXC__Service_Pricebook_Entry__c where SVMXC__Price_Book__c in :servicePriceBookIdSet]);
        
        map<id,List<SVMXC__Required_Part__c>> TaskTemplateIdRequiredPartIdMap = new map<id,List<SVMXC__Required_Part__c>>();
        set<id> PartIdSet = new set<id>();
        set<id> ActivityIdSet = new set<id>();
        for(SVMXC__Required_Part__c rl : [select id,SVMXC__Product__c,SVMXC__Work_Order_Purpose__c,SMAX_PS_Activity__c,SMAX_PS_Line_Type__c,SVMXC__Quantity__c, SMAX_PS_Item_Name__c, SMAX_PS_SAP_HTSPlantStatus__c, SMAX_PS_Pack_Unit_No__c, SMAX_PS_Remarks__c, SMAX_PS_Unit_Of_Measure__c, SMAX_PS_Use_Purpose__c, SMAX_PS_Activity_Type__c, SMAX_PS_Service_Target__c, SMAX_PS_Product_Classification__c  from SVMXC__Required_Part__c where SVMXC__Work_Order_Purpose__c in :TTSetId])
        {
            if(rl.SVMXC__Product__c != null)
                PartIdSet.add(rl.SVMXC__Product__c);
            if(rl.SMAX_PS_Activity__c != null)
                ActivityIdSet.add(rl.SMAX_PS_Activity__c);
            if(TaskTemplateIdRequiredPartIdMap.containsKey(rl.SVMXC__Work_Order_Purpose__c) && TaskTemplateIdRequiredPartIdMap.get(rl.SVMXC__Work_Order_Purpose__c) != null) {
                List<SVMXC__Required_Part__c> reqPartActivityList = TaskTemplateIdRequiredPartIdMap.get(rl.SVMXC__Work_Order_Purpose__c);
                reqPartActivityList.add(rl);
                TaskTemplateIdRequiredPartIdMap.put(rl.SVMXC__Work_Order_Purpose__c,reqPartActivityList); 
            }   
            else {
                TaskTemplateIdRequiredPartIdMap.put(rl.SVMXC__Work_Order_Purpose__c, new List<SVMXC__Required_Part__c> {rl});
            }
            
        }
        map<string,PricebookEntry> PricebookIdProductIdRecMap = new map<string,PricebookEntry>();
        map<string,SVMXC__Service_Pricebook_Entry__c> ServicePricebookIdActivityIdRecMap = new map<string,SVMXC__Service_Pricebook_Entry__c>();
        
        for(PricebookEntry pbe : [SELECT Id,UnitPrice,Product2Id,Pricebook2Id FROM PricebookEntry where Pricebook2Id in :priceBookIdSet AND Product2Id in :PartIdSet] )
        {
            PricebookIdProductIdRecMap.put(pbe.Pricebook2Id+'#'+pbe.Product2Id,pbe);
        }
        system.debug('PricebookIdProductIdRecMap' +PricebookIdProductIdRecMap);
        for(SVMXC__Service_Pricebook_Entry__c spbe : [SELECT Id,SVMXC__Regular_Rate__c,SVMXC__Price_Book__c,SVMXC__Activity_Product__c,SVMXC__Activity_Type__c,SVMXC__Activity_Product__r.SVMXC__Product__c FROM SVMXC__Service_Pricebook_Entry__c where SVMXC__Price_Book__c in :servicePriceBookIdSet] )
        {
            ServicePricebookIdActivityIdRecMap.put(spbe.SVMXC__Price_Book__c+'#'+spbe.SVMXC__Activity_Product__r.SVMXC__Product__c+'#'+spbe.SVMXC__Activity_Type__c,spbe);
        }
        
        list<SMAX_PS_Quote_Lines__c> QuoteLineTobeAddList = new list<SMAX_PS_Quote_Lines__c>();
        for(id QuoteIpLineId : QuoteIPIdTTSetId.keySet()){
            if((TaskTemplateIdRequiredPartIdMap.get(QuoteIPIdTTSetId.get(QuoteIpLineId).SMAX_PS_Task_Template__c))!=null){
            
            list<SVMXC__Required_Part__c> ReqPartList = TaskTemplateIdRequiredPartIdMap.get(QuoteIPIdTTSetId.get(QuoteIpLineId).SMAX_PS_Task_Template__c);
            system.debug('ReqPartList' +ReqPartList.size());
            for(SVMXC__Required_Part__c rp : ReqPartList)
            {
                SMAX_PS_Quote_Lines__c QLsObject = new SMAX_PS_Quote_Lines__c();
                QLsObject.SMAX_PS_Service_Quote_IP_Line__c = QuoteIpLineId;
                QLsObject.SMAX_PS_Quote__c  = QuoteIPIdTTSetId.get(QuoteIpLineId).SMAX_PS_Service_Quote__c;
                QLsObject.SMAX_PS_Product__c = rp.SVMXC__Product__c;
                if(rp.SMAX_PS_Line_Type__c == '1003' )
                {
                    if(PricebookIdProductIdRecMap.get(QuoteIPIdTTSetId.get(QuoteIpLineId).SMAX_PS_Service_Quote__r.SMAX_PS_Parts_Price_Book__c+'#'+rp.SVMXC__Product__c) != null )
                        QLsObject.SMAX_PS_Unit_Price__c = PricebookIdProductIdRecMap.get(QuoteIPIdTTSetId.get(QuoteIpLineId).SMAX_PS_Service_Quote__r.SMAX_PS_Parts_Price_Book__c+'#'+rp.SVMXC__Product__c).UnitPrice;
                        QLsObject.SMAX_PS_Customer_Procured__c = false;
                    
                }
                else{
                    //QLsObject.SMAX_PS_Activity__c  = rp.SMAX_PS_Activity__c; 
                    if(ServicePricebookIdActivityIdRecMap.get(QuoteIPIdTTSetId.get(QuoteIpLineId).SMAX_PS_Service_Quote__r.SMAX_PS_Service_Pricebook__c+'#'+rp.SVMXC__Product__c+'#'+rp.SMAX_PS_Activity_Type__c) != null ){
                        QLsObject.SMAX_PS_Unit_Price__c = ServicePricebookIdActivityIdRecMap.get(QuoteIPIdTTSetId.get(QuoteIpLineId).SMAX_PS_Service_Quote__r.SMAX_PS_Service_Pricebook__c+'#'+rp.SVMXC__Product__c+'#'+rp.SMAX_PS_Activity_Type__c).SVMXC__Regular_Rate__c;
                        QLsObject.SMAX_PS_Service_PBE__c = ServicePricebookIdActivityIdRecMap.get(QuoteIPIdTTSetId.get(QuoteIpLineId).SMAX_PS_Service_Quote__r.SMAX_PS_Service_Pricebook__c+'#'+rp.SVMXC__Product__c+'#'+rp.SMAX_PS_Activity_Type__c).Id;
                    }
                    QLsObject.SMAX_PS_Refer_PB__c = true; //Nagur: by default need to be true for all non-parts lines
                    QLsObject.SMAX_PS_Expense_Target__c = true; //Nagur: by default need to be true for all non-parts lines
                }
                QLsObject.SMAX_PS_Line_Type__c = rp.SMAX_PS_Line_Type__c;
                QLsObject.SMAX_PS_Quantity2__c = rp.SVMXC__Quantity__c;
                //Nagur Add
                QLsObject.SMAX_PS_Item_Name__c = rp.SMAX_PS_Item_Name__c;
                QLsObject.SMAX_PS_Pack_Unit_No__c = rp.SMAX_PS_Pack_Unit_No__c;
                QLsObject.SMAX_PS_Remarks__c = rp.SMAX_PS_Remarks__c;
                QLsObject.SMAX_PS_Unit_Of_Measure__c = rp.SMAX_PS_Unit_Of_Measure__c;
                QLsObject.SMAX_PS_Use_Purpose__c = rp.SMAX_PS_Use_Purpose__c;
                QLsObject.SMAX_PS_SAP_HTSPlantStatus__c= rp.SMAX_PS_SAP_HTSPlantStatus__c;
                QLsObject.SMAX_PS_Activity_Type__c= rp.SMAX_PS_Activity_Type__c;
                QLsObject.SMAX_PS_Service_Target__c= rp.SMAX_PS_Service_Target__c;
                QLsObject.SMAX_PS_Product_Classification__c= rp.SMAX_PS_Product_Classification__c;
                //Nagur Add
                /*if(QLsObject.SMAX_PS_Line_Type__c != '1003'){
                    QLsObject.SMAX_PS_Refer_PB__c = true;
                    QLsObject.SMAX_PS_Expense_Target__c = true;
                }else{
                    QLsObject.SMAX_PS_Customer_Procured__c = false;
                }*/
                QuoteLineTobeAddList.add(QLsObject);
                
            }
            }
            
        }
        system.debug('QuoteLineTobeAddList' + QuoteLineTobeAddList);
        system.debug('QuoteLineTobeAddList size' + QuoteLineTobeAddList.size());
        //checkTriggerCanRun();
        triggerfromQuote = false;
        if(QuoteLineTobeAddList.size() > 0 )
            insert QuoteLineTobeAddList;
    }
    
    public static void UpdateQuoteLinePriceBeforeInsertUpdate(list<SMAX_PS_Quote_Lines__c> quoteLinesList,map<id,SMAX_PS_Quote_Lines__c>oldMapQuoteLines,map<id,SMAX_PS_Quote_Lines__c>newMapQuoteLines)
    {
        triggerfromQuoteLine = false;
        set<id> priceBookIdSet = new set<id>();
        set<id> PartIdSet = new set<id>();
        set<id> servicePriceBookIdSet = new set<id>();
        set<id> servicePriceBookEntryIdSet = new set<id>();
        set<id> ActivityIdSet = new set<id>();
        set<id> quoteIdSet = new set<id>();
        system.debug('Old map is' +oldMapQuoteLines);
        for(SMAX_PS_Quote_Lines__c ql : quoteLinesList){

            PartIdSet.add(ql.SMAX_PS_Product__c);
            servicePriceBookEntryIdSet.add(ql.SMAX_PS_Service_PBE__c);
            ActivityIdSet.add(ql.SMAX_PS_Activity__c);
            quoteIdSet.add(ql.SMAX_PS_Quote__c);
            
        }
        map<id,id> quoteIdPriceBookIdMap = new map<id,id>();
        map<id,id> quoteIdServicePriceBookIdMap = new map<id,id>();
        for(SVMXC__Quote__c qo : [select id,SMAX_PS_Parts_Price_Book__c,SMAX_PS_Service_Pricebook__c from SVMXC__Quote__c where id in : quoteIdSet ])
        {
            priceBookIdSet.add(qo.SMAX_PS_Parts_Price_Book__c);
            quoteIdPriceBookIdMap.put(qo.id,qo.SMAX_PS_Parts_Price_Book__c);
            servicePriceBookIdSet.add(qo.SMAX_PS_Service_Pricebook__c);
            quoteIdServicePriceBookIdMap.put(qo.id,qo.SMAX_PS_Service_Pricebook__c);
        }
        map<string,PricebookEntry> PricebookIdProductIdRecMap = new map<string,PricebookEntry>();
        map<string,SVMXC__Service_Pricebook_Entry__c> ServicePricebookIdActivityIdRecMap = new map<string,SVMXC__Service_Pricebook_Entry__c>();
        map<string,SVMXC__Service_Pricebook_Entry__c> SPIdActivityIdRecMap = new map<string,SVMXC__Service_Pricebook_Entry__c>();
        
        for(PricebookEntry pbe : [SELECT Id,UnitPrice,Product2Id,Pricebook2Id FROM PricebookEntry where Pricebook2Id in :priceBookIdSet AND Product2Id in :PartIdSet] )
        {
            PricebookIdProductIdRecMap.put(pbe.Pricebook2Id+'#'+pbe.Product2Id,pbe);
        }
        system.debug('PricebookIdProductIdRecMap' +PricebookIdProductIdRecMap);
        system.debug('servicePriceBookIdSet' +servicePriceBookIdSet);
        system.debug('ActivityIdSet' +ActivityIdSet);
        system.debug('PartIdSet' +PartIdSet);
       
        
        string dynSOQL = 'SELECT Id,SVMXC__Regular_Rate__c,SVMXC__Price_Book__c,SVMXC__Activity_Product__c,SVMXC__Activity_Type__c,SVMXC__Activity_Product__r.SVMXC__Product__c FROM SVMXC__Service_Pricebook_Entry__c where';
        string whereclause = '(SVMXC__Price_Book__c in : servicePriceBookIdSet)';
        /*if(!servicePriceBookEntryIdSet.isempty())
            whereclause = whereclause+'OR (Id in :servicePriceBookEntryIdSet AND SVMXC__Product__c in :PartIdSet)';*/
        system.debug('Query' +dynSOQL+' ' +whereclause);
        List<SVMXC__Service_Pricebook_Entry__c> spbeList = database.query(dynSOQL+' ' +whereclause);
        system.debug('spbeList'+spbeList);
        for(SVMXC__Service_Pricebook_Entry__c spbe : spbeList)
        {
            ServicePricebookIdActivityIdRecMap.put(spbe.SVMXC__Price_Book__c+'#'+spbe.SVMXC__Activity_Product__r.SVMXC__Product__c+'#'+spbe.SVMXC__Activity_Type__c,spbe);
            SPIdActivityIdRecMap.put(spbe.Id+'#'+spbe.SVMXC__Activity_Product__r.SVMXC__Product__c+'#'+spbe.SVMXC__Activity_Type__c,spbe);
        }
        Id quotePriceBookId;
        Id quoteServicePriceBookId;
        system.debug('SPIdActivityIdRecMap'+SPIdActivityIdRecMap);
        system.debug('ServicePricebookIdActivityIdRecMap'+ServicePricebookIdActivityIdRecMap);
        //list<SMAX_PS_Quote_Lines__c> quoteLinesTobeUpdate = new list<SMAX_PS_Quote_Lines__c>();
        for(SMAX_PS_Quote_Lines__c qls : quoteLinesList)
        {
            quotePriceBookId = quoteIdPriceBookIdMap.get(qls.SMAX_PS_Quote__c);
            quoteServicePriceBookId = quoteIdServicePriceBookIdMap.get(qls.SMAX_PS_Quote__c);
            if(qls.SMAX_PS_Line_Type__c  == '1003')
            {
                //Nagur Added SMAX_PS_Customer_Procured__c criteria
                if(qls.SMAX_PS_Customer_Procured__c == true)
                    qls.SMAX_PS_Unit_Price__c = 0;
                else {
                    if(PricebookIdProductIdRecMap.get(quotePriceBookId+'#'+qls.SMAX_PS_Product__c) != null )
                        qls.SMAX_PS_Unit_Price__c = PricebookIdProductIdRecMap.get(quotePriceBookId+'#'+qls.SMAX_PS_Product__c).UnitPrice;
                    else
                        qls.SMAX_PS_Unit_Price__c = 0;
                }
                
            }
            else
            {
                
                system.debug('Key is'+quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c);
                system.debug('oldMapQuoteLines' +oldMapQuoteLines);
                //system.debug('The value is'+oldMapQuoteLines.get(qls.id).SMAX_PS_Service_PBE__c+ 'Other value is'+oldMapQuoteLines.get(qls.id).SMAX_PS_Activity__c);
                //Scenario User creates new record with SPEID and Activity Id to update the unit price
                if(ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c) != null && oldMapQuoteLines == null )
                {
                    system.debug('Scene 1');
                    qls.SMAX_PS_Unit_Price__c = ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c).SVMXC__Regular_Rate__c;
                    //qls.SMAX_PS_Service_PBE__c = ServicePricebookIdActivityIdRecMap.get(qls.SMAX_PS_Service_PBE__c+'#'+qls.SMAX_PS_Activity__c).Id;
                }
                //Scenario User creates new record with Only Activity Id to update the unit price
                /*else if( qls.SMAX_PS_Service_PBE__c == null && ServicePricebookIdActivityIdRecMap.get( quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c) != null && oldMapQuoteLines == null ){
                    qls.SMAX_PS_Unit_Price__c = ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c).SVMXC__Regular_Rate__c;
                    system.debug('Scene 2');
                    qls.SMAX_PS_Service_PBE__c = ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c).Id;
                }
                
                //Scenario User Changes the Price book entry and Activity id manually to update the unit price 
                else if(SPIdActivityIdRecMap.get(qls.SMAX_PS_Service_PBE__c+'#'+qls.SMAX_PS_Product__c) != null && qls.SMAX_PS_Service_PBE__c != null && oldMapQuoteLines.get(qls.id).SMAX_PS_Product__c != qls.SMAX_PS_Product__c && oldMapQuoteLines.get(qls.id).SMAX_PS_Service_PBE__c != qls.SMAX_PS_Service_PBE__c){
                    qls.SMAX_PS_Unit_Price__c = SPIdActivityIdRecMap.get(qls.SMAX_PS_Service_PBE__c+'#'+qls.SMAX_PS_Product__c).SVMXC__Regular_Rate__c;
                    system.debug('Scene 3');
                    //qls.SMAX_PS_Service_PBE__c = ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Activity__c).Id;
                }*/
                //Scenario User nullify the Price book entry and change the Activity id manually to update the unit price 
                //Since trigger this code will be executed only for required field changes, clearing product change filter as checkbox change also need to be captured.
                //else if(ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c) != null && oldMapQuoteLines.get(qls.id).SMAX_PS_Product__c != qls.SMAX_PS_Product__c){
                else if(ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c) != null && qls.SMAX_PS_Refer_PB__c == true){
                    qls.SMAX_PS_Unit_Price__c = ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c).SVMXC__Regular_Rate__c;
                    system.debug('Scene 4');
                    qls.SMAX_PS_Service_PBE__c = ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c).Id;
                }
                
                //else if(oldMapQuoteLines.get(qls.id).SMAX_PS_Activity__c != qls.SMAX_PS_Activity__c && qls.SMAX_PS_Service_PBE__c == null && ServicePricebookIdActivityIdRecMap.get( quoteServicePriceBookId+'#'+qls.SMAX_PS_Activity__c) != null ){
                
                else{
                    system.debug('Scene 5');
                    //Nagur If price information is not fetched no need to reset the price
                    //qls.SMAX_PS_Unit_Price__c = 0;
                    //qls.SMAX_PS_Service_PBE__c = null;
                }
            }
        }
    }
    public static void UpdateQuoteLinePriceAfterUpdate(list<SMAX_PS_Quote_Lines__c> quoteLinesList,map<id,svmxc__quote__c>oldMapQuote,map<id,svmxc__quote__c>newMapQuote ){
        set<id> priceBookIdSet = new set<id>();
        set<id> PartIdSet = new set<id>();
        set<id> servicePriceBookEntryIdSet = new set<id>();
        set<id> ActivityIdSet = new set<id>();
        set<id> quoteIdSet = new set<id>();
        for(SMAX_PS_Quote_Lines__c ql : quoteLinesList){
            //priceBookIdSet.add(ql.SMAX_PS_Quote__r.SMAX_PS_Parts_Price_Book__c);
            PartIdSet.add(ql.SMAX_PS_Product__c);
            //servicePriceBookEntryIdSet.add(ql.SMAX_PS_Service_PBE__c);
            ActivityIdSet.add(ql.SMAX_PS_Activity__c);
            quoteIdSet.add(ql.SMAX_PS_Quote__c);
            
        }
        map<id,id> quoteIdPriceBookIdMap = new map<id,id>();
        map<id,id> quoteIdServicePriceBookIdMap = new map<id,id>();
        for(SVMXC__Quote__c qo : [select id,SMAX_PS_Parts_Price_Book__c,SMAX_PS_Service_Pricebook__c from SVMXC__Quote__c where id in : quoteIdSet ])
        {
            priceBookIdSet.add(qo.SMAX_PS_Parts_Price_Book__c);
            servicePriceBookEntryIdSet.add(qo.SMAX_PS_Service_Pricebook__c);
            quoteIdPriceBookIdMap.put(qo.id,qo.SMAX_PS_Parts_Price_Book__c);
            quoteIdServicePriceBookIdMap.put(qo.id,qo.SMAX_PS_Service_Pricebook__c);
        }
        map<string,PricebookEntry> PricebookIdProductIdRecMap = new map<string,PricebookEntry>();
        map<string,SVMXC__Service_Pricebook_Entry__c> ServicePricebookIdActivityIdRecMap = new map<string,SVMXC__Service_Pricebook_Entry__c>();
        
        for(PricebookEntry pbe : [SELECT Id,UnitPrice,Product2Id,Pricebook2Id FROM PricebookEntry where Pricebook2Id in :priceBookIdSet AND Product2Id in :PartIdSet] )
        {
            PricebookIdProductIdRecMap.put(pbe.Pricebook2Id+'#'+pbe.Product2Id,pbe);
        }
        system.debug('PricebookIdProductIdRecMap' +PricebookIdProductIdRecMap);
        for(SVMXC__Service_Pricebook_Entry__c spbe : [SELECT Id,SVMXC__Regular_Rate__c,SVMXC__Price_Book__c,SVMXC__Activity_Product__c,SVMXC__Activity_Type__c,SVMXC__Activity_Product__r.SVMXC__Product__c FROM SVMXC__Service_Pricebook_Entry__c where SVMXC__Price_Book__c in :servicePriceBookEntryIdSet] )
        {
            ServicePricebookIdActivityIdRecMap.put(spbe.SVMXC__Price_Book__c+'#'+spbe.SVMXC__Activity_Product__r.SVMXC__Product__c+'#'+spbe.SVMXC__Activity_Type__c,spbe);
        }
        Id quotePriceBookId;
        Id quoteServicePriceBookId;
        list<SMAX_PS_Quote_Lines__c> quoteLinesTobeUpdate = new list<SMAX_PS_Quote_Lines__c>();
        for(SMAX_PS_Quote_Lines__c qls : quoteLinesList)
        {
            quotePriceBookId = quoteIdPriceBookIdMap.get(qls.SMAX_PS_Quote__c);
            quoteServicePriceBookId = quoteIdServicePriceBookIdMap.get(qls.SMAX_PS_Quote__c);
            
            if(qls.SMAX_PS_Line_Type__c  == '1003' && (oldMapQuote.get(qls.SMAX_PS_Quote__c).SMAX_PS_Parts_Price_Book__c != newMapQuote.get(qls.SMAX_PS_Quote__c).SMAX_PS_Parts_Price_Book__c ) )
            {
                //Nagur Added SMAX_PS_Customer_Procured__c criteria
                if(qls.SMAX_PS_Customer_Procured__c == true)
                    qls.SMAX_PS_Unit_Price__c = 0;
                else {
                    if(PricebookIdProductIdRecMap.get(quotePriceBookId+'#'+qls.SMAX_PS_Product__c) != null )
                        qls.SMAX_PS_Unit_Price__c = PricebookIdProductIdRecMap.get(quotePriceBookId+'#'+qls.SMAX_PS_Product__c).UnitPrice;
                    else
                        qls.SMAX_PS_Unit_Price__c = 0;
                }                    
            }
            
            if(qls.SMAX_PS_Line_Type__c  != '1003' && oldMapQuote.get(qls.SMAX_PS_Quote__c).SMAX_PS_Service_Pricebook__c != newMapQuote.get(qls.SMAX_PS_Quote__c).SMAX_PS_Service_Pricebook__c)
            {
                system.debug('Inside Service Price');
                if(ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c) != null ){
                    system.debug('Update Service Prioce');
                    system.debug('Flat Rate is' +ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c).SVMXC__Regular_Rate__c);
                    qls.SMAX_PS_Unit_Price__c = ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c).SVMXC__Regular_Rate__c;
                    qls.SMAX_PS_Service_PBE__c = ServicePricebookIdActivityIdRecMap.get(quoteServicePriceBookId+'#'+qls.SMAX_PS_Product__c+'#'+qls.SMAX_PS_Activity_Type__c).Id;
                }
                
                else{
                    
                    qls.SMAX_PS_Unit_Price__c = 0;
                    qls.SMAX_PS_Service_PBE__c = null;
                }
                
            }
            
            
            quoteLinesTobeUpdate.add(qls);
        }
        system.debug('quoteLinesTobeUpdate' +quoteLinesTobeUpdate);
        system.debug('triggerfromQuote' +triggerfromQuote);
        //checkTriggerCanRun();
        triggerfromQuote = false;
        update quoteLinesTobeUpdate;
        
    }
    
    public static boolean checkTriggerCanRun(){
    if(triggerfromQuote){
     triggerfromQuote=false;
     return true;
    }else{
        return triggerfromQuote;
    }
    }
    public static void CreateQuoteLinesForClonedQuote(Map<id,id> oldquoteipIdNewquoteipIdMap,Map<id,id> newquoteIPIdQuoteIdMap,set<id> oldquoteLineIdset){
        List<SMAX_PS_Quote_Lines__c> oldQuoteLineList = [SELECT SMAX_PS_Refer_PB__c,SMAX_PS_Service_Quote_IP_Line__c,SMAX_PS_Service_Target__c,SMAX_PS_Product_Classification__c,SMAX_PS_Service_PBE__c,SMAX_PS_Item_Name__c,SMAX_PS_Quantity2__c,SMAX_PS_Unit_Price__c,SMAX_PS_Expense_Target__c,
                                                        SMAX_PS_Activity__c,SMAX_PS_Product__c,SMAX_PS_Line_Type__c,SMAX_PS_Customer_Procured__c,SMAX_PS_Use_Purpose__c,SMAX_PS_Remarks__c,SMAX_PS_SAP_HTSPlantStatus__c,SMAX_PS_Pack_Unit_No__c FROM SMAX_PS_Quote_Lines__c WHERE SMAX_PS_Service_Quote_IP_Line__c in :oldquoteLineIdset];
        system.debug('oldQuoteLineList'+oldQuoteLineList.size());

        List<SMAX_PS_Quote_Lines__c> QuoteLineTobeInserted=new List<SMAX_PS_Quote_Lines__c>();
        for(SMAX_PS_Quote_Lines__c oldqls:oldQuoteLineList){
            //id oldsqIpLineId=oldqls.SMAX_PS_Service_Quote_IP_Line__c;
            SMAX_PS_Quote_Lines__c clonedquoteLines = oldqls.clone(false);
            system.debug(oldquoteipIdNewquoteipIdMap.get(oldqls.SMAX_PS_Service_Quote_IP_Line__c));
            system.debug(newquoteIPIdQuoteIdMap.get(oldquoteipIdNewquoteipIdMap.get(oldqls.SMAX_PS_Service_Quote_IP_Line__c)));
            clonedquoteLines.SMAX_PS_Service_Quote_IP_Line__c=oldquoteipIdNewquoteipIdMap.get(oldqls.SMAX_PS_Service_Quote_IP_Line__c);
            clonedquoteLines.SMAX_PS_Quote__c = newquoteIPIdQuoteIdMap.get(oldquoteipIdNewquoteipIdMap.get(oldqls.SMAX_PS_Service_Quote_IP_Line__c));
            clonedquoteLines.SMAX_PS_Cloned_From_Quote_Lines__c = oldqls.id; 
            QuoteLineTobeInserted.add(clonedquoteLines);
            
        }
        system.debug('QuoteLineTobeInserted' + QuoteLineTobeInserted);
        if(QuoteLineTobeInserted.size()>0)
            insert QuoteLineTobeInserted;


    }
    /*public static void CreateQuoteLinesForClonedQuote(Map<id,id> clonedFromIdQuoteIpLineMap,Map<id,id> quoteIpLineIdQuoteIdMap,set<id> oldquoteLineIdset){
        set<id> clonedFromIdSet=clonedFromIdQuoteIpLineMap.keyset();

        List<SMAX_PS_Quote_Lines__c> QuoteLineList = [SELECT id,Name,SMAX_PS_Refer_PB__c,SMAX_PS_Service_Quote_IP_Line__c,SMAX_PS_Service_Target__c,SMAX_PS_Product_Classification__c,SMAX_PS_Service_PBE__c,SMAX_PS_Item_Name__c,SMAX_PS_Quantity2__c,SMAX_PS_Pack_Unit_No__c,SMAX_PS_Unit_Price__c,SMAX_PS_Expense_Target__c,
                                                        SMAX_PS_Activity__c,SMAX_PS_Product__c,SMAX_PS_Line_Type__c,SMAX_PS_Customer_Procured__c,SMAX_PS_Use_Purpose__c,SMAX_PS_Remarks__c,SMAX_PS_SAP_HTSPlantStatus__c
                                                        FROM SMAX_PS_Quote_Lines__c WHERE SMAX_PS_Service_Quote_IP_Line__c IN : clonedFromIdSet];
        //List<SMAX_PS_Quote_Lines__c> newQuoteLineList = QuoteLineList;
        List<SMAX_PS_Quote_Lines__c> clonedQlList = new List<SMAX_PS_Quote_Lines__c>();
        for(SMAX_PS_Quote_Lines__c qlInstance:QuoteLineList){
            id oldsqIpLineId=qlInstance.SMAX_PS_Service_Quote_IP_Line__c;
            qlInstance.SMAX_PS_Service_Quote_IP_Line__c=clonedFromIdQuoteIpLineMap.get(oldsqIpLineId);
            qlInstance.SMAX_PS_Quote__c = quoteIpLineIdQuoteIdMap.get(qlInstance.SMAX_PS_Service_Quote_IP_Line__c);
            qlInstance.id=null;
            clonedQlList.add(qlInstance);
        }
        //List<SMAX_PS_Quote_Lines__c> clonedQlList = new List<SMAX_PS_Quote_Lines__c>(QuoteLineList);
        //DML
        Insert clonedQlList;


    }*/
    
}
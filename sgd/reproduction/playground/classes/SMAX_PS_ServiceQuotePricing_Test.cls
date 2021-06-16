/**
* @description       : Test Data Class 
* @author            : Pavithira (SpringFive)
* @group             : Servicemax PS
* @last modified on  : 24-05-2021
* @last modified by  : Deepak Andeli
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   10-22-2020   Pavithira                 Initial Version
**/
@isTest
public with sharing class SMAX_PS_ServiceQuotePricing_Test {

      static testMethod void createQuoteLineTest(){
          
        //Create product,tasktemplate,ActivityMaster and RequiredParts
        Product2 product = SMAX_PS_TestDataFactory.CreateProduct('Test Product','3000');
        insert product;
        SVMXC__Task_Template__c ttemplate = SMAX_PS_TestDataFactory.CreateTasktemplate('testTemplate');
        insert ttemplate;
        SVMXC__Activity_Master__c activityMaster = SMAX_PS_TestDataFactory.createActivityMaster('3000');
        insert activityMaster;
        SVMXC__Activity_Product__c activityProduct = SMAX_PS_TestDataFactory.createActivityProduct(activityMaster,product);
        insert activityProduct; 
        List<SVMXC__Required_Part__c> reqPartList = new List<SVMXC__Required_Part__c>();
        SVMXC__Required_Part__c requiredPart1 = SMAX_PS_TestDataFactory.createRequiredPart(ttemplate,null,activityMaster,'1001','3000');
        SVMXC__Required_Part__c requiredPart = SMAX_PS_TestDataFactory.createRequiredPart(ttemplate,null,activityMaster,'1002','4000');
        SVMXC__Required_Part__c requiredPart2 = SMAX_PS_TestDataFactory.createRequiredPart(ttemplate,product,null,'1003',null);
        reqPartList.add(requiredPart1);
        reqPartList.add(requiredPart);
        reqPartList.add(requiredPart2);
        insert reqPartList;
        
        //Create Pricing records
        PricebookEntry stdPriceBookEntry = new PricebookEntry();
        stdPriceBookEntry.Pricebook2Id = Test.getStandardPricebookId();
        stdPriceBookEntry.IsActive = True;
        stdPriceBookEntry.Product2Id = product.id;
        stdPriceBookEntry.UnitPrice = 100;
        insert stdPriceBookEntry;
        List<Pricebook2> priceBookList = new List<Pricebook2>();
        Pricebook2 pricebookFirst = SMAX_PS_TestDataFactory.CreatePricebook('Test Parts Pricebook1');
        Pricebook2 pricebookSecond = SMAX_PS_TestDataFactory.CreatePricebook('Test Parts Pricebook2');
        priceBookList.add(pricebookFirst);
        priceBookList.add(pricebookSecond);
        insert priceBookList;
        List<PricebookEntry> priceBookEntryList = new List<PricebookEntry>();
        PricebookEntry pbEntry1 = SMAX_PS_TestDataFactory.CreatePricebookentry(pricebookFirst,product,100);
        PricebookEntry pbEntry2 = SMAX_PS_TestDataFactory.CreatePricebookentry(pricebookSecond,product,200);
        priceBookEntryList.add(pbEntry1);
        priceBookEntryList.add(pbEntry2);
        insert priceBookEntryList;
        List<SVMXC__Service_Pricebook__c> servicePriceBookList = new List<SVMXC__Service_Pricebook__c>();
        SVMXC__Service_Pricebook__c spbookFirst = SMAX_PS_TestDataFactory.CreateServicePricebook('Test ServicePricebook1'); 
        SVMXC__Service_Pricebook__c spbookSecond = SMAX_PS_TestDataFactory.CreateServicePricebook('Test ServicePricebook2'); 
        servicePriceBookList.add(spbookFirst);
        servicePriceBookList.add(spbookSecond);
        insert servicePriceBookList;
        List<SVMXC__Service_Pricebook_Entry__c> servicePriceBookEntryList = new List<SVMXC__Service_Pricebook_Entry__c>();  
        SVMXC__Service_Pricebook_Entry__c spbookEntryFirst = SMAX_PS_TestDataFactory.CreateServicePricebookEntry(spbookFirst,activityProduct); 
        SVMXC__Service_Pricebook_Entry__c spbookEntrySecond = SMAX_PS_TestDataFactory.CreateServicePricebookEntry(spbookSecond,activityProduct);   
        servicePriceBookEntryList.add(spbookEntryFirst);
        servicePriceBookEntryList.add(spbookEntrySecond);  
        insert servicePriceBookEntryList;
          
        //Creating Account,Quote,QuoteIPLine for method "CreateQuoteLine"
        Account newAccount = SMAX_PS_TestDataFactory.CreateAccount('Test Account','state','city');
        insert newAccount;
        SVMXC__Quote__c serviceQuote = SMAX_PS_TestDataFactory.CreateServiceQuote(newAccount,pricebookFirst,spbookFirst,'testDeliveryCondition','HTS','draft');
        serviceQuote.SMAX_PS_Delivery_Condition__c='9999';
        insert serviceQuote;
        SMAX_PS_Service_Quote_IP_Line__c serviceQuoteIPLine = SMAX_PS_TestDataFactory.CreateServiceQuoteIpLines(serviceQuote,ttemplate);
        insert serviceQuoteIPLine;
        /***************Coverage for method "CreateQuoteLine" ends*****************/
        
        //Creating and updating quote lines for method "UpdateQuoteLinePriceBeforeInsertUpdate"
        SVMX_PS_ServiceQuotePricing.triggerfromQuote = true;
        List<SMAX_PS_Quote_Lines__c> qlList = new List<SMAX_PS_Quote_Lines__c>();
        Product2 productSecond = SMAX_PS_TestDataFactory.CreateProduct('Test Product','3000');
        insert productSecond;
        SMAX_PS_Quote_Lines__c quoteLine1 = SMAX_PS_TestDataFactory.CreateQuoteLines(serviceQuote,serviceQuoteIPLine,'1001',null);
        SMAX_PS_Quote_Lines__c quoteLine2 = SMAX_PS_TestDataFactory.CreateQuoteLines(serviceQuote,serviceQuoteIPLine,'1003',product);
        SMAX_PS_Quote_Lines__c quoteLine3 = SMAX_PS_TestDataFactory.CreateQuoteLines(serviceQuote,serviceQuoteIPLine,'1003',productSecond);
        qlList.add(quoteLine1);
        qlList.add(quoteLine2);
        qlList.add(quoteLine3);
        insert qlList; 
          for(SMAX_PS_Quote_Lines__c ql:qlList){
              ql.SMAX_PS_Refer_PB__c=false;
              ql.SMAX_PS_Customer_Procured__c=true;
              //ql.SMAX_PS_Product__c=product.id;
          }
          update qlList;
          /*******coverage for method "UpdateQuoteLinePriceBeforeInsertUpdate" ends********/
          
          //Updating pricebooks in quote for method "UpdateQuoteLinePriceAfterUpdate"
          serviceQuote.SMAX_PS_Parts_Price_Book__c=pricebookSecond.id;
          serviceQuote.SMAX_PS_Service_Pricebook__c=spbookSecond.id;
          update serviceQuote;
          /********Coverage for method "UpdateQuoteLinePriceBeforeInsertUpdate" ends****/
          
          //Creating a cloned serviceQuoteIpLine for the method "CreateQuoteLinesForClonedQuote"
          SMAX_PS_Service_Quote_IP_Line__c clonedServiceQuoteIPLine = SMAX_PS_TestDataFactory.CreateServiceQuoteIpLines(serviceQuote,null);
          clonedServiceQuoteIPLine.SMAX_PS_ClonedFromServiceQuoteIPLine__c =serviceQuoteIPLine.id;
          insert clonedServiceQuoteIPLine;
          /*****Coverage for the method "CreateQuoteLinesForClonedQuote" ends****/
          
    }
    
    
        
    
}
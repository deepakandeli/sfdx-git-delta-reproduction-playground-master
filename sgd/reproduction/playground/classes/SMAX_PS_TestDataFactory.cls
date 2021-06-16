/**
* @description       : Test Data Class 
* @author            : Pavithira (SpringFive)
* @group             : Servicemax PS
* @last modified on  : 04-26-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
* Modifications Log 
* Ver   Date         Author                               Modification
* 1.0   10-22-2020   Pavithira 				   Initial Version
**/   

@isTest
public class SMAX_PS_TestDataFactory {
    //Create Account
    public static Account CreateAccount(String accName,String billState,String billCity) {
        Account acc=new Account(Name=accName);
        //insert acc;
        acc.BillingState = billState;
        acc.BillingCity = billCity;
        return acc;
    }
    //Create Contact
    public static Contact CreateContact(String conName) {
        Contact con=new Contact(LastName=conName);
        //insert con;
        return con;
    }
    //Create Product
    public static Product2 CreateProduct(String prodName,String productLine) {
        Product2 product=new Product2(Name=prodName); 
        product.SVMXC__Product_Line__c=productLine;
        //insert product;
        return product;
    }
    //Create Location
    public static SVMXC__Site__c CreateLocation(String locationName){
        SVMXC__Site__c location=new SVMXC__Site__c(Name=locationName);
        return location;
    }
    //Create Installed Product
    public static SVMXC__Installed_Product__c CreateInstalledProduct(String ipName,Product2 product,String status) {
        SVMXC__Installed_Product__c installedProduct=new SVMXC__Installed_Product__c(Name=ipName,SVMXC__Product__c=product.Id,SVMXC__Status__c=status);
        //insert installedProduct;
        return installedProduct;
    }
    //Create Territory
    public static SVMXC__Territory__c CreateTerritory(String Name) {
        SVMXC__Territory__c territory=new SVMXC__Territory__c(Name=Name);
        //insert installedProduct;
        return territory;
    }
    //Create Service Team
    public static SVMXC__Service_Group__c CreateServiceTeam(String teamName,String recordType) {
        SVMXC__Service_Group__c serviceTeam=new SVMXC__Service_Group__c();
        serviceTeam.Name=teamName;
        serviceTeam.RecordTypeId=recordType;
        return serviceTeam;
    }
    //Create Technician/Equipment
    public static SVMXC__Service_Group_Members__c CreateTechnicianOrEquipment(String techName,SVMXC__Service_Group__c serviceTeam,String recordType) {
        SVMXC__Service_Group_Members__c technician=new SVMXC__Service_Group_Members__c();
        technician.Name='testTech';
        technician.SVMXC__Service_Group__c=serviceTeam.Id;
        return technician;
        
    }
    //Create Service Quote
    public static SVMXC__Quote__c CreateServiceQuote(Account acc,Pricebook2 pricebook,SVMXC__Service_Pricebook__c spbook,String deliveryCondition,String outputType,String status) {
        SVMXC__Quote__c serviceQuote=new SVMXC__Quote__c();
        serviceQuote.SVMXC__Company__c=acc.id;
        serviceQuote.SMAX_PS_Parts_Price_Book__c=pricebook.id;
        serviceQuote.SMAX_PS_Service_Pricebook__c=spbook.id;
        serviceQuote.SMAX_PS_Delivery_Cond_Special__c=deliveryCondition;
        serviceQuote.SMAX_PS_OutPut_Type__c=outputType;
        serviceQuote.SVMXC__Status__c =status;
        /*serviceQuote.SMAX_PS_Subject__c=;
        serviceQuote.SMAX_PS_SAP_SalesOrg__c=;
        serviceQuote.SMAX_PS_SAP_SalesOffice__c=;//picklist
        serviceQuote.SMAX_PS_SAP_SalesGroup__c=;
        serviceQuote.SVMXC__Status__c=;
        serviceQuote.SMAX_PS_Segment__c=;
        serviceQuote.SMAX_PS_End_User_Account__c=;//lookup*/
        return serviceQuote;
    }
    //create Service Quote Ip Lines
    public static SMAX_PS_Service_Quote_IP_Line__c CreateServiceQuoteIpLines(SVMXC__Quote__c quotename,SVMXC__Task_Template__c ttemplate) {
        SMAX_PS_Service_Quote_IP_Line__c serviceQuoteIpLine=new SMAX_PS_Service_Quote_IP_Line__c();
        serviceQuoteIpLine.SMAX_PS_Service_Quote__c=quotename.id;
        if(ttemplate!=null)
        serviceQuoteIpLine.SMAX_PS_Task_Template__c=ttemplate.id;
        return serviceQuoteIpLine;
    }
    //Create Task Template
    public static SVMXC__Task_Template__c CreateTasktemplate(String name) {
        SVMXC__Task_Template__c taskTemplate=new SVMXC__Task_Template__c();
        taskTemplate.SVMXC__Template_Name__c=name;
        return taskTemplate;
    }
    //create Required Parts
    public static SVMXC__Required_Part__c createRequiredPart(SVMXC__Task_Template__c ttName,Product2 part,SVMXC__Activity_Master__c activity,String lineType,String activityType) {
        SVMXC__Required_Part__c requiredPart=new SVMXC__Required_Part__c();
        if(part != null){
            requiredPart.SVMXC__Product__c=part.id;
        }
        
        requiredPart.SVMXC__Work_Order_Purpose__c=ttName.id;
        if(activity != null)
           requiredPart.SMAX_PS_Activity__c=activity.id; 
        
        requiredPart.SMAX_PS_Line_Type__c=lineType;
         if(activityType != null)
        	requiredPart.SMAX_PS_Activity_Type__c=activityType;
        return requiredPart;
    }
    //Create Activity Master
    public static SVMXC__Activity_Master__c createActivityMaster(String activityType) {
        SVMXC__Activity_Master__c activityMaster=new SVMXC__Activity_Master__c();
        activityMaster.SVMXC__Activity_Type__c=activityType;
        return activityMaster;
    }
    
    //Create Activity Product
    public static SVMXC__Activity_Product__c createActivityProduct(SVMXC__Activity_Master__c activityMaster,Product2 product) {
        SVMXC__Activity_Product__c activityProduct=new SVMXC__Activity_Product__c();
        activityProduct.SVMXC__Activity__c=activityMaster.id;
        activityProduct.SVMXC__Product__c=product.id;
        //activityProduct.SVMXC__Product__c=activityType;
        return activityProduct;
        
    }
    
    //Create PricebookEntry
    public static PricebookEntry CreatePricebookentry(Pricebook2 Pricebook,Product2 product,Integer amount) {
        PricebookEntry pbEntry=new PricebookEntry();

        pbEntry.Pricebook2Id=Pricebook.id;
        pbEntry.Product2Id=product.id;
        pbEntry.UnitPrice=amount;
        return pbEntry;
    }
    //Create Pricebook
    public static Pricebook2 CreatePricebook(String name) {
        Pricebook2 pricebook=new Pricebook2(Name=Name);
        return pricebook;
    }
    //Create service pricebook
    public static SVMXC__Service_Pricebook__c CreateServicePricebook(String name) {
        SVMXC__Service_Pricebook__c servicePricebook=new SVMXC__Service_Pricebook__c(Name=Name);
        return servicePricebook;
    }
    //Create service pricebook Entry
    public static SVMXC__Service_Pricebook_Entry__c CreateServicePricebookEntry(SVMXC__Service_Pricebook__c name,SVMXC__Activity_Product__c activityProduct ) {
        SVMXC__Service_Pricebook_Entry__c servicePricebookEntry=new SVMXC__Service_Pricebook_Entry__c();
        servicePricebookEntry.SVMXC__Price_Book__c=name.id;
        servicePricebookEntry.SVMXC__Activity_Product__c=activityProduct.id;
        return servicePricebookEntry;
    }

    //create Quote Lines
    public static SMAX_PS_Quote_Lines__c CreateQuoteLines(SVMXC__Quote__c quote,SMAX_PS_Service_Quote_IP_Line__c serviceQuoteIpLines,String lineType,Product2 product) {
        SMAX_PS_Quote_Lines__c quoteLine = new SMAX_PS_Quote_Lines__c();
        quoteLine.SMAX_PS_Quote__c=quote.id;
        quoteLine.SMAX_PS_Service_Quote_IP_Line__c=serviceQuoteIpLines.id;
        if(lineType != null)
        	quoteLine.SMAX_PS_Line_Type__c=lineType;
        if(product != null)
        	quoteLine.SMAX_PS_Product__c=product.id;
        return quoteLine;
    }

}
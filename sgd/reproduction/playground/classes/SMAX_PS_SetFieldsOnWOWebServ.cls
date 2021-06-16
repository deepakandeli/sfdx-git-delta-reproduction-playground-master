/**
* @CLASS: SMAX_PS_SetFieldsOnWOWebServ
*
* @DESCRIPTION: This class is used to set the address fields and IP data fields on a work order based on the address type selected and the component on the WO on their
                respective field changes and on initial load of the SFM.
                The current choices for address type are Account and Installed Product. The fields on work order copy the addresses from these 2 related parent records
*
*-------------------------------------------------------------------------------------------------------------------
* DEVELOPER                     DATE                  REASON
*-------------------------------------------------------------------------------------------------------------------
* ServiceMax/Shreyas         2021-03-03              Created
* ServiceMax/Shreyas         2021-03-16              Added Methods setIPDataOnChange and setFieldsOnLoad
********************************************************************************************************************/
global class SMAX_PS_SetFieldsOnWOWebServ
{
    webservice static SVMXC.SFM_WrapperDef.SFM_PageData setAddressOnChange(SVMXC.SFM_WrapperDef.SFM_TargetRecord request)
    {
        System.Debug('request'+request.toString());
        System.Debug('Set Address : Inside the Webservice');
        SVMXC.SFM_WrapperDef.SFM_PageData pagedata = new SVMXC.SFM_WrapperDef.SFM_PageData();
        SVMXC.SFM_ServicesDef def = new SVMXC.SFM_ServicesDef();
        Map<String,Schema.SObjectType> mapAllobj = new Map<String, Schema.SObjectType>();
        Map<String, Schema.SObjectType> mapGlobalDesc = new Map<String, Schema.SObjectType>();
        Map<String,List<Sobject>> detailSobjectMap = new Map<String, List<Sobject>>();

        mapGlobalDesc = Schema.getGlobalDescribe();

        if(mapGlobalDesc.size() > 0)
        {
            for(Schema.SObjectType schIterator : mapGlobalDesc.values())
            {
                Schema.DescribeSObjectResult result = schIterator.getDescribe();
                mapAllobj.put(result.getName(), schIterator);
            }
        }

        Sobject headerSobj = def.SFM_Page_GetHeaderRecord(request, mapAllobj);
        SVMXC__Service_Order__c objWO = new SVMXC__Service_Order__c();
        objWO = (SVMXC__Service_Order__c)headerSobj;
        System.Debug('Set Address : Work Order header data '+objWO);

        if(objWO.SMAX_PS_Address_Type__c != null)
        {
            if(objWO.SMAX_PS_Address_Type__c == 'Account')
            {
                System.Debug('Set Address : Get address information from Account '+objWO.SVMXC__Company__c);
                for(Account accIterator : [Select Id, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, SVMXC__Latitude__c, SVMXC__Longitude__c From Account
                                           Where Id =: objWO.SVMXC__Company__c Limit 1])
                {
                    objWO.SVMXC__Street__c = accIterator.BillingStreet;
                    objWO.SVMXC__State__c = accIterator.BillingState;
                    objWO.SVMXC__Zip__c = accIterator.BillingPostalCode;
                    objWO.SVMXC__Country__c = accIterator.BillingCountry;
                    objWO.SVMXC__City__c = accIterator.BillingCity;
                    objWO.SVMXC__Latitude__c = accIterator.SVMXC__Latitude__c;
                    objWO.SVMXC__Longitude__c = accIterator.SVMXC__Longitude__c;
                }
            }
            else if(objWO.SMAX_PS_Address_Type__c == 'Installed Product')
            {
                System.Debug('Set Address : Get address information from Installed Product '+objWO.SVMXC__Component__c);
                for(SVMXC__Installed_Product__c ipIterator : [Select Id, SVMXC__Street__c, SVMXC__State__c, SVMXC__Zip__c, SVMXC__Country__c, SVMXC__City__c
                                                              From SVMXC__Installed_Product__c Where Id =: objWO.SVMXC__Component__c Limit 1])
                {
                    objWO.SVMXC__Street__c = ipIterator.SVMXC__Street__c;
                    objWO.SVMXC__State__c = ipIterator.SVMXC__State__c;
                    objWO.SVMXC__Zip__c = ipIterator.SVMXC__Zip__c;
                    objWO.SVMXC__Country__c = ipIterator.SVMXC__Country__c;
                    objWO.SVMXC__City__c = ipIterator.SVMXC__City__c;
                }
            }
        }
        detailSobjectMap = def.SFM_Page_GetDetailRecords(request, mapAllobj);
        System.Debug('Set Address : Work Order data after setting address '+objWO);
        pagedata = def.SFM_Page_BuildResponse(request, objWO, detailSobjectMap); 
        system.debug('Set Address : Response = ' + pagedata); 
        return pagedata;
    }
    webservice static SVMXC.SFM_WrapperDef.SFM_PageData setIPDataOnChange(SVMXC.SFM_WrapperDef.SFM_TargetRecord request)
    {
        System.Debug('request'+request);
        System.Debug('Set IP Data : Inside the Webservice');
        SVMXC.SFM_WrapperDef.SFM_PageData pagedata = new SVMXC.SFM_WrapperDef.SFM_PageData();
        SVMXC.SFM_ServicesDef def = new SVMXC.SFM_ServicesDef();
        Map<String,Schema.SObjectType> mapAllobj = new Map<String, Schema.SObjectType>();
        Map<String, Schema.SObjectType> mapGlobalDesc = new Map<String, Schema.SObjectType>();
        Map<String,List<Sobject>> detailSobjectMap = new Map<String, List<Sobject>>();
        

        mapGlobalDesc = Schema.getGlobalDescribe();

        if(mapGlobalDesc.size() > 0)
        {
            for(Schema.SObjectType schIterator : mapGlobalDesc.values())
            {
                Schema.DescribeSObjectResult result = schIterator.getDescribe();
                mapAllobj.put(result.getName(), schIterator);
            }
        }

        Sobject headerSobj = def.SFM_Page_GetHeaderRecord(request, mapAllobj);
        SVMXC__Service_Order__c objWO = new SVMXC__Service_Order__c();
        objWO = (SVMXC__Service_Order__c)headerSobj;
        System.Debug('Set IP Data : Work Order header data '+objWO);

        if(objWO.SVMXC__Component__c != null)
        {
            System.Debug('Set IP Data : IP On The WO '+objWO.SVMXC__Component__c);
            for(SVMXC__Installed_Product__c ipIterator : [Select Id, SMAX_PS_MeterCategory__c, SMAX_PS_ModelApprovalNo__c, SMAX_PS_InspectionLimitDate__c, SVMXC__Service_Contract__c,
                                                          SVMXC__Contact__c, SVMXC__Preferred_Technician__c, SVMXC__Product__c, SVMXC__Serial_Lot_Number__c, SVMXC__Site__c,
                                                          SVMXC__Service_Contract_Start_Date__c, SVMXC__Service_Contract_End_Date__c, SVMXC__Street__c, SVMXC__State__c, SVMXC__Zip__c,
                                                          SVMXC__Country__c, SVMXC__City__c From SVMXC__Installed_Product__c Where Id =: objWO.SVMXC__Component__c Limit 1])
            {
                objWO.SMAX_PS_MeterCategory__c = ipIterator.SMAX_PS_MeterCategory__c;
                objWO.SMAX_PS_ModelApprovalNo__c = ipIterator.SMAX_PS_ModelApprovalNo__c;
                objWO.SMAX_PS_InspectionLimitDate__c = ipIterator.SMAX_PS_InspectionLimitDate__c;
                objWO.SVMXC__Service_Contract__c = ipIterator.SVMXC__Service_Contract__c;
                objWO.SVMXC__Contact__c = ipIterator.SVMXC__Contact__c;
                objWO.SVMXC__Preferred_Technician__c = ipIterator.SVMXC__Preferred_Technician__c;
                objWO.SVMXC__Product__c = ipIterator.SVMXC__Product__c;
                objWO.SMAX_PS_Serial_Lot_Number__c = ipIterator.SVMXC__Serial_Lot_Number__c;
                objWO.SVMXC__Site__c = ipIterator.SVMXC__Site__c;
                objWO.SMAX_PS_Service_Contract_Start_Date__c = ipIterator.SVMXC__Service_Contract_Start_Date__c;
                objWO.SMAX_PS_Service_Contract_End_Date__c = ipIterator.SVMXC__Service_Contract_End_Date__c;
            }
        }
        detailSobjectMap = def.SFM_Page_GetDetailRecords(request, mapAllobj);
        System.Debug('Set IP Data : Work Order data after setting populating IP '+objWO);
        pagedata = def.SFM_Page_BuildResponse(request, objWO, detailSobjectMap); 
        system.debug('Set IP Data : Response = ' + pagedata); 
        return pagedata;
    }
    webservice static SVMXC.SFM_WrapperDef.SFM_PageData setFieldsOnLoad(SVMXC.SFM_WrapperDef.SFM_TargetRecord request)
    {
        System.Debug('Set On Load : Inside the Webservice');
        SVMXC.SFM_WrapperDef.SFM_PageData pagedata = new SVMXC.SFM_WrapperDef.SFM_PageData();
        SVMXC.SFM_ServicesDef def = new SVMXC.SFM_ServicesDef();
        Map<String,Schema.SObjectType> mapAllobj = new Map<String, Schema.SObjectType>();
        Map<String, Schema.SObjectType> mapGlobalDesc = new Map<String, Schema.SObjectType>();
        Map<String,List<Sobject>> detailSobjectMap = new Map<String, List<Sobject>>();

        mapGlobalDesc = Schema.getGlobalDescribe();

        if(mapGlobalDesc.size() > 0)
        {
            for(Schema.SObjectType schIterator : mapGlobalDesc.values())
            {
                Schema.DescribeSObjectResult result = schIterator.getDescribe();
                mapAllobj.put(result.getName(), schIterator);
            }
        }

        Sobject headerSobj = def.SFM_Page_GetHeaderRecord(request, mapAllobj);
        SVMXC__Service_Order__c objWO = new SVMXC__Service_Order__c();
        objWO = (SVMXC__Service_Order__c)headerSobj;
        System.Debug('Set On Load : Work Order header data '+objWO);
        //set fields onload from case
        if(objWO.SVMXC__Case__c != null)
        {
            System.Debug('Set On Load : case On The WO '+objWO.SVMXC__Case__c);
            for(Case caseIterator : [Select Id, Subject, SMAX_PS_SAP_SalesOrg__c,AccountId, SMAX_PS_SAP_SalesOffice__c, SMAX_PS_SAP_SalesGroup__c,
                                                          SMAX_PS_SoldTo__c, SMAX_PS_SoldTo_Contact__c, SMAX_PS_Segment__c From Case Where Id =: objWO.SVMXC__Case__c Limit 1])
            {
                objWO.SMAX_PS_Subject__c = caseIterator.Subject;
                objWO.SMAX_PS_SAP_SalesOrg__c = caseIterator.SMAX_PS_SAP_SalesOrg__c;
                objWO.SMAX_PS_SAP_SalesOffice__c = caseIterator.SMAX_PS_SAP_SalesOffice__c;
                objWO.SMAX_PS_SAP_SalesGroup__c = caseIterator.SMAX_PS_SAP_SalesGroup__c;
                //objWO.SMAX_PS_SoldTo__c ='0010p00000tF0NKAA0';
                objWO.SMAX_PS_SoldTo__c = caseIterator.SMAX_PS_SoldTo__c;
                objWO.SMAX_PS_SoldTo_Contact__c = caseIterator.SMAX_PS_SoldTo_Contact__c;
                objWO.SMAX_PS_Segment__c = caseIterator.SMAX_PS_Segment__c;
                objWO.SVMXC__Company__c = caseIterator.AccountId;

                
            }
            
        }else if(objWO.SMAX_PS_Service_Quote__c!= null){
         	System.Debug('Set On Load : SQ On The WO '+objWO.SMAX_PS_Service_Quote__c);
            for(SVMXC__Quote__c quoteIterator : [Select id,SMAX_PS_SAP_SalesGroup__c,SMAX_PS_Site__c,SMAX_PS_SAP_SalesOffice__c,SMAX_PS_SAP_SalesOrg__c,SMAX_PS_Segment__c,SMAX_PS_Service_Team__c,SMAX_PS_Case__c,SVMXC__Company__c,SMAX_PS_End_User_Account__c,SVMXC__Contact__c,SMAX_PS_End_User_Contact__c,SMAX_PS_Expense_Percent__c 
                                                 FROM SVMXC__Quote__c WHERE Id =:objWO.SMAX_PS_Service_Quote__c LIMIT 1])
            {
                objWO.SMAX_PS_SAP_SalesOrg__c = quoteIterator.SMAX_PS_SAP_SalesOrg__c; 
                objWO.SMAX_PS_SAP_SalesOffice__c = quoteIterator.SMAX_PS_SAP_SalesOffice__c;
                objWO.SMAX_PS_SAP_SalesGroup__c = quoteIterator.SMAX_PS_SAP_SalesGroup__c;
                objWO.SVMXC__Case__c = quoteIterator.SMAX_PS_Case__c;
                objWO.SMAX_PS_Segment__c = quoteIterator.SMAX_PS_Segment__c;
                objWO.SVMXC__Company__c = quoteIterator.SMAX_PS_End_User_Account__c;
                objWO.SVMXC__Site__c = quoteIterator.SMAX_PS_Site__c;
                objWO.SMAX_PS_SoldTo__c = quoteIterator.SVMXC__Company__c;
                objWO.SMAX_PS_SoldTo_Contact__c = quoteIterator.SVMXC__Contact__c;
                objWO.SVMXC__Contact__c = quoteIterator.SMAX_PS_End_User_Contact__c;
                objWO.SVMXC__Service_Group__c=quoteIterator.SMAX_PS_Service_Team__c;
                objWO.SMAX_PS_Expense_Percent__c=quoteIterator.SMAX_PS_Expense_Percent__c;
                
                                        
            }

            
        }

        if(objWO.SVMXC__Component__c != null)
        {
            System.Debug('Set On Load : IP On The WO '+objWO.SVMXC__Component__c);
            for(SVMXC__Installed_Product__c ipIterator : [Select Id, SMAX_PS_MeterCategory__c, SMAX_PS_ModelApprovalNo__c, SMAX_PS_InspectionLimitDate__c, SVMXC__Service_Contract__c,
                                                          SVMXC__Contact__c, SVMXC__Preferred_Technician__c, SVMXC__Product__c, SVMXC__Serial_Lot_Number__c, SVMXC__Site__c,
                                                          SVMXC__Service_Contract_Start_Date__c, SVMXC__Service_Contract_End_Date__c, SVMXC__Street__c, SVMXC__State__c, SVMXC__Zip__c, SVMXC__Country__c,
                                                          SVMXC__City__c From SVMXC__Installed_Product__c Where Id =: objWO.SVMXC__Component__c Limit 1])
            {
                objWO.SMAX_PS_MeterCategory__c = ipIterator.SMAX_PS_MeterCategory__c;
                objWO.SMAX_PS_ModelApprovalNo__c = ipIterator.SMAX_PS_ModelApprovalNo__c;
                objWO.SMAX_PS_InspectionLimitDate__c = ipIterator.SMAX_PS_InspectionLimitDate__c;
                objWO.SVMXC__Service_Contract__c = ipIterator.SVMXC__Service_Contract__c;
                objWO.SVMXC__Contact__c = ipIterator.SVMXC__Contact__c;
                objWO.SVMXC__Preferred_Technician__c = ipIterator.SVMXC__Preferred_Technician__c;
                objWO.SVMXC__Product__c = ipIterator.SVMXC__Product__c;
                objWO.SMAX_PS_Serial_Lot_Number__c = ipIterator.SVMXC__Serial_Lot_Number__c;
                objWO.SVMXC__Site__c = ipIterator.SVMXC__Site__c;
                objWO.SMAX_PS_Service_Contract_Start_Date__c = ipIterator.SVMXC__Service_Contract_Start_Date__c;
                objWO.SMAX_PS_Service_Contract_End_Date__c = ipIterator.SVMXC__Service_Contract_End_Date__c;
                objWO.SMAX_PS_Address_Type__c = 'Installed Product';
                objWO.SVMXC__Street__c = ipIterator.SVMXC__Street__c;
                objWO.SVMXC__State__c = ipIterator.SVMXC__State__c;
                objWO.SVMXC__Zip__c = ipIterator.SVMXC__Zip__c;
                objWO.SVMXC__Country__c = ipIterator.SVMXC__Country__c;
                objWO.SVMXC__City__c = ipIterator.SVMXC__City__c;
            }
        }
        else
        {
            System.Debug('Set On Load : Account On The WO '+objWO.SVMXC__Company__c);
            for(Account accIterator : [Select Id, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, SVMXC__Latitude__c, SVMXC__Longitude__c From Account
                                       Where Id =: objWO.SVMXC__Company__c Limit 1])
            {
                objWO.SMAX_PS_Address_Type__c = 'Account';
                objWO.SVMXC__Street__c = accIterator.BillingStreet;
                objWO.SVMXC__State__c = accIterator.BillingState;
                objWO.SVMXC__Zip__c = accIterator.BillingPostalCode;
                objWO.SVMXC__Country__c = accIterator.BillingCountry;
                objWO.SVMXC__City__c = accIterator.BillingCity;
                objWO.SVMXC__Latitude__c = accIterator.SVMXC__Latitude__c;
                objWO.SVMXC__Longitude__c = accIterator.SVMXC__Longitude__c;
            }
        }
        detailSobjectMap = def.SFM_Page_GetDetailRecords(request, mapAllobj);
        System.Debug('Set On Load : Work Order data after setting populating IP '+objWO);
        pagedata = def.SFM_Page_BuildResponse(request, objWO, detailSobjectMap); 
        system.debug('Set On Load : Response = ' + pagedata); 
        return pagedata;
    }
}
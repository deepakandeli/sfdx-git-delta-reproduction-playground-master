<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Test_Email</fullName>
        <description>Test Email.</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SVMXC__ServiceMaxEmailTemplates/SMAX_PS_SAP_Error_HTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Parent_ID</fullName>
        <field>SMAX_PS_Parent_ID__c</field>
        <formula>IF(NOT(ISBLANK(SMAX_PS_Parts_Order__c)),SMAX_PS_Parts_Order__r.Id,IF(NOT(ISBLANK(SMAX_PS_Work_Order__c)),SMAX_PS_Work_Order__r.Id,&apos;&apos;))</formula>
        <name>Set Parent ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>JitterBitOutboundMessage</fullName>
        <apiVersion>51.0</apiVersion>
        <description>Outbound message send to JitterBit everytime a Interface Log record is created.</description>
        <endpointUrl>https://envbmnfyjz8pq.x.pipedream.net/</endpointUrl>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>Id</fields>
        <fields>SMAX_PS_Interface_Name__c</fields>
        <fields>SMAX_PS_Interface_Status__c</fields>
        <fields>SMAX_PS_Object_API_name__c</fields>
        <fields>SMAX_PS_Parent_ID__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>deepak.andeli@servicemax.com.hts</integrationUser>
        <name>JitterBitOutboundMessage</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Integration Outbound Message</fullName>
        <actions>
            <name>Set_Parent_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>JitterBitOutboundMessage</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(
	ISPICKVAL( SMAX_PS_Interface_Status__c,&apos;In Progress&apos;),
	NOT(OR(CONTAINS(&apos;SVMXC__Installed_Product__c&apos;,SMAX_PS_Object_API_name__c),CONTAINS(&apos;Product2&apos;,SMAX_PS_Object_API_name__c),CONTAINS(&apos;Account&apos;,SMAX_PS_Object_API_name__c),CONTAINS(&apos;PricebookEntry&apos;,SMAX_PS_Object_API_name__c),CONTAINS(&apos;OracleWorkOrder&apos;,SMAX_PS_Object_API_name__c),CONTAINS(&apos;OracleCase&apos;,SMAX_PS_Object_API_name__c)))
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SMAX PS Send Email on Integration Error</fullName>
        <actions>
            <name>Test_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SMAX_PS_Interface_Log__c.SMAX_PS_Interface_Status__c</field>
            <operation>equals</operation>
            <value>Failed</value>
        </criteriaItems>
        <description>Send email to the Interface log record creator when there is a failure with the integration</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Parent ID</fullName>
        <actions>
            <name>Set_Parent_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(NOT(ISNULL(SMAX_PS_Parts_Order__c)),NOT(ISNULL(SMAX_PS_Work_Order__c)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

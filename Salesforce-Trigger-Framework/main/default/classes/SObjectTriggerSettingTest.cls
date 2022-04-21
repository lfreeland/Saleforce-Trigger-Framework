@isTest
public with sharing class SObjectTriggerSettingTest {
    
    @isTest
    static void constructor_instantiateWithCustomMetadataType_expectCustomMetadataTypeValuesUsedInSettingTest() {
        sObject_Trigger_Setting__mdt sObjectTriggerSettingCMDT = new sObject_Trigger_Setting__mdt();
        sObjectTriggerSettingCMDT.Object_API_Name__c = 'Account';
        sObjectTriggerSettingCMDT.Active__c = true;

        SObjectTriggerSetting triggerSetting = new SObjectTriggerSetting(sObjectTriggerSettingCMDT);

        system.assertEquals(sObjectTriggerSettingCMDT.Object_API_Name__c, triggerSetting.ObjectAPIName,
                            'The object api name from the sObject_Trigger_Setting__mdt was not used.');
        
        system.assertEquals(sObjectTriggerSettingCMDT.Active__c, triggerSetting.Active,
                            'The Active value from the sObject_Trigger_Setting__mdt was not used.');
    }

    @isTest
    static void bypass_accountSObjectSetToBypass_expectAccountBypassedTest() {
        String accountSObjectName = 'Account';

        SObjectTriggerSetting.bypass(accountSObjectName);

        Boolean accountIsBypassed = SObjectTriggerSetting.isBypassed(accountSObjectName);

        system.assert(accountIsBypassed, 'The account sobject was not bypassed.');
    }

    @isTest
    static void clear_accountSObjectSetToBypassAndThenCleared_expectAccountNotBypassedTest() {
        String accountSObjectName = 'Account';

        SObjectTriggerSetting.bypass(accountSObjectName);

        Boolean accountIsBypassed = SObjectTriggerSetting.isBypassed(accountSObjectName);

        system.assert(accountIsBypassed, 'The account sobject was not bypassed.');

        SObjectTriggerSetting.clearBypass(accountSObjectName);

        accountIsBypassed = SObjectTriggerSetting.isBypassed(accountSObjectName);

        system.assertEquals(false, accountIsBypassed, 'The account sobject was bypassed after it was cleared.');
    }

    @isTest
    static void isBypassed_nullSobjectNameGiven_expectIsBypassedIsFalseTest() {
        String nullSObjectName = null;

        SObjectTriggerSetting.bypass(nullSObjectName);

        Boolean isSobjectBypassed = SObjectTriggerSetting.isBypassed(nullSObjectname);

        system.assertEquals(false, isSobjectBypassed,
                            'A null Sobject name should not be bypassed.');
    }
}
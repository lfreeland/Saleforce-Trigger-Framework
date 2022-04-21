@isTest
public with sharing class MetadataSObjectTriggerSettingQuerierTest {

    @isTest
    static void getSObjectTriggerSettings_invoke_expectAnyRecordsHaveMatchingDomainObjectSettingsTest() {
        MetadataSObjectTriggerSettingQuerier querier = new MetadataSObjectTriggerSettingQuerier();
        List<SObjectTriggerSetting> sobjectTriggerSettings = querier.getSObjectTriggerSettings();

        List<sObject_Trigger_Setting__mdt> objectTriggerSettingCMDTs = sObject_Trigger_Setting__mdt.getAll().values();

        system.assertEquals(objectTriggerSettingCMDTs.size(), sobjectTriggerSettings.size(),
                            'There should be one object trigger setting for each object trigger setting custom metadata type record.');

        List<Trigger_Action__mdt> objectTriggerActions = Trigger_Action__mdt.getAll().values();

        List<TriggerActionSetting> allTriggerActionSettings = new List<TriggerActionSetting>();

        for (SObjectTriggerSetting ots : sobjectTriggerSettings) {
            allTriggerActionSettings.addAll(ots.TriggerActionSettings);
        }

        system.assertEquals(objectTriggerActions.size(), allTriggerActionSettings.size(),
                            'There should be one object trigger action for each object trigger setting custom metadata type record.');
    }
}
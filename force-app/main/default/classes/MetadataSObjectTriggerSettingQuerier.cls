global with sharing class MetadataSObjectTriggerSettingQuerier implements SObjectTriggerSettingQuerier {
    global List<SObjectTriggerSetting> getSObjectTriggerSettings() {
        List<sObject_Trigger_Setting__mdt> objectTriggerSettings = sObject_Trigger_Setting__mdt.getAll().values();
        List<Trigger_Action__mdt> objectTriggerActions = Trigger_Action__mdt.getAll().values();

        Map<Id, sObject_Trigger_Setting__mdt> objectTriggerSettingsById = 
            new Map<Id, sObject_Trigger_Setting__mdt>();

        Map<String, SObjectTriggerSetting> objectTriggerSettingByObjectName =
            new Map<String, SObjectTriggerSetting>();

        for (sObject_Trigger_Setting__mdt objectTriggerSettingMDT : objectTriggerSettings) {
            SObjectTriggerSetting ots = new SObjectTriggerSetting(objectTriggerSettingMDT);

            objectTriggerSettingByObjectName.put(ots.ObjectAPIName.toLowerCase(), ots);
            objectTriggerSettingsById.put(objectTriggerSettingMDT.Id, objectTriggerSettingMDT);
        }

        for (Trigger_Action__mdt objectTriggerAction : objectTriggerActions) {
            TriggerActionSetting tas = new TriggerActionSetting(objectTriggerAction);

            sObject_Trigger_Setting__mdt objectTrigger = objectTriggerSettingsById.get(objectTriggerAction.sObject_Trigger_Setting__c);

            SObjectTriggerSetting ots = objectTriggerSettingByObjectName.get(objectTrigger.Object_API_Name__c.toLowerCase());

            ots.TriggerActionSettings.add(tas);
        }

        return objectTriggerSettingByObjectName.values();
    }
}
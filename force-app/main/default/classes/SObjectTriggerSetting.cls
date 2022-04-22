global with sharing class SObjectTriggerSetting {
    global String ObjectAPIName { get; set; }

    global Boolean Active { get; set; }

    global List<TriggerActionSetting> TriggerActionSettings { get; set; }

    global SObjectTriggerSetting() {
        Active = true;
        TriggerActionSettings = new List<TriggerActionSetting>();
    }

    global SObjectTriggerSetting(sObject_Trigger_Setting__mdt triggerSettingCMDT) {
        this();

        this.Active = triggerSettingCMDT.Active__c;
        this.ObjectAPIName = triggerSettingCMDT.Object_API_Name__c;
    }

    global void sortTriggerActionsByOrder() {
        TriggerActionSettings.sort();
    }

    private static Set<String> bypassedObjects = new Set<String>();

    public static void bypass(String sobjectAPIName) {
        if (String.isNotBlank(sobjectAPIName)) {
            bypassedObjects.add(sobjectAPIName.toLowerCase());
        }
    }

    global static void clearBypass(String sobjectAPIName) {
        if (String.isNotBlank(sobjectAPIName)) {
            bypassedObjects.remove(sobjectAPIName.toLowerCase());
        }
    }

    global static Boolean isBypassed(String sobjectAPIName) {
        if (String.isNotBlank(sobjectAPIName)) {
            return bypassedObjects.contains(sobjectAPIName.toLowerCase());
        }

        return false;
    }
}
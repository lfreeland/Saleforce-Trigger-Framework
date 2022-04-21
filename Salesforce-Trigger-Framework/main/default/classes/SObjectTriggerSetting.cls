public with sharing class SObjectTriggerSetting {
    public String ObjectAPIName { get; set; }

    public Boolean Active { get; set; }

    public List<TriggerActionSetting> TriggerActionSettings { get; set; }

    public SObjectTriggerSetting() {
        Active = true;
        TriggerActionSettings = new List<TriggerActionSetting>();
    }

    public SObjectTriggerSetting(sObject_Trigger_Setting__mdt triggerSettingCMDT) {
        this();

        this.Active = triggerSettingCMDT.Active__c;
        this.ObjectAPIName = triggerSettingCMDT.Object_API_Name__c;
    }

    public void sortTriggerActionsByOrder() {
        TriggerActionSettings.sort();
    }

    private static Set<String> bypassedObjects = new Set<String>();

    public static void bypass(String sobjectAPIName) {
        if (String.isNotBlank(sobjectAPIName)) {
            bypassedObjects.add(sobjectAPIName.toLowerCase());
        }
    }

    public static void clearBypass(String sobjectAPIName) {
        if (String.isNotBlank(sobjectAPIName)) {
            bypassedObjects.remove(sobjectAPIName.toLowerCase());
        }
    }

    public static Boolean isBypassed(String sobjectAPIName) {
        if (String.isNotBlank(sobjectAPIName)) {
            return bypassedObjects.contains(sobjectAPIName.toLowerCase());
        }

        return false;
    }
}
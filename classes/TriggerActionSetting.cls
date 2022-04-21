public inherited sharing class TriggerActionSetting implements Comparable {
    public Boolean Active { get; set; }

    public String ApexClass { get; set; }

    public Decimal SortOrder { get; set; }

    public String Description { get; set; }

    public TriggerActionSetting() {
        Active = true;
        ApexClass = '';
        SortOrder = 0;
        Description = '';
    }

    public TriggerActionSetting(Trigger_Action__mdt triggerActionCMDT) {
        Active = triggerActionCMDT.Active__c;
        ApexClass = triggerActionCMDT.Apex_Class_Name__c;
        SortOrder = triggerActionCMDT.Order__c;
        Description = triggerActionCMDT.Description__c;
    }

    public Integer compareTo(Object compareTo) {
        TriggerActionSetting triggerActionSettingCompareTo = (TriggerActionSetting) compareTo;

        return Integer.valueOf(this.SortOrder - triggerActionSettingCompareTo.SortOrder);
    }

    private TriggerAction instantiatedTriggerAction = null;

    public TriggerAction instantiateTriggerAction() {
        if (instantiatedTriggerAction == null) {
            Type triggerActionType = Type.forName(this.ApexClass);

            instantiatedTriggerAction = (TriggerAction) triggerActionType.newInstance();
        }

        return instantiatedTriggerAction;
    }

    private static Set<String> bypassedTriggerActions = new Set<String>();

    public static void bypass(String apexClassName) {
        if (String.isNotBlank(apexClassName)) {
            bypassedTriggerActions.add(apexClassName.toLowerCase());
        }
    }

    public static void clearBypass(String apexClassName) {
        if (String.isNotBlank(apexClassName)) {
            bypassedTriggerActions.remove(apexClassName.toLowerCase());
        }
    }

    public static Boolean isBypassed(String apexClassName) {
        if (String.isNotBlank(apexClassName)) {
            return bypassedTriggerActions.contains(apexClassName.toLowerCase());
        }

        return false;
    }
}
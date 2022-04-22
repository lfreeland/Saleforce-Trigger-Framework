global inherited sharing class TriggerActionSetting implements Comparable {
    global Boolean Active { get; set; }

    global String ApexClass { get; set; }

    global Decimal SortOrder { get; set; }

    global String Description { get; set; }

    global TriggerActionSetting() {
        Active = true;
        ApexClass = '';
        SortOrder = 0;
        Description = '';
    }

    global TriggerActionSetting(Trigger_Action__mdt triggerActionCMDT) {
        Active = triggerActionCMDT.Active__c;
        ApexClass = triggerActionCMDT.Apex_Class_Name__c;
        SortOrder = triggerActionCMDT.Order__c;
        Description = triggerActionCMDT.Description__c;
    }

    global Integer compareTo(Object compareTo) {
        TriggerActionSetting triggerActionSettingCompareTo = (TriggerActionSetting) compareTo;

        return Integer.valueOf(this.SortOrder - triggerActionSettingCompareTo.SortOrder);
    }

    private TriggerAction instantiatedTriggerAction = null;

    global TriggerAction instantiateTriggerAction() {
        if (instantiatedTriggerAction == null) {
            Type triggerActionType = Type.forName(this.ApexClass);

            if (triggerActionType == null) {
                throw new InstantiationException(getTypeNotFoundErrorMessage(this.ApexClass));
            }

            if (!TriggerAction.class.isAssignableFrom(triggerActionType)) {
                throw new InstantiationException(getNotTriggerActionTypeErrorMessage(this.ApexClass));
            }

            instantiatedTriggerAction = (TriggerAction) triggerActionType.newInstance();
        }

        return instantiatedTriggerAction;
    }

    private static Set<String> bypassedTriggerActions = new Set<String>();

    global static void bypass(String apexClassName) {
        if (String.isNotBlank(apexClassName)) {
            bypassedTriggerActions.add(apexClassName.toLowerCase());
        }
    }

    global static void clearBypass(String apexClassName) {
        if (String.isNotBlank(apexClassName)) {
            bypassedTriggerActions.remove(apexClassName.toLowerCase());
        }
    }

    global static Boolean isBypassed(String apexClassName) {
        if (String.isNotBlank(apexClassName)) {
            return bypassedTriggerActions.contains(apexClassName.toLowerCase());
        }

        return false;
    }

    @testVisible
    private static String getTypeNotFoundErrorMessage(String apexClass) {
        return 'The type for apex class, ' + apexClass + ', was not found. Make sure that class exists and is global so the trigger framework can see it.';
    }

    @testVisible
    private static String getNotTriggerActionTypeErrorMessage(String apexClass) {
        return 'The apex class, ' + apexClass + ', must extend the mtl.TriggerAction apex class.';
    }

    global class InstantiationException extends Exception { }
}
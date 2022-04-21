@isTest
public with sharing class TriggerActionSettingTest {
    
    @isTest
    static void constructor_instantiateWithCustomMetadataType_expectCustomMetadataTypeValuesUsedInSettingTest() {
        Trigger_Action__mdt triggerActionCMDT = new Trigger_Action__mdt();
        triggerActionCMDT.Apex_Class_Name__c = String.valueOf(NoOpTriggerAction.class);
        triggerActionCMDT.Active__c = true;
        triggerActionCMDT.Order__c = 1;
        triggerActionCMDT.Description__c = 'Some Description';

        TriggerActionSetting tas = new TriggerActionSetting(triggerActionCMDT);

        system.assertEquals(triggerActionCMDT.Active__c, tas.Active,
                            'The active value did not come from the triggerActionCMDT');

        system.assertEquals(triggerActionCMDT.Apex_Class_Name__c, tas.ApexClass,
                            'The ApexClass did not come from the triggerActionCMDT');

        system.assertEquals(triggerActionCMDT.Order__c, tas.SortOrder,
                            'The SortOrder value did not come from the triggerActionCMDT');

        system.assertEquals(triggerActionCMDT.Description__c, tas.Description,
                            'The description value did not come from the triggerActionCMDT');
    }

    @isTest
    static void bypass_ApexClassSetToBypass_expectApexClassBypassedTest() {
        String apexClassToBypass = String.valueOf(NoOpTriggerAction.class);

        TriggerActionSetting.bypass(apexClassToBypass);

        Boolean apexClassIsBypassed = TriggerActionSetting.isBypassed(apexClassToBypass);

        system.assert(apexClassIsBypassed, 'The apex class was not bypassed.');
    }

    @isTest
    static void clear_ApexClassSetToBypassAndThenCleared_expectApexClassNotBypassedTest() {
        String apexClassToBypass = String.valueOf(NoOpTriggerAction.class);

        TriggerActionSetting.bypass(apexClassToBypass);

        Boolean apexClassIsBypassed = TriggerActionSetting.isBypassed(apexClassToBypass);

        system.assert(apexClassIsBypassed, 'The apex class was not bypassed.');

        TriggerActionSetting.clearBypass(apexClassToBypass);

        apexClassIsBypassed = TriggerActionSetting.isBypassed(apexClassToBypass);

        system.assertEquals(false, apexClassIsBypassed, 'The apex class was bypassed after it was cleared.');
    }

    @isTest
    static void isBypassed_nullApexClassGiven_expectIsBypassedIsFalseTest() {
        String nullApexClass = null;

        TriggerActionSetting.bypass(nullApexClass);

        Boolean isTriggerActionBypassed = TriggerActionSetting.isBypassed(nullApexClass);

        system.assertEquals(false, isTriggerActionBypassed,
                            'A null Apex Class should not be bypassed.');
    }
}
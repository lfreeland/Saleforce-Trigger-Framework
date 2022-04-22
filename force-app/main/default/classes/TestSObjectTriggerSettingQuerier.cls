@isTest
global with sharing class TestSObjectTriggerSettingQuerier implements SObjectTriggerSettingQuerier {

    global List<SObjectTriggerSetting> SObjectTriggerSettings;

    global TestSObjectTriggerSettingQuerier() {
        SObjectTriggerSettings = new List<SObjectTriggerSetting>();
    }

    global List<SObjectTriggerSetting> getSObjectTriggerSettings() {
        return SObjectTriggerSettings;
    }
}
@isTest
public with sharing class TestSObjectTriggerSettingQuerier implements SObjectTriggerSettingQuerier {

    public List<SObjectTriggerSetting> SObjectTriggerSettings;

    public TestSObjectTriggerSettingQuerier() {
        SObjectTriggerSettings = new List<SObjectTriggerSetting>();
    }

    public List<SObjectTriggerSetting> getSObjectTriggerSettings() {
        return SObjectTriggerSettings;
    }
}
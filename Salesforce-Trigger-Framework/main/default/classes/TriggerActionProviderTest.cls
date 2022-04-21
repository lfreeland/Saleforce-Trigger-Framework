@isTest
public class TriggerActionProviderTest {

    @isTest
    static void getSObjectTriggerActions_nullSObjectProvided_expectNoTriggerActionsReturnedTest() {
        String nullSObjectName = null;

        TriggerActionProvider tap = new TriggerActionProvider();
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(nullSobjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(0, objectTriggerActions.size(), 'There should be no trigger actions.');
    }

    @isTest
    static void getSObjectTriggerActions_noObjectTriggerSettingsForSObjectProvided_expectNoTriggerActionsReturnedTest() {
        String accountSObjectName = 'Account';

        TestSObjectTriggerSettingQuerier emptyQuerier = new TestSObjectTriggerSettingQuerier();
        TriggerActionProvider tap = new TriggerActionProvider(emptyQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(0, objectTriggerActions.size(), 'There should be no trigger actions.');
    }

    @isTest
    static void getSObjectTriggerActions_sObjectTriggerSettingsForSObjectProvidedNotActive_expectNoTriggerActionsReturnedTest() {
        String accountSObjectName = 'Account';

        SObjectTriggerSetting disabledAccountTriggerSetting = buildAccountCounterTriggerActionTriggerSetting();
        disabledAccountTriggerSetting.Active = false;

        TestSObjectTriggerSettingQuerier accountCounterQuerier = new TestSObjectTriggerSettingQuerier();
        accountCounterQuerier.SObjectTriggerSettings.add(disabledAccountTriggerSetting);

        TriggerActionProvider tap = new TriggerActionProvider(accountCounterQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(0, objectTriggerActions.size(), 'There should be no trigger actions.');
    }

    @isTest
    static void getSObjectTriggerActions_triggerActionNotActiveForSObjectProvided_expectNoTriggerActionsReturnedTest() {
        String accountSObjectName = 'Account';

        SObjectTriggerSetting accountTriggerSetting = buildAccountCounterTriggerActionTriggerSetting();
        accountTriggerSetting.TriggerActionSettings[0].Active = false;

        TestSObjectTriggerSettingQuerier accountCounterQuerier = new TestSObjectTriggerSettingQuerier();
        accountCounterQuerier.SObjectTriggerSettings.add(accountTriggerSetting);

        TriggerActionProvider tap = new TriggerActionProvider(accountCounterQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(0, objectTriggerActions.size(), 'There should be no trigger actions.');
    }

    @isTest
    static void getSObjectTriggerActions_sObjectTriggerSettingsForActiveAccount_expectCounterTriggerActionReturnedTest() {
        String accountSObjectName = 'Account';

        TestSObjectTriggerSettingQuerier accountCounterQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        TriggerActionProvider tap = new TriggerActionProvider(accountCounterQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(1, objectTriggerActions.size(), 'There should be one trigger action.');

        TriggerAction ta = objectTriggerActions[0];

        system.assert(ta instanceOf CounterTriggerAction,
                      'The trigger action is not the CounterTriggerAction');
    }

    @isTest
    static void getSObjectTriggerActions_triggerActionsCreatedInProperOrder_expectNoOpTriggerActionAndThenCounterTriggerActionReturnedTest() {
        String accountSObjectName = 'Account';

        TestSObjectTriggerSettingQuerier accountQuerier = buildAccountCounterObjectTriggerSettingQuerier();
        accountQuerier.SObjectTriggerSettings[0].TriggerActionSettings[0].SortOrder = 2;

        TriggerActionSetting noOpTriggerActionSetting = new TriggerActionSetting();
        noOpTriggerActionSetting.Active = true;
        noOpTriggerActionSetting.SortOrder = 1;
        noOpTriggerActionSetting.ApexClass = String.valueOf(NoOpTriggerAction.class);

        accountQuerier.SObjectTriggerSettings[0].TriggerActionSettings.add(noOpTriggerActionSetting);

        TriggerActionProvider tap = new TriggerActionProvider(accountQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(2, objectTriggerActions.size(), 'There should be two trigger actions.');

        TriggerAction firstTriggerAction = objectTriggerActions[0];

        system.assert(firstTriggerAction instanceOf NoOpTriggerAction,
                      'The first trigger action is not the NoOpTriggerAction.');

        TriggerAction secondTriggerAction = objectTriggerActions[1];

        system.assert(secondTriggerAction instanceOf CounterTriggerAction,
                      'The second trigger action is not the CounterTriggerAction.');
    }

    @isTest
    static void getSObjectTriggerActions_triggerActionSpecifiedAndThenSObjectBypassedProgrammatically_expectNoTriggerActionsReturnedTest() {
        String accountSObjectName = 'Account';

        TestSObjectTriggerSettingQuerier accountQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        TriggerActionProvider tap = new TriggerActionProvider(accountQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(1, objectTriggerActions.size(), 'There should be 1 trigger action.');

        SObjectTriggerSetting.bypass(accountSObjectName);

        objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assertEquals(0, objectTriggerActions.size(),
                            'There should be no account trigger actions when the sObject is bypassed.');
    }

    @isTest
    static void getSObjectTriggerActions_triggerActionSpecifiedAndThenSObjectBypassedAndThenClearedProgrammatically_expectTriggerActionsReturnedTest() {
        String accountSObjectName = 'Account';

        TestSObjectTriggerSettingQuerier accountQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        SObjectTriggerSetting.bypass(accountSObjectName);

        TriggerActionProvider tap = new TriggerActionProvider(accountQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(0, objectTriggerActions.size(), 'There should be no trigger actions.');

        SObjectTriggerSetting.clearBypass(accountSObjectName);

        objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assertEquals(1, objectTriggerActions.size(),
                            'There should be one account trigger actions when the sObject is cleared.');
    }

    @isTest
    static void getSObjectTriggerActions_triggerActionSpecifiedAndThenTriggerActionBypassedProgrammatically_expectNoTriggerActionsReturnedTest() {
        String accountSObjectName = 'Account';

        TestSObjectTriggerSettingQuerier accountQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        TriggerActionProvider tap = new TriggerActionProvider(accountQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(1, objectTriggerActions.size(), 'There should be 1 trigger action.');

        TriggerActionSetting triggerActionSettingUsed = accountQuerier.SObjectTriggerSettings[0].TriggerActionSettings[0];

        TriggerActionSetting.bypass(triggerActionSettingUsed.ApexClass);

        objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assertEquals(0, objectTriggerActions.size(),
                            'There should be no account trigger actions when the sObject is bypassed.');
    }

    @isTest
    static void getSObjectTriggerActions_triggerActionSpecifiedAndThenTriggerActionBypassedProgrammaticallyAndThenCleared_expectTriggerActionReturnedTest() {
        String accountSObjectName = 'Account';

        TestSObjectTriggerSettingQuerier accountQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        TriggerActionSetting triggerActionSettingUsed = accountQuerier.SObjectTriggerSettings[0].TriggerActionSettings[0];

        TriggerActionSetting.bypass(triggerActionSettingUsed.ApexClass);

        TriggerActionProvider tap = new TriggerActionProvider(accountQuerier);
        List<TriggerAction> objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assert(objectTriggerActions != null, 'The objectTriggerActions should not be null.');
        system.assertEquals(0, objectTriggerActions.size(), 'There should be no trigger actions.');

        TriggerActionSetting.clearBypass(triggerActionSettingUsed.ApexClass);

        objectTriggerActions = tap.getSObjectTriggerActions(accountSObjectName);

        system.assertEquals(1, objectTriggerActions.size(),
                            'There should be one account trigger actions when the trigger account is cleared.');
    }

    private static TestSObjectTriggerSettingQuerier buildAccountCounterObjectTriggerSettingQuerier() {
        TestSObjectTriggerSettingQuerier testQuerier = new TestSObjectTriggerSettingQuerier();
        testQuerier.SObjectTriggerSettings.add( buildAccountCounterTriggerActionTriggerSetting() );

        return testQuerier;
    }

    private static SObjectTriggerSetting buildAccountCounterTriggerActionTriggerSetting() {
        SObjectTriggerSetting sots = new SObjectTriggerSetting();
        sots.ObjectAPIName = 'Account';
        sots.Active = true;

        TriggerActionSetting counterTAS = new TriggerActionSetting();
        counterTAS.ApexClass = String.valueOf(CounterTriggerAction.class);
        counterTAS.SortOrder = 1;


        sots.TriggerActionSettings.add(counterTAS);

        return sots;
    }
}
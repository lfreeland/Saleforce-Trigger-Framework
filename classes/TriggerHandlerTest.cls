@isTest
public with sharing class TriggerHandlerTest {
    private static final Id TEST_ACCOUNT_ID = '001000000000000';
    
    @isTest
    static void oldRecords_oldRecordsSetManually_expectProvidedRecordsReturnedTest() {
        List<Account> oldAccounts = new List<Account>{
            new Account()
        };
        
        TriggerHandler mth = new TriggerHandler();
        mth.oldRecords = oldAccounts;

        system.assertEquals(oldAccounts, (List<Account>) mth.oldRecords,
                            'The old records provided were not returned.');
    }

    @isTest
    static void oldRecords_oldRecordsNotSet_expectTriggerDotOldReturnedTest() {
        TriggerHandler mth = new TriggerHandler();

        system.assertEquals(Trigger.old, mth.oldRecords,
                            'The Trigger.old records were not returned.');
    }

    @isTest
    static void newRecords_newRecordsSetManually_expectProvidedRecordsReturnedTest() {
        List<Account> newAccounts = new List<Account>{
            new Account()
        };
        
        TriggerHandler mth = new TriggerHandler();
        mth.newRecords = newAccounts;

        system.assertEquals(newAccounts, (List<Account>) mth.newRecords,
                            'The new records provided were not returned.');
    }

    @isTest
    static void newRecords_newRecordsNotSet_expectTriggerDotNewReturnedTest() {
        TriggerHandler mth = new TriggerHandler();

        system.assertEquals(Trigger.new, mth.newRecords,
                            'The Trigger.new records were not returned.');
    }

    @isTest
    static void oldRecordsMap_oldRecordsMapManuallySet_expectProvidedOldRecordsMapReturnedTest() {
        Map<Id, Account> oldAccountsMap = new Map<Id, Account>{
            TEST_ACCOUNT_ID => new Account()
        };

        TriggerHandler mth = new TriggerHandler();
        mth.oldRecordsMap = oldAccountsMap;

        system.assertEquals(oldAccountsMap, (Map<Id, Account>) mth.oldRecordsMap,
                            'The old records map provided was not returned.');
    }

    @isTest
    static void oldRecordsMap_oldRecordsMapNotProvided_expectTriggerDotOldMapReturnedTest() {
        TriggerHandler mth = new TriggerHandler();

        system.assertEquals(Trigger.oldMap, mth.oldRecordsMap,
                            'The Trigger.oldMap was not returned.');
    }

    @isTest
    static void newRecordsMap_newRecordsMapManuallySet_expectProvidedNewRecordsMapReturnedTest() {
        Map<Id, Account> newAccountsMap = new Map<Id, Account>{
            TEST_ACCOUNT_ID => new Account()
        };

        TriggerHandler mth = new TriggerHandler();
        mth.newRecordsMap = newAccountsMap;

        system.assertEquals(newAccountsMap, (Map<Id, Account>) mth.newRecordsMap,
                            'The new records map provided was not returned.');
    }

    @isTest
    static void newRecordsMap_newRecordsMapNotProvided_expectTriggerDotNewMapReturnedTest() {
        TriggerHandler mth = new TriggerHandler();

        system.assertEquals(Trigger.newMap, mth.newRecordsMap,
                            'The Trigger.newMap was not returned.');
    }

    @isTest
    static void sObjectName_AccountProvidedForSObjectName_expectAccountReturnedTest() {
        String accountSObjectName = 'Account';

        TriggerHandler mth = new TriggerHandler();
        mth.SObjectName = accountSObjectName;

        system.assertEquals(accountSObjectName, mth.SObjectName,
                            'The account sobject name was not returned.');
    }

    @isTest
    static void sObjectName_NoSObjectNameProvidedAndAccountInNewRecords_expectAccountReturnedTest() {
        List<Account> newAccounts = new List<Account>{
            new Account()
        };

        TriggerHandler mth = new TriggerHandler();
        mth.newRecords = newAccounts;

        system.assertEquals('Account', mth.SObjectName,
                            'The account sobject name was not returned.');
    }

    @isTest
    static void sObjectName_NoSObjectNameProvidedAndAccountInOldRecords_expectAccountReturnedTest() {
        List<Account> oldAccounts = new List<Account>{
            new Account()
        };

        TriggerHandler mth = new TriggerHandler();
        mth.oldRecords = oldAccounts;

        system.assertEquals('Account', mth.SObjectName,
                            'The account sobject name was not returned.');
    }

    @isTest
    static void triggerOperation_triggerOperationProvided_expectProvidedTriggerOperationReturnedTest() {
        System.TriggerOperation beforeInsertTriggerOperation = System.TriggerOperation.BEFORE_INSERT;

        TriggerHandler mth = new TriggerHandler();
        mth.triggerOperation = beforeInsertTriggerOperation;

        system.assertEquals(beforeInsertTriggerOperation, mth.triggerOperation,
                            'The provided trigger operation was not returned.');
    }

    @isTest
    static void triggerOperation_triggerOperationNotSet_expectTriggerDotOperationTypeReturnedTest() {
        TriggerHandler mth = new TriggerHandler();

        system.assertEquals(Trigger.operationType, mth.triggerOperation,
                            'The Trigger.operationType was not returned.');
    }

    @isTest
    static void run_beforeInsertOnAccountWithCounterTriggerAction_expectBeforeInsertCounterIsOneTest() {
        TestSObjectTriggerSettingQuerier testQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        List<Account> newAccounts = new List<Account>{
            new Account()
        };

        TriggerHandler mth = new TriggerHandler(testQuerier);
        mth.newRecords = newAccounts;
        mth.triggerOperation = System.TriggerOperation.BEFORE_INSERT;

        mth.run();

        system.assertEquals(1, CounterTriggerAction.beforeInsertRuns,
                            'The CounterTriggerAction was not instantiated and before insert was not executed');
    }

    @isTest
    static void run_afterInsertOnAccountWithCounterTriggerAction_expectAfterInsertCounterIsOneTest() {
        TestSObjectTriggerSettingQuerier testQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        List<Account> newAccounts = new List<Account>{
            new Account()
        };

        TriggerHandler mth = new TriggerHandler(testQuerier);
        mth.newRecords = newAccounts;
        mth.triggerOperation = System.TriggerOperation.AFTER_INSERT;

        mth.run();

        system.assertEquals(1, CounterTriggerAction.afterInsertRuns,
                            'The CounterTriggerAction was not instantiated and after insert was not executed');
    }

    @isTest
    static void run_beforeUpdateOnAccountWithCounterTriggerAction_expectBeforeUpdateCounterIsOneTest() {
        TestSObjectTriggerSettingQuerier testQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        Map<Id, Account> newAccountsMap = new Map<Id, Account>{
            TEST_ACCOUNT_ID => new Account()
        };

        Map<Id, Account> oldAccountsMap = new Map<Id, Account>{
            TEST_ACCOUNT_ID => new Account()
        };

        TriggerHandler mth = new TriggerHandler(testQuerier);
        mth.newRecordsMap = newAccountsMap;
        mth.newRecords = newAccountsMap.values();
        mth.oldRecordsMap = oldAccountsMap;
        mth.oldRecords = oldAccountsMap.values();
        mth.triggerOperation = System.TriggerOperation.BEFORE_UPDATE;

        mth.run();

        system.assertEquals(1, CounterTriggerAction.beforeUpdateRuns,
                            'The CounterTriggerAction was not instantiated and before update was not executed');
    }

    @isTest
    static void run_afterUpdateOnAccountWithCounterTriggerAction_expectAfterUpdateCounterIsOneTest() {
        TestSObjectTriggerSettingQuerier testQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        Map<Id, Account> newAccountsMap = new Map<Id, Account>{
            TEST_ACCOUNT_ID => new Account()
        };

        Map<Id, Account> oldAccountsMap = new Map<Id, Account>{
            TEST_ACCOUNT_ID => new Account()
        };

        TriggerHandler mth = new TriggerHandler(testQuerier);
        mth.newRecordsMap = newAccountsMap;
        mth.newRecords = newAccountsMap.values();
        mth.oldRecordsMap = oldAccountsMap;
        mth.oldRecords = oldAccountsMap.values();
        mth.triggerOperation = System.TriggerOperation.AFTER_UPDATE;

        mth.run();

        system.assertEquals(1, CounterTriggerAction.afterUpdateRuns,
                            'The CounterTriggerAction was not instantiated and after update was not executed');
    }

    @isTest
    static void run_beforeDeleteOnAccountWithCounterTriggerAction_expectBeforeDeleteCounterIsOneTest() {
        TestSObjectTriggerSettingQuerier testQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        Map<Id, Account> oldAccountsMap = new Map<Id, Account>{
            TEST_ACCOUNT_ID => new Account()
        };

        TriggerHandler mth = new TriggerHandler(testQuerier);
        mth.oldRecordsMap = oldAccountsMap;
        mth.oldRecords = oldAccountsMap.values();
        mth.triggerOperation = System.TriggerOperation.BEFORE_DELETE;

        mth.run();

        system.assertEquals(1, CounterTriggerAction.beforeDeleteRuns,
                            'The CounterTriggerAction was not instantiated and before delete was not executed');
    }

    @isTest
    static void run_afterDeleteOnAccountWithCounterTriggerAction_expectAfterDeleteCounterIsOneTest() {
        TestSObjectTriggerSettingQuerier testQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        Map<Id, Account> oldAccountsMap = new Map<Id, Account>{
            TEST_ACCOUNT_ID => new Account()
        };

        TriggerHandler mth = new TriggerHandler(testQuerier);
        mth.oldRecordsMap = oldAccountsMap;
        mth.oldRecords = oldAccountsMap.values();
        mth.triggerOperation = System.TriggerOperation.AFTER_DELETE;

        mth.run();

        system.assertEquals(1, CounterTriggerAction.afterDeleteRuns,
                            'The CounterTriggerAction was not instantiated and after delete was not executed');
    }

    @isTest
    static void run_afterUndeleteOnAccountWithCounterTriggerAction_expectAfterUndeleteCounterIsOneTest() {
        TestSObjectTriggerSettingQuerier testQuerier = buildAccountCounterObjectTriggerSettingQuerier();

        List<Account> newAccounts = new List<Account>{
            new Account()
        };

        TriggerHandler mth = new TriggerHandler(testQuerier);
        mth.newRecords = newAccounts;
        mth.triggerOperation = System.TriggerOperation.AFTER_UNDELETE;

        mth.run();

        system.assertEquals(1, CounterTriggerAction.afterUndeleteRuns,
                            'The CounterTriggerAction was not instantiated and after undelete was not executed');
    }

    static TestSObjectTriggerSettingQuerier buildAccountCounterObjectTriggerSettingQuerier() {
        TestSObjectTriggerSettingQuerier testQuerier = new TestSObjectTriggerSettingQuerier();
        testQuerier.SObjectTriggerSettings.add( buildAccountCounterTriggerActionTriggerSetting() );

        return testQuerier;
    }

    static SObjectTriggerSetting buildAccountCounterTriggerActionTriggerSetting() {
        SObjectTriggerSetting sots = new SObjectTriggerSetting();
        sots.ObjectAPIName = 'Account';

        TriggerActionSetting counterTAS = new TriggerActionSetting();
        counterTAS.ApexClass = String.valueOf(CounterTriggerAction.class);
        counterTAS.SortOrder = 1;

        sots.TriggerActionSettings.add(counterTAS);

        return sots;
    }
}
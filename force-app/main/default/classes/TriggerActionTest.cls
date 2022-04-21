@isTest
public with sharing class TriggerActionTest {

    @isTest
    static void runAllEventsWithNullArguments_expectNoErrorsTest() {
        Exception runException = null;

        try {
            TriggerAction ta = new TriggerAction();
            ta.beforeInsert(null);
            ta.afterInsert(null);
            ta.beforeUpdate(null, null);
            ta.afterUpdate(null, null);
            ta.beforeDelete(null);
            ta.afterDelete(null);
            ta.afterUndelete(null);
        }
        catch (Exception ex) {
            runException = ex;
        }

        system.assertEquals(null, runException,
                            'Error running the TriggerAction event methods');
    }
}
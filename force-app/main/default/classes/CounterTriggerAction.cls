@isTest
global class CounterTriggerAction extends TriggerAction {
    global static Integer beforeInsertRuns = 0;
    global static Integer afterInsertRuns = 0;
    global static Integer beforeUpdateRuns = 0;
    global static Integer afterUpdateRuns = 0;
    global static Integer beforeDeleteRuns = 0;
    global static Integer afterDeleteRuns = 0;
    global static Integer afterUnDeleteRuns = 0;

    global override void beforeInsert(List<Sobject> newRecords) {
        ++beforeInsertRuns;
    }

    global override void beforeUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) {
        ++beforeUpdateRuns;
    }

    global override void beforeDelete(Map<Id, Sobject> deletedRecordsMap) {
        ++beforeDeleteRuns;
    }

    global override void afterInsert(List<Sobject> newRecords) {
        ++afterInsertRuns;
    }

    global override void afterUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) {
        ++afterUpdateRuns;
    }

    global override void afterDelete(Map<Id, Sobject> deletedRecordsMap) {
        ++afterDeleteRuns;
    }

    global override void afterUndelete(List<Sobject> undeletedRecords) {
        ++afterUnDeleteRuns;
    }
}
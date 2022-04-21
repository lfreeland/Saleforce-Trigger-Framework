@isTest
public class CounterTriggerAction extends TriggerAction {
    public static Integer beforeInsertRuns = 0;
    public static Integer afterInsertRuns = 0;
    public static Integer beforeUpdateRuns = 0;
    public static Integer afterUpdateRuns = 0;
    public static Integer beforeDeleteRuns = 0;
    public static Integer afterDeleteRuns = 0;
    public static Integer afterUnDeleteRuns = 0;

    public override void beforeInsert(List<Sobject> newRecords) {
        ++beforeInsertRuns;
    }

    public override void beforeUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) {
        ++beforeUpdateRuns;
    }

    public override void beforeDelete(Map<Id, Sobject> deletedRecordsMap) {
        ++beforeDeleteRuns;
    }

    public override void afterInsert(List<Sobject> newRecords) {
        ++afterInsertRuns;
    }

    public override void afterUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) {
        ++afterUpdateRuns;
    }

    public override void afterDelete(Map<Id, Sobject> deletedRecordsMap) {
        ++afterDeleteRuns;
    }

    public override void afterUndelete(List<Sobject> undeletedRecords) {
        ++afterUnDeleteRuns;
    }
}
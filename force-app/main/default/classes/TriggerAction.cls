global virtual inherited sharing class TriggerAction {
    global virtual void beforeInsert(List<Sobject> newRecords) { }

    global virtual void beforeUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) { }

    global virtual void beforeDelete(Map<Id, Sobject> deletedRecordsMap) { }

    global virtual void afterInsert(List<Sobject> newRecords) { }

    global virtual void afterUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) { }

    global virtual void afterDelete(Map<Id, Sobject> deletedRecordsMap) { }

    global virtual void afterUndelete(List<Sobject> undeletedRecords) { }
}
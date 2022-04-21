public virtual inherited sharing class TriggerAction {
    public virtual void beforeInsert(List<Sobject> newRecords) { }

    public virtual void beforeUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) { }

    public virtual void beforeDelete(Map<Id, Sobject> deletedRecordsMap) { }

    public virtual void afterInsert(List<Sobject> newRecords) { }

    public virtual void afterUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) { }

    public virtual void afterDelete(Map<Id, Sobject> deletedRecordsMap) { }

    public virtual void afterUndelete(List<Sobject> undeletedRecords) { }
}
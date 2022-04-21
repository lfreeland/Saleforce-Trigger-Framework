public with sharing class TriggerHandler {
    private List<TriggerAction> triggerActions;
    private SObjectTriggerSettingQuerier querier;

    public TriggerHandler() {
        this(new MetadataSObjectTriggerSettingQuerier());
    }

    public TriggerHandler(SObjectTriggerSettingQuerier querierToUse) {
        this.querier = querierToUse;
    }

    public void run() {
        TriggerActionProvider provider = new TriggerActionProvider(this.querier);
        triggerActions = provider.getSObjectTriggerActions(sobjectName);

        switch on this.triggerOperation {
            when BEFORE_INSERT {
                runBeforeInsertActions();
            }

            when AFTER_INSERT {
                runAfterInsertActions();
            }

            when BEFORE_UPDATE {
                runBeforeUpdateActions();
            }

            when AFTER_UPDATE {
                runAfterUpdateActions();
            }

            when BEFORE_DELETE {
                runBeforeDeleteActions();
            }

            when AFTER_DELETE {
                runAfterDeleteActions();
            }

            when AFTER_UNDELETE {
                runAfterUndeleteActions();
            }
        }


    }

    private void runBeforeInsertActions() {
        for (TriggerAction ta : triggerActions) {
            ta.beforeInsert(this.newRecords);
        }
    }

    private void runAfterInsertActions() {
        for (TriggerAction ta : triggerActions) {
            ta.afterInsert(this.newRecords);
        }
    }

    private void runBeforeUpdateActions() {
        for (TriggerAction ta : triggerActions) {
            ta.beforeUpdate(this.oldRecordsMap, this.newRecordsMap);
        }
    }

    private void runAfterUpdateActions() {
        for (TriggerAction ta : triggerActions) {
            ta.afterUpdate(this.oldRecordsMap, this.newRecordsMap);
        }
    }

    private void runBeforeDeleteActions() {
        for (TriggerAction ta : triggerActions) {
            ta.beforeDelete(this.oldRecordsMap);
        }
    }

    private void runAfterDeleteActions() {
        for (TriggerAction ta : triggerActions) {
            ta.afterDelete(this.oldRecordsMap);
        }
    }

    private void runAfterUndeleteActions() {
        for (TriggerAction ta : triggerActions) {
            ta.afterUndelete(this.newRecords);
        }
    }

    private String sObjectNamePriv = null;

    @testVisible
    private String SobjectName {
        get {
            if (String.isNotBlank(sObjectNamePriv)) {
                return sObjectNamePriv;
            }

            SObject triggerRecord;

            if (this.newRecords != null && !this.newRecords.isEmpty()) {
                triggerRecord = this.newRecords[0];
            }
            else {
                triggerRecord = this.oldRecords[0];
            }

            return triggerRecord.getSObjectType()
                        .getDescribe()
                        .getName();
        }

        set {
            this.sObjectNamePriv = value;
        }
    }

    private System.TriggerOperation triggerOperationPriv = null;

    @testVisible
    private System.TriggerOperation triggerOperation {
        get {
            if (triggerOperationPriv != null) {
                return triggerOperationPriv;
            }

            return Trigger.operationType;
        }

        set {
            this.triggerOperationPriv = value;
        }
    }

    private List<SObject> newRecordsPriv = null;

    @testVisible
    private List<SObject> newRecords {
        get {
            if (newRecordsPriv != null) {
                return newRecordsPriv;
            }

            return Trigger.new;
        }

        set {
            this.newRecordsPriv = value;
        }
    }

    private List<SObject> oldRecordsPriv = null;

    @testVisible
    private List<SObject> oldRecords {
        get {
            if (oldRecordsPriv != null) {
                return oldRecordsPriv;
            }

            return Trigger.old;
        }

        set {
            this.oldRecordsPriv = value;
        }
    }

    private Map<Id, SObject> oldRecordsMapPriv = null;

    @testVisible
    private Map<Id, SObject> oldRecordsMap {
        get {
            if (oldRecordsMapPriv != null) {
                return oldRecordsMapPriv;
            }

            return Trigger.oldMap;
        }

        set {
            this.oldRecordsMapPriv = value;
        }
    }

    private Map<Id, SObject> newRecordsMapPriv = null;

    @testVisible
    private Map<Id, SObject> newRecordsMap {
        get {
            if (newRecordsMapPriv != null) {
                return newRecordsMapPriv;
            }

            return Trigger.newMap;
        }

        set {
            this.newRecordsMapPriv = value;
        }
    }
}
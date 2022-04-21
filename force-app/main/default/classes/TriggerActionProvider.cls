public with sharing class TriggerActionProvider {

    private SObjectTriggerSettingQuerier querier;

    private Map<String, SObjectTriggerSetting> sobjectTriggerSettingsByObjectPriv = null;

    private Map<String, SObjectTriggerSetting> SObjectTriggerSettingsByObjectName {
        get {
            if (sobjectTriggerSettingsByObjectPriv == null) {
                sobjectTriggerSettingsByObjectPriv = new Map<String, SObjectTriggerSetting>();

                List<SObjectTriggerSetting> objectTriggerSettings = querier.getSObjectTriggerSettings();

                for (SObjectTriggerSetting ots : objectTriggerSettings) {
                    sobjectTriggerSettingsByObjectPriv.put(ots.ObjectAPIName.toLowerCase(), ots);

                    ots.sortTriggerActionsByOrder();
                }
            }

            return sobjectTriggerSettingsByObjectPriv;
        }
    }

    public TriggerActionProvider() {
        this( new MetadataSObjectTriggerSettingQuerier() );
    }

    public TriggerActionProvider(SObjectTriggerSettingQuerier querierToUse) {
        this.querier = querierToUse;
    }

    public List<TriggerAction> getSObjectTriggerActions(String sobjectAPIName) {
        List<TriggerAction> sobjectTriggerActions = new List<TriggerAction>();

        if (String.isBlank(sobjectAPIName)) {
            return sobjectTriggerActions;
        }

        SObjectTriggerSetting sots = SObjectTriggerSettingsByObjectName.get(sobjectAPIName.toLowerCase());

        if (sots == null ||
            sots.Active == false ||
            SObjectTriggerSetting.isBypassed(sobjectAPIName)) {
            return sobjectTriggerActions;
        }

        for (TriggerActionSetting tas : sots.TriggerActionSettings) {
            if (tas.Active == false ||
                TriggerActionSetting.isBypassed(tas.ApexClass)) {
                continue;
            }

            sobjectTriggerActions.add( tas.instantiateTriggerAction() );
        }

        return sobjectTriggerActions;
    }
}
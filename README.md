# Saleforce Trigger Framework
A Salesforce Apex trigger framework where an object's Apex trigger actions are configured via custom metadata.

# Installation
The trigger framework uses an unlocked package for distribution. To install it, use the appropriate installation url based on your org type using the instructions below.

## Sandbox Installation
1. Open <a href="https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4W0000030AMJQA2" target="_blank">installation page</a>.
2. Login with your credentials. The "Admins Only" option is fine.
3. Click Install.


## Production, Developer Edition, and Trailhead Org Installation
1. Open <a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4W0000030AMJQA2" target="_blank">installation page</a>.
2. Login with your credentials. The "Admins Only" option is fine.
3. Click Install.

# Usage
To create a trigger action for an Object, the steps are to create the trigger action class, create the trigger for the object, and create the custom metadata records. Separate each trigger "automation" into one trigger action.

## Create Trigger Action Class
Create a global Apex class that extends the `mtf.TriggerAction` apex class and override the appropriate trigger event methods as needed. If an event isn't needed, don't override it and the mtf.triggeraction's empty, no-op event method will be executed instead. This allows only the event methods needed to be used.

In the overridden event method, downcast the provided list or map to its strongly-typed SObject type for better compile time assistance.

Note: It has to be a global Apex class so the framework can see it since the framework uses Type.forName to dynamically instantiate it.

### Available Trigger Action Event Methods To Override From mtf.TriggerAction
    void beforeInsert(List<Sobject> newRecords)

    void beforeUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap)

    void beforeDelete(Map<Id, Sobject> deletedRecordsMap)

    void afterInsert(List<Sobject> newRecords)

    void afterUpdate(Map<Id, Sobject> oldRecordsMap, Map<Id, Sobject> newRecordsMap) { }

    void afterDelete(Map<Id, Sobject> deletedRecordsMap) { }

    void afterUndelete(List<Sobject> undeletedRecords) { }

### Trigger Action Class Example
Let's say one has to do some custom validation when Accounts are inserted.
```
global with sharing class AccountCustomValidation extends mtf.TriggerAction {
    public override void beforeInsert(List<SObject> newRecords) {
        List<Account> newAccounts = (List<Account>) newRecords;

        for (Account newAccount : newAccounts) {
            // Add newAccount custom validation here
        }
    }
}
```

## Create SObject Trigger
Create an Apex Trigger for the SObject if there's none. If this already exists, skip this because there should only be one Apex Trigger for the SObject. All the trigger events should be specified for the trigger so one doesn't have to remember to update it later as new events are needed. The trigger then instantiates the `mtf.TriggerHandler` class and invokes its run method.

### Example Account Trigger
```
trigger AccountTrigger on Account (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    new mtf.TriggerHandler().run();
}
```

## Create Custom Metadata Records
One creates one "sObject Trigger Setting" custom metadata record per SObject and then one "Trigger Action" custom metadata record for each Trigger Action to invoke for an SObject.

### Create "sObject Trigger Setting" Custom Metadata Record
The "sObject Trigger Setting" custom metadata records tell the framework which SObjects have trigger actions for them and if they are active or not. If the SObject already has an "sObject Triger Setting" record, skip this step since only 1 should be created per SObject.

Steps to create the record
1. Open Setup in the browser.
2. Open the "Custom Metadata Types" page.
3. Click "Manage Records" next to "sObject Trigger Setting".
4. Click the "New" button.
5. Enter the SObject's API Name for the Label, "sObject Trigger Setting Name", and "Object API Name" fields.
6. Click Save.

### Create "Trigger Action" Custom Metadata Record
The "Trigger Action" custom metadata record tells the framework the Apex Classes to execute for a given SObject. One record is created per apex class.

Steps to create the record
1. Open Setup in the browser.
2. Open the "Custom Metadata Types" page.
3. Click "Manage Records" next to "Trigger Action".
4. Click the "New" button.
5. Enter
    1. Label - Trigger Action Name
    2. Trigger Action Name - The Label but with underscores instead of spaces.
    3. sObject Trigger Seeting - The related "sObject Trigger Setting" to indicate which SObject this trigger action is for.
    4. Apex Class Name - The name of the global Apex class that extends `mtf.TriggerAction`.
    5. Order - The numeric order in which this trigger action will run.
    6. Description - A description of the functionality this trigger action provides. This is required.
6. Click Save.

# Bypass Execution Options
One can bypass trigger actions from executing using the custom metadata or programatically. All trigger actions for a given object can be bypassed or specific trigger actions can be bypassed.

## All Object Trigger Actions
There are two options to bypass all of an object's trigger actions:
### Custom Metadata
On the sObject Trigger Setting custom metadata record in Setup, uncheck the Active checkbox. This disables all trigger actions from executing for that sObject for everyone. To reenable them, check the Active checkbox again.

### Programmatically
One can also bypass all trigger actions for an object programmatically by using the `mtf.SObjectTriggerSetting.bypass` method and passing in the SObject's API Name. This disables that object's trigger actions for this execution context only. Use the `mtf.SObjectTriggerSetting.clearBypass` method and pass in the SObject's API Name to clear the bypass.

#### Account Bypass Example
```
mtf.SObjectTriggerSetting.bypass('Account');
```
#### Account Clear Bypass Example
```
mtf.SObjectTriggerSetting.clearBypass('Account');
```

## Specific Object Trigger Actions
To disable one or more specific trigger actions for an object, one can use custom metadata or programmatically with Apex.

### Custom Metadata
On the Trigger Action custom metadata record(s) in Setup, uncheck the Active checkbox for those trigger actions to disable. This prevents the trigger action from running for everyone. To renable them, check the Active checkbox again.

### Programmatically
One can also bypass a specific trigger action programmatically by using the `mtf.TriggerActionSetting.bypass` method and passing in the Apex Class Name that extends the `mtf.TriggerAction`. This disables the trigger action for this execution context only. Use the `mtf.TriggerActionSetting.clearBypass` method and pass in the Apex Class Name to clear the bypass.

#### NoOpTriggerAction Bypass Example
```
mtf.TriggerActionSetting.bypass('NoOpTriggerAction');
```

#### NoOpTriggerAction Clear Bypass Example
```
mtf.TriggerActionSetting.clearBypass('NoOpTriggerAction');
```

# Design
## Overview
This framework uses custom metadata to determine which Apex Classes, and in which order, to run for an SObject's Apex Trigger. This allows more granular control over the automation by an admin or developer. It also allows multiple implementers to develop multiple trigger actions concurrently more easily since the code is separated into different apex classes.

## Design Goals
- More granularity and control was the primary goal for this framework over my <a href="https://metillium.com/2019/02/a-simple-trigger-framework/">Simple Trigger Framework</a>. It doesn't provide recursion control / prevention since I believe that is better controlled by each trigger action so that allows the framework to be simpler.
- Decoupled Trigger Actions.
- Easy Distribution Through Unlocked Package.

## Framework Classes
### TriggerHandler
Used in Apex Triggers to run the specified trigger actions configured for that Object. It uses the TriggerActionProvider to determine which Trigger Actions to execute for each trigger event.

### TriggerActionProvider
Used to determine the TriggerActions to run for a given SObject using the SObjectTriggerSettings and their TriggerActionSettings. One can provide it an SObjectTriggerSettingQuerier to use to fetch its SObject Trigger Settings. By default the MetadataSObjectTriggerSettingQuerier is used. The test code uses the TestSObjectTriggerSettingQuerier to build the SObjectTriggerSettings and their TriggerActionSettings in memory so it doesn't depend on the custom metadata.

One could build another SObjectTriggerSettingQuerier if the settings are stored elsewhere such as in Objects.

### SObjectTriggerSetting
This class has the trigger action settings for an SObject and indicates if it's active or not. One can also programmatically bypass all the SObject's trigger actions using the bypass and clearBypass methods.

### TriggerActionSeeting
This class has the setting information for a trigger action of an SObject. It knows how to instantiate the TriggerAction using the specified ApexClass. One can also programmatically bypass all trigger action using the bypass and clearBypass methods.

### TriggerAction
The base class for all trigger actions. It has one virtual, empty method for each trigger event. One overrides the method to use in the sub-class and leaves the unused ones in the base class here.

# Versions

## 0.1
Initial release. Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4W0000030AMJQA2

# Origin
I reviewed the <a href="https://github.com/mitchspano/apex-trigger-actions-framework">Apex Trigger Action Framework</a> and thought it was good overall but a bit too granular where one implements a trigger action per trigger event. This made me wonder what if I created the Trigger Action framework but not as granularly and without recursion prevention.

# Other Apex Trigger Frameworks & Other Trigger Resources
The Salesforce community has many Apex trigger frameworks available. If this one doesn't fit your needs, here are some others that might along with other resources you may find helpful:

- <a href="https://github.com/mitchspano/apex-trigger-actions-framework">Apex Trigger Action Framework</a>
- <a href="https://metillium.com/2019/02/a-simple-trigger-framework/">Simple Trigger Framework</a> - My original, simple framework.
- <a href="https://krishhari.wordpress.com/2013/07/22/an-architecture-framework-to-handle-triggers-in-the-force-com-platform/">Hari Krishnan’s Framework</a>
- <a href="http://sfdcpanther.com/trigger-architecture-framework-recipe-sfdcpanther/">SFDC Panther Trigger Framework</a>
- <a href="https://www.salesforce.org/blog/table-driven-trigger-management-matters/">NPSP Table-Driven Trigger Management</a>
- <a href="https://trailhead.salesforce.com/content/learn/modules/apex_triggers/apex_triggers_intro">Trailhead Apex Triggers Intro</a>
- <a href="https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_bestpract.htm">Trigger Best Practices</a>
- <a href="https://cloudsundial.com/the-third-age-of-trigger-frameworks">The Third Age of Trigger Frameworks</a>
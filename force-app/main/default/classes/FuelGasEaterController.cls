public with sharing class FuelGasEaterController {
    
    @AuraEnabled(cacheable=true)
    public static List<Commute__c> getCommutes(){
        String userId = UserInfo.getUserId();
        return Security.stripInaccessible(
            AccessType.READABLE, 
            [SELECT Id, Name, CommuteType__r.Name, CommuteDate__c, Emission__c, Reduce__c FROM Commute__c WHERE OwnerId = :userId ORDER BY CommuteDate__c DESC]
        ).getRecords();
    }

    @AuraEnabled(cacheable=true)
    public static List<Object> getCommuteReduceThisWeek(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Commute__c.isAccessible() && Schema.sObjectType.Commute__c.fields.Reduce__c.isAccessible() && Schema.sObjectType.Commute__c.fields.OwnerId.isAccessible() && Schema.sObjectType.Commute__c.fields.CommuteDate__c.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Commute__c WHERE OwnerId = :userId AND CommuteDate__c = THIS_WEEK];
        }
        throw new AuraHandledException('Not Accessible');
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getCommuteReduceLastWeek(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Commute__c.isAccessible() && Schema.sObjectType.Commute__c.fields.Reduce__c.isAccessible() && Schema.sObjectType.Commute__c.fields.OwnerId.isAccessible() && Schema.sObjectType.Commute__c.fields.CommuteDate__c.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Commute__c WHERE OwnerId = :userId AND CommuteDate__c = LAST_WEEK];
        }
        throw new AuraHandledException('Not Accessible');
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getCommuteReduceThisFiscalYear(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Commute__c.isAccessible() && Schema.sObjectType.Commute__c.fields.Reduce__c.isAccessible() && Schema.sObjectType.Commute__c.fields.OwnerId.isAccessible() && Schema.sObjectType.Commute__c.fields.CommuteDate__c.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Commute__c WHERE OwnerId = :userId AND CommuteDate__c = THIS_FISCAL_YEAR];
        }
        throw new AuraHandledException('Not Accessible');
    }

    @AuraEnabled(cacheable=true)
    public static List<Event> getEvents(){
        String userId = UserInfo.getUserId();
        return Security.stripInaccessible(
            AccessType.READABLE, 
            [SELECT id, Subject, whatId, what.Name, what.Type, BusinessTripType__c, BusinessTripType__r.Name, ActivityDate, Distance__c, Emission__c, Reduce__c FROM Event WHERE OwnerId = :userId AND WhatId != null ORDER BY ActivityDate DESC]
        ).getRecords();
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getEventReduceThisWeek(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Event.isAccessible() && Schema.sObjectType.Event.fields.Reduce__c.isAccessible() && Schema.sObjectType.Event.fields.OwnerId.isAccessible() && Schema.sObjectType.Event.fields.ActivityDate.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Event WHERE OwnerId = :userId AND ActivityDate = THIS_WEEK];
        }
        throw new AuraHandledException('Not Accessible');
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getEventReduceLastWeek(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Event.isAccessible() && Schema.sObjectType.Event.fields.Reduce__c.isAccessible() && Schema.sObjectType.Event.fields.OwnerId.isAccessible() && Schema.sObjectType.Event.fields.ActivityDate.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Event WHERE OwnerId = :userId AND ActivityDate = LAST_WEEK];
        }
        throw new AuraHandledException('Not Accessible');
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getEventReduceThisFiscalYear(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Event.isAccessible() && Schema.sObjectType.Event.fields.Reduce__c.isAccessible() && Schema.sObjectType.Event.fields.OwnerId.isAccessible() && Schema.sObjectType.Event.fields.ActivityDate.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Event WHERE OwnerId = :userId AND ActivityDate = THIS_FISCAL_YEAR];
        }
        throw new AuraHandledException('Not Accessible');
    }

    @AuraEnabled(cacheable=true)
    public static List<Task> getTasks(){
        String userId = UserInfo.getUserId();
        return Security.stripInaccessible(
            AccessType.READABLE, 
            [SELECT Id, Subject, whatId, what.Name, what.Type, BusinessTripType__c, BusinessTripType__r.Name, ActivityDate, Distance__c, Emission__c, Reduce__c FROM Task WHERE OwnerId = :userId AND WhatId != null ORDER BY ActivityDate DESC]
        ).getRecords();
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getTaskReduceThisWeek(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.fields.Reduce__c.isAccessible() && Schema.sObjectType.Task.fields.OwnerId.isAccessible() && Schema.sObjectType.Task.fields.ActivityDate.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Task WHERE OwnerId = :userId AND ActivityDate = THIS_WEEK];
        }
        throw new AuraHandledException('Not Accessible');
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getTaskReduceLastWeek(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.fields.Reduce__c.isAccessible() && Schema.sObjectType.Task.fields.OwnerId.isAccessible() && Schema.sObjectType.Task.fields.ActivityDate.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Task WHERE OwnerId = :userId AND ActivityDate = LAST_WEEK];
        }
        throw new AuraHandledException('Not Accessible');
    }
    @AuraEnabled(cacheable=true)
    public static List<Object> getTaskReduceThisFiscalYear(){
        String userId = UserInfo.getUserId();
        if (Schema.sObjectType.Task.isAccessible() && Schema.sObjectType.Task.fields.Reduce__c.isAccessible() && Schema.sObjectType.Task.fields.OwnerId.isAccessible() && Schema.sObjectType.Task.fields.ActivityDate.isAccessible()) {
            return [SELECT SUM(Reduce__c) FROM Task WHERE OwnerId = :userId AND ActivityDate = THIS_FISCAL_YEAR];
        }
        throw new AuraHandledException('Not Accessible');
    }

}
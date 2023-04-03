trigger EventTrigger on Event (before insert, before update) {

    static final String KM_UNIT = 'km';

    for (Event e: Trigger.new){
        if (e.whatId != null && e.BusinessTripType__c != null
            && Schema.sObjectType.User.isAccessible() && Schema.sObjectType.User.fields.Location__c.isAccessible()
            && Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Id.isAccessible() && Schema.sObjectType.Account.fields.BillingLatitude.isAccessible() && Schema.sObjectType.Account.fields.BillingLongitude.isAccessible()
            && Schema.sObjectType.Opportunity.isAccessible() && Schema.sObjectType.Opportunity.fields.AccountId.isAccessible()
            && Schema.sObjectType.BusinessTripType__c.isAccessible() && Schema.sObjectType.BusinessTripType__c.fields.Air_Travel_Emissions_Factor__c.isAccessible() && Schema.sObjectType.BusinessTripType__c.fields.Ground_Travel_Emissions_Factor__c.isAccessible()
        ){
            Schema.sObjectType whatType = e.WhatId.getSObjectType();
            if (whatType == Account.sObjectType || whatType == Opportunity.sObjectType){
                Account acc = null;
                if (whatType == Account.sObjectType){
                    acc = [SELECT Id, BillingLatitude, BillingLongitude FROM Account WHERE Id = :e.whatId LIMIT 1];
                } else if (whatType == Opportunity.sObjectType){
                    acc = [SELECT Id, BillingLatitude, BillingLongitude FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE Id = :e.whatId) LIMIT 1];
                }
                Double dst = 0;
                User us = [SELECT Location__c FROM User WHERE Id = :e.OwnerId LIMIT 1];
    
                if (acc != null && acc.BillingLatitude != null && acc.BillingLongitude != null && us.Location__c != null){

                    // Location for Account
                    Location loc1 = Location.newInstance(acc.BillingLatitude, acc.BillingLongitude);

                    // Location for Office
                    Location loc2 = us.Location__c;
        
                    // Distance
                    dst = Location.getDistance(loc1, loc2, KM_UNIT);
                }
                e.Distance__c = dst;

                // Emission
                BusinessTripType__c btt = [SELECT Air_Travel_Emissions_Factor__c, Ground_Travel_Emissions_Factor__c FROM BusinessTripType__c WHERE Id = :e.BusinessTripType__c LIMIT 1];
                Decimal ems = FuelGasEaterUtils.getEmission(btt.Air_Travel_Emissions_Factor__c, btt.Ground_Travel_Emissions_Factor__c, (dst * 2));
                e.Emission__c = ems;

                // Reduce
                BusinessTripType__c bbtt = [SELECT Air_Travel_Emissions_Factor__c, Ground_Travel_Emissions_Factor__c FROM BusinessTripType__c WHERE isDefault__c = true LIMIT 1];
                Double baseEms = FuelGasEaterUtils.getEmission(bbtt.Air_Travel_Emissions_Factor__c, bbtt.Ground_Travel_Emissions_Factor__c, (dst * 2));
                Double rdc = baseEms - ems;
                e.Reduce__c = rdc;
            }
        }
    }


}
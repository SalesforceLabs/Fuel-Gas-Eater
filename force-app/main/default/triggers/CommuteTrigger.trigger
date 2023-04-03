trigger CommuteTrigger on Commute__c (before insert, before update) {

    static final String KM_UNIT = 'km';

    for (Commute__c c: Trigger.new){
        if (c.CommuteType__c != null){

            List<User> uss = Security.stripInaccessible(
                AccessType.READABLE,
                [SELECT Location__c, Home__c FROM User WHERE Id = :c.OwnerId LIMIT 1]
            ).getRecords();

            List<CommuteType__c> cts = Security.stripInaccessible(
                AccessType.READABLE,
                [SELECT Air_Travel_Emissions_Factor__c, Ground_Travel_Emissions_Factor__c FROM CommuteType__c WHERE Id =:c.CommuteType__c LIMIT 1]
            ).getRecords();

            List<CommuteType__c> bcts = Security.stripInaccessible(
                AccessType.READABLE,
                [SELECT Air_Travel_Emissions_Factor__c, Ground_Travel_Emissions_Factor__c FROM CommuteType__c WHERE isDefault__c = true LIMIT 1]
            ).getRecords();

            if (uss != null && cts != null && bcts != null && uss.size() == 1 && cts.size() == 1 && bcts.size() == 1){
                User us = uss.get(0);
                // Distance
                Double dst = 0;
                if (us.Location__c != null && us.Home__c != null){
                    dst = Location.getDistance(us.Location__c, us.Home__c, KM_UNIT);
                }

                // Emission
                CommuteType__c ct = cts.get(0);
                Decimal ems = FuelGasEaterUtils.getEmission(ct.Air_Travel_Emissions_Factor__c, ct.Ground_Travel_Emissions_Factor__c, (dst * 2));
                c.Emission__c = ems;

                // Reduce
                CommuteType__c bct = bcts.get(0);
                Double baseEms = FuelGasEaterUtils.getEmission(bct.Air_Travel_Emissions_Factor__c, bct.Ground_Travel_Emissions_Factor__c, (dst * 2));
                Double rdc = baseEms - ems;
                c.Reduce__c = rdc;
            }
        } else {
            c.Emission__c = 0;
            c.Reduce__c = 0;
        }

    }
}
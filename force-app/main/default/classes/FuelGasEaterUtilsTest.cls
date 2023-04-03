@isTest
public with sharing class FuelGasEaterUtilsTest {
    
    private static final Decimal KM_TO_MILE = 0.62137119;
    private static final Decimal MILE_TO_KM = 1.609344;

    private static testMethod void myTest001() {    
        AirTravelEmssnFctr atef1 = new AirTravelEmssnFctr(
            Name = 'Air Plane #1',
            DistanceUnit = 'Miles',
            Co2PsgrKmShortHaulInKg = 2000
        );
        insert atef1;
        
        AirTravelEmssnFctr atef2 = new AirTravelEmssnFctr(
            Name = 'Air Plane #2',
            DistanceUnit = 'Kilometers',
            MediumHaulMaximumDistance = 1000,
            ShortHaulMaximumDistance = 500,
            Co2PsgrKmLongHaulInKg = 150,
            Co2PsgrKmMediumHaulInKg = 130,
            Co2PsgrKmShortHaulInKg = 120
        );
        insert atef2;

        GroundTravelEmssnFctr gtef1 = new GroundTravelEmssnFctr(
            Name = 'Car',
            DistanceUnit = 'Kilometers',
            PersCarEmssnInKgCo2eDstnUnit = 200
        );
        insert gtef1;
        GroundTravelEmssnFctr gtef2 = new GroundTravelEmssnFctr(
            Name = 'Taxi',
            DistanceUnit = 'Kilometers',
            TaxiEmssnInKgCo2eDstnUnit = 200
        );
        insert gtef2;

        GroundTravelEmssnFctr gtef3 = new GroundTravelEmssnFctr(
            Name = 'Train',
            DistanceUnit = 'Miles',
            TrainEmssnInKgCo2eDstnUnit = 200
        );
        insert gtef3;

        Decimal em = 0;
        Decimal distance = 0;
        Decimal expected = 0;

        distance = 1;
        em = FuelGasEaterUtils.getEmission(null, null, distance);
        System.assertEquals(expected, em);

        distance = 1;
        em = FuelGasEaterUtils.getEmission(null, gtef2.Id, distance);
        expected = distance * 200;
        System.assertEquals(expected, em);

        distance = 1;
        em = FuelGasEaterUtils.getEmission(null, gtef3.Id, distance);
        expected = distance * 200 * KM_TO_MILE;
        System.assertEquals(expected, em);

        distance = 1;
        em = FuelGasEaterUtils.getEmission(atef1.Id, null, distance);
        expected = distance * 2000;
        System.assertEquals(expected, em);
        
        distance = 10;
        em = FuelGasEaterUtils.getEmission(atef2.Id, null, distance);
        expected = distance * 120;
        System.assertEquals(expected, em);

        distance = 600;
        em = FuelGasEaterUtils.getEmission(atef2.Id, null, distance);
        expected = distance * 130;
        System.assertEquals(expected, em);

        distance = 1100;
        em = FuelGasEaterUtils.getEmission(atef2.Id, null, distance);
        expected = distance * 150;
        System.assertEquals(expected, em);
    }
        


}
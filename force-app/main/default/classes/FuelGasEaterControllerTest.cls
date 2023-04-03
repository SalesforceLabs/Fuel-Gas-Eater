@isTest
public with sharing class FuelGasEaterControllerTest {

    @testSetup
    private static void setup(){
        
        AirTravelEmssnFctr atef1 = new AirTravelEmssnFctr(
            Name = 'Air Plane',
            DistanceUnit = 'Miles',
            Co2PsgrKmShortHaulInKg = 1000
        );
        insert atef1;

        GroundTravelEmssnFctr gtef1 = new GroundTravelEmssnFctr(
            Name = 'Car',
            DistanceUnit = 'Miles',
            PersCarEmssnInKgCo2eDstnUnit = 200
        );
        insert gtef1;

        CommuteType__c ct0 = new CommuteType__c(
            Name = 'Air Plane',
            Air_Travel_Emissions_Factor__c = atef1.Id,
            isDefault__c = true
        );
        insert ct0;

        CommuteType__c ct1 = new CommuteType__c(
            Name = 'Train',
            Ground_Travel_Emissions_Factor__c = gtef1.Id
        );
        insert ct1;

        Date dt = Date.today();

        //Commute
        Commute__c cm0 = new Commute__c(
            CommuteDate__c = dt
        );
        insert cm0;
        Commute__c cm = new Commute__c(
            CommuteDate__c = dt,
            CommuteType__c = ct1.Id
        );
        insert cm;
        
        // Account
        Account acc = new Account(
            Name = 'Test Company'
        );
        insert acc;

        // Business Trip
        BusinessTripType__c bt0 = new BusinessTripType__c(
            Name = 'Air Plane',
            isDefault__c = true,
            Air_Travel_Emissions_Factor__c = atef1.Id
        );
        insert bt0;
        BusinessTripType__c bt1 = new BusinessTripType__c(
            Name = 'Train',
            Ground_Travel_Emissions_Factor__c = gtef1.Id
        );
        insert bt1;
        
        //Task
        Task ts0 = new Task(
            Subject = 'Test Task #0'
        );
        insert ts0;

        Task ts1 = new Task(
            Subject = 'Test Task #1',
            WhatId = acc.Id,
            BusinessTripType__c = bt1.Id
        );
        insert ts1;

        //Event
        Event ev0 = new Event(
            Subject = 'Test Event #0',
            StartDateTime = Datetime.now(),
            EndDateTime = Datetime.now().addHours(2)
        );
        insert ev0;

        Event ev1 = new Event(
            Subject = 'Test Event #1',
            StartDateTime = Datetime.now(),
            EndDateTime = Datetime.now().addHours(2),
            WhatId = acc.Id,
            BusinessTripType__c = bt1.Id
        );
        insert ev1;


    }

    private static testMethod void myTest001() {    
        List<Commute__c> rs1 = FuelGasEaterController.getCommutes();
        System.assertEquals(2, rs1.size());
        List<Event> rs2 = FuelGasEaterController.getEvents();
        System.assertEquals(1, rs2.size());
        List<Task> rs3 = FuelGasEaterController.getTasks();
        System.assertEquals(1, rs3.size());
    }

    private static testMethod void myTest002() { 

        List<Object> rs;
        rs = FuelGasEaterController.getCommuteReduceThisWeek();
        System.assertEquals(1, rs.size());
        rs = FuelGasEaterController.getCommuteReduceLastWeek();
        System.assertEquals(1, rs.size());
        rs = FuelGasEaterController.getCommuteReduceThisFiscalYear();
        System.assertEquals(1, rs.size());
        rs = FuelGasEaterController.getEventReduceThisWeek();
        System.assertEquals(1, rs.size());
        rs = FuelGasEaterController.getEventReduceLastWeek();
        System.assertEquals(1, rs.size());
        rs = FuelGasEaterController.getEventReduceThisFiscalYear();
        System.assertEquals(1, rs.size());
        rs = FuelGasEaterController.getTaskReduceThisWeek();
        System.assertEquals(1, rs.size());
        rs = FuelGasEaterController.getTaskReduceLastWeek();
        System.assertEquals(1, rs.size());
        rs = FuelGasEaterController.getTaskReduceThisFiscalYear();
        System.assertEquals(1, rs.size());

        
        
    }


}
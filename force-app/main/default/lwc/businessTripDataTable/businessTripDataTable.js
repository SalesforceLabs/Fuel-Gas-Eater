import { LightningElement, wire } from 'lwc';
import getEvents from '@salesforce/apex/FuelGasEaterController.getEvents';
import getTasks from '@salesforce/apex/FuelGasEaterController.getTasks';
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'Date', fieldName: 'date', type: 'date' },
    { label: 'Subject', fieldName: 'subject' },
    { label: 'Related To', fieldName: 'what' },
    { label: 'Business Trip Type', fieldName: 'typeName' },
    { label: 'CO2 Emission Reduction', fieldName: 'reduce', type: 'number' },
];

export default class BusinessTripDataTable extends LightningElement {
    columns = columns;

    @wire(getEvents)
    events;

    @wire(getTasks)
    tasks;

    get data(){
        if (this.events?.data && this.tasks?.data){
            return [...this.tasks.data, ...this.events.data].sort((a, b) => {
                if (a.ActivityDate < b.ActivityDate){
                    return 1;
                } else if (a.ActivityDate > b.ActivityDate){
                    return -1;
                } else {
                    return 0;
                }
            }).map(rc => {
                return {
                    what: rc.What?.Name,
                    subject: rc.Subject,
                    typeName: rc.BusinessTripType__r.Name,
                    reduce: rc.Reduce__c ?? 0,
                    emission: rc.Emission__c,
                    date: rc.ActivityDate
                }
            });
        }
        return [];
    }

    clickedRefresh(){
        refreshApex(this.events);
        refreshApex(this.tasks);
    }
}
import { LightningElement, wire } from 'lwc';
import getCommutes from '@salesforce/apex/FuelGasEaterController.getCommutes'
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'Date', fieldName: 'date', type: 'date' },
    { label: 'Commute Type', fieldName: 'typeName' },
    { label: 'CO2 Emission Reduction', fieldName: 'reduce', type: 'number' },
];

export default class CommuteDataTable extends LightningElement {
    columns = columns;

    @wire(getCommutes)
    commutes;

    get data(){
        if (this.commutes?.data){
            return this.commutes.data.map(rc => {
                return {
                    name: rc.Name,
                    typeName: rc.CommuteType__r.Name,
                    reduce: rc.Reduce__c ?? 0,
                    emission: rc.Emission__c,
                    date: rc.CommuteDate__c
                }
            });    
        }
        return [];
    }
    
    clickedRefresh(){
        refreshApex(this.commutes);
    }
    
}
import { LightningElement, wire } from 'lwc';
import FGE_AVATER from '@salesforce/resourceUrl/FuelGasEater';
import getCommuteReduceThisFiscalYear from '@salesforce/apex/FuelGasEaterController.getCommuteReduceThisFiscalYear';
import getEventReduceThisFiscalYear from '@salesforce/apex/FuelGasEaterController.getEventReduceThisFiscalYear';
import getTaskReduceThisFiscalYear from '@salesforce/apex/FuelGasEaterController.getTaskReduceThisFiscalYear';
import getCommuteReduceThisWeek from '@salesforce/apex/FuelGasEaterController.getCommuteReduceThisWeek';
import getEventReduceThisWeek from '@salesforce/apex/FuelGasEaterController.getEventReduceThisWeek';
import getTaskReduceThisWeek from '@salesforce/apex/FuelGasEaterController.getTaskReduceThisWeek';
import { refreshApex } from '@salesforce/apex';

const limit = 100;

export default class FuelGasEater extends LightningElement {

    fgeAvaterUrl = FGE_AVATER;

    @wire(getCommuteReduceThisFiscalYear)
    commuteReduceThisFiscalYear;
    @wire(getCommuteReduceThisWeek)
    commuteReduceThisWeek;
    @wire(getEventReduceThisFiscalYear)
    eventReduceThisFiscalYear;
    @wire(getEventReduceThisWeek)
    eventReduceThisWeek;
    @wire(getTaskReduceThisFiscalYear)
    taskReduceThisFiscalYear;
    @wire(getTaskReduceThisWeek)
    taskReduceThisWeek;

    getValue(obj){
        if (obj?.data && obj.data.length == 1){
            if (obj.data[0].expr0){
                return Math.round(Number(obj.data[0].expr0));
            }
        }
        return 0;
    }

    get totalReduceThisFiscalYear(){
        if (this.commuteReduceThisFiscalYear && this.eventReduceThisFiscalYear && this.taskReduceThisFiscalYear){
            return this.getValue(this.commuteReduceThisFiscalYear) + this.getValue(this.eventReduceThisFiscalYear) + this.getValue(this.taskReduceThisFiscalYear);
        }
        return 0;
    }
    get totalReduceThisWeek(){
        if (this.commuteReduceThisWeek && this.eventReduceThisWeek && this.taskReduceThisWeek){
            return this.getValue(this.commuteReduceThisWeek) + this.getValue(this.eventReduceThisWeek) + this.getValue(this.taskReduceThisWeek);
        }
        return 0;
    }

    get level(){
        return `Stage ${Math.floor(this.totalReduceThisFiscalYear / limit)}`;
    }

    get experiences(){
        return (this.totalReduceThisFiscalYear % limit)
    }
    get toNext(){
        return limit - this.experiences;
    }

    get progressVal(){
        return 100 * this.experiences / limit;
    }

    clickedRefresh(){
        refreshApex(this.commuteReduceThisFiscalYear);
        refreshApex(this.commuteReduceThisWeek);
        refreshApex(this.eventReduceThisFiscalYear);
        refreshApex(this.eventReduceThisWeek);
        refreshApex(this.taskReduceThisFiscalYear);
        refreshApex(this.taskReduceThisWeek);
    }

}
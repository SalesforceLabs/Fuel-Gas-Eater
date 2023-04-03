import { LightningElement, wire } from 'lwc';
import getCommuteReduceLastWeek from '@salesforce/apex/FuelGasEaterController.getCommuteReduceLastWeek';
import getCommuteReduceThisWeek from '@salesforce/apex/FuelGasEaterController.getCommuteReduceThisWeek';
import getEventReduceLastWeek from '@salesforce/apex/FuelGasEaterController.getEventReduceLastWeek';
import getEventReduceThisWeek from '@salesforce/apex/FuelGasEaterController.getEventReduceThisWeek';
import getTaskReduceLastWeek from '@salesforce/apex/FuelGasEaterController.getTaskReduceLastWeek';
import getTaskReduceThisWeek from '@salesforce/apex/FuelGasEaterController.getTaskReduceThisWeek';
import { refreshApex } from '@salesforce/apex';

export default class PerformanceBoard extends LightningElement {

    @wire(getCommuteReduceLastWeek)
    commuteReduceLastWeek;

    @wire(getCommuteReduceThisWeek)
    commuteReduceThisWeek;

    @wire(getEventReduceLastWeek)
    eventReduceLastWeek;

    @wire(getEventReduceThisWeek)
    eventReduceThisWeek;

    @wire(getTaskReduceLastWeek)
    taskReduceLastWeek;

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

    get commuteReduceLastWeekValue(){
        if (this.commuteReduceLastWeek){
            return this.getValue(this.commuteReduceLastWeek);
        }
        return 0;
    }
    get commuteReduceThisWeekValue(){
        if (this.commuteReduceThisWeek){
            return this.getValue(this.commuteReduceThisWeek);
        }
        return 0;
    }

    get activityReduceLastWeekValue(){
        if (this.eventReduceLastWeek && this.taskReduceLastWeek){
            return this.getValue(this.eventReduceLastWeek) + this.getValue(this.taskReduceLastWeek);
        }
        return 0;
    }
    get activityReduceThisWeekValue(){
        if (this.eventReduceThisWeek && this.taskReduceThisWeek){
            return this.getValue(this.eventReduceThisWeek) + this.getValue(this.taskReduceThisWeek);
        }
        return 0;
    }


    get totalReduceLastWeekValue(){
        return this.activityReduceLastWeekValue + this.commuteReduceLastWeekValue;
    }
    get totalReduceThisWeekValue(){
        return this.activityReduceThisWeekValue + this.commuteReduceThisWeekValue;
    }

    clickedRefresh(){
        refreshApex(this.commuteReduceLastWeek);
        refreshApex(this.commuteReduceThisWeek);
        refreshApex(this.eventReduceLastWeek);
        refreshApex(this.eventReduceThisWeek);
        refreshApex(this.taskReduceLastWeek);
        refreshApex(this.taskReduceThisWeek);
    }

}
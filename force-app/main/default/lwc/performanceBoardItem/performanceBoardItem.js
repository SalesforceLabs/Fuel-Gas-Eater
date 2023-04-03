import { LightningElement, api } from 'lwc';

export default class PerformanceBoardItem extends LightningElement {
    @api
    label;

    @api
    currentValue;

    @api
    previousValue;

    get ratio(){
        if (this.currentValue && this.previousValue){
            return Math.round(100 * Number(this.currentValue) / Number(this.previousValue)) - 100;
        }
        return 0;
    }

    get showRatio(){
        if (this.ratio > 0){
            return `+${this.ratio}%`;
        } else if (this.ratio < 0){
            return `${this.ratio}%`;
        }
        return '';
    }

    get trend(){
        if (Number(this.currentValue) > Number(this.previousValue)){
            return 'up';
        } else if (Number(this.currentValue) < Number(this.previousValue)){
            return 'down';
        }
        return 'neutral';
    }
}
import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class YouTubePlayerRecordWrapper extends LightningElement {
    @api fieldName;
    @api objectApiName;
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
    record;

    get youTubeId() {
        //alert('Fetch youTubeId:Get record Id');
        //alert(this.record.data);
        //alert('Fetch youTubeId:Get fieldName');
        //alert(this.record.data.fields[this.fieldName].value);
        return this.record.data
            ? this.record.data.fields[this.fieldName].value
            : '';
    }

    get fields() {
        //alert('Object Api Name:' + this.objectApiName);
        //alert('Field Name:' + this.fieldName);
        return [this.objectApiName + '.' + this.fieldName];
    }
}
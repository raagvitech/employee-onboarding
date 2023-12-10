/* eslint-disable no-console */
import { LightningElement, wire, track, api } from "lwc";
import getUsers from '@salesforce/apex/employeeViewForTrainingHandler.getUsers';


export default class dynamicDataTable extends LightningElement {
 // Define columns for the table
 columns = [
    // {fieldName: 'User ID', label: 'Id'},
    {fieldName: 'Name', label: 'Name'},
    {fieldName: 'Email', label: 'Email'},
    {fieldName: 'Username', label: 'Username'}];
  @track users = [];
  @track noOfDays;
  // @track dynamicColumns = [];
  downloadEnabled = false;
  @wire(getUsers)
  wiredUsers({ error, data }) {
      if (data) {
        console.log('data --> ',data);
        // let dynamicColumnsNames = [{label: 'User ID', fieldName: 'Id'}];
        // console.log('dynamicColumnsNames --> ',JSON.stringify(dynamicColumnsNames));
        this.users = data.userList;
        this.noOfDays = data.noOfDaysWrp;
        // data.columns.forEach( ele => {
        //   console.log('ele --> ',ele);
        //   dynamicColumnsNames.push({
        //     label: ele, fieldName: ele
        //   })
        // })
        // console.log('dynamicColumnsNames --> ',JSON.stringify(dynamicColumnsNames));
        // this.dynamicColumns = dynamicColumnsNames;
        // console.log('dynamicColumns --> ',this.dynamicColumns);
      } else if (error) {
          console.error('Error loading users', error);
      }
  }

  // columns = this.dynamicColumns;

  handleCheckboxChange(event) {
    this.downloadEnabled = event.target.checked;

    if (this.downloadEnabled) {
        this.handleDownload();
    }
}
  handleDownload() {
    // Create a CSV content string
    const csvContent = this.generateCSV();
    console.log('csvContent:::: ',csvContent);
    this.downloadCSVFile(csvContent, 'RecentlyOnboadingEmployees.csv');
}
downloadCSVFile(filedata, fileName) {
  var hiddenElement = document.createElement('a');
  hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(filedata);
  hiddenElement.target = '_self'; // 
  hiddenElement.download = fileName;  // CSV file Name* you can change it.[only name not .csv] 
  document.body.appendChild(hiddenElement); // Required for FireFox browser
  hiddenElement.click(); // using click() js function to download csv file
}
generateCSV() {
    // Create a header row
    let csvContent = 'User ID,Name,Email,Username\n';

    // Add data rows
    this.users.forEach(user => {
        csvContent += `${user.Id},"${user.Name}","${user.Email}","${user.Username}"\n`;
    });

    return csvContent;
}
}
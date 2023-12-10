import { LightningElement, api, track } from 'lwc';

// Apex imports
import apex_onLoad from '@salesforce/apex/EmployeeOnboardingUtility.onLoad';
import apex_createUser from '@salesforce/apex/EmployeeOnboardingUtility.createUser';

export default class EmployeeTrainingOnbordingSystem extends LightningElement 
{
    @track showPopup = false;
    @api userPermission;
    hrOnboadingView = false;
    
    connectedCallback()
    {
        //imperative-apex to find out which user has logged in
        apex_onLoad()
            .then(result => {
                console.log("apex_onLoad result= ",result);
                this.hrOnboadingView = result;
            })
            .catch(error => {
                console.log("apex_onLoad ERROR: ",error);
            });
        //Once we get the value. store it in api variable "userPermission" so that this can be accessed from parent.

        //
    }
    handleshowForm(){
        this.showPopup = true;
    }
    handleiconclosePopup(){
        this.showPopup = false;
    }
    handleSaveUser(){
        console.log('Save user starts');
        let userObj = {};
        var fields = this.template.querySelectorAll('.validatefld');
        var valid = this.validateFields(fields);
        if (!valid) {
            return;
        }
        fields.forEach(tag => {
            console.log('field= ',tag.name);
            console.log('value= ',tag.value);
            userObj[tag.name] = tag.value;
        });

        apex_createUser({obj : JSON.stringify(userObj)})
            .then(result => {
                console.log('apex_createUser res= ',result);
                this.showPopup = false;
            })
            .catch(error => {
                console.log("apex_createUser ERR: ",error);
            });
    }

    // HELPER METHODS
    validateFields(arrayOfFields){
        let isValid = true;
        arrayOfFields.forEach(fld => {
            console.log("f= ",fld.value);
            if (!fld.value && fld.required == true) {
                fld.reportValidity();
                isValid = false;
            }
        });
        console.log('validateFields ?:', isValid);
        return isValid;
    }
}
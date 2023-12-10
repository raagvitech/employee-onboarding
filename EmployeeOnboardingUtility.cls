public with sharing class EmployeeOnboardingUtility {

    //Variables
    public static Map<String, Object> users_Map = new Map<String, Object>();
    public static Map<String, Schema.SObjectField> userFieldsMap = Schema.SObjectType.User.fields.getMap();
    public static ID standardprofileId = [SELECT Id, Name FROM Profile WHERE Name = 'Chatter Free User'].Id;

    @AuraEnabled
    public static Boolean onLoad()
    {
        List<String> requiredFields = new List<String>();
        ID currentuserId = UserInfo.getUserId();
        User logedInUser = [Select Id, CreateandViewOnboadingEmp__c FROM USER WHERE id=:currentuserId];
        Boolean returnData = false;
        // User usr = [SELECT FIELDS(STANDARD) FROM User Where Id =: currentuserId];

        /* for (String fieldName : userFieldsMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = userFieldsMap.get(fieldName).getDescribe();

            if (fieldDescribe.isNillable()) {
                requiredFields.add(fieldDescribe.getName());
            }
        } */
        // System.debug('Required Fields for User Object: ' + requiredFields);
        // users_Map.put('currentuser',usr);
        // users_Map.put('requiredFields',requiredFields);
        if(logedInUser.CreateandViewOnboadingEmp__c){
            returnData = employeeViewForTrainingHandler.checkUserPermissionSet(logedInUser.Id,'User_Information_and_Onboarding_Access');
        }
        System.debug('returnData::::'+returnData);
        return returnData;
    }

    @AuraEnabled
    public static string createUser(String obj){
        try
        {
            Map<String, Object> userToCreate = (Map<String, Object>) JSON.deserializeUntyped(obj);
            System.debug('---'+userToCreate.get('Name'));
            Map<String, Object> name = (Map<String, Object>)userToCreate.get('Name');
            String fname = (String) name.get('FirstName');
            String lname = (String) name.get('LastName');
            String email = (String)userToCreate.get('Email');
            System.debug('userToCreate= '+userToCreate);
            User u = new User(Alias = (lname).substring(0,4) , Email = email, 
                                EmailEncodingKey='UTF-8',FirstName = fname, LastName = lname, LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = standardprofileId, 
                                TimeZoneSidKey = String.valueOf(UserInfo.getTimeZone()), UserName=email);

            System.debug('Yet to create= '+u);

            try {
                INSERT u;
                sendVerificationEmail(u);
            } catch (Exception e) {
                System.debug('createUser insert ERR: '+e.getMessage());
            }

            return ''+u;
        }
        catch (Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }


    public static void sendVerificationEmail(User Email) {
        try {
            System.debug('email id ====>'+Email.Id);
            System.resetPassword(Email.Id, true);
            System.debug('email sent to user sucessfully'+email);
        } catch (Exception e) {
            System.debug('email has not sent to user '+e.getMessage());
            
        }
    }
}
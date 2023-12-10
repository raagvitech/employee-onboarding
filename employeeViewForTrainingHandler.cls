public with sharing class employeeViewForTrainingHandler {
    @AuraEnabled(cacheable=true)
    public static GetUsersWrapper getUsers() {
        GetUsersWrapper getUsersWrapper = new GetUsersWrapper();
        List<String> clms = new List<String>();
        System.debug('System.Label.NoOfDays --> '+System.Label.NoOfDays);
        System.debug('System.Label.DynamicQuery --> '+System.Label.DynamicQuery);
        Integer noOfDays = Integer.valueOf(System.Label.NoOfDays);
        String dynamicQueryFields = String.valueOf(System.Label.DynamicQuery);
        List<String> dynamicQueryFieldsList = dynamicQueryFields.split(',');
        for(String str : dynamicQueryFieldsList){
            clms.add(str);
        }
        System.debug('noOfDays --> '+noOfDays);
        System.debug('noOfDays --> '+dynamicQueryFields);
        Date lastNDays = Date.today().addDays(-noOfDays);
        String query = 'SELECT Id, '+dynamicQueryFields+' FROM User WHERE CreatedDate >= :lastNDays';
        List<User> usrList = (List<User>)database.query(query);
        getUsersWrapper.userList = usrList;
        getUsersWrapper.noOfDaysWrp = noOfDays;
        getUsersWrapper.columns = clms;
        System.debug('getUsersWrapper --> '+getUsersWrapper);
        return getUsersWrapper;
    }
    @AuraEnabled
    public static void createTaskComment( TaskComment__c taskComment){
    System.debug('createTaskComment::::: '+taskComment);
       INSERT taskComment;

       Task taskObj = [SELECT ID FROM Task  WHERE TaskNumber__c=:taskComment.Name];
       taskObj.TaskComment__c = taskComment.Id;
       Update taskObj;

    }
    @AuraEnabled
    public static OnboardingWrapper getAllTask(){
        List<Task> assignedTask = new List<Task>();
        Id loggedInUserId = UserInfo.getUserId();
        assignedTask = [Select Id,OwnerId,Priority, Owner.Name,TaskNumber__c, Subject,Description, Status, WhoId, WhatId, Who.Name, What.Name from Task WHERE CreatedById=:loggedInUserId ];
        Boolean hasAccess = checkUserPermissionSet(loggedInUserId,'EmployeeOnboarding');
        OnboardingWrapper wrapData = new OnboardingWrapper();
        wrapData.hasAccess =  hasAccess;
        wrapData.assignedTask =  assignedTask;
        return wrapData;
    }

    @AuraEnabled
    public static void updateTask(Id newTaskId, String newStatus){
        System.debug('status==========='+newStatus);
        Task updateTask = new Task(Id = newTaskId, Status = newStatus);
        Database.upsert(updateTask);
        System.debug('updateTask==========='+updateTask);
    }
    @AuraEnabled
    public static void DataInsert(Task newlist) {
        System.debug('newlist:::'+newlist);
        insert newlist;

    }
    @AuraEnabled(cacheable=true)
    public static List<User> fetchUsers(){
        Set<Id> userIdFetch = new Set<Id>();
      for(profile pro : [select id From profile where Name ='System Administrator' OR  Name ='Analytics Cloud Integration User' ]){
        userIdFetch.add(pro.Id);
      }
        System.debug('ids'+userIdFetch);

        List<User> userProfile = [select id,Name from User where ProfileId IN : userIdFetch];
        return userProfile;
    }

    public static Boolean checkUserPermissionSet(Id userId, String permissionSetName){
        
        String query = 'SELECT ID, PermissionSet.name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId= :userId';
        List<PermissionSetAssignment> psList = new List<PermissionSetAssignment>();
        if(String.isNotBlank(permissionSetName)){
            query += ' AND PermissionSet.Name =: permissionSetName';
        }
        query = String.escapeSingleQuotes(query);
        Boolean hasAccess = false;
        psList = Database.query(query);
        System.debug('psList::::: '+psList);
        if(!psList.isEmpty()){
            hasAccess = true;
            
        }
        return hasAccess;
    }

    public class OnboardingWrapper{
        @AuraEnabled public boolean hasAccess = false;
        @AuraEnabled public List<Task> assignedTask ;
    }

    public class GetUsersWrapper{
        @AuraEnabled public List<User> userList;
        @AuraEnabled public Integer noOfDaysWrp;
        @AuraEnabled public List<String> columns;
    }
}
@isTest
private class TestEmployeeViewForTrainingHandler {

    @isTest
    static void testGetUsers() {
        // Test data setup
        Test.startTest();
        // Insert test users
        // Replace this with your test data creation logic
        List<User> testUsers = new List<User>();
        // Add test user records to testUsers list

        insert testUsers;
        Test.stopTest();

        // Call the method to test
        employeeViewForTrainingHandler.GetUsersWrapper returnedUsers = employeeViewForTrainingHandler.getUsers();

        // Perform assertions
        //System.assertEquals(testUsers.size(), returnedUsers.size(), 'Number of users should match');
    }


    @isTest
    static void testGetAllTask() {
        Test.startTest();
  
        employeeViewForTrainingHandler.OnboardingWrapper result = employeeViewForTrainingHandler.getAllTask();


        System.assertEquals(true, result.hasAccess, 'Access should be false initially');
        Test.stopTest();
    }

    @isTest
    static void testCreateTaskComment() {
        Test.startTest();

        Test.stopTest();
    }
}
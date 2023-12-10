@isTest
private class EmployeeOnboardingUtilityTest {

    @isTest
    static void testOnLoad() {
        // Create a test user with required permissions
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Chatter External User' LIMIT 1];
        User testUser = new User(
            FirstName = 'TestFirstName',
            LastName = 'TestLastName',
            Alias = 'test',
            Email = 'TestHackthon001@example.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = testProfile.Id,
            TimeZoneSidKey = 'GMT',
            UserName = 'TestHackthon001@example.com',
            CreateandViewOnboadingEmp__c = true // Set necessary permission
        );
        insert testUser;

        Test.startTest();
        System.runAs(testUser) {
            Boolean result = EmployeeOnboardingUtility.onLoad();
            // Assert the expected result
            System.assertEquals(false, result);
        }
        Test.stopTest();    }
    

    @isTest
    static void testCreateUser() {
        // Test data for creating a user
        Map<String, Object> testUserMap = new Map<String, Object>{
            'Name' => new Map<String, Object>{
                'FirstName' => 'TestFirstName',
                'LastName' => 'TestLastName'
            },
            'Email' => 'test@example.com'
     };
        String jsonString = JSON.serialize(testUserMap);

        Test.startTest();
        String result = EmployeeOnboardingUtility.createUser(jsonString);
        System.assertNotEquals('', result);
        Test.stopTest();
    }
}
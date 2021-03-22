@isTest
private class MyCallOutClassTest {
     @isTest static void testCallout() {
        // Tell the system how to handle the mock test.   
        // use HttpCalloutMock class and my specific mock response: MyMockHttpResponseGen1
        // You can test multiple responses by creating additional responses and then setting in Test.setMock()
        //
        Test.setMock(HttpCalloutMock.class, new MyMockHttpResponseGen1());
        
        // This causes the Http service to send a request
        HttpResponse myResponse = MyCallOutClass.getMyExternalService(); 
        
        // Verify response received contains fake values
        String contentType = myResponse.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String ret = myResponse.getBody();
        String expected = '{"myResponse":"Testing"}';
        System.assertEquals(expected, ret);
        System.assertEquals(10, myResponse.getStatusCode());
    }
}
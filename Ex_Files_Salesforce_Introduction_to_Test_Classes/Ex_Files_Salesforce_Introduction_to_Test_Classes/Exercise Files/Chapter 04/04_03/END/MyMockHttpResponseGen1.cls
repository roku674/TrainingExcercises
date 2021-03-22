@isTest
global class MyMockHttpResponseGen1 implements HttpCalloutMock {
    //
    // class implements HttpCalloutMock with a respond method
    //
    global HTTPResponse respond(HTTPRequest req) {
        // Respond to the request with a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"myResponse":"Testing"}');
        res.setStatusCode(10);
        return res;
    }
}
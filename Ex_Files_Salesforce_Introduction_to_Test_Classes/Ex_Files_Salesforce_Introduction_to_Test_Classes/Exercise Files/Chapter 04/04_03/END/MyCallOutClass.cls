public class MyCallOutClass {
    public static HttpResponse getMyExternalService() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://devClass2.com/myTest/test');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
}
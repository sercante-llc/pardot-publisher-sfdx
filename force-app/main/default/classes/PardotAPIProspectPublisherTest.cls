@isTest
private class PardotAPIProspectPublisherTest {
    
    @isTest
    static void shouldMakeHttpCallout() {
        //arrange
        List<PardotAPIProspectPublisher.NewProspect> prospects = new List<PardotAPIProspectPublisher.NewProspect>();

        //Build out requests to fill a single batch
        for(Integer i = 0; i<PardotAPIProspectPublisher.HTTP_REQUESTS_PER_BATCH; i++) {
            prospects.add(buildProspect('bob'+i+'@email.com'));
        }

        PardotAPIProspectHttpCalloutMock httpMock = new PardotAPIProspectHttpCalloutMock();

        //act
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, httpMock);
            PardotAPIProspectPublisher.sendProspectToPardot(prospects);
        Test.stopTest();

        //assert
        for(Integer i=0; i<PardotAPIProspectPublisher.HTTP_REQUESTS_PER_BATCH; i++) { //we are testing that all callouts for a single batch are made
            HttpRequest result = httpMock.capturedRequests.get(i);
            String bodyJson = result.getBody();
            Map<String, Object> prospect =  (Map<String, Object>) System.JSON.deserializeUntyped(bodyJson);
            System.assertEquals('bob'+i+'@email.com', prospect.get('matchEmail'));
            }
    }

    private static PardotAPIProspectPublisher.NewProspect buildProspect(String email) {
        PardotAPIProspectPublisher.NewProspect a = new PardotAPIProspectPublisher.NewProspect();
        a.email = email;
        a.businessUnitId = '0UvB00000004CC7KAM';
        return a;
    }
}

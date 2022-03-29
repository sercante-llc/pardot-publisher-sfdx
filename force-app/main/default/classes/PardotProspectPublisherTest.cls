@isTest
private class PardotProspectPublisherTest {
    
    @isTest
    static void shouldMakeHttpCallout() {
        //arrange
        List<PardotProspectPublisher.NewProspect> prospects = new List<PardotProspectPublisher.NewProspect>();

        //Build out requests to fill a single batch
        for(Integer i = 0; i<PardotProspectPublisher.HTTP_REQUESTS_PER_BATCH; i++) {
            prospects.add(buildProspect('bob'+i+'@email.com'));
        }

        PardotProspectHttpCalloutMock httpMock = new PardotProspectHttpCalloutMock();

        //act
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, httpMock);
            PardotProspectPublisher.sendProspectToPardot(prospects);
        Test.stopTest();

        //assert
        for(Integer i=0; i<PardotProspectPublisher.HTTP_REQUESTS_PER_BATCH; i++) { //we are testing that all callouts for a single batch are made
            HttpRequest result = httpMock.capturedRequests.get(i);
            String bodyJson = result.getBody();
            Map<String, Object> prospect =  (Map<String, Object>) System.JSON.deserializeUntyped(bodyJson);
            System.assertEquals('bob'+i+'@email.com', prospect.get('matchEmail'));
            }
    }

    private static PardotProspectPublisher.NewProspect buildProspect(String email) {
        PardotProspectPublisher.NewProspect a = new PardotProspectPublisher.NewProspect();
        a.email = email;
        a.businessUnitId = '0UvB00000004CC7KAM';
        if (email == 'bob1@email.com') { // Lets test adding a campaign id at least once
            a.campaignId = '12345';
        }
        return a;
    }
}

public with sharing class AIVideoFetchService {
    public static void retrieveGeneratedVideo(){
        UserToDoVideos__c userVideo = [SELECT id,VideoExternalId__c,VideoSubtitleLink__c,VideoURl__c FROM UserToDoVideos__c WHERE User__c =: UserInfo.getUserId() order by createddate desc LIMIT 1];
         makeGetCallout(userVideo);
    }

    public static void makeGetCallout(UserToDoVideos__c userVideo){
        String relativePath = '/videos/'+userVideo.VideoExternalId__c;
        String NAMED_CREDENTIAL = 'callout:synthesia';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NAMED_CREDENTIAL + relativePath); // Appends to the base URL
        req.setMethod('GET');
        req.setHeader('accept', 'application/json'); 

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('res '+res.getBody());
        System.debug('res '+res.getStatusCode());
        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Map<String, Object> captions = (Map<String, Object>) result.get('captions');
            String tempSubtitleName = 'Subtitle '+System.today();
            VttFileService.UploadResult upResult = VttFileService.downloadAndStoreVttFile((String) captions.get('vtt'),tempSubtitleName);
            userVideo.VideoURl__c = (String) result.get('download');
            userVideo.VideoSubtitleLink__c = upResult.fileUrl;
            update userVideo;
        } else {
            throw new AuraHandledException('Failed to get video URL. Status: ' + res.getStatus());
        }
    }
}
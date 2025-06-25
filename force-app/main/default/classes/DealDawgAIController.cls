/* Purpose - Class acts as controller for DealDawgAIVideoPlayer lwc component.
 *           handles database interactions for DealDawgAIVideoPlayer lwc component.
 * Author  - Amarjit Singh
 */
public with sharing class DealDawgAIController {  
    
    @AuraEnabled
    public static VideoDetailsResponse fetchTodaysToDoVideo() {     
        UserToDoVideos__c userVideo = [SELECT id,VideoExternalId__c,VideoSubtitleLink__c,VideoURl__c FROM UserToDoVideos__c WHERE User__c =: UserInfo.getUserId() order by createddate desc LIMIT 1];      
        VideoDetailsResponse response = new VideoDetailsResponse();
        response.videoUrl = userVideo.VideoURl__c;
        response.subtitleVtt = userVideo.VideoSubtitleLink__c;
        return response;
    }

    public class VideoDetailsResponse {
        @AuraEnabled public String videoUrl;
        @AuraEnabled public String subtitleVtt;
    }

    public class Captions {
        public String vtt;
        public String srt;
    }
}


public with sharing class AIVideoGenClass {

    /**
    * Generic method to make API POST callouts with additional URL appendages.
    */
    @future(callout=true)
    public static void makePostCallout(String relativePath, String jsonBody, String reqType) {
        String NAMED_CREDENTIAL = 'callout:synthesia';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NAMED_CREDENTIAL + relativePath); // Appends to the base URL
        req.setMethod(reqType);
        req.setHeader('Content-Type', 'application/json'); 
        req.setBody(jsonBody);

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200 || res.getStatusCode() == 201 || res.getStatusCode() == 202 || res.getStatusCode() == 203 ) {
            UserToDoVideos__c userVideo = new UserToDoVideos__c();
            userVideo.VideoExternalId__c = (String) ((Map<String, Object>) JSON.deserializeUntyped(res.getBody())).get('id');
            userVideo.User__c = UserInfo.getUserId();
            insert userVideo;
        }
        System.debug('res '+res.getBody());
        System.debug('res '+res.getStatusCode());
    }

    public static void createVideoCallout(String videoScript){
        User loggedUser = [Select id,gender__c from User where id=:userinfo.getUserId() limit 1];
        VideoRequest vr = new VideoRequest();
        vr.title = 'ToDo Video for '+ UserInfo.getName() +' for '+ System.Today();

        InputData inputData = new InputData();
        /*inputData.scriptText = 'Good morning, Jessica! Ready to win today?'
                                +'There are 3 tasks on your list — like “Follow-up with GlobalCorp”. You’ve got 2 important meetings today, first up: “Strategy Session” at 2 PM sharp.'
                                +'Your most important lead is Priya Sharma from TechNova — time to turn that into gold.'
                                +' Let’s focus on closing Acme Renewal for USD12M today. Oh — your key account Beta Inc. needs extra care, they’re marked at risk.'
                                +'Forget about losing Delta Enterprises over pricing — that’s yesterday’s story. Today’s yours.'
                                +'You’ve got this, Jessica. DealDawg’s got your back. '; */
        inputData.scriptText = videoScript;
        inputData.avatar = (loggedUser.gender__c == 'Female')?'440548a8-4701-402f-afdb-6d32a851a3a6': 'f022d26e-418e-4d68-b91f-87c4dbfdaeff';

        AvatarSettings avatarSettings = new AvatarSettings();
        inputData.avatarSettings = avatarSettings;

        VideoSettings videoSettings = new VideoSettings();
        BackgroundSettings backgroundSettings = new BackgroundSettings();
        backgroundSettings.videoSettings = videoSettings;
        inputData.backgroundSettings = backgroundSettings;

        vr.input = new List<InputData>();
        vr.input.add(inputData);

        String jsonBody = JSON.serialize(vr);
        System.debug(jsonBody);
        makePostCallout('/videos',jsonBody,'POST');
    }



    public class VideoRequest {
        public Boolean test = false;
        public String title;
        public String visibility = 'private';
        public String aspectRatio = '16:9';
        public List<InputData> input = new List<InputData>();
        public String soundtrack = 'inspirational';
    }

    public class InputData {
        public String scriptText;
        public String avatar;
        public AvatarSettings avatarSettings;
        public String background = 'open_office';
        public BackgroundSettings backgroundSettings;
    }

    public class AvatarSettings {
        public String horizontalAlign = 'center';
        public Decimal scale = 1;
        public String style = 'rectangular';
        public Boolean seamless = false;
    }

    public class BackgroundSettings {
        public VideoSettings videoSettings;
    }

    public class VideoSettings { 
        public String shortBackgroundContentMatchMode = 'freeze';
        public String longBackgroundContentMatchMode = 'trim';
    }

}
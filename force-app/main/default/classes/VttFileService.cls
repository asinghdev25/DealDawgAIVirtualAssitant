public with sharing class VttFileService {
    
    public class UploadResult {
         public String fileId;
         public String fileUrl;
    }

    public static UploadResult downloadAndStoreVttFile(String vttUrl, String fileName) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(vttUrl);
        req.setMethod('GET');
        req.setHeader('Accept', 'text/vtt');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Blob fileBody = res.getBodyAsBlob();

            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = fileName;
            contentVersion.PathOnClient = fileName + '.vtt';
            contentVersion.VersionData = fileBody;
            insert contentVersion;

            ContentDistribution cd = new ContentDistribution();
            cd.Name = fileName+'_cd';
            cd.ContentVersionId = contentVersion.Id;
            cd.PreferencesAllowOriginalDownload = true;
            cd.PreferencesAllowViewInBrowser = true;
            cd.PreferencesNotifyOnVisit = false;
            insert cd;

            ContentVersion cvObj = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];
            String distPublicUrl = [SELECT ContentDownloadUrl  FROM ContentDistribution WHERE Id = :cd.Id].ContentDownloadUrl;
            //String fileDownloadUrl = '/sfc/servlet.shepherd/document/download/' + ContentDocumentId;
            String subtitleUrl = distPublicUrl.substringAfter('.com');
            UploadResult result = new UploadResult();
            result.fileId = cvObj.ContentDocumentId;
            result.fileUrl = subtitleUrl;
            return result;
        } else {
            throw new AuraHandledException('Failed to download VTT. Status Code: ' + res.getStatus());
        }
    }
}
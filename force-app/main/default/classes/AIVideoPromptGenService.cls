public with sharing class AIVideoPromptGenService {

    // Creates the object for input parameter for the prompt template
    public static String prepareVideoScriptPmtInputs() {
        VideoPromptScriptParameter__c videoScrPromptRec = new VideoPromptScriptParameter__c();
        String salesRepId = userinfo.getUserId();
        // Pending Tasks
        List<Task> tasks = [
            SELECT Subject, ActivityDate
            FROM Task
            WHERE OwnerId = :salesRepId AND Status != 'Completed'
            ORDER BY ActivityDate ASC
            LIMIT 3
        ];
        videoScrPromptRec.pendingTaskCount__c = tasks.size();
        if (!tasks.isEmpty()) videoScrPromptRec.taskExample__c = tasks[0].Subject;

        //Upcoming Meetings
        List<Event> meetings = [
            SELECT Subject, StartDateTime
            FROM Event
            WHERE OwnerId = :salesRepId AND StartDateTime = TODAY
            ORDER BY StartDateTime ASC
            LIMIT 2
        ];
        videoScrPromptRec.meetingCount__c = meetings.size();
        if (!meetings.isEmpty()) videoScrPromptRec.firstMeetingSubject__c = meetings[0].Subject;
        if (!meetings.isEmpty()) videoScrPromptRec.firstMeetingTime__c = String.valueOf(meetings[0].StartDateTime);

        // Important Leads
        List<Lead> leads = [
            SELECT Name, Company
            FROM Lead
            WHERE OwnerId = :salesRepId AND Rating = 'Hot'
            ORDER BY LastActivityDate DESC
            LIMIT 1
        ];
        if (!leads.isEmpty()) {
            videoScrPromptRec.hotLeadName__c = leads[0].Name;
            videoScrPromptRec.hotLeadCompany__c = leads[0].Company;
        }

        // Opportunities Closing Soon
        List<Opportunity> opps = [
            SELECT Name, Amount
            FROM Opportunity
            WHERE OwnerId = :salesRepId AND StageName != 'Closed Won' AND StageName != 'Closed Lost' AND CloseDate = THIS_WEEK
            ORDER BY CloseDate ASC
            LIMIT 1
        ];
        if (!opps.isEmpty()) {
            videoScrPromptRec.closingOpportunity__c = opps[0].Name;
            videoScrPromptRec.closingOpportunityAmount__c = opps[0].Amount;
        }

        //Key Accounts
        List<Account> accounts = [
            SELECT Name, Health_Score__c
            FROM Account
            WHERE OwnerId = :salesRepId AND Health_Score__c != null
            ORDER BY LastModifiedDate DESC
            LIMIT 1
        ];
        if (!accounts.isEmpty()) {
            videoScrPromptRec.keyAccountName__c = accounts[0].Name;
            videoScrPromptRec.keyAccountHealth__c = accounts[0].Health_Score__c;
        }

        //Recently Lost Deals
        List<Opportunity> lostDeals = [
            SELECT Name, Lost_Reason__c
            FROM Opportunity
            WHERE OwnerId = :salesRepId AND StageName = 'Closed Lost'
            ORDER BY LastModifiedDate DESC
            LIMIT 1
        ];
        if (!lostDeals.isEmpty()) {
            videoScrPromptRec.lostDealName__c = lostDeals[0].Name;
            videoScrPromptRec.lostReason__c = lostDeals[0].Lost_Reason__c;
        }
        try{
            insert videoScrPromptRec;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw e;
        }
        return videoScrPromptRec.Id;
    }

        // Actually inovkes the prompt template and returns the script for video 
    public static String invokePromptTemplate(String promptParamObjId){
        // Create inputs
        ConnectApi.WrappedValue inputWrappedValue = new ConnectApi.WrappedValue();
        inputWrappedValue.value = new Map<String, String>{'id' => promptParamObjId};
        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
        inputParams.put('Input:VideoPromptParameter', inputWrappedValue);

        // Configure invocation parameters
        ConnectApi.EinsteinPromptTemplateGenerationsInput promptTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        promptTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        promptTemplateInput.additionalConfig.applicationName = 'PromptTemplateGenerationsInvocable';
        promptTemplateInput.isPreview = false;
        promptTemplateInput.inputParams = inputParams;

        try {
            // Call the service
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
                'DealDawgAIPromptTemplate',
                promptTemplateInput
            );
            ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0];
            return response.text;
        } catch (Exception e) {
            System.debug(e.getMessage());
            throw e;
        }
    }
}
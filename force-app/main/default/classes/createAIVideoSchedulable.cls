global class createAIVideoSchedulable  Implements Schedulable {
   global void execute(SchedulableContext SC) {
       generateTodaysToDoVideo();
   }

    public static void generateTodaysToDoVideo() {
        String promptParamObjId = AIVideoPromptGenService.prepareVideoScriptPmtInputs();
        String videoScript = AIVideoPromptGenService.invokePromptTemplate(promptParamObjId);
        System.debug('script tiyar hai bro '+videoScript);
        AIVideoGenClass.createVideoCallout(videoScript);
    } 
}
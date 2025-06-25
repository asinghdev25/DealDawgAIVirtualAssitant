global class fetchAIVideoSchedulable  Implements Schedulable {
   global void execute(SchedulableContext SC) {
        AIVideoFetchService.retrieveGeneratedVideo();
   }
}
import { LightningElement, api, wire, track } from 'lwc';
import getGeneratedVideoUrl from '@salesforce/apex/DealDawgAIController.fetchTodaysToDoVideo';

export default class DealDawgAIVideoPlayer extends LightningElement {
    isLoading  = false;
    videoUrl;
    subtitleUrl;
    showButtons = true;

     connectedCallback() {
        this.showButtons = false;
        this.isLoading = true;
        console.log("reached 10");
        getGeneratedVideoUrl()
            .then(result => {
                this.videoUrl = result.videoUrl;
                this.subtitleUrl = result.subtitleVtt;
                this.isLoading = false;
                console.log(JSON.stringify(result, null, 2));
            })
            .catch(error => {
                console.error(error);
                this.isLoading = false;
                console.log("reached 20");
            });
    }
}
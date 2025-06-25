# 🐾 DealDawgAI – Your AI-Powered Sales Sidekick

**DealDawgAI** is a smart, AI-driven virtual assistant built for Salesforce Sales Reps. It delivers **daily personalized video briefings** featuring a digital avatar — helping reps **stay focused**, **close more deals**, and **never miss a beat**.
---
## 🎯 What It Does
Every morning, DealDawgAI generates and delivers a short, dynamic video tailored to the logged-in sales rep. On the basis of data present in Salesforce. The video includes:

1. ✅ **Pending Tasks Summary** – A quick recap of to-dos
2. 📅 **Upcoming Meetings Overview** – Including time & topic
3. 🔥 **Hot Leads Follow-up Reminder** – So no leads go cold
4. 💰 **Opportunities Closing Soon** – Prioritized for action
5. 🧠 **Key Account Alerts** – Risky accounts flagged
6. ❌ **Lost Deal Follow-up** – Learnings and retry triggers

Each video is **scripted and narrated uniquely per user**, with the tone and voice **customized by gender and role**.
---
## 🧠 Powered By

### ✨ AI Stack:
- **Salesforce Einstein GPT**: Generates contextual, personalized daily scripts using Salesforce **Prompt Templates**.
- **Synthesia API**: Converts the script into **video with avatars**, including visual narration and audio.
  
### 📊 Salesforce Platform:
- Built entirely within Salesforce using:
  - **LWC (Lightning Web Components)** to display the videos
  - **Apex Controllers** for external API callouts
  - **Named Credentials + External Services** for secure integration
  - **ContentVersion & ContentDistribution** for subtitle storage
---
## 💡 Key Features

| Feature                         | Description                                                                 |
|----------------------------------|-----------------------------------------------------------------------------|
| 🎬 Dynamic Daily Videos         | Each day generates a fresh, AI-narrated video with insights for the rep     |
| 🧾 Script Customization          | Gender-based tone & personality in script using Einstein Prompt Templates   |
| 🤖 Avatar-Driven Delivery       | Realistic avatars deliver the script in human voice and motion              |
| 📈 Real-Time Data Pull          | Live Salesforce data from Task, Event, Opportunity, Lead, and Account       |
| 🔐 Secure API Callouts          | Uses Named Credentials to integrate with Synthesia’s API                    |
| 🗣️ Subtitles & Accessibility    | Supports subtitle loading via VTT files stored securely in Salesforce       |

---
**Important component details - **
1. **DealDawgAIVideoPlayer** - LWC component- contains video player
2. **synthesia** - Named credentail - for callouts
3. **synthesiaExt** - External credentials - for callouts
4. **DealDawgAIPromptTemplate** - genai Prompt template - for video script generation
5. **DealDawgAIController** - Controller to lwc
6. **createAIVideoSchedulable** - to schedule video generation
7. **AIVideoPromptGenService** - Apex to invoke Salesforce prompt template
8. **AIVideoGenClass** - service class makes callout to Synthesia api generates video
9. **createAIVideoSchedulable** - schedulable to generate video every morning.
10. **AIVideoFetchService** - service class to fetch generated video by callout to Synthesia
11. **VttFileService** - stores the video subtitles in Salesforce
12. **fetchAIVideoSchedulable** -  to schedule video fetch
13. **UserTodovideos__C** - custom object stores the details of videos for each user.
14. **VideoPromptScriptParameter__C** - custom object stores the input parameter for prompt template
    
## 🚀 Prerequite Instructions
1. Need Synthesia account with atleast content creator pack.for APi support.
2. Add the authorisation key of your account to synthesiaExt external cred, Authorization header value.
3. Make sure you clone complete project and do not miss any component even like trusted sites.
4. Include the DealDawgAIVideoPlayer lwc component to User home page.
5. Schdeule createAIVideoSchedulable class to schedule video generation.
6. Schedule fetchAIVideoSchedulable class 30 mins after that to fetch user video.

---

## 📹 Demo Screenshot / Video
Can be found on https://www.linkedin.com/in/amarjit-singh-b37b23165
---
Happy coding fellow developer. Make world a better place one software at a time.
---

# Create Pardot Prospects by API - APEX Implementation

This project enables an API created prospect from Salesforce. As such, we are only sending the email address into Pardot trusting the Pardot <-> CRM sync to follow normal processes and sync the rest of the fields in. This project doesn't do anything on it's own, needing a FLOW or other mechanism to call this APEX class.

## Installation & Usage
It is important to note that this APEX code cannot work by itself. It requires a Named Credential properly configured to communicate with Pardot. If you aren't interested in reading the complete series of blog posts (recommended), then please at least follow the steps in our [Connecting to Pardot API from APEX](https://thespotforpardot.com/2021/02/02/pardot-api-and-getting-ready-with-salesforce-sso-users-part-3a-connecting-to-pardot-api-from-apex/) blog post which details those steps.

Once the Named credential is good to go, it is time to tweak the APEX code in this project, deploy, and then you are good to go.

### Flow
A simple example flow which sends every record to Pardot 
![image](https://user-images.githubusercontent.com/779440/154770572-b0a04691-d932-4875-a02e-a884f43dc6c4.png)
![image](https://user-images.githubusercontent.com/779440/154770612-3c1bf47a-110c-4b1d-af26-d5009bce582a.png)
Note this is not actually recomended. We can check if the record is already in Pardot by seeing if the Pardot_URL field is populated first. If empty, proceed with something like the above.


## APEX Tweaks Required

**Recommended** - you should take a look at the try/catch block to see how you will want to handle any potential API errors.

## Pardot Camapign IDs
Pardot Campaign IDs are different from the CRM campaign IDs and are numeric. There isn't an easy way to find the Pardot Campaign IDs inside Lightning Experience. Maybe edit a prospect, inspect the Campaign Dropdown to get the Pardot ID. 

The https://pi.pardot.com campaign page is more convenient as we can see the Pardot Campaign ID in the URL for a given Pardot Campaign.

# Create Pardot Prospects by API - APEX Implementation

This project enables an API created prospect from Salesforce. As such, we are only sending the email address into Marketing Cloud Account Enagemetnt / MCAE / Pardot trusting the Pardot <-> CRM sync to follow normal processes and sync the rest of the fields in. This project doesn't do anything on it's own, needing a FLOW or other mechanism to call this APEX class.

## Installation & Usage
It is important to note that this APEX code cannot work by itself. It requires a Named Credential properly configured to communicate with MCAE/Pardot. If you aren't interested in reading the complete series of blog posts (recommended), then please at least follow the steps in our [Connecting to Pardot API from APEX](https://thespotforpardot.com/2021/02/02/pardot-api-and-getting-ready-with-salesforce-sso-users-part-3a-connecting-to-pardot-api-from-apex/) blog post which details those steps *[**Note** if using in a Sandbox, use the pi.demo.pardot.com and test.salesforce.com URLs as indicated in the blog post]*.

Once the Named credential is set up, it is time to tweak the APEX code in this project, deploy, and test.

### Flow
A simple example flow which sends every record to Pardot 

![image](https://user-images.githubusercontent.com/779440/154770572-b0a04691-d932-4875-a02e-a884f43dc6c4.png)
![image](https://user-images.githubusercontent.com/779440/154770612-3c1bf47a-110c-4b1d-af26-d5009bce582a.png)

Note this is not actually recommended. We can check if the record is already in Pardot by seeing if the Pardot_URL field is populated first. If empty, proceed with something like the above.




## Campaign Related Flows
First, create a custom field on the Campaign object, lets call it "MCAE Sync" for this example.


### New Campaign Member to MCAE/Pardot  
This flow runs when a new member is added to a campaign. In order for this Flow to run:
The Campaign must have the "MCAE Sync" checkbox ticked
The Campaign Member should not have Do not Email ticked.

#### Flow Steps
* The Campaign Member record is checked to make sure it does not exist in Pardot
Defined by the pi_pardot_url field being null
* The APEX is called to create the Pardot record by API, syncing the email address
* The CRM <-> Pardot sync will then populate data beyond the email address

![image](https://user-images.githubusercontent.com/779440/168663721-47a38597-48d4-4ffc-9923-50ec4f7263e8.png)


### Campaign Switched to Sync to Pardot  
This flow runs when a campaign has the Sync all members with Pardot checkbox ticked.

#### Flow Steps
* The Campaign Member record is checked to make sure it does not exist in Pardot
Defined by the pi_pardot_url field being null
* The APEX is called to create the Pardot Prospect record by API, syncing the email address
* The CRM <-> Pardot sync will then populate data beyond the email address

![image](https://user-images.githubusercontent.com/779440/168664534-6a6ef828-da60-4e33-b0ef-dc603628cfd2.png)


## APEX Tweaks Required

**Recommended** - you should take a look at the try/catch block to see how you will want to handle any potential API errors.

This supports Multiple Business Units as we pass in the Business Unit ID, but assumes a single API user which is set up in all the MBUs. Adjustments would need to be made to support multiple logins. Likely having a named credential per business unit ID.

## Pardot Campaign IDs

Pardot Requires Campaigns for record creation (along with email address). If a campaign isn't provided, Pardot will default to the OLDEST active campaign in Pardot.

Pardot Campaign IDs are different from the CRM campaign IDs and are numeric. There currently isn't an easy way to find the Pardot Campaign IDs inside Lightning Experience. Maybe edit a prospect, inspect the Campaign Dropdown to get the Pardot ID. 

The https://pi.pardot.com campaign page is more convenient as we can see the Pardot Campaign ID in the URL for a given Pardot Campaign.

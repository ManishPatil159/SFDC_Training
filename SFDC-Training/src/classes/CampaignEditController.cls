/**
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Dec-22-2017   Manish Patil  All functionalities related to Campaigns. (Edit and Delete)
 */

public class CampaignEditController {
    Campaign campaignObj;
    ApexPages.StandardController pageControllerObj;
    public CampaignEditController(ApexPages.StandardController controller){
        campaignObj = (Campaign)controller.getRecord();
        pageControllerObj=controller;
    }
    
    /**
      * method is called when user clicks save on edit page to save the campaign and redirect to details page. 
    **/
    public PageReference saveAndRedirect(){
        pageControllerObj.save();
        // PageReference pageRef= new PageReference('/apex/CM_Campaign_Detail?id='+campaignObj.Id);
        PageReference pageRef= new PageReference(System.Label.CM_Campaign_Detail_URL + campaignObj.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
      * method is called when user clicks delete link on details page to delete the campaign and redirect to the landing page. 
    **/
    public PageReference deleteCampaign(){
    	delete campaignObj;
    	// PageReference pageRef= new PageReference('/apex/CM_Campaign_Landing');
    	PageReference pageReferenceObj= new PageReference(System.Label.CMCampaignLandingPage);
    	pageReferenceObj.setRedirect(true);
        return pageReferenceObj; 
    }
}
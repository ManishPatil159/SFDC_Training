/**
 *  ================================================================================================
 *   Version    Date          Author                        Comment
 *  ================================================================================================
 *   v1.0     Dec-22-2017   Manish Patil  	Functionalities related to displaying Campaign list.
 */
public class CampaignLandingPageController {
	
    private Campaign campaignObj;
	public CampaignLandingPageController(ApexPages.StandardController controller){
        campaignObj = (Campaign)controller.getRecord();
		this.strFilterId='LastModifiedDate';
        this.counter=0;
        this.pageSize=20;
        this.totalCount=0;
	}
    
    private String strSortString;
    private String strWhereQuery;
    private Integer counter;
    public String strFilterId {get;set;}
    public Integer totalCount { get; set; }
    public Integer pageSize { get; set; }


    /**
      * property to return list of values for filter dropdown. 
    **/
    public List<SelectOption> listOfFilterOptions{
    	get { 
                List<SelectOption> listOfFilterOptions= new List<SelectOption>();
                listOfFilterOptions.add(new SelectOption('RecentlyModified', System.Label.RecentlyModified));    
                listOfFilterOptions.add(new SelectOption('AllCampaigns', System.Label.AllCampaigns));
                listOfFilterOptions.add(new SelectOption('AllActiveCampaigns', System.Label.AllActiveCampaigns));
                listOfFilterOptions.add(new SelectOption('InactiveCampaigns', System.Label.InactiveCampaigns));
                return listOfFilterOptions;  
		}
    }

 	/**
      * method is called on page load and returns campaigns according to the search and sort criteria 
      * set in strSortString and strWhereQuery.  
    **/		    
    public List<Campaign> getCampaigns(){
    	if(this.strFilterId.equalsIgnoreCase('AllCampaigns')) {
    		this.strSortString='StartDate';
            this.strWhereQuery='';
    	}
        else if(this.strFilterId.equalsIgnoreCase('AllActiveCampaigns') ){
            this.strSortString='StartDate';
            this.strWhereQuery=' WHERE IsActive = true';
        }
        else if(this.strFilterId.equalsIgnoreCase('InactiveCampaigns') ){
            this.strSortString='StartDate';
            this.strWhereQuery=' WHERE IsActive = false';
        }
    	else { 
    		this.strSortString='LastModifiedDate';
            this.strWhereQuery='';
    	}
 	    String strQuery = System.Label.CMSelectQuery + 
          					this.strWhereQuery +
        					' ORDER BY '+this.strSortString +
        					' DESC LIMIT '+ this.pageSize + 
        					' OFFSET '+ this.counter;
        List<Campaign> listOfCampaingns=Database.query(strQuery);
        this.totalCount=Database.countQuery('SELECT count() from Campaign' + this.strWhereQuery);
		return listOfCampaingns;
    }
    
    /**
      * method to return the current page number for pagination.  
    **/	
    public Integer getPageNumber(){
        return (this.counter/this.pageSize)+1;
    }
    
    /**
      * method to return total number of pages for pagination.   
    **/	
    public Integer getTotalPages(){
        return math.mod(this.totalCount, this.pageSize)>0 ? 
        		(this.totalCount/this.pageSize) + 1 :
        		(this.totalCount/ this.pageSize);
    }
    
   
   /**
      * method to goto first page.  
    **/	 
   public PageReference Beginning() {
      this.counter = 0;
      return null;
   }

	/**
      * method to go to previous page.  
    **/	
   public PageReference Previous() {
      this.counter -= this.pageSize;
      return null;
   }

	/**
      * method to go to next page.  
    **/	
   public PageReference Next() {
      this.counter += this.pageSize;
      return null;
   }

	/**
      * method to go to last page.  
    **/	
   public PageReference End() { 
      this.counter = this.totalCount - math.mod(this.totalCount, this.pageSize);
       // this.counter= this.counter>0?this.counter-1:this.counter;
       this.counter= this.counter>0?this.counter:this.counter;
      return null;
   }

	/**
      * method to disable the previous page button when user is on first page.  
    **/	
   public Boolean getDisablePrevious() { 
       return this.counter>0? false : true;
   }

	/**
      * method to disable the next page button when user is on last page.  
    **/
   public Boolean getDisableNext() { 
      if (this.counter + this.pageSize < this.totalCount) 
      	return false; 
      else 
      	return true;
   }
}
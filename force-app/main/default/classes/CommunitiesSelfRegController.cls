/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public class CommunitiesSelfRegController {

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public Boolean status {get; set;}
    public String loginUrl {get; set;}
    
    public CommunitiesSelfRegController() {
        String expid = ApexPages.currentPage().getParameters().get('expid');            
        if (expId != null) {
            Site.setExperienceId(expId); 
        }
        status = false;
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'My Tests'];
        loginUrl = Network.getLoginUrl(myCommunity.Id);
    }
    
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    //code for options list below
    
    public String[] examTopics {get; set;}
    //If multiselect is false, examTopics must be of type String
    //String examTopics;

    private boolean isNotEmptyExamTopics() {
        return this.examTopics.size() > 0;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('English_Level_1', 'English Level 1'));
        options.add(new SelectOption('Vocabulary_Level_1', 'Vocabulary Level 1'));
        options.add(new SelectOption('Math_Level_1', 'Math Level 1'));
        return options;
    }
    
    public PageReference redirectToLogin() {
        //redirect to the login page
        Network myCommunity = [SELECT Id FROM Network WHERE Name = 'My Tests'];
        String myCommunityUrl = Network.getLoginUrl(myCommunity.Id);
        System.debug(myCommunityUrl);
        PageReference pageRef = new PageReference(myCommunityUrl);
        pageRef.setRedirect(true);
        return pageRef;            
    }
    
    public PageReference registerUser() {
        System.debug('Registering user');
        
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }
               
        String profileId = null; // To be filled in by customer -- test taker.
        String roleEnum = null; // To be filled in by customer - optional
        String accountId = null; // To be filled in by customer -- customers

        //String userName = communityNickname + '@testprep.com';
        //email address should not have been assigned to any user created earlier
        String userName = email;

        User u = new User();
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = communityNickname;
        u.ProfileId = profileId;
        //store the exam topics selected - this will decide the permission sets the user gets
        //u.examTopics__c = String.join(this.examTopics, ',');

        String userId;

        //use this for testing
        //User u = [select id, name from user where name = 'Joe Runner'];
        //userId = u.id;
        
        try {
            userId = Site.createExternalUser(u, accountId, password);
            this.status = true;
            //future method to add user to permission set
            //AddUserToPermissionSet.doAddUserFuture(userId);
            } catch(Site.ExternalUserCreateException ex) {
                List<String> errors = ex.getDisplayMessages();
                for (String error : errors)  {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }
            
                // This message is used for debugging. Do not display this in the UI to the end user.
                // It has the information around why the user creation failed.
                //System.debug(ex.getMessage());
                //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
                //ApexPages.addMessage(msg);
                return null;
                }
        
        //if user was created
        //if password exists, then perform login else redirect to confirmation page
        //otherwise, send email with new password to the user's email address
        if (userId != null) { 
            if (password != null && password.length() > 1) {
                return Site.login(userName, password, ApexPages.currentPage().getParameters().get('startURL'));
            }
            else {
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        
        
        ApexPages.Message msg5 = new ApexPages.Message(ApexPages.Severity.ERROR, 'User Id is null');
        ApexPages.addMessage(msg5);
        
        return null;
    }
}
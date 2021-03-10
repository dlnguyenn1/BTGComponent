({
    init: function (cmp, event, helper) {
      helper.getEnclosingTabId(cmp,event,helper);  
      helper.getAccountDetails(cmp,event,helper);  
    }, 
    
    closeModel: function (cmp, event, helper) {
        cmp.set("v.BTGFlag",false);
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    update : function (component, event, helper) {
        // Get the new hash from the event
        var AccUrl = window.location.pathname;
        console.log("=AccUrl=",AccUrl);
        console.log(component.get("v.recordId"));
        if(AccUrl == '/lightning/r/Account/'+component.get("v.recordId")+'/view'){
            helper.getEnclosingTabId(component,event,helper);  
      		helper.getAccountDetails(component,event,helper);  
        }
      
        
    },
    
    handleChange: function (cmp, event, helper) {
        
    },
    
    saveUserDetails: function (cmp, event, helper) {
        var BTGObj = cmp.get("v.BTGObj");
        var msg = 'Please fill in further explanation for accessing the patient\'s file';
        if(BTGObj.Reason__c == 'Unspecified'){
            if(BTGObj.Further_Explanation__c == null || BTGObj.Further_Explanation__c == ''){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Info Message',
                    message: msg,
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'info',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
            else{
                cmp.set("v.BTGFlag",false);
                helper.openTab(cmp,event,helper);
                helper.createBTGUserLog(cmp,event,helper); 
            }
        }else{
            cmp.set("v.BTGFlag",false);
            helper.openTab(cmp,event,helper);
            helper.createBTGUserLog(cmp,event,helper); 
        }
        
    },
    
})
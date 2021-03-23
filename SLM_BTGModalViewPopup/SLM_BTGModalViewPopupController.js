({
    init : function(component, event, helper) {
        helper.getEnclosingTabId(component, event, helper);
       /*  var action = component.get("c.getUIThemeDescription");
        action.setCallback(this, function(a) {
            component.set("v.UITheme", a.getReturnValue());
        });
        $A.enqueueAction(action); */
        
        
    },
    
    closeModel: function (cmp, event, helper) {
        cmp.set("v.BTGFlag",false);
        console.log('BTGFlag is ' + cmp.get("v.BTGFlag"));
        var UItheme = cmp.get("v.UITheme");
        //cmp.set("v.UserUITheme", UItheme);
        var workspaceAPI = cmp.find("workspace");
        var AccTabId = cmp.get("v.AcctTabId");
        //workspaceAPI.closeTab({tabId: AccTabId});   
        var action = cmp.get("c.getUIThemeDescription");
        action.setCallback(this, function(a) {
            var theme = a.getReturnValue();
            console.log("The value of theme is " + theme);
            cmp.set("v.UITheme", cmp.get("c.getUIThemeDescription"));
            console.log("Closing with theme " + theme);
            if (theme == 'Theme4t'){
                var navService = cmp.find("navService");
                var pageRef = {
                type: "standard__objectPage",
                attributes: {
                    actionName: "home",
                    objectApiName: "Account",
                    
                },
                state: {
                   nooverride: "1",
                }
            };
            navService.navigate(pageRef, false);
            } else {
                workspaceAPI.getTabInfo().then(function(response) {
                    var focusedTabId = response.parentTabId ;
                    workspaceAPI.closeTab({tabId: focusedTabId});
                })
                .catch(function(error) {
                    console.log(error);          
                });
            }
            
        });
        $A.enqueueAction(action);
        
        
    },
  
    
    saveUserDetails: function (cmp, event, helper) {
        var BTGObj = cmp.get("v.BTGObj");
        BTGObj.EventType__c = 'Break the Glass';
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
                var updateParamsObj = new Object();
                updateParamsObj["objectID"] = cmp.get("v.recordId");
                updateParamsObj["BTGUserLogObj"] = cmp.get("v.BTGObj");
                helper.doServerSideCall(cmp, 'createBTGUserLog', updateParamsObj,'saveUserDetails').then(function(response) {
                    helper.closeTab(cmp,event,helper);
                })
                .then(function(response){
                    helper.openTab(cmp,event,helper);
                })
                
            }
        }else{
            var updateParamsObj = new Object();
            updateParamsObj["objectID"] = cmp.get("v.recordId");
            updateParamsObj["BTGUserLogObj"] = cmp.get("v.BTGObj");
            helper.doServerSideCall(cmp, 'createBTGUserLog', updateParamsObj,'saveUserDetails').then(function(response) {
                helper.closeTab(cmp,event,helper);
            })
            .then(function(response){
                helper.openTab(cmp,event,helper);
            })
        }
        
    }
})
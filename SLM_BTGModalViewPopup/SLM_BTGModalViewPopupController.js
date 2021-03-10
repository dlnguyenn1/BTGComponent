({
    init : function(component, event, helper) {
        helper.getEnclosingTabId(component, event, helper);
        
    },
    
    closeModel: function (cmp, event, helper) {
        cmp.set("v.BTGFlag",false);
        var workspaceAPI = cmp.find("workspace");
        var AccTabId = cmp.get("v.AcctTabId");
        //workspaceAPI.closeTab({tabId: AccTabId});
        workspaceAPI.getTabInfo().then(function(response) {
            var focusedTabId = response.parentTabId ;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
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
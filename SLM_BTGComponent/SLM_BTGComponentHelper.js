({
    getAccountDetails : function(cmp,event,helper) {
        var self = this;
        var action = cmp.get('c.getAccountDetails');
        action.setParams({objectID: cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                if(records!=null){ console.log(records);
                                  cmp.set("v.BTGFlag", records.BTGFlag);
                                  cmp.set("v.UserUITheme", records.Theme);
                                  console.log('User UI Theme is ' + records.Theme);
                                  if(records.BTGFlag == true){
                                      window.setTimeout(self.openComponentTab, 200, cmp, event, helper);                             
                                  } // INSERT NEW CODE HERE
                                   else if (records.BTGFlag == false && (records.Theme != 'Theme4d' || records.Theme != 'Theme3')){
                                      window.setTimeout(self.redirectToRecord, 200, cmp, event, helper); 
                                   }
                                 }
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    getEnclosingTabId : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            console.log(tabId);
            component.set("v.AccountTabId",tabId);
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    closeTab : function(component, event, helper){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },

    redirectToRecord : function(component, event, helper) {
        var navLink = component.find("navLink");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                //objectApiName: 'PersonAccount',
                recordId : component.get("v.recordId")
                
            },
            state: {
                nooverride: "1",
            }
        };
        navLink.navigate(pageRef);
    },
    
    
    
    openComponentTab: function(component, event, helper) {
        //initialize the service components
        var workspaceAPI = component.find("workspace");
        var navService = component.find("navService");
        
        // set the pageReference object used to navigate to the component. Include any parameters in the state key.
        
        
        var pageReference = {
            type: "standard__component",
            attributes: {
                        componentName: "c__SLM_BTGModalViewPopup"  
                    },
            state: {
                 uid: "1",
                 c__BTGFlag: component.get("v.BTGFlag"),
                 c__recordId: component.get("v.recordId"),
                 c__AccountTabId: component.get("v.AccountTabId")
                    }
        };
        // handles checking for console and standard navigation and then navigating to the component appropriately
        workspaceAPI
        .isConsoleNavigation()
        .then(function(isConsole) {
            if (isConsole) {
                //  // in a console app - generate a URL and then open a subtab of the currently focused parent tab
                navService.generateUrl(pageReference).then(function(cmpURL) {
                    workspaceAPI
                    .getEnclosingTabId()
                    .then(function(tabId) {
                        return workspaceAPI.openSubtab({
                            parentTabId: tabId,
                            url: cmpURL,
                            focus: true
                        });
                    })
                    .then(function(subTabId) {
                        // the subtab has been created, use the Id to set the label
                        workspaceAPI.setTabLabel({
                            tabId: subTabId,
                            label: "Break-the-Glass"
                        });
                    });
                });
            } else {
                // this is standard navigation, use the navigate method to open the component
                navService.navigate(pageReference, false);
                console.log("This is page reference correct" + pageReference);
            }
        })
        .catch(function(error) {
            console.log(error);
        });
    }
    
})
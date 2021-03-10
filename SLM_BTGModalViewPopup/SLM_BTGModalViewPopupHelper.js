({
    openTab: function(component, event, helper) {
        //initialize the service components
        var workspaceAPI = component.find("workspace");
        var navService = component.find("navService");
        
        // set the pageReference object used to navigate to the component. Include any parameters in the state key.
        
        
        var pageReference = {
            type: "standard__recordPage",
            attributes: {
                        recordId: component.get("v.recordId"),
                    	actionName:"view" 
                    },
            state: {
                nooverride: "1",
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
                });
            } else {
                // this is standard navigation, use the navigate method to open the component
                navService.navigate(pageReference, false);
            }
        })
        .catch(function(error) {
            console.log(error);
        });
    },
      
    doServerSideCall : function(component, apexAction, params, callFromMethod) {
        var self = this;
        try {
            return new Promise(function(resolve, reject) {
                var action = component.get("c."+apexAction+"");
                if( params != null || typeof params != "undefined" ) {
                    action.setParams( params );
                }
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        resolve( response.getReturnValue() );
                    } else {
                        console.log('=error=',response.getError());
                    }
                });
                $A.enqueueAction(action);
            });
        } catch(e) {
            var errLogObj = self.formErrorLogObject("doServerSideCall - "+callFromMethod, "98", e);
            self.doErrorLogging(component, JSON.stringify(errLogObj));
        }
    },
    
    closeTab : function(component,event,helper){
        
        component.set("v.BTGFlag",false);
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getEnclosingTabId().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    
    
    getEnclosingTabId : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var self = this;
        var BTGObj = component.get("v.BTGObj");
        workspaceAPI.getEnclosingTabId().then(function(tabId) {
            console.log(tabId);
            component.set("v.CurrentTabId",tabId);
            console.log('==pagereference=',component.get("v.pageReference"));
            component.set("v.BTGFlag",component.get("v.pageReference").state.c__BTGFlag);
            component.set("v.recordId",component.get("v.pageReference").state.c__recordId);
            var AccTabId = component.get("v.pageReference").state.c__AccountTabId;
            component.set("v.AcctTabId",AccTabId);console.log('=AccTabId=',AccTabId);
            //workspaceAPI.closeTab({tabId: AccTabId});
        	BTGObj.EventType__c = 'Bump the Glass';
        	var updateParamsObj = new Object();console.log('=BTGObj=',BTGObj);
            updateParamsObj["objectID"] = component.get("v.recordId");
            updateParamsObj["BTGUserLogObj"] = BTGObj;
            self.doServerSideCall(component, 'createBTGUserLog', updateParamsObj,'getEnclosingTabId').then(function(response) {
                console.log('=response=',response);
                component.set("v.BTGObj",JSON.parse(JSON.stringify(response)));
                
            })
            
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
   
    
    
})
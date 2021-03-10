public without sharing class SLM_BTG {
    public static List<BTG_Visibility__mdt> BTGVisibility = new List<BTG_Visibility__mdt>();
    Public Static List<Schema.FieldSetMember> AccFields = new List<Schema.FieldSetMember>();
    Public Static List<Schema.DescribeFieldResult> ListObjectFields = new List<Schema.DescribeFieldResult> ();
    Public Static List<Break_the_Glass_Config__mdt> BTGConfig = new List< Break_the_Glass_Config__mdt>();
    @AuraEnabled
    public static AccountUserLogTableWrapper getAccountDetails(Id objectID){
        List<BTG_User_Log__c> ListBTG = new List<BTG_User_Log__c>();
        Account ObjAcc = new Account();
        AccountUserLogTableWrapper ObjAULTW = new AccountUserLogTableWrapper();
        
        List<String> FlagSelections = new List<String>();
        List<GroupMember> GMList = new List<GroupMember>();
        List<Group> ListGroups = new  List<Group>();
        List<UserRole> ListUserRoles = new  List<UserRole>();
        List<Profile> ListProfiles = new  List<Profile>();
        Set<Id> GroupIDs = new Set<Id>();  
        Set<Id> GroupMemberIDs = new Set<Id>();
        Map<Id,Id> MapGroupMember = new Map<Id,Id>();
        Map<Id,Set<Id>> MapGroupUserIds = new Map<Id,Set<Id>>();
        Map<String,Id> MapGroupNameswithId = new Map<String,Id>();
        Map<String,Id> MapProfileNameswithId = new Map<String,Id>();
        Map<String,Id> MapUserRoleNameswithId = new Map<String,Id>();
        Map<String,Decimal> MapUserRoleDuration = new Map<String,Decimal>();
        Map<String,Decimal> MapGroupUserDuration = new Map<String,Decimal>();
        Map<String,Decimal> MapProfileUserDuration = new Map<String,Decimal>();
        Decimal DefaultDuration;
        try{ 
            
            Id LoggedInUserId = Userinfo.getUserId();
            Id LoggedInUserRoleId = Userinfo.getUserRoleId();
            Id LoggedInUserProfileId = Userinfo.getProfileId();
            // dnguyen changes 
            String LoggedInUserTheme = Userinfo.getUiTheme();
            System.debug('User UI is' + Userinfo.getUiTheme());
            System.debug('User UI Display is' + Userinfo.getUiThemeDisplayed());
            // end
            System.debug('Logged in user profileId '+LoggedInUserProfileId);
            ObjAcc = getAccount(objectID);
            
            if(ObjAcc !=null){
                ObjAULTW.ObjAcc = ObjAcc;
                ObjAULTW.BTGFlag = false;
                ObjAULTW.isBTGUser = false;
                ObjAULTW.Theme = LoggedInUserTheme;
                String JSONstr = JSON.serialize(ObjAcc);
                Map<String, Object> objWrapper = (Map<String, Object>) JSON.deserializeUntyped(JSONstr);
                system.debug('=objWrapper='+ objWrapper);
                system.debug('=BTGConfig='+ BTGConfig);
                if(BTGVisibility.size()<1){
                    BTGVisibility = [Select Id, DeveloperName, Label, Duration__c, Type__c 
                                 FROM BTG_Visibility__mdt
                                 ORDER By Type__c];
                }
                
                
                system.debug('=BTGVisibility='+BTGVisibility);
                ListGroups = [Select Id, DeveloperName from Group where type='Regular'];
                for(Group Gr: ListGroups){
                    MapGroupNameswithId.put(Gr.DeveloperName,Gr.Id);
                }
                ListUserRoles = [Select Id, DeveloperName from userrole];
                for(UserRole UsR: ListUserRoles){
                    MapUserRoleNameswithId.put(UsR.DeveloperName,UsR.Id);
                    System.debug('MapUserRoleNameswithId '+MapUserRoleNameswithId);
                }
                ListProfiles = [Select Id, Name from Profile where UserType='Standard'];
                for(Profile Pr: ListProfiles){
                    MapProfileNameswithId.put(Pr.Name,Pr.Id);
                    
                }
                for(BTG_Visibility__mdt BTGV: BTGVisibility){
                    if(BTGV.Type__c == 'Group'){
                        if(MapGroupNameswithId.get(BTGV.DeveloperName) != null){
                            GroupIDs.add(MapGroupNameswithId.get(BTGV.DeveloperName));
                            MapGroupUserDuration.put(MapGroupNameswithId.get(BTGV.DeveloperName),BTGV.Duration__c);
                        }
                    }
                    if(BTGV.Type__c == 'UserRole'){
                        System.debug('Found UserRole Config');
                        if(MapUserRoleNameswithId.get(BTGV.DeveloperName) != null){
                            MapUserRoleDuration.put(MapUserRoleNameswithId.get(BTGV.DeveloperName),BTGV.Duration__c);
                            System.debug('UserRole MapUserRoleDuration');
                        }
                    }
                    if(BTGV.Type__c == 'Profile'){
                        System.debug('Profile Visibiliy clause'+MapProfileNameswithId.get(BTGV.Label));
                        if(MapProfileNameswithId.get(BTGV.Label) != null){
                            MapProfileUserDuration.put(MapProfileNameswithId.get(BTGV.Label),BTGV.Duration__c);
                            System.debug('Map Profile to metatdata'+MapProfileUserDuration.size());
                        }
                    }
                    if(BTGV.DeveloperName == 'Default'){
                        DefaultDuration = BTGV.Duration__c;
                    }
                }
                system.debug('=GroupIDs='+GroupIDs);
                if(GroupIDs.size()>0){
                    MapGroupUserIds = SLM_GroupMemberController.getUserIdsFromGroups(GroupIDs);
                }
                
                if(MapGroupUserDuration.size()>0){
                    System.debug('Found BTG for logged in group');
                    if(MapGroupUserIds.size()>0){
                        for(Id GrId: MapGroupUserIds.keyset()){
                            if(MapGroupUserIds.get(GrId).contains(LoggedInUserId)){
                                ObjAULTW.isBTGUser = true;
                            }
                        }
                    }
                }else if(MapUserRoleDuration.size()>0 && MapUserRoleDuration.containskey(LoggedInUserRoleId)){
                        ObjAULTW.isBTGUser = true;
                        System.debug('Enter mapUserRoleDuration');
                    
                }else if(MapProfileUserDuration.size()>0 && MapProfileUserDuration.containskey(LoggedInUserProfileId)){
                    	System.debug('Found BTG for logged in profile');
                        System.debug('Found BTG for logged in profile');
                        ObjAULTW.isBTGUser = true;
                    
                }else if(DefaultDuration != null){
                    ObjAULTW.isBTGUser = true;
                }
                
                if(ObjAULTW.isBTGUser == true){
                    System.debug('BTG User is True');
                    Map<String,List<String>> MapBTGKeyValue = new Map<String,List<String>>();
                    for(Break_the_Glass_Config__mdt BTG: BTGConfig){
                        List<String> BTGValues = new List<String>();
                        if(BTG.Value__c != null){
                            BTGValues = BTG.Value__c.split(',');
                            MapBTGKeyValue.put(BTG.FieldAPIName__c,BTGValues);
                        }
                    }
                    
                    
                    for(Schema.DescribeFieldResult f : ListObjectFields) {
                        /* if(f.getType() == Schema.DisplayType.MultiPicklist){
FlagSelections = new List<String>();
if(objWrapper.get(f.getName()) != null){
FlagSelections = String.valueof(objWrapper.get(f.getName())).split(';');
for(String BTGVal: MapBTGKeyValue.get(f.getName())){
if(FlagSelections.contains(BTGVal)){
ObjAULTW.BTGFlag = true;
break; 
}
}
}
}*/
                        if(MapBTGKeyValue.containskey(f.getName())){
                            for(String BTGVal: MapBTGKeyValue.get(f.getName())){
                                if(BTGVal == String.valueof(objWrapper.get(f.getName())).toLowerCase()){
                                    ObjAULTW.BTGFlag = true;
                                    break;  
                                }
                            }
                        }
                    }
                    
                    ListBTG = [Select Id, Active__c , CreatedDate, OwnerId , Patient__c, Reason__c, Further_Explanation__c 
                               FROM BTG_User_Log__c
                               Where Patient__c =:objectID and Active__c = true
                               and OwnerId = :LoggedInUserId
                               Order by CreatedDate Desc];
                    
                    for(BTG_User_Log__c BTG: ListBTG){
                        Date dt = BTG.CreatedDate.date();
                        if(MapGroupUserIds.size()>0){
                            for(Id GrId: MapGroupUserIds.keyset()){
                                if(MapGroupUserIds.get(GrId).contains(BTG.OwnerId)){
                                    Decimal nDuration = MapGroupUserDuration.get(GrId);
                                    if(dt.daysBetween(system.today()) <= nDuration){
                                        ObjAULTW.BTGFlag = false;
                                        break;
                                    }
                                } 
                            }
                        }
                        if(MapUserRoleDuration.containskey(LoggedInUserRoleId)){
                            Decimal nDuration = MapUserRoleDuration.get(LoggedInUserRoleId);
                            if(dt.daysBetween(system.today()) < nDuration){
                                ObjAULTW.BTGFlag = false;
                                break;
                            }
                        }else if(MapProfileUserDuration.containskey(LoggedInUserProfileId)){
                            Decimal nDuration = MapProfileUserDuration.get(LoggedInUserProfileId);
                            if(dt.daysBetween(system.today()) < nDuration){
                                ObjAULTW.BTGFlag = false;
                                break;
                            }
                        }else if(DefaultDuration!= null){
                            if(dt.daysBetween(system.today()) < DefaultDuration){
                                ObjAULTW.BTGFlag = false;
                                break;
                            }
                        }
                        
                    }
                }else{
                    ObjAULTW.BTGFlag = false;
                }
                
                return ObjAULTW;
            }
            
        }catch(Exception ex){
            system.debug('==Exception=='+ex.getCause());
            system.debug('==Exception=='+ex.getLineNumber());
            system.debug('==Exception=='+ex.getMessage());
            system.debug('==Exception=='+ex.getStackTraceString());
            system.debug('==Exception=='+ex.getTypeName());
        }
        return null;
    }
    
    
    
    private Static Account getAccount(Id objectID) {
        try{ 
            
            Set<String> SetFieldAPINames = new Set<String>();
            Set<String> CustomFieldNames = new Set<String>();
            BTGConfig = [Select Id, DeveloperName, Type__c, FieldAPIName__c, Value__c 
                         FROM Break_the_Glass_Config__mdt 
                         ORDER by Type__c];
            for(Break_the_Glass_Config__mdt BTG: BTGConfig){
                if(BTG.Type__c == 'Filter Criteria'){
                    SetFieldAPINames.add(BTG.FieldAPIName__c);
                }else if(BTG.Type__c == 'Query Param'){
                    CustomFieldNames.add(BTG.FieldAPIName__c);
                }
            }
            System.debug('SetFieldAPINames' +SetFieldAPINames);
            SObjectType accountType = Schema.getGlobalDescribe().get('Account');
            Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
            
            for(Schema.SObjectField field : mfields.values())
            {
                Schema.DescribeFieldResult fieldResult = field.getDescribe();
                if(SetFieldAPINames.contains(fieldResult.getName()))
                {
                    System.debug('fieldResults '+fieldResult.getName());
                    ListObjectFields.add(fieldResult);
                }
                
            }
            String query = 'SELECT ';
            for(Schema.DescribeFieldResult f : ListObjectFields) {
                query += f.getName() + ', ';
            }
            if(CustomFieldNames !=null){
                for(String CFN: CustomFieldNames){
                    query += CFN + ', ';
                }
            }
            
            query += 'Id FROM Account where Id =:objectID';
            System.debug('Query '+query);
            return Database.query(query);
        }catch(Exception ex){
            system.debug('==Exception=='+ex.getCause());
            system.debug('==Exception=='+ex.getLineNumber());
            system.debug('==Exception=='+ex.getMessage());
            system.debug('==Exception=='+ex.getStackTraceString());
            system.debug('==Exception=='+ex.getTypeName());
        }
        return null;
    }
    
    @AuraEnabled
    public static BTG_User_Log__c createBTGUserLog(Id objectID, BTG_User_Log__c BTGUserLogObj){
        Account ObjAcc = new Account();
        try{ 
            if(objectID != null && BTGUserLogObj !=null){
                ObjAcc = getAccount(objectID);
                BTGUserLogObj.Patient__c = objectID;
                //BTGUserLogObj.MRN__c = ObjAcc.MedicalRecordNumber__c != null ? ObjAcc.MedicalRecordNumber__c: '';
                //BTGUserLogObj.SourceSystemID__c  = ObjAcc.SourceSystemId__c  !=null? ObjAcc.SourceSystemId__c : '';
                BTGUserLogObj.Active__c = BTGUserLogObj.EventType__c == 'Break the Glass'? True: False;
                BTGUserLogObj.OwnerId = UserInfo.getUserId();
                upsert BTGUserLogObj;
                return BTGUserLogObj;
            }
        }catch(Exception ex){
            system.debug('==Exception=='+ex.getCause());
            system.debug('==Exception=='+ex.getLineNumber());
            system.debug('==Exception=='+ex.getMessage());
            system.debug('==Exception=='+ex.getStackTraceString());
            system.debug('==Exception=='+ex.getTypeName());
        }
        return null;
    }    
    
    
    public class AccountUserLogTableWrapper{
        @AuraEnabled Public Account ObjAcc;
        @AuraEnabled Public Boolean BTGFlag;
        @AuraEnabled Public Boolean isBTGUser;
        @AuraEnabled Public String Theme;
    }
    
    
}
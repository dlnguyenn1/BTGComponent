/*@@
#TEST CLASS NAME       :    SLM_BTGTest
#DESCRIPTION           :    This test class is for SLM_BTG.
@@**/
@isTest(SeeAllData=true)
public class SLM_BTGTest {
    @isTest static void testMethod1() {
        List<BTG_Visibility__mdt> testBTGVList = (List<BTG_Visibility__mdt>)Json.deserialize('[{"Label": "Default","developername": "Default","Duration__c" : "1"},{"Label": "All User","developername": "All_User","Duration__c" : "1","Type__c" : "Group"},{"Label": "Data Coordinator","developername": "Data_Coordinator","Duration__c" : "1","Type__c" : "Profile"},{"Label": "Break the Glass","developername": "Break_the_Glass","Duration__c" : "1","Type__c" : "UserRole"}]', List<BTG_Visibility__mdt>.class); 
        List<Break_the_Glass_Config__mdt> testBTGCList = (List<Break_the_Glass_Config__mdt>)Json.deserialize('[{"Label": "EPIC Flag Ambassador 5","developername": "EPIC_Flag_Ambassador_5","Type__c" : "Filter Criteria","Value__c":"Break The Glass", "FieldAPIName__c": "Break_The_Glass__c" }]', List<Break_the_Glass_Config__mdt>.class); 
        User u1 = new User();
        Id AmbRoleId = [Select Id from userrole where developername='Break_the_Glass'].Id;
        u1 = [Select id from user where userroleid=:AmbRoleId and isactive=true limit 1];
        Test.startTest();
        System.runAs(u1){
            Set<String> SetFieldVals = new Set<String>();
            List<Sobject> sObjList = new List<Sobject>();
            sObjectType sObjType; 
            List<Account> AccList = new List<Account>();
            String GrpName = [Select developername from group limit 1].developername;
            String UsrRoleName = [Select developerName from UserRole limit 1].developerName;
            Id AccRT = [Select Id from Recordtype where SobjectType = 'Account' and developername='PersonAccount'].Id;
            List<Account> AccListTemp = [Select Id from Account where recordtypeId = :AccRT limit 4];
            sObjType = Schema.getGlobalDescribe().get('Account');
            Sobject sObj1 = sObjType.newSobject();
            sObj1.put('Id',AccListTemp[0].Id);
            sObjList.add(sObj1);
            Sobject sObj2 = sObjType.newSobject();
            sObj2.put('Id',AccListTemp[1].Id);
            sObj2.put('VIP__c',True);
            sObjList.add(sObj2);
            
            List<Database.SaveResult> results = Database.update(sObjList, false);
            system.debug('=results='+results);
            BTG_User_Log__c BTGLog = new BTG_User_Log__c(Patient__c = sObjList[0].Id,EventType__c = 'Break the Glass');
            //Iteration 1
            SLM_BTG.BTGConfig = testBTGCList;
            SLM_BTG.BTGVisibility = testBTGVList;
            SLM_BTG.AccountUserLogTableWrapper WrapperObj = new SLM_BTG.AccountUserLogTableWrapper();
            WrapperObj = SLM_BTG.getAccountDetails(sObjList[0].Id);
            
        }
        Test.stopTest();
    }
    @isTest static void testMethod2() {
         List<BTG_Visibility__mdt> testBTGVList = (List<BTG_Visibility__mdt>)Json.deserialize('[{"Label": "Default","developername": "Default","Duration__c" : "1"},{"Label": "All User","developername": "All_User","Duration__c" : "1","Type__c" : "Group"},{"Label": "Data Coordinator","developername": "Data_Coordinator","Duration__c" : "1","Type__c" : "Profile"},{"Label": "Break the Glass","developername": "Break_the_Glass","Duration__c" : "1","Type__c" : "UserRole"}]', List<BTG_Visibility__mdt>.class); 
        List<Break_the_Glass_Config__mdt> testBTGCList = (List<Break_the_Glass_Config__mdt>)Json.deserialize('[{"Label": "EPIC Flag Ambassador 5","developername": "EPIC_Flag_Ambassador_5","Type__c" : "Filter Criteria","Value__c":"Break The Glass", "FieldAPIName__c": "Break_The_Glass__c" }]', List<Break_the_Glass_Config__mdt>.class); 
        User u1 = new User();
        Id CareMProfId = [Select Id from profile where name='Data Coordinator'].Id;
        u1 = [Select id from user where profileid=:CareMProfId and isactive=true limit 1];
        Test.startTest();
        System.runAs(u1){
            Set<String> SetFieldVals = new Set<String>();
            List<Sobject> sObjList = new List<Sobject>();
            sObjectType sObjType; 
            List<Account> AccList = new List<Account>();
            String GrpName = [Select developername from group limit 1].developername;
            String UsrRoleName = [Select developerName from UserRole limit 1].developerName;
            Id AccRT = [Select Id from Recordtype where SobjectType = 'Account' and developername='PersonAccount'].Id;
            List<Account> AccListTemp = [Select Id from Account where recordtypeId = :AccRT limit 4];
            sObjType = Schema.getGlobalDescribe().get('Account');
            Sobject sObj1 = sObjType.newSobject();
            sObj1.put('Id',AccListTemp[0].Id);
            sObjList.add(sObj1);
            Sobject sObj2 = sObjType.newSobject();
            sObj2.put('Id',AccListTemp[1].Id);
            sObj2.put('VIP__c',True);
            sObjList.add(sObj2);
            List<Database.SaveResult> results = Database.update(sObjList, false);
            system.debug('=results='+results);
            BTG_User_Log__c BTGLog = new BTG_User_Log__c(Patient__c = sObjList[0].Id,EventType__c = 'Break the Glass');
           // SLM_BTG.BTGConfig = testBTGCList;
            SLM_BTG.BTGVisibility = testBTGVList;
            SLM_BTG.AccountUserLogTableWrapper WrapperObj = new SLM_BTG.AccountUserLogTableWrapper();
            WrapperObj = SLM_BTG.getAccountDetails(sObjList[0].Id);
           //SLM_BTG.createBTGUserLog(sObjList[0].Id,BTGLog);
        }
        Test.stopTest();
    }
    @isTest static void testMethod3() {
        List<BTG_Visibility__mdt> testBTGVList = (List<BTG_Visibility__mdt>)Json.deserialize('[{"Label": "Default","developername": "Default","Duration__c" : "1"},{"Label": "All User","developername": "All_User","Duration__c" : "1","Type__c" : "Group"}]', List<BTG_Visibility__mdt>.class); 
        List<Break_the_Glass_Config__mdt> testBTGCList = (List<Break_the_Glass_Config__mdt>)Json.deserialize('[{"Label": "EPIC Flag Ambassador 5","developername": "EPIC_Flag_Ambassador_5","Type__c" : "Filter Criteria","Value__c":"Break The Glass", "FieldAPIName__c": "Break_The_Glass__c" }]', List<Break_the_Glass_Config__mdt>.class); 
        User u1 = new User();
        Id HSSConnectStandProfId = [Select Id from profile where name='Contact Center'].Id;
        u1 = [Select id from user where profileid=:HSSConnectStandProfId and isactive=true limit 1];
        Test.startTest();
        System.runAs(u1){
            Set<String> SetFieldVals = new Set<String>();
            List<Sobject> sObjList = new List<Sobject>();
            sObjectType sObjType; 
            List<Account> AccList = new List<Account>();
            String GrpName = [Select developername from group limit 1].developername;
            String UsrRoleName = [Select developerName from UserRole limit 1].developerName;
            Id AccRT = [Select Id from Recordtype where SobjectType = 'Account' and developername='PersonAccount'].Id;
            List<Account> AccListTemp = [Select Id from Account where recordtypeId = :AccRT limit 4];
            sObjType = Schema.getGlobalDescribe().get('Account');
            Sobject sObj1 = sObjType.newSobject();
            sObj1.put('Id',AccListTemp[0].Id);
            sObjList.add(sObj1);
            Sobject sObj2 = sObjType.newSobject();
            sObj2.put('Id',AccListTemp[1].Id);
            sObj2.put('VIP__c',True);
            sObjList.add(sObj2);
            List<Database.SaveResult> results = Database.update(sObjList, false);
            system.debug('=results='+results);
            BTG_User_Log__c BTGLog = new BTG_User_Log__c(Patient__c = sObjList[1].Id, Active__c = true, EventType__c = 'Break the Glass');
           // SLM_BTG.BTGConfig = testBTGCList;
            SLM_BTG.BTGVisibility = testBTGVList;
            SLM_BTG.AccountUserLogTableWrapper WrapperObj = new SLM_BTG.AccountUserLogTableWrapper();
            //Iteration 3
            BTG_User_Log__c BTGLog2 = new BTG_User_Log__c();
            BTGLog2.Patient__c = sObjList[1].Id;
            BTGLog2.Active__c = True;
            BTGLog2.EventType__c = 'Break the Glass';
            BTGLog2.OwnerId = UserInfo.getUserId();
            insert BTGLog2;
            WrapperObj = SLM_BTG.getAccountDetails(sObjList[1].Id);
           // SLM_BTG.createBTGUserLog(sObjList[1].Id,BTGLog);
        }
        Test.stopTest();
    }    
    @isTest static void testMethod4() {
       List<BTG_Visibility__mdt> testBTGVList = (List<BTG_Visibility__mdt>)Json.deserialize('[{"Label": "Default","developername": "Default","Duration__c" : "1"},{"Label": "All User","developername": "All_User","Duration__c" : "1","Type__c" : "Group"},{"Label": "Opportunity Management","developername": "Opportunity_Management","Duration__c" : "1","Type__c" : "Profile"},{"Label": "Break the Glass","developername": "Break_the_Glass","Duration__c" : "1","Type__c" : "UserRole"}]', List<BTG_Visibility__mdt>.class); 
        List<Break_the_Glass_Config__mdt> testBTGCList = (List<Break_the_Glass_Config__mdt>)Json.deserialize('[{"Label": "EPIC Flag Ambassador 5","developername": "EPIC_Flag_Ambassador_5","Type__c" : "Filter Criteria","Value__c":"Break The Glass", "FieldAPIName__c": "Break_The_Glass__c" }]', List<Break_the_Glass_Config__mdt>.class); 
        Test.startTest();
        Set<String> SetFieldVals = new Set<String>();
        List<Sobject> sObjList = new List<Sobject>();
        sObjectType sObjType; 
        List<Account> AccList = new List<Account>();
        String GrpName = [Select developername from group limit 1].developername;
        String UsrRoleName = [Select developerName from UserRole limit 1].developerName;
        Id AccRT = [Select Id from Recordtype where SobjectType = 'Account' and developername='PersonAccount'].Id;
        List<Account> AccListTemp = [Select Id from Account where recordtypeId = :AccRT limit 4];
        sObjType = Schema.getGlobalDescribe().get('Account');
        Sobject sObj1 = sObjType.newSobject();
        sObj1.put('Id',AccListTemp[0].Id);
        sObjList.add(sObj1);
        Sobject sObj2 = sObjType.newSobject();
        sObj2.put('Id',AccListTemp[1].Id);
        sObj2.put('VIP__c',True);
        sObjList.add(sObj2);
        List<Database.SaveResult> results = Database.update(sObjList, false);
        system.debug('=results='+results);
        BTG_User_Log__c BTGLog = new BTG_User_Log__c(Patient__c = sObjList[1].Id, Active__c = true, EventType__c = 'Break the Glass');
        SLM_BTG.BTGConfig = testBTGCList;
        SLM_BTG.BTGVisibility = testBTGVList;
        SLM_BTG.AccountUserLogTableWrapper WrapperObj = new SLM_BTG.AccountUserLogTableWrapper();
        //Iteration 4
        BTG_User_Log__c BTGLog3 = new BTG_User_Log__c();
        BTGLog3.Patient__c = sObjList[1].Id;
        BTGLog3.Active__c = True;
        BTGLog3.EventType__c = 'Break the Glass';
        BTGLog3.OwnerId = UserInfo.getUserId();
        insert BTGLog3;
        WrapperObj = SLM_BTG.getAccountDetails(sObjList[1].Id);
        Test.stopTest();
    }  
    
    @isTest
    static void testBTGLogCreation(){
        Id AccRT = [Select Id from Recordtype where SobjectType = 'Account' and developername='PersonAccount'].Id;
        List<Account> AccListTemp = [Select Id from Account where recordtypeId = :AccRT limit 4];
        List<Sobject> sObjList = new List<Sobject>();
        sObjectType sObjType = Schema.getGlobalDescribe().get('Account');
        Sobject sObj1 = sObjType.newSobject();
        sObj1.put('Id',AccListTemp[0].Id);
        sObjList.add(sObj1);
        List<Database.SaveResult> results = Database.update(sObjList, false);
        system.debug('=results='+results);
        BTG_User_Log__c BTGLog = new BTG_User_Log__c(Patient__c = sObjList[0].Id,EventType__c = 'Break the Glass');
        SLM_BTG.createBTGUserLog(sObjList[0].Id,BTGLog);
    }
}
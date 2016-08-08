@isTest
public class UtilityHelperTest {
     @isTest static void testMessage(){
         Account acct = new Account(Name='Test Account');
          
        
      //   Attachment attc = UtilityHelper.attachPdf('',acct.id,at.name,);
         EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = '00528000001uD0v', TemplateType= 'Text', Name = 'test');
         System.runAs ( new User(Id = UserInfo.getUserId()) ) {
         insert e;
          insert acct;
 			 }
         Attachment  attach =new Attachment();
         attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=acct.id;
        
         System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        insert attach;
         }
         map<string,string> otherparams = new map<string,string>();
         Attachment attc = UtilityHelper.attachPdf('/apex/acct.Id',acct.id,attach.name,acct.OwnerId,otherparams);
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
       
        UtilityHelper.addErrorMessage('This is error message');
        UtilityHelper.addInfoMessage('Information Message');
        Boolean flag= UtilityHelper.sendEmail(e.Id,attach.Id,usr.Id,'Test',new Attachment ());
        UtilityHelper.getEmailTemplateId('Test');
        Messaging.SingleEmailMessage SingEmail = UtilityHelper.createEmail(e.Id,attach.Id,usr.Id,'Test',new Attachment());
        Boolean flag1 = UtilityHelper.sendEmail(SingEmail);
      //  UtilityHelper.returnStringValue(10); 
         UtilityHelper.returnYNValue(true);
         UtilityHelper.returnBooleanValue('yes');
         UtilityHelper.returnDecimalValue('y');
         
        String result = UtilityHelper.getQueryString('Account');
        /* User user = new User(
            Username= 'u.white@company.com',
            Email = 'u.white@company.com',
            Lastname = 'u',
            Firstname = 'white',
            Alias = 'uwhite',
           TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US');
        insert user;  */
		List<RecordType> rtype = [Select name From RecordType where sObjectType='Account' limit 1];
    	UtilityHelper.getRecordTypeDetail('Account','rtype');
        UtilityHelper.formatCurrencyInternational('1000000000','$');
    	  
    	Datetime dt = UtilityHelper.convertDateWithSlashToDatetime('21/02/2016');
         date daate = UtilityHelper.convertDateWithSlashToDate('21/02/2016');
         UtilityHelper.formatDate(system.today() , 'dd/mm/yyyy');
         UtilityHelper.isListNullOrEmpty(rtype);
      
            /* negative conditions  */
         UtilityHelper.getEmailTemplateId('');
       //  UtilityHelper.returnStringValue(-12); 
         UtilityHelper.returnYNValue(false);
         UtilityHelper.returnBooleanValue('NO');
         UtilityHelper.returnDecimalValue('1234');
         UtilityHelper.returnDecimalValue('');
         UtilityHelper.formatCurrencyInternational('1000abcd','$');
      //   UtilityHelper.returnStringValue(0); 
       //    id rtypeid = UtilityHelper.getRecordTypeId('Account','rtype');
       		UtilityHelper Utilhelp = new UtilityHelper();
     	// Utilhelp.Success = true;
         //Utilhelp.attachPdf('/apex/acct.Id',acct.id,attach.name,acct.OwnerId,otherparams);
     }

}
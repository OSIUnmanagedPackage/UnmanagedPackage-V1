/*
###########################################################################
# Created by..........: Siddharth Jain
# Created Date........: 04-May-2016
# Last Modified by....: 
# Last Modified Date..: 
# Description.........: Helper class containing commonly used Utility methods.
#
# Change Log:               
#
# S.No.		Date	 	Author			Description
# 1 		04-May-16 	Siddharth Jain 	Initial Version
#
#
###########################################################################
*/

public class UtilityHelper 
{
	/*
    * @description  : 	Function to add Error Message on VF
    * @return       : 	void
    * @param        : 	message : Message to display    
    */
	public static void addErrorMessage(String message)
	{        
		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,message));
    } 

	/*
    * @description  : 	Function to add Info Message on VF
    * @return       : 	void
    * @param        : 	message : Message to display    
    */
	public static void addInfoMessage(String message)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info,message));
	}
	
    /*
    * @description  : 	Function to Attach PDF
    * @return       : 	Attachment
    * @param        : 	pageRef : Page for the required pdf
    *  					objId : Id of the object it needs to attach
    *  					attachmentName : Name of the attachment file
    *  					ownerId : Id of the owner of the attachment
    *  					otherParams : Other Query String Params
    */
    public static Attachment attachPdf(string pageRef, id objId, string attachmentName, id ownerId, map<string,string> otherParams) 
    {
        boolean success = false;
        Blob pdfBlob;
        /* Get the page definition */
        PageReference pdfPage = new PageReference('/apex/' + pageRef );
            
        /* set the quote id on the page definition */
        pdfPage.getParameters().put('id',objId);
        
        if(otherParams != null)
        {
	        for(string s : otherParams.keyset())
    	    {
        		pdfPage.getParameters().put(s,otherParams.get(s));
        	}
        }
        pdfPage.getParameters().put('isdtp','vw');   
        /* generate the pdf blob */
        try
        { 
            pdfBlob = pdfPage.getContent();
            success = true;
		}
		catch(Exception e)
		{
	        addErrorMessage(Label.PDF_Error_In_Generation + ' ' + e.getMessage());
	        success = false;
	        return null;
		}
	
   		/* create the attachment against the quote */
        if(success)
        {
        	Attachment a = new Attachment(parentId = objId, name= attachmentName, body = pdfBlob , ContentType = 'application/pdf',OwnerId = ownerId);
            /* insert the attachment */
            try
            {
                insert a;
                return a;
            }
            catch(Exception e)
            {
		        addErrorMessage(Label.PDF_Error_In_Attachment + ' ' + e.getMessage());
                success = false;
	            return null;
            }   
        }
        else
    	    return null;
    }
    
    /*
    * @description  : Function to Send Email
    * @return       : boolean
    * @param        : emailTemplateId : Template Id of email
    *  objId : Id of the object it needs to attach
    *  targetId : Id of the contact / user
    *  senderDisplayName : Display name to be used
    *  att : Attachment object 
    */
    public static boolean sendEmail(id emailTemplateId, id objId, id targetId, string senderDisplayName, Attachment att)
    {
    	// Send Email
        //EmailTemplate emlTemp = [Select Id From EmailTemplate e WHERE DeveloperName = :emailTemplateName LIMIT 1].get(0);
        //Id emailTemplateId = Id.ValueOf(emlTemp.Id);
        try
        {
	        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	        email.setTemplateId(emailTemplateId);
	        email.setWhatId(objId);
	        email.setTargetObjectId(targetId);
	        email.setSenderDisplayName(senderDisplayName);
               
            if(att != null)
            {
		        Messaging.EmailFileAttachment pdfAttc = new Messaging.EmailFileAttachment();      
		        pdfAttc.setFileName(Att.name);
		        pdfAttc.setBody(Att.body);
		        email.setFileAttachments(new Messaging.EmailFileAttachment[]{pdfAttc});
            }            
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
	        return true;
        }
        catch(Exception e)
        {
	        addErrorMessage(Label.Error_In_Sending_Email + ' ' + e.getMessage());
	        return false;
        }
    }
    
    /*
    * @description  : Function to Send Email
    * @return       : boolean
    * @param        : email : Email template 
    */
    public static boolean sendEmail(Messaging.SingleEmailMessage email)
    {
        try
        {
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
	        return true;
        }
        catch(Exception e)
        {
	        addErrorMessage(Label.Error_In_Sending_Email + ' ' + e.getMessage());
	        return false;
        }
    }
    
    
    /*
    * @description  : Function to find the correct email template
    * @return       : id
    * @param        : emailTemplateName : Name of emailTemplate
    */
    public static id getEmailTemplateId(string emailTemplateName)
    {
	    try
        {
            if(String.IsBlank(emailTemplateName))
            {
    	        addErrorMessage(Label.No_Email_Template_Found);
        	    return null;
            }
            
            EmailTemplate emlTemp = [Select Id, subject From EmailTemplate e WHERE DeveloperName = :emailTemplateName LIMIT 1].get(0);
            Id emailTemplateId = Id.ValueOf(emlTemp.Id);
			return emailTemplateId;
        }
        catch(Exception e)
        {
        	addErrorMessage(Label.No_Email_Template_Found);
        	return null;
        }
    }
    
       
    /*
    * @description  : Function to Create Email
    * @return       : boolean
    * @param        : emailTemplateId : Template Id of email
    *  objId : Id of the object it needs to attach
    *  targetId : Id of the contact / user
    *  senderDisplayName : Display name to be used
    *  att : Attachment object 
    */
    public static Messaging.SingleEmailMessage createEmail(id emailTemplateId, id objId, id targetId, string senderDisplayName, Attachment att)
    {
        try
        {
	        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
	        email.setTemplateId(emailTemplateId);
	        email.setWhatId(objId);
	        email.setTargetObjectId(targetId);
	        email.setSenderDisplayName(senderDisplayName);
               
            if(att != null)
            {
		        Messaging.EmailFileAttachment pdfAttc = new Messaging.EmailFileAttachment();      
		        pdfAttc.setFileName(Att.name);
		        pdfAttc.setBody(Att.body);
		        email.setFileAttachments(new Messaging.EmailFileAttachment[]{pdfAttc});
            }            
        	return email;
        }
        catch(Exception e)
        {
	        addErrorMessage(Label.Error_In_Sending_Email + ' ' + e.getMessage());
	        return null; 
        }
    }

	
	/*
    * @description  : Function to return Y/N value for boolean
    * @return       : string
    * @param        : inputBoolean: Input Boolean to be converted
    */
	public static string returnYNValue(boolean inputBoolean)
	{
		if(inputBoolean != null && inputBoolean)
			return('Y');
		else
			return ('N');
	}

	/*
    * @description  : Function to return boolean value for Y/N
    * @return       : boolean
    * @param        : inputString: Input String to be converted
    */
	public static boolean returnBooleanValue(string inputString)
	{
		if(String.IsNotBlank(inputString) && (inputString.equalsIgnoreCase('Y') || inputString.equalsIgnoreCase('TRUE') || inputString.equalsIgnoreCase('YES')))
			return(true);
		else
			return (false);
	}

	/*
    * @description  : Function to return Decimal value from string
    * @return       : decimal
    * @param        : inputString: Input String to be converted
    */
	public static decimal returnDecimalValue(string inputString)
	{
		if(String.IsNotBlank(inputString))
		{
			if((inputString.replace('.', '').replace(',','')).isNumeric())
				return Decimal.valueOf(inputString);
			else
				return null; 
		}
		else
			return null;
	}

	/**
    * <P> This method is used to Check the List is Null or empty</p>
    * @param1: List
    *
    * @return: returns Boolean
    */ 
    public static Boolean isListNullOrEmpty(List<Object> listData)
    {
        System.debug('#### Input List := '+listData);
        if(null!=listData && !listData.isEmpty()){
            return false;
        }else{
            return true;
        }   
    }  
    
    /**
    * <P> This method returns all fields of an Object, which can be used in a dynamic select query.
    The main purpose of this function is copying complete object in to another object (same type)</P>
    */
    public static String getQueryString(String objectName)
    {
        Schema.DescribeSObjectResult sobjResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
        map<String, Schema.SObjectField> fieldMap  = sobjResult.fields.getMap();
       
        string fieldList = '';
        for (string field : fieldMap.keySet())
        {
            fieldList += fieldMap.get(field).getDescribe().getName() + ' ,';
        }
        fieldList = fieldList.substring(0,fieldList.lastIndexOf(','));
        return fieldList;
    }
        
	/**
    * <P> This method is used to fetch the details of RecordType for a Perticular Sobject by name./</P>
    * @param: sobjectType, the Object name
    * @param: recordTypeName, the record type name
    * @retun: record types of the Sobject fro the specified name
    */
    public static RecordType getRecordTypeDetail(String sobjectType, String recordTypeName) 
    {
        System.debug('### fetching record type details for recordType name:= '+recordTypeName + ' For Sobject:= '+sobjectType);
        
        if(null!=sobjectType && null!=recordTypeName)
        {
        	List<RecordType> recordTypes=[SELECT ID,Name,Description,DeveloperName,IsActive,BusinessProcessId 
        									FROM RecordType WHERE SobjectType=:sobjectType and Name=:recordTypeName ];
        
	        if(null!=recordTypes && recordTypes.size()>0)
    	        return recordTypes.get(0);
	        else{
	            System.debug('No Details found for the Given record type name:= '+ recordTypeName + ' for Sobject:= '+sobjectType);
	            return null;
	        }
        }
        return null;
    }

    /*
    * @description : Function to Select Record Type(using Describe call)
    * @return : Id
    * @param : sObj : sObject type
    * recordTypeName : Name of the Record Type
    */  
    public static Id getRecordTypeId(string sObj,string recordTypeName)
    {        
         Schema.DescribeSObjectResult objSchemaDesc = Schema.getGlobalDescribe().get(sObj).getDescribe(); 
         Map<string,schema.RecordTypeInfo> mapRecType =objSchemaDesc.getRecordTypeInfosByName();
         Schema.RecordTypeInfo objRecTypeName = mapRecType.get(recordTypeName);
         return objRecTypeName.getRecordTypeId();   
    }
    
    /**
     * @name         :   formatCurrency
     * @description  :   This method will format amount string and place comma at correct place
     * @param        :   
     * @return       :   
     **/     
    public static String formatCurrencyInternational(String unformattedAmt, string currSymbol)
    {
        String formattedAmount;
        if(!string.isBlank(unformattedAmt))
        {
            try{
                formattedAmount = ( Decimal.valueOf(unformattedAmt==null||unformattedAmt.trim()==''?'0':unformattedAmt).setScale(2) + 0.001).format();
                formattedAmount = (currSymbol + ' ' + formattedAmount.substring(0,formattedAmount.length()-1)).trim();
            }catch(Exception e){
                return unformattedAmt;
            }
            return formattedAmount;      
        }
        return formattedAmount;
    }
    
    /**
     * @name         :   convertStringToDatetime
     * @description  :   This method will format date string to Datetime format
     * @param        :   Date with Slash
     * @return       :   Datetime
     **/    
    public static Datetime convertDateWithSlashToDatetime(String inputDateString)
    {
    	// Date String is in the format dd/MM/YYYY
      	if(string.isEmpty(inputDateString) || inputDateString.trim().length()<8 || (inputDateString.indexOf('/')<0))return null;
      	String[] sarr = inputDateString.split('/');
      	if(sarr.size() <2) return null;
      
      	Integer d = Integer.valueOf(sarr[0]);
      	Integer m = Integer.valueOf(sarr[1]);
      	Integer y = Integer.valueOf(sarr[2]);
      
      	if (!(y>1900 || m>=1 || d>=1)) return null;
      	return Datetime.newInstance(y,m,d,0,0,0);
	}
    
    /**
     * @name         :   convertStringToDate
     * @description  :   This method will format date string to Date format
     * @param        :   Date with Slash
     * @return       :   Date
     **/    
	public static Date convertDateWithSlashToDate(String inputDateString){
      // Date String is in the format dd/MM/YYYY
      
      	if(string.isEmpty(inputDateString) || inputDateString.trim().length()<8 || (inputDateString.indexOf('/')<0))return null;
	    String[] sarr = inputDateString.split('/');
        if(sarr.size() <2) return null;
      
        Integer d = Integer.valueOf(sarr[0]);
        Integer m = Integer.valueOf(sarr[1]);
        Integer y = Integer.valueOf(sarr[2].substring(0,4));
      
      	if (!(y>1900 || m>=1 || d>=1)) return null;
		return Date.valueOf(Date.newInstance(y,m,d));
    }
     
    public static String formatDate(Date inputDate, string dateFormat)
    {
        if(inputDate==null) return '';
        DateTime dtime=DateTime.newInstance(inputDate, Time.newInstance(12,0,0,0));
        return dtime.format(dateFormat);    
    }
}
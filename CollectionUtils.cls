/*
###########################################################################
# File..................: CollectionUtils
# Class Type............: Class
# Created by............: Naveen Ila
# Created Date..........: 02-Aug-2016
# Last Modified by......: 
# Last Modified Date....: 
# Description...........: This is collection utility class
							1) Here we have all common useful methods w.r.t collections
# VF page...............: 
# Change Log:
###########################################################################
*/
public with sharing class CollectionUtils {


	public static Boolean isCollectionEmpty(List<Object> objList){
		if(objList == null || objList.isEmpty()){
			return true;
		}
		return false;
	}
	/*
	public static Boolean isCollectionEmpty(Set<object> objSet){
		if(objSet == null || objSet.isEmpty()){
			return true;
		}
		return false;	
	}
	*/	
}

//SysCollectionUtils.isCollectionEmpty(new List<String>{'a','b'});
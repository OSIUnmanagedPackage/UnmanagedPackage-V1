/*
###########################################################################
# File..................: Sample_Standard_BatchCls
# Class Type............: Batch Class
# Created by............: Naveen Ila
# Created Date..........: 02-Aug-2016
# Last Modified by......: Naveen Ila
# Last Modified Date....: 
# Description...........: Sample Batch Class
# VF page...............: 
# Change Log:
###########################################################################
*/
global class Sample_Standard_BatchCls implements Database.Batchable<sObject> {
    public String query;
    // Default constructor
    global Sample_Standard_BatchCls() {
        this.query = query;
    }
    // Strat Method
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    // Execute Method
    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        
    }
    //Finish Method
    global void finish(Database.BatchableContext BC) {

    }
}
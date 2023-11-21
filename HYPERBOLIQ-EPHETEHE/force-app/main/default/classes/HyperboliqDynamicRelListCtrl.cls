/**
 * @description       : Controller class for LWC hyperboliq-dynamic-related-list
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * Ver   Date         Author                       			Modification
 * 1.0   2023-11-20   ephetehe.mokgopanyane@tetrad.co.za   	Initial Version
 **/
 public with sharing class HyperboliqDynamicRelListCtrl {
    public HyperboliqDynamicRelListCtrl() {}
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(String parentRecordId) {
        return [SELECT Id, Email, FirstName, LastName, Name, Phone, Title FROM Contact WHERE AccountId =: parentRecordId LIMIT 40];
    }
}
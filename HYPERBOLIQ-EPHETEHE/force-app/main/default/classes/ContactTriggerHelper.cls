public class ContactTriggerHelper {
	public static void handleBeforeInsert(List<Contact> contacts){
        contacts = createMedicalInfoRecords(contacts);
    }
    
    public static void handleBeforeUpdate(List<Contact> contacts, Map<Id, Contact> oldContacts){
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for(Contact contact : contacts){
            if(contact.Medical_Info__c == null){
                contactsToUpdate.add(contact);
            }
        }
        
        if(contactsToUpdate != null && contactsToUpdate.size() > 0){
            Map<Id, Contact> contIdContact = new Map<Id, Contact>();
            List<Contact> updatedContacts = new List<Contact>();
            contactsToUpdate = createMedicalInfoRecords(contactsToUpdate);
            
            for(Contact contact : contacts){
                contIdContact.put(contact.Id, contact);
            }
            
            for(Contact contact : contactsToUpdate){
                contIdContact.put(contact.Id, contact);
            }
            
            for(Id contactId : contIdContact.keySet()){
                updatedContacts.add(contIdContact.get(contactId));
            }
            
            if(updatedContacts != null && updatedContacts.size() > 0){
                contacts = updatedContacts;
            }
        }
    }
    
    public static void handleAfterUpdate(List<Contact> contacts, Map<Id, Contact> oldContacts){
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for(Contact contact : contacts){
        	if(contact.FirstName != oldContacts.get(contact.Id).FirstName || contact.LastName != oldContacts.get(contact.Id).LastName){
                contactsToUpdate.add(contact);
            }
        }
        
        if(contactsToUpdate != null && contactsToUpdate.size() > 0){
            updateMedicalInfoName(contactsToUpdate);
        }
    }
    
    public static void handleBeforeDelete(List<Contact> contacts){
        Set<Id> medInfoIds = new Set<Id>();
        
        for(Contact contact : contacts){
            if(contact.Medical_Info__c != null){
                medInfoIds.add(contact.Medical_Info__c);
            }
        }
        
        deleteMedicalInfos(medInfoIds);
    }
    
    public static List<Contact> createMedicalInfoRecords(List<Contact> contacts){
        Map<Id, Id> contIdMedInfoId = new Map<Id, Id>();
        List<Medical_Info__c> medInfoToInsert = new List<Medical_Info__c>();
        Medical_Info__c medInfo;
        
        for(Contact contact : contacts){
            medInfo = new Medical_Info__c();
            medInfo.Name = contact.FirstName + ' ' + contact.LastName;
            medInfo.Contact_Id__c = contact.Id;
            medInfoToInsert.add(medInfo);
        }
        
        insert medInfoToInsert;
        
        for(Medical_Info__c newMedInfo : medInfoToInsert){
            contIdMedInfoId.put(newMedInfo.contact_Id__c, newMedInfo.Id);
        }
        
        for(Contact contact : contacts){
            contact.Medical_Info__c = contIdMedInfoId.get(contact.Id);
        }
        
        return contacts;
    }
    
    public static void updateMedicalInfoName(List<Contact> contacts){
        Map<Id, Contact> contIdContact = new Map<Id, Contact>();
        Set<Id> medInfoIds = new Set<Id>();
        
        for(Contact contact : contacts){
        	medInfoIds.add(contact.Medical_Info__c);
            contIdContact.put(contact.Id, contact);
        }
        
        List<Medical_Info__c> medInfos = [SELECT Id, Contact_Id__c, Name FROM Medical_Info__c WHERE Id IN: medInfoIds];
        
        for(Medical_Info__c medInfo : medInfos){
        	medInfo.Name = contIdContact.get(medInfo.Contact_Id__c).FirstName + ' ' + contIdContact.get(medInfo.Contact_Id__c).LastName;
        } 
        
        update medInfos;
    }
    
    public static void deleteMedicalInfos(Set<Id> medInfoIds){
        List<Medical_Info__c> medInfos = [SELECT Id FROM Medical_Info__c WHERE Id IN: medInfoIds];
        
        if(medInfos != null && medInfos.size() > 0){
            delete medInfos;
        }
    }
}
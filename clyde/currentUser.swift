//
//  currentUser.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 6/27/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import SwiftyJSON

class currentUser{
    var fullName: String
    var email: String
    var phoneNumber: String
    var anticipatedStartTerm: String
    var contactId: String
    
    init(fullName: String, email: String, phoneNumber: String, anticipatedStartTerm: String, contactId: String){
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.anticipatedStartTerm = anticipatedStartTerm
        self.contactId = contactId
    }
}

class currentUserController{
    
   let userId = UserAccountManager.shared.currentUserAccountIdentity?.userId
    
    
    
    
    //Create query
   private func pullUserInfo(userId: String) -> currentUser{
        let request = RestClient.shared.request(forQuery: "SELECT ContactId FROM User WHERE Id = \(userId)")
    RestClient.shared.send(request: request, onFailure:  { (error, urlResponse) in
        SalesforceLogger.d(type(of:self), message:"Error invoking: \(request)")
    }) { [weak self] (response, urlResponse) in
        let json = JSON(response!)
        if json["records"]["Id"].string != nil{
            let contactId = json["records"]["Id"].string
        }
        }
        let infoRequest = RestClient.shared.request(forQuery: "SELECT  ")
    }
    
    var user = currentUser(fullName: <#T##String#>,
                           email: <#T##String#>,
                           phoneNumber: <#T##String#>,
                           anticipatedStartTerm: <#T##String#>,
                           contactId: <#T##String#>)
        
    
}

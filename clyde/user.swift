//
//  user.swift
//  clyde
//
//  Created by Rahimi, Meena Nichole (Student) on 7/1/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import Foundation
import SalesforceSDKCore

protocol UserDelegate: AnyObject {
    
    
    /// - Parameter dataSource: The data source that was updated.
    func UserDidUpdateRecords(_ dataSource: User)
    
}

class User: NSObject {

    var user = UserAccount.init()
    //MARK: Properties
    var fullName: String
    var ID: UserAccountIdentity
    
    
    
    
    //MARK: Initiallization
    init(fullName: String) {
        self.fullName = fullName
        self.ID = user.accountIdentity
        
        
    }
    
    typealias salesForceRecord = [String : Any]
    private(set) var records: [salesForceRecord] = []
    weak var delegate: UserDelegate?
    
    private func handleError(_ error: Error?, urlResponse: URLResponse? = nil) {
        let errorDescription: String
        if let error = error {
            errorDescription = "\(error)"
        } else {
            errorDescription = "An unknown error occurred."
        }
        SalesforceLogger.e(type(of: self), message: "Failed to successfully complete the REST request. \(errorDescription)")
    }
    
    @objc func fetchData(){
        let request = RestClient.shared.request(forQuery: "SELECT FullName FROM Contact")
        RestClient.shared.send(request: request, onFailure: handleError) { [weak self] response, _ in
            guard let self = self else { return }
            var resultsToReturn = [salesForceRecord]()
            if let dictionaryResponse = response as? [String: Any],
                let records = dictionaryResponse["records"] as? [salesForceRecord] {
                resultsToReturn = records
            }
            DispatchQueue.main.async {
                self.records = resultsToReturn
                self.delegate?.UserDidUpdateRecords(self)
            }
        }
    }
}

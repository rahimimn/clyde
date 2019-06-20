//
//  RestClient+NewStudent.swift
//  CofCApp
//
//  Created by Rahimi, Meena Nichole (Student) on 6/13/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore

extension RestClient{
    
    /// An error that may occur while sending a request related to `Student` records.
    enum CaseRequestError: LocalizedError {
        
        /// The response dictionary did not contain the expected fields.
        case responseDataCorrupted(keyPath: String)
        
        /// A localized message describing what error occurred.
        var errorDescription: String? {
            switch self {
            case .responseDataCorrupted(let keyPath): return "The response dictionary did not contain the expected fields: \(keyPath)"
            }
        }
    }
    
    /// Sends a composite request for creating records and calls the completion
    /// handler with the list of resulting IDs.
    ///
    /// - Parameters:
    ///   - compositeRequest: The request to be sent.
    ///   - failureHandler: The closure to call if the request fails
    ///     (due to timeout, cancel, or error).
    ///   - completionHandler: The closure to call if the request successfully
    ///     completes.
    ///   - ids: The list of IDs for the created records.
    func sendCompositeRequest(_ compositeRequest: RestRequest, onFailure failureHandler: @escaping RestFailBlock, completionHandler: @escaping (_ ids: [String]) -> Void) {
        self.send(request: compositeRequest, onFailure: failureHandler) { response, urlResponse in
            guard let responseDictionary = response as? [String: Any],
                let results = responseDictionary["compositeResponse"] as? [[String: Any]]
                else {
                    failureHandler(CaseRequestError.responseDataCorrupted(keyPath: "compositeResponse"), urlResponse)
                    return
            }
            let ids = results.compactMap { result -> String? in
                guard let resultBody = result["body"] as? [String: Any] else { return nil }
                return resultBody["id"] as? String
            }
            completionHandler(ids)
        }
    }
    
    /// Returns a request that executes multiple subrequests, with automatically
    /// generated RefIDs following the pattern "RefID-0", "RefID-1", and so on.
    ///
    /// - Parameter requests: The list of subrequests to execute.
    /// - Returns: The new composite request.
    private func compositeRequestWithSequentialRefIDs(composedOf requests: [RestRequest]) -> RestRequest {
        let refIDs = (0..<requests.count).map { "RefID-\($0)" }
        return self.compositeRequest(requests, refIds: refIDs, allOrNone: false)
    }
    
    
}


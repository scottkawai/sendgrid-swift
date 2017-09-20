//
//  GlobalUnsubscribe.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension GlobalUnsubscribe {
    
    /// The `GlobalUnsubscribe.Get` class represents the API call to [retrieve
    /// the global unsubscribe list](https://sendgrid.com/docs/API_Reference/Web_API_v3/Suppression_Management/global_suppressions.html#List-all-globally-unsubscribed-email-addresses-GET).
    public class Get: SuppressionListReader<GlobalUnsubscribe> {
        
        /// The path to the spam reports API.
        override var path: String { return "/v3/suppression/unsubscribes" }
        
    }
    
}

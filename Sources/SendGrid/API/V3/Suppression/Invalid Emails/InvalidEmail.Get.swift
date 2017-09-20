//
//  InvalidEmail.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension InvalidEmail {
    
    /// The `InvalidEmail.Get` class represents the API call to [retrieve the
    /// invalid email list](https://sendgrid.com/docs/API_Reference/Web_API_v3/invalid_emails.html#List-all-invalid-emails-GET).
    public class Get: SuppressionListReader<InvalidEmail> {
        
        /// The path to the spam reports API.
        override var path: String { return "/v3/suppression/invalid_emails" }
        
    }
    
}

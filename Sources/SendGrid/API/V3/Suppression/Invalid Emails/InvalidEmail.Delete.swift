//
//  InvalidEmail.Delete.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension InvalidEmail {

    /// The `InvalidEmail.Delete` class represents the API call to [delete from
    /// the invalid email list](https://sendgrid.com/docs/API_Reference/Web_API_v3/invalid_emails.html#Delete-invalid-emails-DELETE).
    public class Delete: SuppressionListDeleter<InvalidEmail>, AutoEncodable {
        
        // MARK: - Properties
        //======================================================================
        
        /// The path for the spam report API
        override var path: String { return "/v3/suppression/invalid_emails" }
        
        /// Returns a request that will delete *all* the entries on your spam
        /// report list.
        public static var all: InvalidEmail.Delete {
            return InvalidEmail.Delete(deleteAll: true, emails: nil)
        }
        
    }
    
}

/// Encodable conformance
public extension InvalidEmail.Delete {
    
    public enum CodingKeys: String, CodingKey {
        case deleteAll  = "delete_all"
        case emails
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.deleteAll, forKey: .deleteAll)
        try container.encodeIfPresent(self.emails, forKey: .emails)
    }
    
}

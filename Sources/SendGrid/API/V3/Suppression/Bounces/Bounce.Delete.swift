//
//  Bounce.Delete.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Bounce {

    /// The `Bounce.Delete` class represents the API call to [delete from the
    /// bounce list](https://sendgrid.com/docs/API_Reference/Web_API_v3/bounces.html#Delete-bounces-DELETE).
    public class Delete: Request<[String:Any]>, AutoEncodable {
        
        // MARK: - Properties
        //======================================================================
        
        // A `Bool` indicating if all the bounces on the bounce list should be
        // deleted.
        public let deleteAll: Bool?
        
        // An array of emails to delete from the bounce list.
        public let emails: [String]?
        
        /// Returns a request that will delete *all* the entries on your bounce
        /// list.
        public static var all: Bounce.Delete {
            return Bounce.Delete(deleteAll: true, emails: nil)
        }
        
        
        // MARK: - Initializer
        //=========================================================================
        
        /// Private initializer to set all the required properties.
        ///
        /// - Parameters:
        ///   - deleteAll:  A `Bool` indicating if all the bounces on the bounce
        ///                 list should be deleted.
        ///   - emails:     An array of emails to delete from the bounce list.
        fileprivate init(deleteAll: Bool?, emails: [String]?) {
            self.deleteAll = deleteAll
            self.emails = emails
            super.init(method: .DELETE, contentType: .json, path: "/v3/suppression/bounces")
        }
        
        /// Initializes the request with an array of email addresses to delete
        /// from the bounce list.
        ///
        /// - Parameter emails: An array of emails to delete from the bounce
        ///                     list.
        public convenience init(emails: [String]) {
            self.init(deleteAll: nil, emails: emails)
        }
        
        /// Initializes the request with an array of email addresses to delete
        /// from the bounce list.
        ///
        /// - Parameter emails: An array of emails to delete from the bounce
        ///                     list.
        public convenience init(emails: String...) {
            self.init(emails: emails)
        }
        
        /// Initializes the request with an array of bounce events that should
        /// be removed from the bounce list.
        ///
        /// - Parameter bounces:    An array of bounce events containing email
        ///                         addresses to remove from the bounce list.
        public convenience init(bounces: [Bounce]) {
            let emails = bounces.map { $0.email }
            self.init(emails: emails)
        }
        
        /// Initializes the request with an array of bounce events that should
        /// be removed from the bounce list.
        ///
        /// - Parameter bounces:    An array of bounce events containing email
        ///                         addresses to remove from the bounce list.
        public convenience init(bounces: Bounce...) {
            self.init(bounces: bounces)
        }
        
    }
    
}

/// Encodable conformance
public extension Bounce.Delete {
    
    public enum CodingKeys: String, CodingKey {
        case deleteAll  = "delete_all"
        case emails
    }
    
}

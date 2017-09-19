//
//  Block.Delete.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Block {

    /// The `Block.Delete` class represents the API call to [delete from the
    /// block list](https://sendgrid.com/docs/API_Reference/Web_API_v3/blocks.html#Delete-blocks-DELETE).
    public class Delete: Request<[String:Any]>, AutoEncodable {
        
        // MARK: - Properties
        //======================================================================
        
        // A `Bool` indicating if all the blocks on the block list should be
        // deleted.
        public let deleteAll: Bool?
        
        // An array of emails to delete from the block list.
        public let emails: [String]?
        
        /// Returns a request that will delete *all* the entries on your block
        /// list.
        public static var all: Block.Delete {
            return Block.Delete(deleteAll: true, emails: nil)
        }
        
        
        // MARK: - Initializer
        //=========================================================================
        
        /// Private initializer to set all the required properties.
        ///
        /// - Parameters:
        ///   - deleteAll:  A `Bool` indicating if all the blocks on the block
        ///                 list should be deleted.
        ///   - emails:     An array of emails to delete from the block list.
        fileprivate init(deleteAll: Bool?, emails: [String]?) {
            self.deleteAll = deleteAll
            self.emails = emails
            super.init(method: .DELETE, contentType: .json, path: "/v3/suppression/blocks")
        }
        
        /// Initializes the request with an array of email addresses to delete
        /// from the block list.
        ///
        /// - Parameter emails: An array of emails to delete from the block
        ///                     list.
        public convenience init(emails: [String]) {
            self.init(deleteAll: nil, emails: emails)
        }
        
        /// Initializes the request with an array of email addresses to delete
        /// from the block list.
        ///
        /// - Parameter emails: An array of emails to delete from the block
        ///                     list.
        public convenience init(emails: String...) {
            self.init(emails: emails)
        }
        
        /// Initializes the request with an array of block events that should
        /// be removed from the block list.
        ///
        /// - Parameter blocks: An array of block events containing email
        ///                     addresses to remove from the block list.
        public convenience init(blocks: [Block]) {
            let emails = blocks.map { $0.email }
            self.init(emails: emails)
        }
        
        /// Initializes the request with an array of block events that should
        /// be removed from the block list.
        ///
        /// - Parameter blocks: An array of block events containing email
        ///                     addresses to remove from the block list.
        public convenience init(blocks: Block...) {
            self.init(blocks: blocks)
        }
        
    }
    
}

/// Encodable conformance
public extension Block.Delete {
    
    public enum CodingKeys: String, CodingKey {
        case deleteAll  = "delete_all"
        case emails
    }
    
}

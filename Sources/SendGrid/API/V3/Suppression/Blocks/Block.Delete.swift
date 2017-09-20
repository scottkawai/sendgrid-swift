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
    public class Delete: SuppressionListDeleter<Block>, AutoEncodable {
        
        // MARK: - Properties
        //======================================================================
        
        /// The path for the blocks API
        override var path: String { return "/v3/suppression/blocks" }
        
        /// Returns a request that will delete *all* the entries on your block
        /// list.
        public static var all: Block.Delete {
            return Block.Delete(deleteAll: true, emails: nil)
        }
        
    }
    
}

/// Encodable conformance
public extension Block.Delete {
    
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

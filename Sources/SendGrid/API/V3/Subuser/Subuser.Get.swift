//
//  Subuser.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/23/17.
//

import Foundation

public extension Subuser {
    
    /// This class is used to make the
    /// [get subusers](https://sendgrid.com/docs/API_Reference/Web_API_v3/subusers.html#List-all-Subusers-for-a-parent-GET)
    /// API call.
    public class Get: Request<[SendGrid.Subuser]> {
        
        // MARK: - Properties
        //=========================================================================
        
        /// The page of results to look for.
        public let page: Page?
        
        /// A specific subuser's username to look for.
        public let username: String?
        
        /// The query params for the request.
        internal var queryItems: [URLQueryItem]? {
            var items: [(String, String)]?
            func append(_ str: String, _ val: Any) {
                let element = (str, "\(val)")
                if items == nil {
                    items = [element]
                } else {
                    items?.append(element)
                }
            }
            
            if let p = self.page {
                append("limit", p.limit)
                append("offset", p.offset)
            }
            if let u = self.username { append("username", u) }
            return items?.map { URLQueryItem(name: $0.0, value: $0.1) }
        }
        
        
        // MARK: - Initialization
        //=========================================================================
        
        /// Initializes the request with pagination info and a username search.
        /// If you don't specify a `username` value, then all subusers will be
        /// returned.
        ///
        /// - Parameters:
        ///   - page:       Provides `limit` and `offset` information to
        ///                 paginate the results.
        ///   - username:   A basic search applied against the subusers'
        ///                 usernames. You can provide a partial username. For
        ///                 instance, if you have a subuser with the username
        ///                 `foobar`, searching for `foo` will return it.
        public init(page: Page? = nil, username: String? = nil) {
            self.page = page
            self.username = username
            super.init(method: .GET, contentType: .formUrlEncoded, path: "/v3/subusers")
            self.endpoint?.queryItems = self.queryItems
        }
        
        
        // MARK: - Methods
        //=========================================================================
        
        /// Validates that the `limit` value isn't over 500.
        public override func validate() throws {
            try super.validate()
            if let limit = self.page?.limit {
                let range = 1...500
                guard range ~= limit else { throw Exception.Global.limitOutOfRange(limit, range) }
            }
        }
        
    }
    
}

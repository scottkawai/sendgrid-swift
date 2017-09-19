//
//  Block.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Block {
    
    /// The `Block.Get` class represents the API call to [retrieve the block
    /// list](https://sendgrid.com/docs/API_Reference/Web_API_v3/blocks.html#List-all-blocks-GET).
    public class Get: Request<[Block]> {
        
        // MARK: - Initialization
        //======================================================================
        
        /// Initializes the request with a specific email to look for in the
        /// block list.
        ///
        /// - Parameter email: The email address to look for in the block list.
        public init(email: String) {
            super.init(
                method: .GET,
                contentType: .formUrlEncoded,
                path: "/v3/suppression/blocks/\(email)"
            )
        }
        
        
        /// Initializes the request to retrieve a list of blocks.
        ///
        /// - Parameters:
        ///   - start:  Limits the search to a specific start time for the
        ///             event.
        ///   - end:    Limits the search to a specific end time for the event.
        ///   - range:  A range of dates to search between If `nil`, the entire
        ///             block list will be searched.
        ///   - page:   A `PaginationInfo` instance to limit the search to a
        ///             specific page. The `limit` value cannot exceed 500. If
        ///             not specified, the limit will be set to 500 and the
        ///             offset will be set to 0.
        /// - Throws:   An error will be thrown if the `limit` value in `page`
        ///             is out of range.
        public init(start: Date? = nil, end: Date? = nil, page: Page = Page(limit: 500, offset: 0)) throws {
            let range = 1...500
            guard range ~= page.limit else { throw Exception.Global.limitOutOfRange(page.limit, range) }
            super.init(
                method: .GET,
                contentType: .formUrlEncoded,
                path: "/v3/suppression/blocks"
            )
            var queryItems: [(String, Any)] = [
                ("limit", page.limit),
                ("offset", page.offset)
            ]
            if let s = start { queryItems.append(("start_time", Int(s.timeIntervalSince1970))) }
            if let e = end { queryItems.append(("end_time", Int(e.timeIntervalSince1970))) }
            self.endpoint?.queryItems = queryItems.map { URLQueryItem(name: $0.0, value: "\($0.1)") }
        }
    }
    
}

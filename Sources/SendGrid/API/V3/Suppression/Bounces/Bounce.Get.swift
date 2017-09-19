//
//  Bounce.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Bounce {
    
    /// The `Bounce.Get` class represents the API call to [retrieve the bounce
    /// list](https://sendgrid.com/docs/API_Reference/Web_API_v3/bounces.html#List-all-bounces-GET).
    public class Get: Request<[Bounce]> {
        
        // MARK: - Initialization
        //======================================================================
        
        /// Initializes the request with a specific email to look for in the
        /// bounce list.
        ///
        /// - Parameter email: The email address to look for in the bounce list.
        public init(email: String) {
            super.init(
                method: .GET,
                contentType: .formUrlEncoded,
                path: "/v3/suppression/bounces/\(email)"
            )
        }
        
        /// Initializes the request to retrieve a list of bounces.
        ///
        /// - Parameters:
        ///   - start:  Limits the search to a specific start time for the
        ///             event.
        ///   - end:    Limits the search to a specific end time for the event.
        ///   - range:  A range of dates to search between If `nil`, the entire
        ///             bounce list will be searched.
        ///   - limit:  Limits the number of results returned (max 500). If not
        ///             specified, then 500 is the default limit.
        ///   - offset: A beginning point in the list to retrieve from, used to
        ///             paginate the results. Default is `0`.
        /// - Throws:   An error will be thrown if the `limit` value is out of
        ///             range.
        public init(start: Date? = nil, end: Date? = nil, limit: Int = 500, offset: Int = 0) throws {
            let range = 1...500
            guard range ~= limit else { throw Exception.Global.limitOutOfRange(limit, range) }
            super.init(
                method: .GET,
                contentType: .formUrlEncoded,
                path: "/v3/suppression/bounces"
            )
            var queryItems: [(String, Any)] = [
                ("limit", limit),
                ("offset", offset)
            ]
            if let s = start { queryItems.append(("start_time", Int(s.timeIntervalSince1970))) }
            if let e = end { queryItems.append(("end_time", Int(e.timeIntervalSince1970))) }
            self.endpoint?.queryItems = queryItems.map { URLQueryItem(name: $0.0, value: "\($0.1)") }
        }
    }
    
}

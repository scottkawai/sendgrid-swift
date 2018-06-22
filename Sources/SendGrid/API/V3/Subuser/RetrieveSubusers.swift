//
//  RetrieveSubusers.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/23/17.
//

import Foundation

/// This class is used to make the
/// [get subusers](https://sendgrid.com/docs/API_Reference/Web_API_v3/subusers.html#List-all-Subusers-for-a-parent-GET)
/// API call.
///
/// You can provide pagination information, and also search by username.  If
/// you partial searches are allowed, so for instance if you had a subuser
/// with username `foobar`, searching for `foo` would return it.
///
/// ```swift
/// do {
///     let search = RetrieveSubusers(username: "foo")
///     try Session.shared.send(request: search) { (response) in
///         if let list = response?.model {
///             // The `model` property on the response will be an array of
///             // `Subuser` instances.
///             list.forEach { print($0.username) }
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class RetrieveSubusers: Request<[Subuser], RetrieveSubusers.Parameters> {
    
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
        super.init(
            method: .GET,
            path: "/v3/subusers",
            parameters: Parameters(page: page, username: username)
        )
    }
    
    
    // MARK: - Methods
    //=========================================================================
    
    /// Validates that the `limit` value isn't over 500.
    public override func validate() throws {
        try super.validate()
        if let limit = self.parameters?.page?.limit {
            let range = 1...500
            guard range ~= limit else { throw Exception.Global.limitOutOfRange(limit, range) }
        }
    }
    
}

public extension RetrieveSubusers /* Parameters Struct */ {
    
    /// The `RetrieveSubusers.Parameters` struct holds all the parameters that
    /// can be used in the `RetrieveSubusers` call.
    public struct Parameters: Encodable {
        
        public var page: Page?
        public var username: String?
        
        public init(page: Page? = nil, username: String? = nil) {
            self.page = page
            self.username = username
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: RetrieveSubusers.Parameters.CodingKeys.self)
            try container.encodeIfPresent(self.page?.limit, forKey: .limit)
            try container.encodeIfPresent(self.page?.offset, forKey: .offset)
            try container.encodeIfPresent(self.username, forKey: .username)
        }
        
        public enum CodingKeys: String, CodingKey {
            case limit
            case offset
            case username
        }
        
    }
    
}

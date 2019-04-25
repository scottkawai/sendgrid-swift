import Foundation

/// The `RateLimit` struct abstracts any rate-limit information returned from an
/// `Response`.
public struct RateLimit {
    // MARK: - Properties
    
    /// The number of calls allowed for this resource during the refresh period.
    public let limit: Int
    
    /// The number of calls remaining for this resource during the current refresh period.
    public let remaining: Int
    
    /// The date and time at which the refresh period will reset.
    public let resetDate: Date
    
    // MARK: - Initialization
    
    /// Initializes the struct.
    ///
    /// - Parameters:
    ///   - limit:      The total number of calls allowed in the rate limit
    ///                 period for the endpoint.
    ///   - remaining:  The number of calls remaining in the rate limit period.
    ///   - resetDate:  The time at which the rate limit will reset.
    public init(limit: Int, remaining: Int, resetDate: Date) {
        self.limit = limit
        self.remaining = remaining
        self.resetDate = resetDate
    }
    
    /// Initializes a new instance from the headers of an API response.
    ///
    /// - Parameter headers: The headers of the API response.
    public init?(headers: [AnyHashable: Any]) {
        guard let limitStr = headers["X-RateLimit-Limit"] as? String,
            let li = Int(limitStr),
            let remainStr = headers["X-RateLimit-Remaining"] as? String,
            let re = Int(remainStr),
            let dateStr = headers["X-RateLimit-Reset"] as? String,
            let date = Double(dateStr)
        else { return nil }
        self.init(limit: li, remaining: re, resetDate: Date(timeIntervalSince1970: date))
    }
    
    /// Abstracts out the rate-limiting headers from an `URLResponse` and
    /// stores their value in a new instance of `RateLimit`.
    ///
    /// - Parameter response:   An instance of `URLResponse`.
    public init?(response: URLResponse?) {
        guard let http = response as? HTTPURLResponse else { return nil }
        self.init(headers: http.allHeaderFields)
    }
}

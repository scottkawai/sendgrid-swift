import Foundation

public extension HTTPURLResponse /* Rate Limit Info */ {
    /// The rate limit information extracted from the response.
    var rateLimit: RateLimit? {
        return RateLimit(response: self)
    }
}

public extension HTTPURLResponse /* Pagination Info */ {
    /// The pagination info from the response, if applicable.
    var pages: Pagination? {
        return Pagination(response: self)
    }
}

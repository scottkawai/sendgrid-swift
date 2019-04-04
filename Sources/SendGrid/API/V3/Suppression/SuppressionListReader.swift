import Foundation

/// The `SuppressionListReader` class is base class inherited by requests that
/// retrieve entries from a supression list. You should not use this class
/// directly.
open class SuppressionListReader<T: EmailEventRepresentable & Decodable>: ModeledRequest<[T], SuppressionListReaderParameters> {
    // MARK: - Initialization
    
    /// Private initializer that sets all the values.
    ///
    /// - Parameters:
    ///   - path:   The path of the API endpoint.
    ///   - email:  The email address to look for in the bounce list.
    ///   - start:  Limits the search to a specific start time for the
    ///             event.
    ///   - end:    Limits the search to a specific end time for the event.
    ///   - page:   A `Page` instance to limit the search to a specific page.
    ///             The `limit` value cannot exceed 500. If not specified, the
    ///             limit will be set to 500 and the offset will be set to 0.
    internal init(path: String? = nil, email: String?, start: Date?, end: Date?, page: Page?) {
        let parameters = SuppressionListReaderParameters(start: start, end: end, page: page)
        var realPath: String {
            let p = path ?? "/"
            guard let em = email else { return p }
            return "\(p)/\(em)"
        }
        let dateEncoder = JSONEncoder.DateEncodingStrategy.custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(Int(date.timeIntervalSince1970))
        }
        super.init(
            method: .GET,
            path: realPath,
            parameters: parameters,
            encodingStrategy: EncodingStrategy(dates: dateEncoder)
        )
    }
    
    /// Initializes the request with a specific email to look for in the
    /// bounce list.
    ///
    /// - Parameter email: The email address to look for in the bounce list.
    public convenience init(email: String) {
        self.init(email: email, start: nil, end: nil, page: nil)
    }
    
    /// Initializes the request to retrieve a list of bounces.
    ///
    /// - Parameters:
    ///   - start:  Limits the search to a specific start time for the
    ///             event.
    ///   - end:    Limits the search to a specific end time for the event.
    ///   - range:  A range of dates to search between If `nil`, the entire
    ///             bounce list will be searched.
    ///   - page:   A `Page` instance to limit the search to a specific page.
    ///             The `limit` value cannot exceed 500. If not specified, the
    ///             limit will be set to 500 and the offset will be set to 0.
    public convenience init(start: Date? = nil, end: Date? = nil, page: Page? = nil) {
        self.init(email: nil, start: start, end: end, page: page)
    }
    
    // MARK: - Methods
    
    /// Validates that the `limit` value isn't over 500.
    open override func validate() throws {
        try super.validate()
        if let limit = self.parameters?.page?.limit {
            let range = 1...500
            guard range ~= limit else { throw Exception.Global.limitOutOfRange(limit, range) }
        }
    }
}

/// The `SuppressionListReaderParameters` serves as the parameters used by the
/// "get suppressions" API calls.
public struct SuppressionListReaderParameters: Codable {
    /// The date to start looking for events.
    public let startDate: Date?
    
    /// The date to stop looking for events.
    public let endDate: Date?
    
    /// The page of results to look for.
    public let page: Page?
    
    /// Initializes the struct.
    ///
    /// - Parameters:
    ///   - start:  Limits the search to a specific start time for the
    ///             event.
    ///   - end:    Limits the search to a specific end time for the event.
    ///   - page:   A `Page` instance to limit the search to a specific page.
    ///             The `limit` value cannot exceed 500. If not specified, the
    ///             limit will be set to 500 and the offset will be set to 0.
    public init(start: Date?, end: Date?, page: Page?) {
        self.startDate = start
        self.endDate = end
        self.page = page
    }
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SuppressionListReaderParameters.CodingKeys.self)
        self.startDate = try container.decodeIfPresent(Date.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        
        guard let limit = try container.decodeIfPresent(Int.self, forKey: .limit),
            let offset = try container.decodeIfPresent(Int.self, forKey: .offset)
        else {
            self.page = nil
            return
        }
        self.page = Page(limit: limit, offset: offset)
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SuppressionListReaderParameters.CodingKeys.self)
        try container.encodeIfPresent(self.startDate, forKey: .startDate)
        try container.encodeIfPresent(self.endDate, forKey: .endDate)
        try container.encodeIfPresent(self.page?.limit, forKey: .limit)
        try container.encodeIfPresent(self.page?.offset, forKey: .offset)
    }
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case startDate = "start_time"
        case endDate = "end_time"
        case limit
        case offset
    }
}

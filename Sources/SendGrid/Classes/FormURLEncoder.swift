import Foundation

/// The `FormURLEncoder` class encodes any `Encodable` instance into the
/// `application/x-www-form-urlencoded` Content-Type.
///
/// The example below shows how to encode an instance of a simple
/// `GroceryProduct` type to a form URL encoded string. The type adopts
/// `Codable` so that it's encodable as JSON using a JSONEncoder instance.
///
/// ```
/// struct GroceryProduct: Codable {
///     var name: String
///     var points: Int
///     var description: String?
/// }
///
/// let pear = GroceryProduct(name: "Pear", points: 250, description: "A ripe pear.")
///
/// let encoder = FormURLEncoder()
/// let results = try encoder.stringEncode(pear)
/// print(results)
///
/// /* Prints:
///  description=A%20ripe%20pear.&name=Pear&points=250
/// */
/// ```
open class FormURLEncoder {
    // MARK: - Properties
    
    /// The strategy used when encoding dates.
    open var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate
    
    // MARK: - Initialization
    
    /// Creates a new, reusable Form URL encoder with the default date encoding
    /// strategy.
    public init() {}
    
    // MARK: - Methods
    
    /// Returns the common "no value" error that can be thrown when encoding.
    ///
    /// - Parameter value:  The `Encodable` type the didn't contain a value.
    /// - Returns:          An `EncodingError` instance.
    fileprivate func _noValueError<T: Encodable>(for value: T) -> EncodingError {
        let context = EncodingError.Context(codingPath: [], debugDescription: "Top-level \(T.self) did not encode any values.")
        return EncodingError.invalidValue(value, context)
    }
    
    /// Encodes an `Encodable` type to the form URL format represented as
    /// `Data`.
    ///
    /// - Parameters:
    ///   - value:          The `Encodable` instance to encode.
    ///   - percentEncoded: A boolean indicating if the resulting encoding
    ///                     should contain percent encoding.
    /// - Returns:          A `Data` instance of the formatted data.
    /// - Throws:           An `EncodingError` can be thrown.
    open func encode<T: Encodable>(_ value: T, percentEncoded: Bool = true) throws -> Data {
        let str = try self.stringEncode(value, percentEncoded: percentEncoded)
        guard let data = str.data(using: .utf8) else {
            throw self._noValueError(for: value)
        }
        return data
    }
    
    /// Encodes an `Encodable` type to the form URL format represented as a
    /// `String`.
    ///
    /// - Parameters:
    ///   - value:          The `Encodable` instance to encode.
    ///   - percentEncoded: A boolean indicating if the resulting encoding
    ///                     should contain percent encoding.
    /// - Returns:          A `String` instance.
    /// - Throws:           An `EncodingError` can be thrown.
    open func stringEncode<T: Encodable>(_ value: T, percentEncoded: Bool = true) throws -> String {
        var components = URLComponents()
        components.queryItems = try self.queryItemEncode(value)
        let str = percentEncoded ? components.percentEncodedQuery : components.query
        guard let query = str else {
            throw self._noValueError(for: value)
        }
        return query
    }
    
    /// Encodes an `Encodable` type to the form URL format represented as an
    /// array of `URLQueryItem` instances.
    ///
    /// - Parameter value:  The `Encodable` instance to encode.
    /// - Returns:          An array of `URLQueryItem` instances.
    /// - Throws:           An `EncodingError` can be thrown.
    open func queryItemEncode<T: Encodable>(_ value: T) throws -> [URLQueryItem] {
        let encoder = _FormURLEncoder(dateEncodingStrategy: self.dateEncodingStrategy)
        return try encoder.encodeToQueryItems(value)
    }
}

/// The `_FormURLEncoder` class is the actual encoder used by `FormURLEncoder`.
private class _FormURLEncoder: Encoder {
    // MARK: - Properties
    
    /// :nodoc:
    fileprivate var codingPath: [CodingKey]
    
    /// :nodoc:
    fileprivate var userInfo: [CodingUserInfoKey: Any]
    
    /// The internal storage tracker for what's currently being encoded.
    fileprivate var storage: _FormURLEncoderStorage
    
    /// The date encoding strategy.
    fileprivate var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy
    
    /// This bool indicates if the encoder can currently encode a new value.
    fileprivate var _canEncodeNewValue: Bool {
        return self.storage._count == self.codingPath.count
    }
    
    // MARK: - Initialization
    
    /// Initializes the encoder with a path and date encoding strategy.
    ///
    /// - Parameters:
    ///   - codingPath:             The current coding path.
    ///   - dateEncodingStrategy:   The date encoding strategy.
    fileprivate init(codingPath: [CodingKey] = [], dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) {
        self.storage = _FormURLEncoderStorage()
        self.codingPath = codingPath
        self.userInfo = [:]
        self.dateEncodingStrategy = dateEncodingStrategy
    }
    
    // MARK: - Methods
    
    /// This method takes an `Encodable` instance and converts it into an array
    /// of `URLQueryItem` instances.
    ///
    /// - Parameter value:  The `Encodable` instance to encode.
    /// - Returns:          An array of `URLQueryItem` instances.
    /// - Throws:           If the top level type of the `Encodable` instances
    ///                     doesn't encode to a dictionary, an error will be
    ///                     thrown.
    fileprivate func encodeToQueryItems<T: Encodable>(_ value: T) throws -> [URLQueryItem] {
        let encoder = _FormURLEncoder(dateEncodingStrategy: dateEncodingStrategy)
        guard let topLevel = try encoder.box(value) else {
            let context = EncodingError.Context(codingPath: [], debugDescription: "Top-level \(T.self) did not encode any values.")
            throw EncodingError.invalidValue(value, context)
        }
        
        guard let items = self._queryItems(from: topLevel) else {
            let context = EncodingError.Context(codingPath: [], debugDescription: "Top-level \(T.self) encoded as query item fragment.")
            throw EncodingError.invalidValue(value, context)
        }
        
        return items
    }
    
    /// This method takes some data contained in a `_FormURLEncoderValueWrapper`
    /// and converts it into an array of `URLQueryItem` instances. This method
    /// is called recursively to encode all nested values in the wrapper.
    ///
    /// - Parameters:
    ///   - container:  The `_FormURLEncoderValueWrapper` instance to encode.
    ///   - key:        An optional, current key the value is being encoded for.
    /// - Returns:      An array of `URLQueryItem` instances, or `nil` if it
    ///                 couldn't be converted.
    fileprivate func _queryItems(from container: _FormURLEncoderValueWrapper, forKey key: String? = nil) -> [URLQueryItem]? {
        guard let rawValue = container.rawValue else { return nil }
        var list: [URLQueryItem] = []
        if let dictionary = rawValue as? [String: _FormURLEncoderValueWrapper] {
            let keys = Array(dictionary.keys).sorted { $0 < $1 }
            for thisKey in keys {
                guard let item = dictionary[thisKey] else { continue }
                var path: String {
                    if let thatKey = key {
                        return thatKey + "[" + thisKey + "]"
                    } else {
                        return thisKey
                    }
                }
                guard let converted = self._queryItems(from: item, forKey: path) else { continue }
                list.append(contentsOf: converted)
            }
            return list
        }
        guard let thisKey = key else { return nil }
        if let array = rawValue as? [_FormURLEncoderValueWrapper] {
            let path = thisKey + "[]"
            for item in array {
                guard let converted = self._queryItems(from: item, forKey: path) else { continue }
                list.append(contentsOf: converted)
            }
        } else {
            list.append(URLQueryItem(name: thisKey, value: "\(rawValue)"))
        }
        return list
    }
    
    // MARK: - Encoder Conformance Methods
    
    /// :nodoc:
    fileprivate func container<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        let topWrapper: _FormURLEncoderValueWrapper
        if self._canEncodeNewValue {
            topWrapper = self.storage._pushKeyedWrapper()
        } else {
            guard let container = self.storage._wrappers.last else {
                preconditionFailure("Attempt to push new keyed encoding container when already previously encoded at this path.")
            }
            
            topWrapper = container
        }
        
        let container = _FormURLKeyedEncodingContainer<Key>(referencing: self, codingPath: self.codingPath, wrapping: topWrapper)
        return KeyedEncodingContainer(container)
    }
    
    /// :nodoc:
    fileprivate func unkeyedContainer() -> UnkeyedEncodingContainer {
        let topWrapper: _FormURLEncoderValueWrapper
        if self._canEncodeNewValue {
            topWrapper = self.storage._pushUnkeyedWrapper()
        } else {
            guard let container = self.storage._wrappers.last else {
                preconditionFailure("Attempt to push new unkeyed encoding container when already previously encoded at this path.")
            }
            
            topWrapper = container
        }
        
        return _FormURLUnkeyedEncodingContainer(referencing: self, codingPath: self.codingPath, wrapping: topWrapper)
    }
    
    /// :nodoc:
    fileprivate func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
}

/// This extension on `_FormURLEncoder` adds `SingleValueEncodingContainer`
/// conformance.
extension _FormURLEncoder: SingleValueEncodingContainer {
    /// Pushes a new wrapper into storage.
    ///
    /// - Parameter wrapper: The new wrapper to add.
    fileprivate func _add(wrapper: _FormURLEncoderValueWrapper) {
        precondition(self._canEncodeNewValue, "Attempt to encode value through single value container when previously value already encoded.")
        self.storage._push(wrapper: wrapper)
    }
    
    /// Wraps an `Encodable` instance and adds it into storage.
    ///
    /// - Parameter value: The value to wrap and store.
    fileprivate func _encode(_ value: Encodable?) {
        self._add(wrapper: _FormURLEncoderValueWrapper(value))
    }
    
    /// :nodoc:
    fileprivate func encodeNil() throws { self._encode(nil) }
    
    /// :nodoc:
    fileprivate func encode(_ value: Bool) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: String) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: Double) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: Float) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: Int) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: Int8) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: Int16) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: Int32) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: Int64) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: UInt) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: UInt8) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: UInt16) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: UInt32) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode(_ value: UInt64) throws { self._encode(value) }
    
    /// :nodoc:
    fileprivate func encode<T>(_ value: T) throws where T: Encodable {
        let container: _FormURLEncoderValueWrapper = try self.box(value) ?? [:]
        self._add(wrapper: container)
    }
}

/// This extension on `_FormURLEncoder` adds methods for "boxing" a value, or in
/// otherwords, wrapping a value into the shared `_FormURLEncoderValueWrapper`
/// type. By boxing these values, we can later reliable convert them all to
/// `URLQueryItem` instances.
private extension _FormURLEncoder /* Boxing */ {
    /// Wraps an `Encodable` instance in a `_FormURLEncoderValueWrapper`. This
    /// method looks for specific types and handles them as necessary, such as
    /// `Date` and `Data` instances. In the case of a `Date`, the
    /// `dateEncodingStrategy` property will be taken into consideration. If the
    /// type can't be recognized, then this method will ask the instance to
    /// encode itself to this instance of `_FormURLEncoder`.
    ///
    /// - Parameter value:  The value to box.
    /// - Returns:          The value wrapped in a `_FormURLEncoderValueWrapper`
    ///                     instance, or `nil` if there was a problem boxing the
    ///                     value.
    /// - Throws:           Encoding errors can be thrown.
    func box<T: Encodable>(_ value: T) throws -> _FormURLEncoderValueWrapper? {
        if let date = value as? Date {
            switch self.dateEncodingStrategy {
            case .secondsSince1970:
                return _FormURLEncoderValueWrapper(date.timeIntervalSince1970)
                
            case .millisecondsSince1970:
                return _FormURLEncoderValueWrapper(date.timeIntervalSince1970 * 1000)
                
            case .iso8601:
                if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                    let formatter = ISO8601DateFormatter()
                    return _FormURLEncoderValueWrapper(formatter.string(from: date))
                } else {
                    fatalError("ISO8601DateFormatter is unavailable on this platform.")
                }
                
            case let .formatted(formatter):
                return _FormURLEncoderValueWrapper(formatter.string(from: date))
                
            case let .custom(closure):
                let depth = self.storage._count
                do {
                    try closure(date, self)
                } catch {
                    if self.storage._count > depth {
                        self.storage._popWrapper()
                    }
                    
                    throw error
                }
                
                guard self.storage._count > depth else {
                    return _FormURLEncoderValueWrapper([String: _FormURLEncoderValueWrapper]())
                }
                
                return self.storage._popWrapper()
                
            default:
                try date.encode(to: self)
                return self.storage._popWrapper()
            }
        } else if let url = value as? URL {
            return _FormURLEncoderValueWrapper(url.absoluteString)
        } else if let data = value as? Data {
            return _FormURLEncoderValueWrapper(data.base64EncodedString())
        } else {
            let depth = self.storage._count
            do {
                try value.encode(to: self)
            } catch {
                if self.storage._count > depth {
                    self.storage._popWrapper()
                }
                throw error
            }
            guard self.storage._count > depth else { return nil }
            return self.storage._popWrapper()
        }
    }
}

/// The `_FormURLUnkeyedEncodingContainer` struct functions as an unkeyed
/// encoding container.
private struct _FormURLUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    // MARK: - Properties
    
    /// :nodoc:
    public private(set) var codingPath: [CodingKey]
    
    /// The number of values in the container.
    public var count: Int {
        return self.container.rawArray?.count ?? 0
    }
    
    /// The main encoder of the container.
    fileprivate let encoder: _FormURLEncoder
    
    /// The wrapper representation that all new values get stored into.
    fileprivate let container: _FormURLEncoderValueWrapper
    
    // MARK: - Initialization
    
    /// Initializes the unkeyed container with an encoder, path, and wrapper.
    ///
    /// - Parameters:
    ///   - encoder:    The main encoder of the container.
    ///   - codingPath: The current coding path.
    ///   - container:  The wrapper to store new values in.
    fileprivate init(referencing encoder: _FormURLEncoder, codingPath: [CodingKey], wrapping container: _FormURLEncoderValueWrapper) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.container = container
    }
    
    // MARK: - Methods
    
    /// Adds a new wrapper into the `container`.
    ///
    /// - Parameter container: The new wrapper value to add.
    fileprivate mutating func _add(container: _FormURLEncoderValueWrapper) {
        self.container.rawArray?.append(container)
    }
    
    /// Adds a new `Encodable` instance into the `container`.
    ///
    /// - Parameter value: The value to append to the `container`.
    fileprivate mutating func _encode(_ value: Encodable?) {
        self._add(container: _FormURLEncoderValueWrapper(value))
    }
    
    // MARK: - UnkeyedEncodingContainer Conformance
    
    /// :nodoc:
    public mutating func encodeNil() throws { self._encode(nil) }
    
    /// :nodoc:
    public mutating func encode(_ value: Bool) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: Int) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: Int8) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: Int16) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: Int32) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: Int64) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt8) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt16) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt32) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt64) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: String) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: Double) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode(_ value: Float) throws { self._encode(value) }
    
    /// :nodoc:
    public mutating func encode<T>(_ value: T) throws where T: Encodable {
        self.encoder.codingPath.append(_FormURLKey(index: self.count))
        defer { self.encoder.codingPath.removeLast() }
        self.container.rawArray?.append(try self.encoder.box(value) ?? _FormURLEncoderValueWrapper(nil))
    }
    
    /// :nodoc:
    public mutating func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        self.codingPath.append(_FormURLKey(index: self.count))
        defer { self.codingPath.removeLast() }
        
        let dictionary: _FormURLEncoderValueWrapper = [:]
        self.container.rawArray?.append(dictionary)
        
        let container = _FormURLKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath, wrapping: dictionary)
        return KeyedEncodingContainer(container)
    }
    
    /// :nodoc:
    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        self.codingPath.append(_FormURLKey(index: self.count))
        defer { self.codingPath.removeLast() }
        let array: _FormURLEncoderValueWrapper = []
        self.container.rawArray?.append(array)
        return _FormURLUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath, wrapping: array)
    }
    
    /// :nodoc:
    public mutating func superEncoder() -> Encoder {
        return _FormURLReferencingEncoder(referencing: self.encoder, key: _FormURLKey(index: self.count), wrapping: self.container)
    }
}

/// The `_FormURLKeyedEncodingContainer` struct functions as a keyed encoding
/// container.
private struct _FormURLKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    // MARK: - Properties
    
    /// :nodoc:
    public private(set) var codingPath: [CodingKey]
    
    /// The main encoder of the container.
    fileprivate let encoder: _FormURLEncoder
    
    /// The wrapper representation that all new values get stored into.
    fileprivate let container: _FormURLEncoderValueWrapper
    
    // MARK: - Initialization
    
    /// Initializes the unkeyed container with an encoder, path, and wrapper.
    ///
    /// - Parameters:
    ///   - encoder:    The main encoder of the container.
    ///   - codingPath: The current coding path.
    ///   - container:  The wrapper to store new values in.
    fileprivate init(referencing encoder: _FormURLEncoder, codingPath: [CodingKey], wrapping container: _FormURLEncoderValueWrapper) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.container = container
    }
    
    // MARK: - Methods
    
    /// Adds a new value with a given key into the `container`.
    ///
    /// - Parameters:
    ///   - container:  The wrapped value to add.
    ///   - key:        The key to store the value at.
    fileprivate mutating func set(container: _FormURLEncoderValueWrapper, forKey key: String) {
        self.container.rawDictionary?[key] = container
    }
    
    /// Adds an `Encodable` instance into the `container` at a given key.
    ///
    /// - Parameters:
    ///   - value:  The value to add.
    ///   - key:    The key to store the value at.
    fileprivate mutating func set(value: Encodable?, forKey key: String) {
        let container = _FormURLEncoderValueWrapper(value)
        self.set(container: container, forKey: key)
    }
    
    // MARK: - KeyedEncodingContainerProtocol Conformance
    
    /// :nodoc:
    public mutating func encodeNil(forKey key: Key) throws {
        self.set(value: nil, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: Bool, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: String, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: Double, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: Float, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: Int, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: Int8, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: Int16, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: Int32, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: Int64, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt8, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt16, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt32, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode(_ value: UInt64, forKey key: Key) throws {
        self.set(value: value, forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        self.encoder.codingPath.append(key)
        defer { self.encoder.codingPath.removeLast() }
        self.set(container: try self.encoder.box(value) ?? _FormURLEncoderValueWrapper(nil), forKey: key.stringValue)
    }
    
    /// :nodoc:
    public mutating func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        let dictionary: _FormURLEncoderValueWrapper = [:]
        self.set(container: dictionary, forKey: key.stringValue)
        
        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }
        
        let container = _FormURLKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath, wrapping: dictionary)
        return KeyedEncodingContainer(container)
    }
    
    /// :nodoc:
    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let array: _FormURLEncoderValueWrapper = []
        self.set(container: array, forKey: key.stringValue)
        
        self.codingPath.append(key)
        defer { self.codingPath.removeLast() }
        return _FormURLUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath, wrapping: array)
    }
    
    /// :nodoc:
    public mutating func superEncoder() -> Encoder {
        return _FormURLReferencingEncoder(referencing: self.encoder, key: _FormURLKey.super, wrapping: self.container)
    }
    
    /// :nodoc:
    public mutating func superEncoder(forKey key: Key) -> Encoder {
        return _FormURLReferencingEncoder(referencing: self.encoder, key: key, wrapping: self.container)
    }
}

/// `_FormURLReferencingEncoder` is a special subclass of `_FormURLEncoder`
/// which has its own storage, but references the contents of a different
/// encoder.
///
/// It's used in `superEncoder()`, which returns a new encoder for encoding a
/// superclass -- the lifetime of the encoder should not escape the scope it's
/// created in, but it doesn't necessarily know when it's done being used (to
/// write to the original container).
private class _FormURLReferencingEncoder: _FormURLEncoder {
    // MARK: - Properties
    
    /// The main encoder this encoder is referencing.
    fileprivate let encoder: _FormURLEncoder
    
    /// The container reference itself.
    fileprivate let reference: _FormURLEncoderValueWrapper
    
    /// :nodoc:
    fileprivate let codingKey: CodingKey
    
    /// :nodoc:
    fileprivate override var _canEncodeNewValue: Bool {
        return self.storage._count == self.codingPath.count - self.encoder.codingPath.count - 1
    }
    
    // MARK: - Initialization
    
    /// Initializes `self` by referencing the given container in the given
    /// encoder.
    ///
    /// - Parameters:
    ///   - encoder:    The encoder this class is referencing.
    ///   - key:        The current coding key.
    ///   - container:  The value that's being wrapped.
    fileprivate init(referencing encoder: _FormURLEncoder, key: CodingKey, wrapping container: _FormURLEncoderValueWrapper) {
        self.encoder = encoder
        self.reference = container
        self.codingKey = key
        super.init(codingPath: encoder.codingPath, dateEncodingStrategy: encoder.dateEncodingStrategy)
        self.codingPath.append(self.codingKey)
    }
    
    /// Finalizes `self` by writing the contents of the storage to the
    /// referenced encoder's storage.
    deinit {
        let value: _FormURLEncoderValueWrapper
        switch self.storage._count {
        case 0:
            value = [:]
        case 1:
            value = self.storage._popWrapper()
        default:
            fatalError("Referencing encoder deallocated with multiple containers on stack.")
        }
        if self.reference.rawValue is [_FormURLEncoderValueWrapper], let index = self.codingKey.intValue {
            self.reference.rawArray?.insert(value, at: index)
        } else if self.reference.rawValue is [String: _FormURLEncoderValueWrapper] {
            self.reference.rawDictionary?[self.codingKey.stringValue] = value
        }
    }
}

/// This struct serves as the main CodingKey used when encoding and decoding.
private struct _FormURLKey: CodingKey {
    // MARK: - Properties
    
    /// :nodoc:
    fileprivate var stringValue: String
    
    /// :nodoc:
    fileprivate var intValue: Int?
    
    /// A CodingKey with a "super" `stringValue`.
    fileprivate static let `super` = _FormURLKey(stringValue: "super")!
    
    // MARK: - Initialization
    
    /// :nodoc:
    fileprivate init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    /// :nodoc:
    fileprivate init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    /// Initialize with an index that gets set as the `intValue` and
    /// `stringValue`.
    ///
    /// - Parameter index: An integer.
    fileprivate init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
}

/// The `_FormURLEncoderValueWrapper` class serves as a wrapper for a value that
/// needs to be encoded. By storing the values in this class, there is a shared
/// type that can be passed around for encoding purposes. Compare this to
/// `JSONEncoder` where `NSObject` was used as a shared type.
private class _FormURLEncoderValueWrapper: Encodable, ExpressibleByDictionaryLiteral, ExpressibleByArrayLiteral {
    /// :nodoc:
    fileprivate typealias RawValue = Encodable
    
    // MARK: - Properties
    
    /// The raw value that is being encoded.
    fileprivate var rawValue: RawValue?
    
    /// The `rawValue` returned as an Array of `_FormURLEncoderValueWrapper`
    /// instances, or `nil` if the raw value isn't an array.
    fileprivate var rawArray: [_FormURLEncoderValueWrapper]? {
        set {
            self.rawValue = newValue
        }
        get {
            return self.rawValue as? [_FormURLEncoderValueWrapper]
        }
    }
    
    /// The `rawValue` returned as an Dictionary of string keys and
    /// `_FormURLEncoderValueWrapper` instances, or `nil` if the raw value isn't
    /// a dictionary.
    fileprivate var rawDictionary: [String: _FormURLEncoderValueWrapper]? {
        set {
            self.rawValue = newValue
        }
        get {
            return self.rawValue as? [String: _FormURLEncoderValueWrapper]
        }
    }
    
    // MARK: - Initialization
    
    /// Initializes the wrapper with a value. The value can also be `nil` if
    /// you're trying to encode a `nil` value.
    ///
    /// - Parameter rawValue: The value to encode.
    fileprivate required init(_ rawValue: RawValue?) {
        self.rawValue = rawValue
    }
    
    /// Initializes the wrapper with a dictinoary literal.
    ///
    /// - Parameter elements: The dictionary to wrap.
    fileprivate required convenience init(dictionaryLiteral elements: (String, _FormURLEncoderValueWrapper)...) {
        var dictionary = [Key: Value]()
        for (key, value) in elements {
            dictionary[key] = value
        }
        self.init(dictionary)
    }
    
    /// Initializes the wrapper with an array literal.
    ///
    /// - Parameter elements:   The array to wrap. Each element in the array
    ///                         must be a `_FormURLEncoderValueWrapper` instance.
    fileprivate required convenience init(arrayLiteral elements: _FormURLEncoderValueWrapper...) {
        self.init(elements)
    }
    
    // MARK: - Methods
    
    /// :nodoc:
    fileprivate func encode(to encoder: Encoder) throws {
        try self.rawValue?.encode(to: encoder)
    }
}

/// The `_FormURLEncoderStorage` struct serves as a storage mechanism for the
/// encoder, keeping track of new values that are being encoded.
private struct _FormURLEncoderStorage {
    // MARK: - Properties
    
    /// The current stack of value wrappers in the storage.
    fileprivate var _wrappers: [_FormURLEncoderValueWrapper] = []
    
    /// The current number of items stored.
    fileprivate var _count: Int {
        return self._wrappers.count
    }
    
    // MARK: - Initialization
    
    /// Initializes the storage.
    fileprivate init() {}
    
    // MARK: - Methods
    
    /// Adds a new, empty dictionary wrapper to the stack and returns it.
    ///
    /// - Returns: A new, empty dictionary wrapper.
    fileprivate mutating func _pushKeyedWrapper() -> _FormURLEncoderValueWrapper {
        let wrapper: _FormURLEncoderValueWrapper = [:]
        self._wrappers.append(wrapper)
        return wrapper
    }
    
    /// Adds a new, empty array wrapper to the stack and returns it.
    ///
    /// - Returns: A new, empty array wrapper.
    fileprivate mutating func _pushUnkeyedWrapper() -> _FormURLEncoderValueWrapper {
        let wrapper: _FormURLEncoderValueWrapper = []
        self._wrappers.append(wrapper)
        return wrapper
    }
    
    /// Adds a new wrapper to the stack.
    ///
    /// - Parameter wrapper: The wrapper to add to the stack.
    fileprivate mutating func _push(wrapper: _FormURLEncoderValueWrapper) {
        self._wrappers.append(wrapper)
    }
    
    /// Removes and returns the last wrapper in the stack.
    ///
    /// - Returns: The last wrapper that was removed from the stack.
    @discardableResult
    fileprivate mutating func _popWrapper() -> _FormURLEncoderValueWrapper {
        precondition(!self._wrappers.isEmpty, "Empty container stack.")
        return self._wrappers.popLast()!
    }
}

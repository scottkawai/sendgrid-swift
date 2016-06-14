//
//  APIBlueprint.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `APIBlueprint` struct takes information about an `HTTPMessage`, and formats it into an [API Blueprint](https://APIBlueprint.org).
 
 */
public struct APIBlueprint: CustomStringConvertible {
    
    // MARK: - Properties
    //=========================================================================
    /// The HTTP Method.
    public let method: HTTPMethod
    
    /// The URL of the HTTP request or response.
    public let location: String
    
    /// The content type of the HTTP request or response.
    public let contentType: ContentType
    
    /// Indicates if this is a Request or a Response.
    public let type: MessageType
    
    /// Any headers in the HTTP request or response.
    public var headers: [String:String]?
    
    /// The body of the HTTP request or response.
    public var body: String?
    
    /// The status code of the response.
    public var statusCode: Int?
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the struct with all the properties.
     
     - parameter method:         The HTTP Method.
     - parameter location:       The URL of the HTTP request or response.
     - parameter contentType:    The content type of the HTTP request or response.
     - parameter type:           Indicates if this is a Request or a Response.
     - parameter headers:        Any headers in the HTTP request or response.
     - parameter body:           The body of the request or response.
     - parameter statusCode:     The status code of the response.
     
     */
    public init(method aMethod: HTTPMethod, location aLocation: String, contentType aContentType: ContentType, type aType: MessageType, headers someHeaders: [String : String]?, body aBody: String?, statusCode status: Int?) {
        self.method = aMethod
        self.location = aLocation
        self.contentType = aContentType
        self.type = aType
        self.headers = someHeaders
        self.statusCode = status
        self.body = aBody
    }
    
    /**
     
     Initializes the struct with all the properties.
     
     - parameter method:         The HTTP Method.
     - parameter location:       The URL of the HTTP request or response.
     - parameter contentType:    The content type of the HTTP request or response.
     - parameter type:           Indicates if this is a Request or a Response.
     - parameter headers:        Any headers in the HTTP request or response.
     - parameter parameters:     Any parameters in the HTTP request.
     - parameter statusCode:     The status code of the response.
     
     */
    public init(method aMethod: HTTPMethod, location aLocation: String, contentType aContentType: ContentType, type aType: MessageType, headers someHeaders: [String : String]?, parameters: AnyObject?, statusCode status: Int?) {
        var content: String?
        if let params = parameters where aMethod.hasBody {
            switch aContentType {
            case .FormUrlEncoded:
                content = ParameterEncoding.FormUrlEncoded(params).stringValue
            case .JSON:
                content = ParameterEncoding.PrettyJSON(params).stringValue
            default:
                content = nil
            }
        }
        self.init(method: aMethod, location: aLocation, contentType: aContentType, type: aType, headers: someHeaders, body: content, statusCode: status)
    }
    
    /**
     
     Initializes the struct with an instance of `Request`.
     
     - parameter resource:  The `Request` to make an API Blueprint out of.
     
     */
    init(request: Request) {
        var location = "/" + request.endpoint
        if let params = request.parameters,
            query = ParameterEncoding.FormUrlEncoded(params).stringValue
            where !request.method.hasBody
        {
            location += "?" + query
        }
        self.init(method: request.method, location: location, contentType: request.contentType, type: .Request, headers: request.messageHeaders, parameters: request.parameters, statusCode: nil)
    }
    
    /**
     
     Initializes the struct with an instance of `Response`.
     
     - parameter response:  The `Response` to make an API Blueprint out of.
     
     */
    init?(response: Response) {
        let content = response.contentType
        let resource = response.request
        var location = "/" + resource.endpoint
        if let params = resource.parameters,
            query = ParameterEncoding.FormUrlEncoded(params).stringValue
            where !resource.method.hasBody
        {
            location += "?" + query
        }
        var b: String?
        if let json = response.jsonValue where content.description == ContentType.JSON.description {
            b = ParameterEncoding.PrettyJSON(json).stringValue
        }
        self.init(method: resource.method, location: location, contentType: content, type: .Response, headers: response.messageHeaders, body: b, statusCode: response.statusCode)
    }
    
    // MARK: - Computed Properties
    //=========================================================================
    /// The title used in the API Blueprint.
    var title: String {
        return "# \(self.method.description) \(self.location)"
    }
    
    /// The section content used in the API Blueprint.
    var section: String {
        var components: [String] = ["+",self.type.rawValue]
        if let status = self.statusCode {
            components.append("\(status)")
        }
        components.append("(\(self.contentType.description))")
        return components.joinWithSeparator(" ")
    }
    
    /// The header info used in the API Blueprint.
    var headerInfo: String? {
        guard let head = self.headers where head.count > 0 else { return nil }
        var h: [String] = []
        for (key, value) in head {
            h.append("            \(key): \(value)")
        }
        return h.joinWithSeparator("\n")
    }
    
    /// The body info used in the API Blueprint.
    var bodyInfo: String? {
        return self.body?.componentsSeparatedByString("\n").map({"            \($0)"}).joinWithSeparator("\n")
    }
    
    /// The entire blueprint represented as a String.
    public var description: String {
        var contents: [String] = [
            self.title,
            self.section
        ]
        if let head = self.headerInfo {
            contents += [
                "    + Headers",
                head
            ]
        }
        if let b = self.bodyInfo {
            contents += [
                "    + Body",
                b
            ]
        }
        return contents.joinWithSeparator("\n\n")
    }
    
    /**
     
     The `MessageType` enum represents the two types of HTTP messages (requests and responses).
     
     */
    public enum MessageType: String {
        
        /// An HTTP request.
        case Request
        
        /// An HTTP response.
        case Response
    }
}
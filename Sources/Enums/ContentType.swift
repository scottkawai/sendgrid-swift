//
//  ContentType.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/13/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `ContentType` enum represents the common types of Content Types used when sending through the SendGrid API.
 
 */
public enum ContentType: CustomStringConvertible, Validatable {
    
    // MARK: - Cases
    //=========================================================================
    
    /// Represents "application/x-www-form-urlencoded" encodings.
    case FormUrlEncoded
    
    /// The "application/json" content type.
    case JSON
    
    /// The "text/plain" content type, used for the plain text portion of an email.
    case PlainText
    
    /// The "text/html" content type, used for the HTML portion of an email.
    case HTMLText
    
    /// The "application/csv" content type, used for CSV attachments.
    case CSV
    
    /// The "application/pdf" content type, used for PDF attachments.
    case PDF
    
    /// The "application/zip" content type, used for Zip file attachments.
    case Zip
    
    /// The "image/png" content type, used for PNG images.
    case PNG
    
    /// The "image/jpeg" content type, used for JPEG images.
    case JPEG
    
    /// A case used for any content type that isn't explicity stated in the enum.
    case Other(String)
    
    // MARK: - Properties
    //=========================================================================
    
    /// The string value of the content type.
    public var description: String {
        switch self {
        case .FormUrlEncoded:
            return "application/x-www-form-urlencoded"
        case .JSON:
            return "application/json"
        case .PlainText:
            return "text/plain"
        case .HTMLText:
            return "text/html"
        case .CSV:
            return "application/csv"
        case .PDF:
            return "application/pdf"
        case .Zip:
            return "application/zip"
        case .PNG:
            return "image/png"
        case .JPEG:
            return "image/jpeg"
        case .Other(let str):
            return str
        }
    }
    
    /// An index to make sure the content types are in the proper order.
    var index: Int {
        switch self {
        case .PlainText:
            return 0
        case .HTMLText:
            return 1
        default:
            return 2
        }
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the enum with a String representing the Content-Type.
     
     - parameter description:	A string representation of the Content-Type.
     
     */
    public init(description: String) {
        switch description {
        case "application/csv", "text/csv":
            self = .CSV
        case "application/json", "text/json":
            self = .JSON
        case "application/x-www-form-urlencoded":
            self = .FormUrlEncoded
        case "text/plain":
            self = .PlainText
        case "text/html":
            self = .HTMLText
        case "application/pdf":
            self = .PDF
        case "application/zip":
            self = .Zip
        case "image/png":
            self = .PNG
        case "image/jpeg":
            self = .JPEG
        default:
            self = .Other(description)
        }
    }
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates the content type's description.
     
     */
    public func validate() throws {
        if Validator.CLRFValidator(self.description).valid || self.description.characters.count == 0 {
            throw Error.Mail.InvalidContentType(self.description)
        }
    }
    
}
//
//  Error+Mail.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/9/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

public extension Error {
    
    /**
     
     The `Mail` enum contains all the errors thrown for the mail send API.
     
     */
    public enum Mail: ErrorType, CustomStringConvertible {
        
        // MARK: - Cases
        //=========================================================================
        
        /// The error thrown when an email address was expected, but received a String that isn't RFC 5322 compliant.
        case MalformedEmailAddress(String)
        
        /// The error thrown when an email is scheduled further than 72 hours out.
        case InvalidScheduleDate
        
        /// The error thrown if the subscription tracking setting is configured with text that doesn't contain a `<% %>` tag.
        case MissingSubscriptionTrackingTag
        
        /// The error thrown if a personalization doesn't have at least 1 recipient.
        case MissingRecipients
        
        /// The error thrown when the SpamChecker setting is provided a threshold outside the 1-10 range.
        case ThresholdOutOfRange(Int)
        
        /// The error thrown when more than 25 unsubscribe groups are provided in the `ASM` struct.
        case TooManyUnsubscribeGroups
        
        /// The error thrown if the number of personalizations in an email is less than 1 or more than 100.
        case InvalidNumberOfPersonalizations
        
        /// The error thrown if an email doesn't contain any content.
        case MissingContent
        
        /// The error thrown if a `Content` instance has an empty string value.
        case ContentHasEmptyString
        
        /// Thrown if the array of `Content` instances used in an `Email` instances is in an incorrect order.
        case InvalidContentOrder
        
        /// Thrown when an email contains too many recipients across all the `to`, `cc`, and `bcc` properties of the personalizations.
        case TooManyRecipients
        
        /// Thrown if an email does not contain a subject line.
        case MissingSubject
        
        /// Thrown if a reserved header was specified in the custom headers section.
        case HeaderNotAllowed(String)
        
        /// Thrown if a header's name contains spaces.
        case MalformedHeader(String)
        
        /// Thrown if there are more than 10 categories in an email.
        case TooManyCategories
        
        /// Thrown if a category name exceeds 255 characters.
        case CategoryTooLong(String)
        
        /// Thrown when there are too many substitutions.
        case TooManySubstitutions
        
        /// Thrown if a content type is used with a semicolon or CRLF character.
        case InvalidContentType(String)
        
        /// Thrown when an email address is listed multiple times in an email.
        case DuplicateRecipient(String)
        
        /// Thrown when the number of custom arguments exceeds 10,000 bytes.
        case TooManyCustomArguments(Int, String?)
        
        /// Thrown when an attachment's content ID contains invalid characters.
        case InvalidContentID(String)
        
        /// Thrown when an attachment's filename contains invalid characters.
        case InvalidFilename(String)
        
        // MARK: - Properties
        //=========================================================================
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .MalformedEmailAddress(let str):
                return "\"\(str)\" is not a valid email address. Please provide an RFC 5322 compliant email address."
            case .InvalidScheduleDate:
                return "An email cannot be scheduled further than 72 hours in the future."
            case .MissingSubscriptionTrackingTag:
                return "When specifying plain text and HTML text for the subscription tracking setting, you must include the `<% %>` tag to indicate where the unsubscribe URL should be placed."
            case .MissingRecipients:
                return "At least one recipient is required for a personalization."
            case .ThresholdOutOfRange(let i):
                return "The spam checker app only accepts a threshold which is between 1 and 10 (attempted to use \(i))"
            case .TooManyUnsubscribeGroups:
                return "The `ASM` struct can have no more than 25 unsubscribe groups to display."
            case .InvalidNumberOfPersonalizations:
                return "An `Email` must contain at least 1 personalization and cannot exceed \(Constants.PersonalizationLimit) personalizations."
            case .MissingContent:
                return "An `Email` must contain at least 1 `Content` instance."
            case .ContentHasEmptyString:
                return "The `value` property on `Content` must be a string at least one character in length."
            case .InvalidContentOrder:
                return "When specifying the content of an email, the plain text version must be first (if present), followed by the HTML version (if present), and then any other content."
            case .TooManyRecipients:
                return "Your `Email` instance contains too many recipients. The total number of recipients cannot exceed \(Constants.RecipientLimit) addresses. This includes all recipients defined within the `to`, `cc`, and `bcc` parameters, across each `Personalization` instance that you include in the personalizations array."
            case .MissingSubject:
                return "An `Email` instance must contain a subject line for every personalization, and the subject line must contain at least 1 character. You can either define a global subject on the `Email` instance, add a subject line in every `Personalization` instance, or specify a template ID that contains a subject."
            case .HeaderNotAllowed(let str):
                return "The \"\(str)\" header is a reserved header, and cannot be used in the `headers` property."
            case .MalformedHeader(let str):
                return "Invalid header \"\(str)\": When defining the headers that you would like to use, you must make sure that the header's name contains only ASCII characters and no spaces."
            case .TooManyCategories:
                return "You cannot have more than \(Constants.Categories.TotalLimit) categories associated with an email."
            case .CategoryTooLong(let str):
                return "A category cannot have more than \(Constants.Categories.CharacterLimit) characters (attempted to use category named \"\(str)\")."
            case .TooManySubstitutions:
                return "You cannot have more than \(Constants.SubstitutionLimit) substitutions in a personalization."
            case .InvalidContentType(let str):
                return "Invalid content type \"\(str)\": Content types cannot contain ‘;’, spaces, or CRLF characters, and must be at least 1 character long."
            case .DuplicateRecipient(let str):
                return "Each unique email address in the `personalizations` array should only be included once. You have included \"\(str)\" more than once."
            case .TooManyCustomArguments(let amount, let args):
                var error = "Each personalized email cannot have custom arguments exceeding \(Constants.CustomArguments.MaximumBytes) bytes. The email you're attempting to send has \(amount) bytes.  "
                if let a = args {
                    error += "The offending custom args are below:\n\n    \(a)"
                }
                return error
            case .InvalidContentID(let str):
                return "Invalid content ID \"\(str)\" for attachment: Content IDs cannot contain ‘;’, spaces, or CRLF characters, and must be at least 1 character long."
            case .InvalidFilename(let str):
                return "Invalid filename \"\(str)\" for attachment: Filenames cannot contain ‘;’, spaces, or CRLF characters, and must be at least 1 character long."
            }
        }
    }
}
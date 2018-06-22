//
//  EmptyResponse.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/21/18.
//

import Foundation

/// The `EmptyCodable` struct is used as the model type for any API call whose
/// response doesn't contain any body content, or for a request that doesn't
/// have any parameters that need to be encoded into the query or body. This
/// exists since the `ModelType` and `Parameters` are a required specification
/// when creating a request.
public struct EmptyCodable: Codable {}

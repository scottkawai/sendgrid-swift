//
//  XCTFailUnknownError.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/17/17.
//

import XCTest

func XCTFailUnknownError(_ error: Error) {
    XCTFail("An unexpected error was thrown: \(error)")
}

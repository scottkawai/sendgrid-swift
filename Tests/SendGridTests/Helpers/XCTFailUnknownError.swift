import XCTest

func XCTFailUnknownError(_ error: Error) {
    XCTFail("An unexpected error was thrown: \(error)")
}

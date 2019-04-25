@testable import SendGrid
import XCTest

class HTTPMethodTests: XCTestCase {
    func testDescription() {
        let map: [String: HTTPMethod] = [
            "GET": .GET,
            "POST": .POST,
            "PUT": .PUT,
            "PATCH": .PATCH,
            "DELETE": .DELETE
        ]
        map.forEach { method in
            XCTAssertEqual(method.key, method.value.description)
        }
    }
    
    func testHasBody() {
        XCTAssertFalse(HTTPMethod.GET.hasBody)
        
        XCTAssertTrue(HTTPMethod.POST.hasBody)
        XCTAssertTrue(HTTPMethod.PUT.hasBody)
        XCTAssertTrue(HTTPMethod.PATCH.hasBody)
        XCTAssertTrue(HTTPMethod.DELETE.hasBody)
    }
}

@testable import SendGrid
import XCTest

class RetrieveCategoryStatisticsTests: XCTestCase {
    func date(day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2017-09-\(day)")!
    }

    func testMinimalInitialization() {
        let request = RetrieveCategoryStatistics(startDate: date(day: 20), categories: "Foo")
        XCTAssertEqual(request.description, """
        # GET /v3/categories/stats?categories%5B%5D=Foo&start_date=2017-09-20

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

        """)
    }

    func testMaxInitialization() {
        let request = RetrieveCategoryStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, categories: "Foo", "Bar")
        XCTAssertEqual(request.description, """
        # GET /v3/categories/stats?aggregated_by=week&categories%5B%5D=Foo&categories%5B%5D=Bar&end_date=2017-09-27&start_date=2017-09-20

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

        """)
    }

    func testValidation() {
        let good = RetrieveCategoryStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, categories: "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
        XCTAssertNoThrow(try good.validate())

        do {
            let under = RetrieveCategoryStatistics(startDate: date(day: 20), categories: [])
            try under.validate()
        } catch SendGrid.Exception.Statistic.invalidNumberOfCategories {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }

        do {
            let over = RetrieveCategoryStatistics(startDate: date(day: 20), categories: "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven")
            try over.validate()
        } catch SendGrid.Exception.Statistic.invalidNumberOfCategories {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }

        do {
            let request = RetrieveCategoryStatistics(startDate: date(day: 20), endDate: date(day: 19))
            try request.validate()
            XCTFail("Expected a failure to be thrown when the end date is before the start date, but nothing was thrown.")
        } catch SendGrid.Exception.Statistic.invalidEndDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
}

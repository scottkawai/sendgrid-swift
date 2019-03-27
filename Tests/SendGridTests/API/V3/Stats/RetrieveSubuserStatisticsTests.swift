import SendGrid
import XCTest

class RetrieveSubuserStatisticsTests: XCTestCase {
    func date(day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2017-09-\(day)")!
    }

    func testMinimalInitialization() {
        let request = RetrieveSubuserStatistics(startDate: date(day: 20), subusers: "foo")
        XCTAssertEqual(request.description, """
        # GET /v3/subusers/stats?start_date=2017-09-20&subusers%5B%5D=foo

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

        """)

        let testSub = Subuser(id: 1, username: "foo", email: "foobar@example.nonet", disabled: false)
        let subRequest = RetrieveSubuserStatistics(startDate: date(day: 20), subusers: testSub)
        XCTAssertEqual(subRequest.description, """
        # GET /v3/subusers/stats?start_date=2017-09-20&subusers%5B%5D=foo

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

        """)
    }

    func testMaxInitialization() {
        let request = RetrieveSubuserStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, subusers: "Foo", "Bar")
        XCTAssertEqual(request.description, """
        # GET /v3/subusers/stats?aggregated_by=week&end_date=2017-09-27&start_date=2017-09-20&subusers%5B%5D=Foo&subusers%5B%5D=Bar

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

        """)
    }

    func testValidation() {
        let good = RetrieveSubuserStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, subusers: "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
        XCTAssertNoThrow(try good.validate())

        do {
            let under = RetrieveSubuserStatistics(startDate: date(day: 20), subusers: [String]())
            try under.validate()
        } catch SendGrid.Exception.Statistic.invalidNumberOfSubusers {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }

        do {
            let over = RetrieveSubuserStatistics(startDate: date(day: 20), subusers: "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven")
            try over.validate()
        } catch SendGrid.Exception.Statistic.invalidNumberOfSubusers {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }

        do {
            let request = RetrieveSubuserStatistics(startDate: date(day: 20), endDate: date(day: 19), subusers: "one", "two", "three")
            try request.validate()
            XCTFail("Expected a failure to be thrown when the end date is before the start date, but nothing was thrown.")
        } catch SendGrid.Exception.Statistic.invalidEndDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
}

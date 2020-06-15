@testable import SendGrid
import XCTest

class RetrieveClientStatisticsTests: XCTestCase {
    func date(day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2017-09-\(day)")!
    }

    func testMinimalInitialization() {
        let request = RetrieveClientStatistics(startDate: date(day: 20))
        XCTAssertEqual(request.description, """
        # GET /v3/clients/stats?start_date=2017-09-20

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

        """)
    }

    func testMaxInitialization() {
        let request = RetrieveClientStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week)
        XCTAssertEqual(request.description, """
        # GET /v3/clients/stats?aggregated_by=week&end_date=2017-09-27&start_date=2017-09-20

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

        """)

        let clientRequest = RetrieveClientStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, client: .tablet)
        XCTAssertEqual(clientRequest.description, """
        # GET /v3/clients/tablet/stats?aggregated_by=week&end_date=2017-09-27&start_date=2017-09-20

        + Request (application/json)

            + Headers

                    Accept: application/json
                    Content-Type: application/json

        """)
    }

    func testValidation() {
        let good = RetrieveClientStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week)
        XCTAssertNoThrow(try good.validate())

        do {
            let request = RetrieveClientStatistics(startDate: date(day: 20), endDate: date(day: 19))
            try request.validate()
            XCTFail("Expected a failure to be thrown when the end date is before the start date, but nothing was thrown.")
        } catch SendGrid.Exception.Statistic.invalidEndDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
}
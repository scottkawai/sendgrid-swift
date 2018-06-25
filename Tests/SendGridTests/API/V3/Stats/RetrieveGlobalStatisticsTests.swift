//
//  RetrieveGlobalStatisticsTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/20/17.
//

import XCTest
@testable import SendGrid

class RetrieveGlobalStatisticsTests: XCTestCase {
    
    func date(day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2017-09-\(day)")!
    }
    
    func testMinimalInitialization() {
        let request = RetrieveGlobalStatistics(startDate: date(day: 20))
        XCTAssertEqual(request.description, """
        # GET /v3/stats?start_date=2017-09-20

        + Request (application/json)

            + Headers

                    Content-Type: application/json
                    Accept: application/json

        """)
    }
    
    func testMaxInitialization() {
        let request = RetrieveGlobalStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week)
        XCTAssertEqual(request.description, """
        # GET /v3/stats?start_date=2017-09-20&end_date=2017-09-27&aggregated_by=week

        + Request (application/json)

            + Headers

                    Content-Type: application/json
                    Accept: application/json

        """)
    }
    
    func testValidation() {
        let good = RetrieveGlobalStatistics(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week)
        XCTAssertNoThrow(try good.validate())
        
        do {
            let request = RetrieveGlobalStatistics(startDate: date(day: 20), endDate: date(day: 19))
            try request.validate()
            XCTFail("Expected a failure to be thrown when the end date is before the start date, but nothing was thrown.")
        } catch SendGrid.Exception.Statistic.invalidEndDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}

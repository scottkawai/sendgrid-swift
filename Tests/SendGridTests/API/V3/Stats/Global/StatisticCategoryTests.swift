//
//  StatisticCategoryTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/20/17.
//

import XCTest
@testable import SendGrid

class StatisticCategoryTests: XCTestCase {
    
    func date(day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2017-09-\(day)")!
    }
    
    func testMinimalInitialization() {
        let request = Statistic.Category(startDate: date(day: 20), categories: "Foo")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/categories/stats?start_date=2017-09-20&categories=Foo")
    }
    
    func testMaxInitialization() {
        let request = Statistic.Category(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, categories: "Foo", "Bar")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/categories/stats?start_date=2017-09-20&end_date=2017-09-27&aggregated_by=week&categories=Foo&categories=Bar")
    }
    
    func testValidation() {
        do {
            let request = Statistic.Category(startDate: date(day: 20), endDate: date(day: 19))
            try request.validate()
            XCTFail("Expected a failure to be thrown when the end date is before the start date, but nothing was thrown.")
        } catch SendGrid.Exception.Statistic.invalidEndDate {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
    }
    
}

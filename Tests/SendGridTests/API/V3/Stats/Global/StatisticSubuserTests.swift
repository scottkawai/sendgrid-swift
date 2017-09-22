//
//  StatisticSubuserTests.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/22/17.
//

import XCTest
import SendGrid

class StatisticSubuserTests: XCTestCase {
    
    func date(day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: "2017-09-\(day)")!
    }
    
    func testMinimalInitialization() {
        let request = Statistic.Subuser(startDate: date(day: 20), subusers: "foo")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/subusers/stats?start_date=2017-09-20&subusers=foo")
    }
    
    func testMaxInitialization() {
        let request = Statistic.Subuser(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, subusers: "Foo", "Bar")
        XCTAssertEqual(request.endpoint?.string, "https://api.sendgrid.com/v3/subusers/stats?start_date=2017-09-20&end_date=2017-09-27&aggregated_by=week&subusers=Foo&subusers=Bar")
    }
    
    func testValidation() {
        let good = Statistic.Subuser(startDate: date(day: 20), endDate: date(day: 27), aggregatedBy: .week, subusers: "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten")
        XCTAssertNoThrow(try good.validate())
        
        do {
            let under = Statistic.Subuser(startDate: date(day: 20), subusers: [])
            try under.validate()
        } catch SendGrid.Exception.Statistic.invalidNumberOfSubusers {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
        do {
            let over = Statistic.Subuser(startDate: date(day: 20), subusers: "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven")
            try over.validate()
        } catch SendGrid.Exception.Statistic.invalidNumberOfSubusers {
            XCTAssertTrue(true)
        } catch {
            XCTFailUnknownError(error)
        }
        
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

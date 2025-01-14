//
//  Array+RecoveryTests.swift
//
//
//  Created by Fatih Karakurt on 25.04.22.
//

@testable import CovPassCommon

import Foundation
import XCTest

class ArrayRevoceryTests: XCTestCase {
    
    var sut: [Recovery]!
    
    override func setUpWithError() throws {
        sut = [Recovery(tg: "", fr: Date() - 100, df: Date(), du: Date(), co: "", is: "", ci: "1"),
               Recovery(tg: "", fr: Date() + 10, df: Date(), du: Date(), co: "", is: "", ci: "2"),
               Recovery(tg: "", fr: Date() + 100, df: Date(), du: Date(), co: "", is: "", ci: "3"),
               Recovery(tg: "", fr: Date() - 500, df: Date(), du: Date(), co: "", is: "", ci: "4")]
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }


    func testOldestVaccination() {
        // WHEN
        let latestRecovery = sut.latestRecovery
        
        // THEN
        XCTAssertEqual(latestRecovery?.ci, "3")
    }
}


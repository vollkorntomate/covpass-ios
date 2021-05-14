//
//  QRCoderTests.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import Foundation
import XCTest

@testable import VaccinationCommon

class QRCoderTests: XCTestCase {
    var sut: QRCoder!

    override func setUp() {
        super.setUp()
        sut = QRCoder()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testParseValidCertificate() {
        do {
            let res = try sut.parse(CertificateMock.validCertificate).wait()
            XCTAssertEqual(res.iss, "DE")
        } catch {
            XCTFail("Parse should succeed")
        }
    }

    func testParseValidCertificateWithNoPrefix() {
        do {
            let res = try sut.parse(CertificateMock.validCertificateNoPrefix).wait()
            XCTAssertEqual(res.iss, "DE")
        } catch {
            XCTFail("Parse should succeed")
        }
    }

    func testParseInvalidCertificate() {
        do {
            _ = try sut.parse(CertificateMock.invalidCertificate).wait()
            XCTFail("Parse should fail")
        } catch {
            XCTAssertEqual(error.localizedDescription, CoseParsingError.wrongType.localizedDescription)
        }
    }

    func testParseInvalidCertificateWithOldFormat() {
        do {
            _ = try sut.parse(CertificateMock.invalidCertificateOldFormat).wait()
            XCTFail("Parse should fail")
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
        }
    }
}
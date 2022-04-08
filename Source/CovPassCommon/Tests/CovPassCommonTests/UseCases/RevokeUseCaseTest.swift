//
//  RevokeUseCaseTest.swift
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import CovPassCommon

class RevokeUseCaseTest: XCTestCase {
    
    var sut: RevokeUseCase!
    var revocationRepository: CertificateRevocationRepositoryMock!

    override func setUpWithError() throws {
        let token = CBORWebToken.mockVaccinationCertificate.mockVaccinationUVCI("FOO").extended()
        revocationRepository = CertificateRevocationRepositoryMock()
        sut = RevokeUseCase(token: token,
                            revocationRepository: revocationRepository)
    }
    
    override func tearDownWithError() throws {
        revocationRepository = nil
        sut = nil
    }
    
    func test_isNotRevoked() {
        // GIVEN
        let testExpectation = XCTestExpectation()
        revocationRepository.isRevoked = false
        // WHEN
        sut.execute().done { token in
            // THEN
            XCTAssertNotNil(token)
            XCTAssertTrue(token.vaccinationCertificate.isVaccination)
            XCTAssertEqual(token.vaccinationCertificate.hcert.dgc.uvci, "FOO")
            XCTAssertEqual(token.isInvalid, false)
            testExpectation.fulfill()
        }
        .catch { error in
            XCTFail("Should not fail")
        }
        wait(for: [revocationRepository.isRevokedExpectation,
                   testExpectation],
             timeout: 0.1,
             enforceOrder: true)
    }
    
    func test_isRevoked() {
        // GIVEN
        let testExpectation = XCTestExpectation()
        revocationRepository.isRevoked = true
        // WHEN
        sut.execute().done { token in
            // THEN
            XCTFail("Should fail")
        }
        .catch { error in
            testExpectation.fulfill()
        }
        wait(for: [revocationRepository.isRevokedExpectation,
                   testExpectation],
             timeout: 0.1,
             enforceOrder: true)
    }
}

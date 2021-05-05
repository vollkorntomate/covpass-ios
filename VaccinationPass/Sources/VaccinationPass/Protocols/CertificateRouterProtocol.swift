//
//  CertificateRouterProtocol.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import UIKit
import PromiseKit
import VaccinationUI
import VaccinationCommon
import Scanner

public protocol CertificateRouterProtocol: RouterProtocol {
    func showCertificates(_ certificates: [ExtendedVaccinationCertificate])
    func showProof() -> Promise<Void>
    func scanQRCode() -> Promise<Swift.Result<String, ScanError>>
}
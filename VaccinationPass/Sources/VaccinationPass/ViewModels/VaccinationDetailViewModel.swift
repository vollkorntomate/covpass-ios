//
//  VaccinationDetailViewModel.swift
//  
//
//  Copyright © 2021 IBM. All rights reserved.
//

import UIKit
import VaccinationUI
import VaccinationCommon
import PromiseKit

public struct VaccinationDetailViewModel {

    private var service = VaccinationCertificateService()

    private var certificates: [ExtendedVaccinationCertificate]

    public init(certificates: [ExtendedVaccinationCertificate]) {
        self.certificates = certificates
    }

    public var partialVaccination: Bool {
        return certificates.map({ $0.vaccinationCertificate.partialVaccination }).first(where: { !$0 }) ?? true
    }

    public var isFavorite: Bool {
        do {
            let certList = try service.fetch().wait()
            for cert in certificates where cert.vaccinationCertificate.id == certList.favoriteCertificateId {
                return true
            }
            return false
        } catch {
            print(error)
            return false
        }
    }

    public var name: String {
        return certificates.first?.vaccinationCertificate.name ?? ""
    }

    public var birthDate: String {
        guard let date = certificates.first?.vaccinationCertificate.birthDate else { return "" }
        return DateUtils.displayDateFormatter.string(from: date)
    }
    
    public var immunizationIcon: UIImage? {
        return UIImage(named: partialVaccination ? "status_partial" : "status_full", in: UIConstants.bundle, compatibleWith: nil)
    }
    
    public var immunizationTitle: String {
        return partialVaccination ? "vaccination_detail_immunization_partial_title".localized : "vaccination_detail_immunization_full_title".localized
    }
    
    public var immunizationBody: String {
        return partialVaccination ? "vaccination_detail_immunization_1_body".localized : "vaccination_detail_immunization_2_body".localized
    }
    
    public var immunizationButton: String {
        return partialVaccination ? "vaccination_detail_immunization_1_button".localized : "vaccination_detail_immunization_2_button".localized
    }

    public var vaccinations: [VaccinationViewModel] {
        return certificates.map({ VaccinationViewModel(certificate: $0.vaccinationCertificate) })
    }

    public func delete() -> Promise<Void> {
        service.fetch().then({ list -> Promise<VaccinationCertificateList> in
            var certList = list
            certList.certificates.removeAll(where: { certificate in
                for cert in self.certificates where cert == certificate {
                    return true
                }
                return false
            })
            return Promise.value(certList)
        }).then({ list in
            service.save(list)
        })
    }

    public func updateFavorite() -> Promise<Void> {
        return service.fetch().map({ cert in
            var certList = cert
            guard let id = certificates.first?.vaccinationCertificate.id else {
                return certList
            }
            if certList.favoriteCertificateId == id {
                certList.favoriteCertificateId = ""
            } else {
                certList.favoriteCertificateId = id
            }
            return certList
        }).then({ cert in
            return service.save(cert)
        })
    }
}

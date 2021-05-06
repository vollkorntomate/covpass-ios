//
//  DigitalGreenCertificate.swift
//  
//
//  Copyright © 2021 IBM. All rights reserved.
//

import Foundation

public struct DigitalGreenCertificate: Codable {
    // Person name: Surname(s), given name(s) - in that order
    public var nam: Name
    // Date of Birth of the person addressed in the DGC. ISO 8601 date format restricted to range 1900-2099"
    public var dob: Date?
    // Vaccination Group (may contain multiple entries)
    public var v: [Vaccination]
    // Version of the schema, according to Semantic versioning (ISO, https://semver.org/ version 2.0.0 or newer)"
    public var ver: String

    // True if full immunization is given
    public var fullImmunization: Bool { v.first?.fullImmunization ?? false }

    enum CodingKeys: String, CodingKey {
        case nam
        case dob
        case v
        case ver
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nam = try values.decode(Name.self, forKey: .nam)
        if let dobDateString = try? values.decode(String.self, forKey: .dob) {
            dob = DateUtils.vaccinationDateFormatter.date(from: dobDateString)
        }
        v = try values.decode([Vaccination].self, forKey: .v)
        ver = try values.decode(String.self, forKey: .ver)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nam, forKey: .nam)
        if let dob = dob {
            let dateString = DateUtils.vaccinationDateFormatter.string(from: dob)
            try container.encode(dateString, forKey: .dob)
        }
        try container.encode(v, forKey: .v)
        try container.encode(ver, forKey: .ver)
    }
}

extension DigitalGreenCertificate: Equatable {
    public static func == (lhs: DigitalGreenCertificate, rhs: DigitalGreenCertificate) -> Bool {
        return lhs.nam == rhs.nam && lhs.dob == rhs.dob
    }
}
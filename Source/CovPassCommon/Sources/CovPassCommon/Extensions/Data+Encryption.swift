//
//  Data+Encryption.swift
//  
//
//  Created by Thomas Kuleßa on 17.03.22.
//

import Foundation
import Security

public extension Data {
    func encrypt(with key: SecKey, algoritm: SecKeyAlgorithm) throws -> Data {
        var error: Unmanaged<CFError>?
        let cfData = self as CFData
        guard SecKeyIsAlgorithmSupported(key, .encrypt, algoritm) else {
            throw EncryptionError()
        }
        guard let cipherData = SecKeyCreateEncryptedData(key, algoritm, cfData, &error) as? Data else {
            throw EncryptionError()
        }
        return cipherData
    }
}

public struct EncryptionError: Error {}

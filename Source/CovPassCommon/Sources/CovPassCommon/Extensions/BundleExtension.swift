//
//  BundleExtension.swift
//
//
//  © Copyright IBM Deutschland GmbH 2021
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

public extension Bundle {
    static var commonBundle: Bundle {
        Bundle.module
    }
}

#if !SPM
extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static let module: Bundle = {
        let bundleName = "Frameworks/CovPassCommon.framework"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName)
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named CovPassCommon_CovPassCommon")
    }()
}
#endif

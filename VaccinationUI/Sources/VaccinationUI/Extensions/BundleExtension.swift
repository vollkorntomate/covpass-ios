//
//  BundleExtension.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import Foundation

public extension Bundle {
    static var uiBundle: Bundle {
        Bundle.module
    }
}
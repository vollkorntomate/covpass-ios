//
//  CertificateItemViewModel.swift
//  
//
//  Created by Timo Koenig on 08.06.21.
//

import Foundation
import UIKit
import CovPassCommon

public protocol CertificateItemViewModel {
    var icon: UIImage { get }
    var iconColor: UIColor { get }
    var iconBackgroundColor: UIColor { get }
    var title: String { get }
    var subtitle: String { get }
    var info: String { get }
    var activeTitle: String? { get }
    init(_ certificate: ExtendedCBORWebToken)
}
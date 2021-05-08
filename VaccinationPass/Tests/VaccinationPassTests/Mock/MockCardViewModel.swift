//
//  MockCardViewModel.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import UIKit
import VaccinationUI

struct MockCardViewModel: CardViewModel {
    var delegate: ViewModelDelegate?
    
    var reuseIdentifier: String {
        "\(MockCardViewModel.self)"
    }

    var backgroundColor: UIColor {
        .black
    }
}
//
//  OnboardingPageViewModel.swift
//  
//
//  Copyright © 2021 IBM. All rights reserved.
//

import UIKit

public enum OnboardingPageViewModelType: CaseIterable {
    case page1
    case page2
    case page3
}

public class OnboardingPageViewModel {
    var type: OnboardingPageViewModelType

    public init(type: OnboardingPageViewModelType) {
        self.type = type
    }

    var image: UIImage? {
        switch type {
        case .page1:
            return UIImage(named: UIConstants.IconName.OnboardingScreen1, in: UIConstants.bundle, compatibleWith: nil)
        case .page2:
            return UIImage(named: UIConstants.IconName.OnboardingScreen2, in: UIConstants.bundle, compatibleWith: nil)
        case .page3:
            return UIImage(named: UIConstants.IconName.OnboardingScreen3, in: UIConstants.bundle, compatibleWith: nil)
        }
    }

    var title: String {
        switch type {
        case .page1:
            return "Nach der Impfung erhalten Sie ihre Impfbescheinigung mit QR-Code"
        case .page2:
            return "Scannen Sie mit der App den QR-Code auf Ihrer Impfbescheinigung"
        case .page3:
            return "Weisen Sie Ihren Impfschutz schnnell und sicher mit dem Impfticket nach"
        }
    }

    var info: String {
        switch type {
        case .page1:
            return "Gut zu wissen: Sie können den QR-Code nur ein mal verwenden. Die Impfbescheinigung ist anschließend an das einlesende Smartphone gebunden."
        case .page2:
            return "Tipp: Speichern Sie Impfbescheinigungen von der ganzen Familie zusammen auf einem Smartphone und verwalten Sie diese sicher mit der App."
        case .page3:
            return "Sobald Ihr Impfschutz vollständig ist, erstellt die App automatisch einen Nachweis mit QR-Code. Dieses Impfticket enthält nur die nötigsten Daten. Zeigen Sie es zum Beispiel bei Flugreisen vor."
        }
    }

    // MARK: - Settings

    var imageAspectRatio: CGFloat { 375 / 220 }
    var imageWidth: CGFloat { UIScreen.main.bounds.width }
    var imageHeight: CGFloat { imageWidth / imageAspectRatio }
    var imageContentMode: UIView.ContentMode { .scaleAspectFit }
    var headlineFont: UIFont { UIConstants.Font.onboardingHeadlineFont }
    var headlineColor: UIColor { .black }
    var paragraphBodyFont: UIFont { UIConstants.Font.regularLarger }
    var backgroundColor: UIColor { UIConstants.BrandColor.backgroundPrimary }
}

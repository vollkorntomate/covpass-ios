import Foundation
import UIKit
import CovPassCommon
import PromiseKit

private enum Constants {
    enum Keys {
        static var title = "certificate_renewal_confirmation_page_headline".localized(bundle: .main)
        static var subTitle = "renewal_expiry_success_copy".localized(bundle: .main)
        static var submitButton = "renewal_expiry_success_button".localized(bundle: .main)
    }
}

public class ResultViewViewModel: ResultViewViewModelProtocol {
    
    public var image = UIImage.successLarge
    public var title = Constants.Keys.title
    public var description = Constants.Keys.subTitle
    public var buttonTitle = Constants.Keys.submitButton
    private var router: ResultViewRouterProtocol
    private var resolver: Resolver<Void>

    public init (router: ResultViewRouterProtocol,
                 resolver: Resolver<Void>) {
        self.router = router
        self.resolver = resolver
    }
    
    public func submitTapped() {
        resolver.fulfill_()
    }
}

import CovPassUI
import CovPassCommon
import PromiseKit
import UIKit

private enum Constants {
    enum Text {
        enum Alert {
            enum Cancellation {
                static let message = "cancellation_share_certificate_title".localized
                static let ok = "cancellation_share_certificate_action_button_no".localized
                static let cancel = "cancellation_share_certificate_action_button_yes".localized
            }
        }
    }
}

class ReissueConsentRouter: ReissueConsentRouterProtocol, DialogRouterProtocol {

    // MARK: - Properties

    let sceneCoordinator: SceneCoordinator

    // MARK: - Lifecycle

    init(sceneCoordinator: SceneCoordinator) {
        self.sceneCoordinator = sceneCoordinator
    }

    // MARK: - Methods
    
    func showReissueResultPage(newTokens: [ExtendedCBORWebToken],
                               oldTokens: [ExtendedCBORWebToken],
                               resolver: Resolver<Void>){
        sceneCoordinator
            .push(ReissueResultSceneFactory(router: ReissueResultRouter(sceneCoordinator: sceneCoordinator),
                                            newTokens: newTokens,
                                            oldTokens: oldTokens,
                                            resolver: resolver))
    }
    
    func showGenericResultPage(resolver: Resolver<Void>) {
        sceneCoordinator
            .push(ResultViewSceneFactory(router: ResultViewRouter(sceneCoordinator: sceneCoordinator), resolver: resolver))
    }
    
    func cancel(resolver: Resolver<Void>) {
        showDialog(title: "",
                   message: Constants.Text.Alert.Cancellation.message,
                   actions: [
                    DialogAction(title: Constants.Text.Alert.Cancellation.ok, style: UIAlertAction.Style.default, isEnabled: true, completion: { _ in }),
                    DialogAction(title: Constants.Text.Alert.Cancellation.cancel, style: UIAlertAction.Style.destructive, isEnabled: true, completion: { [weak self] _ in
                        resolver.fulfill_()
                        self?.sceneCoordinator.dimiss(animated: true)
                    })],
                   style: .alert)
    }
    
    func routeToPrivacyStatement() {
        sceneCoordinator
            .present(DataPrivacySceneFactory(router: DataPrivacyRouter(sceneCoordinator: sceneCoordinator)))
            .cauterize()
    }

    func showError(title: String, message: String, faqURL: URL) {
        let okAction = DialogAction(
            title: "certificate_renewal_error_button_primary".localized,
            style: .default
        )
        let faqAction = DialogAction(
            title: "certificate_renewal_error_button_secondary".localized,
            style: .none,
            isEnabled: true) { [weak self] _ in
                self?.showURL(faqURL)
            }

        showDialog(
            title: title,
            message: message,
            actions: [okAction, faqAction],
            style: .alert
        )
    }

    func showURL(_ url: URL) {
        let application = UIApplication.shared
        if application.canOpenURL(url) {
            application.open(url)
        }
    }
}

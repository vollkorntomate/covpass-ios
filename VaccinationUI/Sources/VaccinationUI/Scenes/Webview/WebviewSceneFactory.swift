//
//  WebviewSceneFactory.swift
//
//
//  Copyright © 2021 IBM. All rights reserved.
//

import UIKit

public struct WebviewSceneFactory: SceneFactory {
    // MARK: - Properties

    public let title: String
    public let url: URL

    // MARK: - Lifecycle

    public init(
        title: String,
        url: URL
    ) {
        self.title = title
        self.url = url
    }

    public func make() -> UIViewController {
        let viewModel = WebviewViewModel(title: title, url: url)
        let viewController = WebviewViewController(viewModel: viewModel)

        return viewController
    }
}
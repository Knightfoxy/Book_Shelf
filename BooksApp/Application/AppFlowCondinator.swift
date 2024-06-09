//
//  AppFlowCondinator.swift
//  BooksApp
//
//  Created by Ayush on 04/04/24.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let booksSceneDIContainer = appDIContainer.makeBooksSceneDIContainer()
        let flow = booksSceneDIContainer.makeBooksSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
    
}


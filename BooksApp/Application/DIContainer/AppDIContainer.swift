//
//  AppDIContainer.swift
//  BooksApp
//
//  Created by Ayush on 04/04/24.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "apiBaseURL": appConfiguration.apiBaseURL,
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
//    // MARK: - DIContainers of scenes
    func makeBooksSceneDIContainer() -> BooksSceneDIContainer {
        let dependencies = BooksSceneDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService
        )
        return BooksSceneDIContainer(dependencies: dependencies)
    }
}

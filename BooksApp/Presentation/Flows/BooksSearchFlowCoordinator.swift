//
//  BooksSearchFlowCordinator.swift
//  BooksApp
//
//  Created by Ayush on 04/04/24.
//

import Foundation
import UIKit

protocol BooksSceneFlowCordinatorDependencies {
    func makeBookListViewController(_ actions: BooksListViewModelActions) -> ViewController
    func makeBookDetailViewController(book: Book) -> UIViewController
    func makeBooksQueriesSuggestionsListViewController() -> UIViewController
}

final class BooksSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: BooksSceneFlowCordinatorDependencies

    private weak var booksListVC: ViewController?
    
    init(navigationController: UINavigationController,
         dependencies: BooksSceneFlowCordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = BooksListViewModelActions(showBookDetails: showBookDetails)
        let vc = dependencies.makeBookListViewController(actions)
        navigationController?.pushViewController(vc, animated: false)
        booksListVC = vc
    }
    
    private func showBookDetails(book: Book) {
        let vc = dependencies.makeBookDetailViewController(book: book)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        let transition = transition()
        self.navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func moveToSearchBooksVC() {
        let vc = dependencies.makeBooksQueriesSuggestionsListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func transition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        transition.type = CATransitionType.fade
        
        return transition
    }
    
}

import Combine
import UIKit

class ApplicationCoordinator: BaseCoordinator<Void, Never> {
    private let tabBarController: TabBarController

    init(tabBarController: TabBarController) {
        self.tabBarController = tabBarController
    }

    override func run() {
        configureTabBarModule()
    }
}

// MARK: - Modules

extension ApplicationCoordinator {
    private func configureTabBarModule() {
        tabBarController.viewControllers = [quotesModule(), favouritesQuotesModule()]
        tabBarController.completion.sink { completion in
            switch completion {
            case .quotesModuleOpened(let viewController):
                (viewController as? QuotesViewController)?.scrollToTop()
            case .favouriteQuotesModuleOpened(let viewController):
                (viewController as? FavouriteQuotesViewController)?.scrollToTop()
            }
        }.store(in: &subscriptions)
    }

    private func quotesModule() -> QuotesViewController {
        let (view, router) = QuotesModuleFactory().module()

        router.completion.sink { [weak view] completion in
            if case .openQuote(let model) = completion {
                let viewController = QuotePreviewModuleFactory().module(model: model)
                view?.present(viewController, animated: true)
            }
        }.store(in: &subscriptions)

        return view
    }

    private func favouritesQuotesModule() -> FavouriteQuotesViewController {
        let (view, router) = FavouriteQuotesModuleFactory().module()

        router.completion.sink { [weak view] completion in
            if case .openQuote(let model) = completion {
                let viewController = QuotePreviewModuleFactory().module(model: model)
                view?.present(viewController, animated: true)
            }
        }.store(in: &subscriptions)

        return view
    }
}

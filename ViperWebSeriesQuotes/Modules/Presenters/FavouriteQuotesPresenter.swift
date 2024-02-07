class FavouriteQuotesPresenter {
    private weak var view: FavouriteQuotesViewController?
    private var interactor: FavouriteQuotesInteractor?
    private var router: FavouriteQuotesRouter?
}

// MARK: - Initializators

extension FavouriteQuotesPresenter {
    func initialize(view: FavouriteQuotesViewController,
                    interactor: FavouriteQuotesInteractor,
                    router: FavouriteQuotesRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Model

extension FavouriteQuotesPresenter {
    func modelExists() -> Bool {
        interactor?.modelExists() ?? false
    }

    func reloadModel() {
        interactor?.reloadModel()
    }

    func updateModel(model: [QuoteModel]) {
        view?.model = model
    }

    func addFavouriteQuote(model: QuoteModel) {
        interactor?.addFavouritedQuote(model: model)
    }

    func removeFavouriteQuote(model: QuoteModel) {
        interactor?.removeFavouritedQuote(model: model)
    }

    func favouritedQuote(model: QuoteModel) -> Bool {
        interactor?.favouritedQuote(model: model) ?? false
    }
}

// MARK: - Quote

extension FavouriteQuotesPresenter {
    func openQuote(model: QuoteModel) {
        router?.openQuote(model: model)
    }
}

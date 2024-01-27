class QuotesPresenter {
    private var view: QuotesViewController?
    private var interactor: QuotesInteractor?
    private var router: QuotesRouter?
}

// MARK: - Initializators

extension QuotesPresenter {
    func initialize(view: QuotesViewController, interactor: QuotesInteractor, router: QuotesRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Model

extension QuotesPresenter {
    func modelExists() -> Bool {
        interactor?.modelExists() ?? false
    }

    func reloadModel() {
        interactor?.reloadModel()
    }

    func loadMoreModel() {
        interactor?.loadMoreModel()
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

extension QuotesPresenter {
    func openQuote(model: QuoteModel) {
        router?.openQuote(model: model)
    }
}

struct FavouriteQuotesModuleFactory {
    func module() -> (FavouriteQuotesViewController, FavouriteQuotesRouter) {
        let model = [QuoteModel]()
        let view = FavouriteQuotesViewController()
        let presenter = FavouriteQuotesPresenter()
        let interactor = FavouriteQuotesInteractor(model: model, presenter: presenter)
        let router = FavouriteQuotesRouter()

        presenter.initialize(view: view, interactor: interactor, router: router)
        view.initialize(presenter: presenter)

        return (view, router)
    }
}

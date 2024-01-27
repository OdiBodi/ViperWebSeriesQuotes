struct QuotesModuleFactory {
    func module() -> (QuotesViewController, QuotesRouter) {
        let model = [QuoteModel]()
        let view = QuotesViewController()
        let presenter = QuotesPresenter()
        let interactor = QuotesInteractor(model: model, presenter: presenter)
        let router = QuotesRouter()

        presenter.initialize(view: view, interactor: interactor, router: router)
        view.initialize(presenter: presenter)

        return (view, router)
    }
}

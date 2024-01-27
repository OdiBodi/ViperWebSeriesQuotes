struct QuotePreviewModuleFactory {
    func module(model: QuoteModel) -> QuotePreviewViewController {
        let view = QuotePreviewViewController()
        let presenter = QuotePreviewPresenter()
        let interactor = QuotePreviewInteractor(model: model, presenter: presenter)
        let router = QuotePreviewRouter()

        presenter.initialize(view: view, interactor: interactor, router: router)
        view.initialize(presenter: presenter)

        return view
    }
}

class QuotePreviewPresenter {
    private weak var view: QuotePreviewViewController?
    private var interactor: QuotePreviewInteractor?
    private var router: QuotePreviewRouter?
}

// MARK: - Properties

extension QuotePreviewPresenter {
    var model: QuoteModel? {
        interactor?.model
    }
}

// MARK: - Initializators

extension QuotePreviewPresenter {
    func initialize(view: QuotePreviewViewController, interactor: QuotePreviewInteractor, router: QuotePreviewRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

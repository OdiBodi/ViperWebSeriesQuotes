import Foundation

class QuotePreviewInteractor {
    private(set) var model: QuoteModel
    private weak var presenter: QuotePreviewPresenter?

    init(model: QuoteModel, presenter: QuotePreviewPresenter) {
        self.model = model
        self.presenter = presenter
    }
}

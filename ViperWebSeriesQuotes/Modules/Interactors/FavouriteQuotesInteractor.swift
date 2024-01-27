import Foundation

class FavouriteQuotesInteractor {
    private var model: [QuoteModel]
    private weak var presenter: FavouriteQuotesPresenter?

    init(model: [QuoteModel], presenter: FavouriteQuotesPresenter) {
        self.model = model
        self.presenter = presenter
    }
}

// MARK: - Model

extension FavouriteQuotesInteractor {
    func modelExists() -> Bool {
        !model.isEmpty
    }

    func reloadModel() {
        model = FavouriteQuotes.shared.quotes
        presenter?.updateModel(model: model)
    }

    func addFavouritedQuote(model: QuoteModel) {
        FavouriteQuotes.shared.addQuote(model)
        DispatchQueue.global(qos: .background).async {
            FavouriteQuotes.shared.save()
        }
    }

    func removeFavouritedQuote(model: QuoteModel) {
        FavouriteQuotes.shared.removeQuote(model)
        DispatchQueue.global(qos: .background).async {
            FavouriteQuotes.shared.save()
        }
    }

    func favouritedQuote(model: QuoteModel) -> Bool {
        FavouriteQuotes.shared.existsQuote(model)
    }
}

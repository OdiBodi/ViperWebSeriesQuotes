import Foundation

class QuotesInteractor {
    private var model: [QuoteModel]
    private weak var presenter: QuotesPresenter?

    init(model: [QuoteModel], presenter: QuotesPresenter) {
        self.model = model
        self.presenter = presenter
    }
}

// MARK: - Model

extension QuotesInteractor {
    func modelExists() -> Bool {
        !model.isEmpty
    }

    func reloadModel() {
        Task {
            guard let model = await RandomQuotes(number: 30).fetch() else {
                return
            }

            self.model = model

            DispatchQueue.main.async { [weak self] in
                self?.presenter?.updateModel(model: model)
            }
        }
    }

    func loadMoreModel() {
        Task {
            guard let model = await RandomQuotes(number: 30).fetch() else {
                return
            }

            self.model += model

            DispatchQueue.main.async { [weak self] in
                self?.presenter?.updateModel(model: self?.model ?? [])
            }
        }
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

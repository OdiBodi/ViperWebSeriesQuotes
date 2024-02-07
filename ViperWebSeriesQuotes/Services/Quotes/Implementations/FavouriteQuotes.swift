import Foundation

class FavouriteQuotes {
    static let shared = FavouriteQuotes()

    var quotes: [QuoteModel] = []

    private init() { }
}

// MARK: - Operations

extension FavouriteQuotes {
    @discardableResult
    func load() -> Bool {
        guard let url = url() else {
            return false
        }

        do {
            let data = try Data(contentsOf: url)
            let model = try JSONDecoder().decode(FavouriteQuotesModel.self, from: data)
            quotes = model.quotes
            return true
        } catch {
            print("FavouriteQuotes: load error: \(error)")
        }

        return false
    }

    @discardableResult
    func save() -> Bool {
        do {
            let model = FavouriteQuotesModel(quotes: quotes)
            let data = try JSONEncoder().encode(model)

            guard let url = url() else {
                return false
            }

            try data.write(to: url)
        } catch {
            print("FavouriteQuotes: save error: \(error)")
        }

        return true
    }
}

// MARK: - Url

extension FavouriteQuotes {
    private func url() -> URL? {
        do {
            let cachesUrl = try FileManager.default.url(for: .cachesDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: true)
            return cachesUrl.appendingPathComponent("favourite")
        } catch {
            print("FavouriteQuotes: url error: \(error.localizedDescription)")
        }
        return nil
    }
}

// MARK: - Helpers

extension FavouriteQuotes {
    func addQuote(_ model: QuoteModel) {
        guard !existsQuote(model) else {
            return
        }
        quotes.append(model)
    }

    func removeQuote(_ model: QuoteModel) {
        quotes.removeAll { $0.id == model.id }
    }

    func existsQuote(_ model: QuoteModel) -> Bool {
        return quotes.contains { $0.uid == model.uid }
    }
}

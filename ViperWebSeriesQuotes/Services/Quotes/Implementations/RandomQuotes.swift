import Alamofire

struct RandomQuotes {
    private let url = "https://api.seriesquotes.10cyrilc.me/quote"

    private let number: Int

    init(number: Int) {
        self.number = number
    }
}

// MARK: - Fetch

extension RandomQuotes {
    func fetch() async -> [QuoteModel]? {
        let response = await AF.request(url, parameters: ["count": number])
                               .cacheResponse(using: .cache)
                               .validate()
                               .serializingDecodable([QuoteModel].self)
                               .response

        if let error = response.error {
            print("Series: fetch error: \(error.localizedDescription)")
            return nil
        }

        return response.value
    }
}

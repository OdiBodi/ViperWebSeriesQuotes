import Foundation
import Alamofire

class Series {
    static let shared = Series()

    private let url = "https://api.seriesquotes.10cyrilc.me/series"

    private(set) var series: [String] = []

    private init() { }
}

// MARK: - Fetch

extension Series {
    func fetch() async -> Bool {
        let response = await AF.request(url)
                               .cacheResponse(using: .cache)
                               .validate()
                               .serializingDecodable([String].self)
                               .response

        if let error = response.error {
            print("Series: fetch error: \(error.localizedDescription)")
            return false
        }

        guard let value = response.value else {
            return false
        }

        series = value
        return true
    }
}

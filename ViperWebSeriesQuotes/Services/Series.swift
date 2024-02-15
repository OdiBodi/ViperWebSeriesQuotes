import Foundation
import Alamofire

class Series {
    private(set) var series: [String] = []

    private init() { }
}

// MARK: - Static

extension Series {
    static let shared = Series()

    static private let url = "https://api.seriesquotes.10cyrilc.me/series"
}

// MARK: - Fetch

extension Series {
    func fetch() async -> Bool {
        let response = await AF.request(Series.url)
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

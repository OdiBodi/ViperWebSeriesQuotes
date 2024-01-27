struct QuoteModel: Codable {
    let id: Int
    let author: String
    let series: String
    let text: String
}

// MARK: - Coding keys

extension QuoteModel {
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case series
        case text = "quote"
    }
}

// MARK: - Helpers

extension QuoteModel {
    var uid: Int {
        id.hashValue ^ series.hashValue
    }

    var formattedAuthor: String {
        author.capitalized
    }

    var formattedSeries: String {
        series.capitalized.replacingOccurrences(of: "_", with: " ")
    }
}

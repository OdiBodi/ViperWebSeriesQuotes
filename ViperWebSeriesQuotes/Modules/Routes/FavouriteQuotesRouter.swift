class FavouriteQuotesRouter: BaseCoordinatorModule<FavouriteQuotesModuleCompletion, Never> {
    func openQuote(model: QuoteModel) {
        completionSubject.send(.openQuote(model: model))
    }
}

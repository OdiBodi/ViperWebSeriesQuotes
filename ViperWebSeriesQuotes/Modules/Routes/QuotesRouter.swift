class QuotesRouter: BaseCoordinatorModule<QuotesModuleCompletion, Never> {
    func openQuote(model: QuoteModel) {
        completionSubject.send(.openQuote(model: model))
    }
}

import UIKit
import Combine

class QuotesTableView: UIView {
    private lazy var tableView = initializeTableView()

    var model: [QuoteModel] = [] {
        didSet {
            update()
        }
    }

    var favouritedQuoteHandler: ((QuoteModel) -> Bool)?

    private var reloadModelSubject = PassthroughSubject<UIRefreshControl, Never>()
    private var loadMoreModelSubject = PassthroughSubject<Void, Never>()
    private var addFavouriteQuoteSubject = PassthroughSubject<QuoteModel, Never>()
    private var removeFavouriteQuoteSubject = PassthroughSubject<QuoteModel, Never>()
    private var openQuoteSubject = PassthroughSubject<QuoteModel, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Publishers

extension QuotesTableView {
    var reloadModel: AnyPublisher<UIRefreshControl, Never> {
        reloadModelSubject.eraseToAnyPublisher()
    }

    var loadMoreModel: AnyPublisher<Void, Never> {
        loadMoreModelSubject.eraseToAnyPublisher()
    }

    var addFavouriteQuote: AnyPublisher<QuoteModel, Never> {
        addFavouriteQuoteSubject.eraseToAnyPublisher()
    }

    var removeFavouriteQuote: AnyPublisher<QuoteModel, Never> {
        removeFavouriteQuoteSubject.eraseToAnyPublisher()
    }

    var openQuote: AnyPublisher<QuoteModel, Never> {
        openQuoteSubject.eraseToAnyPublisher()
    }
}

// MARK: - Life cycle

extension QuotesTableView {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Subviews {

extension QuotesTableView {
    private func initializeTableView() -> UITableView {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefreshControlValueChanged), for: .valueChanged)

        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.register(QuoteViewCell.self, forCellReuseIdentifier: "QuoteViewCell")
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.refreshControl = refreshControl

        return view
    }

    private func addSubviews() {
        addSubview(tableView)
    }

    private func updateSubviewsConstraints() {
        tableView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Utilites

extension QuotesTableView {
    func update() {
        tableView.reloadData()
    }

    func scrollToTop() {
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension QuotesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteViewCell", for: indexPath) as! QuoteViewCell

        let index = indexPath.item
        let model = model[index]

        let favourited = favouritedQuoteHandler?(model) ?? false
        cell.initialize(model: model, favourited: favourited)
        cell.favouritedChanged = { [weak self] value in
            value ? self?.addFavouriteQuoteSubject.send(model) : self?.removeFavouriteQuoteSubject.send(model)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let index = indexPath.item
        let model = model[index]

        openQuoteSubject.send(model)
    }
}

// MARK: - UITableViewDelegate

extension QuotesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentItem = indexPath.item
        let lastItem = tableView.numberOfRows(inSection: 0) - 1

        guard currentItem == lastItem else {
            return
        }

        loadMoreModelSubject.send()
    }
}

// MARK: - Callbacks

extension QuotesTableView {
    @objc func onRefreshControlValueChanged() {
        guard let refreshControl = tableView.refreshControl else {
            return
        }
        reloadModelSubject.send(refreshControl)
    }
}

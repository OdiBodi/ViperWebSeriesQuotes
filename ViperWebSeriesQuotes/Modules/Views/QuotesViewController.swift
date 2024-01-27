import UIKit
import SnapKit
import Combine

class QuotesViewController: UIViewController {
    private lazy var quotesTableView: QuotesTableView = {
        let view = QuotesTableView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.reloadModel.sink { [weak self] refreshControl in
            refreshControl.beginRefreshing()
            self?.presenter?.reloadModel()
            RunLoop.main.perform {
                refreshControl.endRefreshing()
            }
        }.store(in: &subscriptions)
        view.loadMoreModel.sink { [weak self] in
            self?.presenter?.loadMoreModel()
        }.store(in: &subscriptions)
        view.addFavouriteQuote.sink { [weak self] model in
            self?.presenter?.addFavouriteQuote(model: model)
        }.store(in: &subscriptions)
        view.removeFavouriteQuote.sink { [weak self] model in
            self?.presenter?.removeFavouriteQuote(model: model)
        }.store(in: &subscriptions)
        view.openQuote.sink { [weak self] model in
            self?.presenter?.openQuote(model: model)
        }.store(in: &subscriptions)
        view.favouritedQuoteHandler = { [weak self] model in
            self?.presenter?.favouritedQuote(model: model) ?? false
        }

        return view
    }()

    private var presenter: QuotesPresenter?
    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - Properties

extension QuotesViewController {
    var model: [QuoteModel] {
        get {
            quotesTableView.model
        }
        set {
            quotesTableView.model = newValue
        }
    }
}

// MARK: Life cycle

extension QuotesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSubviewsConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presenter?.modelExists() ?? false {
            quotesTableView.update()
        } else {
            presenter?.reloadModel()
        }
    }
}

// MARK: - Initializators

extension QuotesViewController {
    func initialize(presenter: QuotesPresenter) {
        self.presenter = presenter
        configureTabBarItem()
    }
}

// MARK: - Configurators

extension QuotesViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }

    private func configureTabBarItem() {
        let image = UIImage(systemName: "quote.closing")
        tabBarItem = UITabBarItem(title: "Quotes", image: image, tag: 0)
    }
}

// MARK: - Subviews

extension QuotesViewController {
    private func addSubviews() {
        view.addSubview(quotesTableView)
    }

    private func updateSubviewsConstraints() {
        quotesTableView.snp.updateConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - Scrolling

extension QuotesViewController {
    func scrollToTop() {
        quotesTableView.scrollToTop()
    }
}

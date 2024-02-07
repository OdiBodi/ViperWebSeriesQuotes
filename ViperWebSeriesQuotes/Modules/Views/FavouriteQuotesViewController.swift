import UIKit
import SnapKit
import Combine

class FavouriteQuotesViewController: UIViewController {
    private lazy var tableView = initializeTableView()

    private var presenter: FavouriteQuotesPresenter?
    private var subscriptions = Set<AnyCancellable>()
}

// MARK: - Properties

extension FavouriteQuotesViewController {
    var model: [QuoteModel] {
        get {
            tableView.model
        }
        set {
            tableView.model = newValue
        }
    }
}

// MARK: - Life cycle

extension FavouriteQuotesViewController {
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
        presenter?.reloadModel()
    }
}

// MARK: - Initializators

extension FavouriteQuotesViewController {
    func initialize(presenter: FavouriteQuotesPresenter) {
        self.presenter = presenter
        configureTabBarItem()
    }
}

// MARK: - Configurators

extension FavouriteQuotesViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }

    private func configureTabBarItem() {
        let image = UIImage(systemName: "star.fill")
        tabBarItem = UITabBarItem(title: "Favourite", image: image, tag: 1)
    }
}

// MARK: - Subviews

extension FavouriteQuotesViewController {
    private func initializeTableView() -> QuotesTableView {
        let view = QuotesTableView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.reloadModel.sink { [weak self] refreshControl in
            refreshControl.beginRefreshing()
            self?.presenter?.reloadModel()
            RunLoop.main.perform {
                refreshControl.endRefreshing()
            }
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
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func updateSubviewsConstraints() {
        tableView.snp.updateConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: - Scrolling

extension FavouriteQuotesViewController {
    func scrollToTop() {
        tableView.scrollToTop()
    }
}

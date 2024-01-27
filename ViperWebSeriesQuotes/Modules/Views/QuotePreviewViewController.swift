import UIKit

class QuotePreviewViewController: UIViewController {
    private lazy var topPlaceholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 2.5
        return view
    }()

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()

    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = -1
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = R.color.quote.text()
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = R.color.quote.authorText()
        return label
    }()

    private lazy var seriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = R.color.quote.seriesText()
        return label
    }()

    private var presenter: QuotePreviewPresenter?
}

// MARK: Life cycle

extension QuotePreviewViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Initializators

extension QuotePreviewViewController {
    func initialize(presenter: QuotePreviewPresenter) {
        self.presenter = presenter

        guard let model = presenter.model else {
            return
        }

        quoteLabel.text = model.text
        authorLabel.text = model.formattedAuthor
        seriesLabel.text = model.formattedSeries
    }
}

// MARK: - Configurators

extension QuotePreviewViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Subviews

extension QuotePreviewViewController {
    private func addSubviews() {
        view.addSubview(topPlaceholderView)
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(quoteLabel)
        verticalStackView.addArrangedSubview(authorLabel)
        verticalStackView.addArrangedSubview(seriesLabel)
    }

    private func updateSubviewsConstraints() {
        topPlaceholderView.snp.updateConstraints { maker in
            maker.top.equalToSuperview().inset(20)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(50)
            maker.height.equalTo(5)
        }
        verticalStackView.snp.updateConstraints { maker in
            maker.left.right.equalToSuperview().inset(16)
            maker.top.equalToSuperview().inset(50)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
        }
        authorLabel.snp.updateConstraints { maker in
            maker.height.equalTo(50)
        }
        seriesLabel.snp.updateConstraints { maker in
            maker.height.equalTo(50)
        }
    }
}

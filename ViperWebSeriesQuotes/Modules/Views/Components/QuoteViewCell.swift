import UIKit

class QuoteViewCell: UITableViewCell {
    static let id = "\(QuoteViewCell.self)"

    private lazy var descriptionLabel = initializeDescriptionLabel()
    private lazy var horizontalStack = initializeHorizontalStack()
    private lazy var authorLabel = initializeAuthorLabel()
    private lazy var seriesLabel = initializeSeriesLabel()
    private lazy var favouriteImage = initializeFavouriteImage()

    var favourited: Bool = false {
        didSet {
            favouriteImage.image = favourited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }
    }
    var favouritedChanged: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Life cycle

extension QuoteViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Initializators

extension QuoteViewCell {
    func initialize(model: QuoteModel, favourited: Bool) {
        descriptionLabel.text = model.text
        authorLabel.text = model.formattedAuthor
        seriesLabel.text = model.formattedSeries
        self.favourited = favourited
    }
}

// MARK: - Subviews

extension QuoteViewCell {
    private func initializeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = R.color.quote.text()
        return label
    }

    private func initializeHorizontalStack() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }

    private func initializeAuthorLabel() -> BubbleLabel {
        let label = BubbleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.color = R.color.quote.authorBackground()
        label.textColor = R.color.quote.authorText()
        label.cornerRadius = 15
        return label
    }

    private func initializeSeriesLabel() -> BubbleLabel {
        let label = BubbleLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.color = R.color.quote.seriesBackground()
        label.textColor = R.color.quote.seriesText()
        label.cornerRadius = 15
        return label
    }

    private func initializeFavouriteImage() -> UIImageView {
        let image = UIImage(systemName: "heart")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFill
        view.tintColor = .systemRed

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onFavouriteImageTapped))
        view.addGestureRecognizer(tapGestureRecognizer)

        return view
    }

    private func addSubviews() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(authorLabel)
        horizontalStack.addArrangedSubview(seriesLabel)
        horizontalStack.addArrangedSubview(favouriteImage)
    }

    private func updateSubviewsConstraints() {
        descriptionLabel.snp.updateConstraints { maker in
            maker.left.right.equalToSuperview().inset(16)
            maker.top.equalToSuperview().inset(10)
            maker.bottom.equalToSuperview().inset(40)
        }
        horizontalStack.snp.updateConstraints { maker in
            maker.left.right.equalToSuperview().inset(16)
            maker.top.equalTo(descriptionLabel.snp.bottom)
            maker.bottom.equalToSuperview().inset(10)
        }
        authorLabel.snp.updateConstraints { maker in
            maker.width.greaterThanOrEqualTo(100)
        }
        seriesLabel.snp.updateConstraints { maker in
            maker.width.greaterThanOrEqualTo(100)
        }
        favouriteImage.snp.updateConstraints { maker in
            maker.width.equalTo(20)
        }
    }
}

// MARK: - Callbacks

extension QuoteViewCell {
    @objc private func onFavouriteImageTapped() {
        favourited = !favourited
        favouritedChanged?(favourited)
    }
}

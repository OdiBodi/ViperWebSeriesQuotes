import UIKit

class BubbleLabel: UIView {
    private lazy var titleLabel = initializeTitleLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Properties

extension BubbleLabel {
    var text: String {
        get {
            titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    var textColor: UIColor? {
        get {
            titleLabel.textColor
        }
        set {
            titleLabel.textColor = newValue
        }
    }

    var color: UIColor? {
        get {
            backgroundColor
        }
        set {
            backgroundColor = newValue
        }
    }

    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

// MARK: - Life cycle

extension BubbleLabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSubviewsConstraints()
    }
}

// MARK: - Subviews

extension BubbleLabel {
    private func initializeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }

    private func addSubviews() {
        addSubview(titleLabel)
    }

    private func updateSubviewsConstraints() {
        titleLabel.snp.updateConstraints { maker in
            maker.left.right.equalToSuperview().inset(20)
            maker.top.bottom.equalToSuperview()
        }
    }
}

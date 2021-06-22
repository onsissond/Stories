//
//  Created by onsissond.
//

import UIKit

final class SummaryFooterStoryView: UIView {

    private lazy var _priceLabel: UILabel = {
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.font = .preferredFont(forTextStyle: .title2)
        $0.textColor = .white
        return $0
    }(UILabel())

    private lazy var _titleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .white
        $0.setContentHuggingPriority(.required, for: .vertical)
        return $0
    }(UILabel())

    private lazy var _subtitleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .caption2)
        $0.textColor = .lightGray
        $0.setContentHuggingPriority(.required, for: .vertical)
        return $0
    }(UILabel())

    init() {
        super.init(frame: .zero)
        _setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupSubviews() {
        addSubview(_titleLabel)
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _titleLabel.topAnchor.constraint(equalTo: topAnchor),
            _titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])

        addSubview(_subtitleLabel)
        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _subtitleLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: 4),
            _subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            _subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(_priceLabel)
        _priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _priceLabel.topAnchor.constraint(equalTo: _titleLabel.topAnchor),
            _priceLabel.leadingAnchor.constraint(equalTo: _titleLabel.trailingAnchor, constant: 8),
            _priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            _priceLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor)
        ])
    }
}

extension SummaryFooterStoryView {
    struct ViewState {
        var title: String
        var subtitle: String
        var price: String
    }

    func render(viewState: ViewState) {
        _priceLabel.text = viewState.price
        _titleLabel.text = viewState.title
        _subtitleLabel.text = viewState.subtitle
    }
}

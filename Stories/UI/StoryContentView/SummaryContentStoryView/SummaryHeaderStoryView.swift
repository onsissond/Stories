//
//  Created by onsissond.
//

import UIKit

final class SummaryHeaderStoryView: UIView {
    private lazy var _periodLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .white
        $0.setContentHuggingPriority(.required, for: .vertical)
        return $0
    }(UILabel())

    private lazy var _titleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.textColor = .white
        $0.numberOfLines = 0
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
        addSubview(_periodLabel)
        _periodLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _periodLabel.topAnchor.constraint(equalTo: topAnchor),
            _periodLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            _periodLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(_titleLabel)
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _titleLabel.topAnchor.constraint(equalTo: _periodLabel.bottomAnchor, constant: 4),
            _titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            _titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            _titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension SummaryHeaderStoryView {
    struct ViewState {
        var period: String
        var title: String
    }

    func render(viewState: ViewState) {
        _periodLabel.text = viewState.period
        _titleLabel.text = viewState.title
    }
}

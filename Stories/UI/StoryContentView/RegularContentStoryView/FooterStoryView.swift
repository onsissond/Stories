//
//  Created by onsissond.
//

import UIKit

final class FooterStoryView: UIView {
    private lazy var _titleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textColor = .white
        return $0
    }(UILabel())

    private lazy var _subtitleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .title3)
        $0.textColor = .white
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
            _titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            _titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        addSubview(_subtitleLabel)
        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _subtitleLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: 4),
            _subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            _subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            _subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension FooterStoryView {
    struct ViewState {
        let title: String
        let subtitle: String
    }

    func render(viewState: ViewState) {
        _titleLabel.text = viewState.title
        _subtitleLabel.text = viewState.subtitle
    }
}

class FooterContentView: UIView {
    private lazy var _stackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 8
        return $0
    }(UIStackView())
    private lazy var _dateView = FooterStoryView()
    private lazy var _priceView = FooterStoryView()

    init() {
        super.init(frame: .zero)
        _setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupSubviews() {
        addSubview(_stackView)
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _stackView.topAnchor.constraint(equalTo: topAnchor),
            _stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            _stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            _stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        _stackView.addArrangedSubview(_priceView)
        _stackView.addArrangedSubview(_dateView)
    }
}

extension FooterContentView {
    struct ViewState {
        let periodInfo: RegularStoryContent.Info?
        let priceInfo: RegularStoryContent.Info?
    }
    func render(viewState: ViewState) {
        if let periodInfo = viewState.periodInfo {
            _dateView.render(viewState: .init(
                title: periodInfo.title,
                subtitle: periodInfo.subtitle
            ))
        }
        _dateView.isHidden = viewState.periodInfo == nil
        if let priceInfo = viewState.priceInfo {
            _priceView.render(viewState: .init(
                title: priceInfo.title,
                subtitle: priceInfo.subtitle
            ))
        }
        _priceView.isHidden = viewState.priceInfo == nil
    }
}

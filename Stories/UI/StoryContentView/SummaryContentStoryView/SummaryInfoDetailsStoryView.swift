//
//  Created by onsissond.
//

import UIKit

final class SummaryInfoDetailsStoryView: UIView {
    private lazy var _iconView: UIImageView = {
        $0.contentMode = .center
        $0.setContentHuggingPriority(.required, for: .horizontal)
        return $0
    }(UIImageView())

    private lazy var _titleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.setContentHuggingPriority(.required, for: .vertical)
        return $0
    }(UILabel())

    private lazy var _subtitleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .lightGray
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
        addSubview(_iconView)
        _iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _iconView.topAnchor.constraint(equalTo: topAnchor),
            _iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            _iconView.widthAnchor.constraint(equalToConstant: 24),
            _iconView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        addSubview(_titleLabel)
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _titleLabel.topAnchor.constraint(equalTo: topAnchor),
            _titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            _titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        addSubview(_subtitleLabel)

        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _subtitleLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor),
            _subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            _subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            _subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension SummaryInfoDetailsStoryView {
    struct ViewState {
        var icon: UIImage?
        var title: String
        var subtitle: String
    }

    func render(viewState: ViewState) {
        _iconView.image = viewState.icon
        _titleLabel.text = viewState.title
        _subtitleLabel.text = viewState.subtitle
    }
}

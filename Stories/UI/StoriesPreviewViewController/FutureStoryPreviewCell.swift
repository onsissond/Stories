//
//  Created by onsissond.
//

import UIKit
import ComposableArchitecture
import RxSwift

final class FutureStoryPreviewCell: UICollectionViewCell {
    private lazy var _contentView: UIView = {
        $0.backgroundColor = UIColor.blue
            .withAlphaComponent(0.75)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        return $0
    }(UIView())

    private lazy var _titleLabel: UILabel = {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .caption1)
        return $0
    }(UILabel())

    private lazy var _subscribeLabel: UILabel = {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupSubviews() {
        contentView.addSubview(_contentView)
        _contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _contentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            _contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            _contentView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            _contentView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])

        _contentView.addSubview(_titleLabel)
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _titleLabel.leadingAnchor.constraint(equalTo: _contentView.leadingAnchor, constant: 8),
            _titleLabel.trailingAnchor.constraint(equalTo: _contentView.trailingAnchor, constant: -8)
        ])

        _contentView.addSubview(_subscribeLabel)
        _subscribeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _subscribeLabel.heightAnchor.constraint(equalToConstant: 28),
            _subscribeLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: 12),
            _subscribeLabel.leadingAnchor.constraint(equalTo: _contentView.leadingAnchor, constant: 8),
            _subscribeLabel.trailingAnchor.constraint(equalTo: _contentView.trailingAnchor, constant: -8),
            _subscribeLabel.bottomAnchor.constraint(equalTo: _contentView.bottomAnchor, constant: -16)
        ])
    }
}

extension FutureStoryPreviewCell {
    struct ViewState {
        enum SubscriptionState {
            case off
            case on
            case failure
        }
        let subscriptionState: SubscriptionState
        let daysToFutureStory: Int
    }

    func render(viewState: ViewState) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attrString = NSMutableAttributedString(string: L10n.FutureStoryPreview.days(viewState.daysToFutureStory))
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        _titleLabel.attributedText = attrString
        _titleLabel.textAlignment = .center

        switch viewState.subscriptionState {
        case .off:
            _subscribeLabel.text = L10n.FutureStoryPreviewCell.SubscribeButton.disabled
        case .on:
            _subscribeLabel.text = L10n.FutureStoryPreviewCell.SubscribeButton.enabled
        case .failure:
            _subscribeLabel.text = L10n.FutureStoryPreviewCell.SubscribeButton.failure
        }
    }
}

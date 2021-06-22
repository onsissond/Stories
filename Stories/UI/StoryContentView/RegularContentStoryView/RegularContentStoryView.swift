//
//  Created by onsissond.
//

import UIKit
import RxCocoa
import Kingfisher

final class RegularContentStoryView: UIView {
    private lazy var _dismissButton: UIButton = .makeStoryDismiss()

    private lazy var _imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())

    private lazy var _stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        return $0
    }(UIStackView())

    private lazy var _titleLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .title1)
        $0.textColor = .white
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var _descriptionLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.textColor = .white
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var _footerContentView = FooterContentView()

    private lazy var _gradientLayer: CAGradientLayer = .storyGradient

    init() {
        super.init(frame: .zero)
        _setupSubviews()
        _setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        _gradientLayer.frame = frame
    }

    private func _setupLayout() {
        _imageView.layer.insertSublayer(_gradientLayer, at: 0)
    }

    private func _setupSubviews() {
        addSubview(_imageView)
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _imageView.topAnchor.constraint(equalTo: topAnchor),
            _imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            _imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            _imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(_dismissButton)
        _dismissButton.translatesAutoresizingMaskIntoConstraints = false
        if hasEyebrow {
            _dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 80).isActive = true
        } else {
            _dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 62).isActive = true
        }
        _dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true

        addSubview(_stackView)
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            _stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            _stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -64)
        ])

        _stackView.addArrangedSubview(_titleLabel)
        _stackView.addArrangedSubview(_descriptionLabel)
        _stackView.addArrangedSubview(_footerContentView)
    }
}

extension RegularContentStoryView: StoryContentView {
    func render(viewState: StoryContent) -> Bool {
        guard case .regular(let viewState) = viewState else {
            return false
        }
        _imageView.kf.setImage(
            with: viewState.image.imageURL,
            options: [
                .transition(.fade(0.5))
            ]
        )
        _titleLabel.text = viewState.title
        _descriptionLabel.text = viewState.description
        _footerContentView.render(viewState: .init(
            periodInfo: viewState.periodInfo,
            priceInfo: viewState.priceInfo
        ))
        _footerContentView.isHidden = viewState.periodInfo == nil &&
            viewState.priceInfo == nil
        return true
    }
}

extension RegularContentStoryView {
    enum Event {
        case dismiss
    }

    var events: ControlEvent<Event> {
        ControlEvent(
            events: _dismissButton.rx.controlEvent(.touchUpInside)
                .map { _ in .dismiss }
        )
    }
}

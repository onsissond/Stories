//
//  Created by onsissond.
//

import UIKit
import Kingfisher

final class StoryPreviewCell: UICollectionViewCell {
    private lazy var _contentView: UIView = {
        $0.backgroundColor = UIColor(hex: 0xAFD4FF)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        return $0
    }(UIView())

    private lazy var _imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        return $0
    }(UIImageView())

    private lazy var _gradientLayer: CAGradientLayer = .storyGradient

    private lazy var _titleLabel: UILabel = {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = .preferredFont(forTextStyle: .caption1)
        return $0
    }(UILabel())

    private lazy var _descriptionLabel: UILabel = {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 10)
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupSubviews()
        _setupAppearence()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        _gradientLayer.frame = contentView.frame
    }

    private func _setupAppearence() {
        _imageView.layer.addSublayer(_gradientLayer)
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
        _contentView.addSubview(_imageView)
        _imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _imageView.topAnchor.constraint(equalTo: _contentView.topAnchor, constant: 2),
            _imageView.leadingAnchor.constraint(equalTo: _contentView.leadingAnchor, constant: 2),
            _imageView.trailingAnchor.constraint(equalTo: _contentView.trailingAnchor, constant: -2),
            _imageView.bottomAnchor.constraint(equalTo: _contentView.bottomAnchor, constant: -2)
        ])

        _contentView.addSubview(_titleLabel)
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _titleLabel.leadingAnchor.constraint(equalTo: _contentView.leadingAnchor, constant: 8),
            _titleLabel.trailingAnchor.constraint(equalTo: _contentView.trailingAnchor, constant: -8)
        ])

        _contentView.addSubview(_descriptionLabel)
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _descriptionLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor),
            _descriptionLabel.leadingAnchor.constraint(equalTo: _contentView.leadingAnchor, constant: 8),
            _descriptionLabel.trailingAnchor.constraint(equalTo: _contentView.trailingAnchor, constant: -8),
            _descriptionLabel.bottomAnchor.constraint(equalTo: _contentView.bottomAnchor, constant: -8)
        ])

    }
}

extension StoryPreviewCell {
    func render(viewState: RegularStoryPreview) {
        _imageView.kf.setImage(
            with: viewState.imageURL,
            options: [
                .transition(.fade(0.5))
            ]
        )
        _titleLabel.text = viewState.title
        _descriptionLabel.text = viewState.description
    }
}

//
//  Created by onsissond.
//

import UIKit

final class SummaryInfoStoryView: UIView {
    private lazy var _contentView: UIView = {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return $0
    }(UIView())

    private lazy var _stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 8
        return $0
    }(UIStackView())

    private lazy var _infoView = SummaryInfoDetailsStoryView()
    private lazy var _extraInfoView = SummaryInfoDetailsStoryView()

    init() {
        super.init(frame: .zero)
        _setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupSubviews() {
        addSubview(_contentView)
        _contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _contentView.topAnchor.constraint(equalTo: topAnchor),
            _contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            _contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            _contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        _contentView.addSubview(_stackView)
        _stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            _stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            _stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            _stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        _stackView.addArrangedSubview(_infoView)
        _stackView.addArrangedSubview(_extraInfoView)
    }
}

extension SummaryInfoStoryView {
    enum ViewState {
        case trip(from: SummaryStoryContent.TripInfo, to: SummaryStoryContent.TripInfo)
        case accommodation(title: String, description: String)
        case nutrition(title: String, description: String)
        case entertainment(title: String, description: String)
    }

    func render(viewState: ViewState) {
        switch viewState {
        case let .trip(tripFrom, tripTo):
            _infoView.render(viewState: .init(
                icon: tripTo.transport.icon,
                title: tripTo.title,
                subtitle: tripTo.subtitle
            ))
            let needIcon = tripTo.transport != tripFrom.transport
            _extraInfoView.render(viewState: .init(
                icon: needIcon ? tripFrom.transport.icon : nil,
                title: tripFrom.title,
                subtitle: tripFrom.subtitle
            ))
            _extraInfoView.isHidden = false
        case let .accommodation(title, description),
             let .nutrition(title, description),
             let .entertainment(title, description):
            _infoView.render(viewState: .init(
                icon: viewState.icon,
                title: title,
                subtitle: description
            ))
            _extraInfoView.isHidden = true
        }
    }
}

private extension Transport {
    var icon: UIImage {
        switch self {
        case .avia:
            return Asset.Icon.flight.image
        case .train:
            return Asset.Icon.train.image
        case .bus:
            return Asset.Icon.bus.image
        }
    }
}

private extension SummaryInfoStoryView.ViewState {
    var icon: UIImage? {
        switch self {
        case .trip:
            return nil
        case .accommodation:
            return Asset.Icon.accommodation.image
        case .nutrition:
            return Asset.Icon.nutrition.image
        case .entertainment:
            return Asset.Icon.entertainment.image
        }
    }
}

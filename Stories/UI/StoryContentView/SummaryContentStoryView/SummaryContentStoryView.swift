//
//  Created by onsissond.
//

import UIKit
import RxSwift
import RxCocoa

final class SummaryContentStoryView: UIView {
    private let _disposeBag = DisposeBag()
    private lazy var _dismissButton: UIButton = .makeStoryDismiss()
    private lazy var _imageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())

    private lazy var _stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 8
        return $0
    }(UIStackView())

    private lazy var _headerView = SummaryHeaderStoryView()
    private lazy var _flightView = SummaryInfoStoryView()
    private lazy var _accommodationView = SummaryInfoStoryView()
    private lazy var _nutritionView = SummaryInfoStoryView()
    private lazy var _entertainmentView = SummaryInfoStoryView()
    private lazy var _summaryFooterStoryView = SummaryFooterStoryView()
    private lazy var _buyTicketButton: UIButton = {
        $0.setTitle(L10n.SummaryContentStoryView.BuyButton.title, for: .normal)
        return $0
    }(UIButton())
    private lazy var _feedbackButton: UIButton = {
        $0.setTitle("Неинтересно", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        return $0
    }(UIButton())

    private lazy var _gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor(hex: 0xF1D2F).withAlphaComponent(0.4).cgColor,
            UIColor(hex: 0xF1D2F).withAlphaComponent(0.6).cgColor,
            UIColor(hex: 0x11834).cgColor
        ]
        layer.locations = [0, 0.08, 0.65, 1]
        return layer
    }()

    private var _viewState: SummaryStoryContent?

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
        addSubview(_stackView)
        if hasEyebrow {
            _stackView.topAnchor.constraint(equalTo: topAnchor, constant: 80).isActive = true
        } else {
            _stackView.topAnchor.constraint(equalTo: topAnchor, constant: 62).isActive = true
        }
        _stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        _stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        if hasEyebrow {
            _stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        } else {
            _stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        }
        _stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(_dismissButton)
        _dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _dismissButton.topAnchor.constraint(equalTo: _stackView.topAnchor),
            _dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        _stackView.addArrangedSubview(_headerView)
        _stackView.addArrangedSubview(_flightView)
        _stackView.addArrangedSubview(_accommodationView)
        _stackView.addArrangedSubview(_nutritionView)
        _stackView.addArrangedSubview(_entertainmentView)
        _stackView.addArrangedSubview(UIView())
        _stackView.addArrangedSubview(_summaryFooterStoryView)
        _stackView.addArrangedSubview(_buyTicketButton)
        _stackView.addArrangedSubview(_feedbackButton)
    }
}

extension SummaryContentStoryView: StoryContentView {
    func render(viewState: StoryContent) -> Bool {
        guard case .summary(let viewState) = viewState else {
            return false
        }
        _viewState = viewState
        _imageView.kf.setImage(
            with: viewState.image.imageURL,
            options: [.transition(.fade(0.5))]
        )
        _headerView.render(viewState: .init(
            period: viewState.period.value,
            title: viewState.title
        ))
        _flightView.render(viewState: .trip(
            from: viewState.trip.from,
            to: viewState.trip.to
        ))
        _accommodationView.render(viewState: .accommodation(
            title: viewState.accommodation.title,
            description: viewState.accommodation.description
        ))
        _nutritionView.render(viewState: .nutrition(
            title: viewState.nutrition.title,
            description: viewState.nutrition.description
        ))
        _entertainmentView.render(viewState: .entertainment(
            title: viewState.entertainment.title,
            description: viewState.entertainment.description
        ))
        _summaryFooterStoryView.render(viewState: .init(
            title: viewState.price.title,
            subtitle: viewState.price.subtitle,
            price: viewState.price.value
        ))
        return true
    }
}

extension SummaryContentStoryView {
    enum Event {
        case dismiss
        case openDeeplink(URL)
        case requestFeedback
    }

    var events: ControlEvent<Event> {
        ControlEvent(events: Observable.merge([
            _dismissButton.rx.controlEvent(.touchUpInside).map { _ in .dismiss },
            _buyTicketButton.rx.controlEvent(.touchUpInside).map { [weak self] in
                self?._viewState?.deeplink
            }
            .filterNil()
            .map(Event.openDeeplink),
            _feedbackButton.rx.controlEvent(.touchUpInside).map { _ in .requestFeedback }
        ]))
    }
}

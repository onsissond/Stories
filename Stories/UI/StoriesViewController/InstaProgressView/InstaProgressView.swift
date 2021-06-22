//
//  InstaProgressView.swift
//  InstaProgressView
//
//  Created by Eduard Sinyakov on 11/19/20.
//

import UIKit

public class InstaProgressView: UIStackView {
    private let _duration: TimeInterval
    private let _progressTintColor: UIColor
    private let _trackTintColor: UIColor

    weak var delegate: InstaProgressViewDelegate?

    public init(
        progressTintColor: UIColor,
        trackTintColor: UIColor,
        spaceBetweenSegments: CGFloat,
        duration: TimeInterval
    ) {
        self._duration = duration
        self._progressTintColor = progressTintColor
        self._trackTintColor = trackTintColor
        super.init(frame: CGRect.zero)
        spacing = spaceBetweenSegments
        _setupAppearence()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupAppearence() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
    }

    private func _createProgressView(
        _ progressTintColor: UIColor,
        _ trackTintColor: UIColor
    ) -> AnimatableProgressView {
        AnimatableProgressView(
            duration: _duration,
            progressTintColor: _progressTintColor,
            trackTintColor: _trackTintColor
        )
    }
}

extension InstaProgressView {
    struct ViewState: Equatable {
        var pagesCount: Int
        var progress: [AnimatorState]
        var currentPage: Int
    }

    enum AnimatorState: Equatable {
        case initial
        case `continue`
        case pause
        case stop
        case start(UUID)
        case finish
    }

    func render(viewState: ViewState) {
        if viewState.pagesCount != arrangedSubviews.count {
            arrangedSubviews.forEach { $0.removeFromSuperview() }
            (0..<viewState.pagesCount)
                .map { _ in _createProgressView(_progressTintColor, _trackTintColor) }
                .forEach(addArrangedSubview)
        }
        zip(
            viewState.progress,
            arrangedSubviews.compactMap({ $0 as? AnimatableProgressView })
        ).forEach { animatorState, progressView in
            switch animatorState {
            case .initial:
                progressView.render(viewState: .initial)
            case .pause:
                progressView.render(viewState: .pause)
            case .continue:
                progressView.render(viewState: .continue)
            case .stop:
                progressView.render(viewState: .stop)
            case .start:
                progressView.render(viewState: .run {
                    self.delegate?.next()
                })
            case .finish:
                progressView.render(viewState: .finish)
            }
        }
    }

    private func _progressView(index: Int) -> AnimatableProgressView {
        arrangedSubviews.compactMap({ $0 as? AnimatableProgressView })[index]
    }
}

class AnimatableProgressView: UIProgressView {
    private var _animator: UIViewPropertyAnimator
    private var _viewState: ViewState?

    init(
        duration: TimeInterval,
        progressTintColor: UIColor,
        trackTintColor: UIColor
    ) {
        _animator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeInOut
        )
        super.init(frame: .zero)
        self.progressTintColor = progressTintColor
        self.trackTintColor = trackTintColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AnimatableProgressView {
    enum ViewState {
        case run(() -> Void)
        case stop
        case pause
        case `continue`
        case finish
        case initial
    }

    func render(viewState: ViewState) {
        _viewState = viewState
        switch viewState {
        case .initial:
            _animator.stopAnimation(true)
            progress = 0
        case .run(let completion):
            _animator.stopAnimation(true)
            progress = 0.01
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self,
                      case .run = self._viewState else { return }
                self._animator.addAnimations {
                    self.setProgress(1, animated: true)
                }
                self._animator.addCompletion { _ in
                    completion()
                }
                self._animator.startAnimation()
            }
        case .stop:
            _animator.stopAnimation(true)
        case .pause:
            _animator.pauseAnimation()
        case .continue:
            _animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        case .finish:
            _animator.stopAnimation(true)
            progress = 1
        }
    }
}

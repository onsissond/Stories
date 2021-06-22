//
//  Created by onsissond.
//

import UIKit

class SwitchableView: UIView {
    private var _contentViews: [StoryContentView]

    init(contentViews: [StoryContentView]) {
        _contentViews = contentViews
        super.init(frame: .zero)
        _setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _setupSubviews() {
        _contentViews.forEach { view in
            addSubview(view)
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension SwitchableView: StoryContentView {
    func render(viewState: StoryContent) -> Bool {
        _contentViews.forEach {
            $0.isHidden = !$0.render(viewState: viewState)
        }
        return true
    }
}

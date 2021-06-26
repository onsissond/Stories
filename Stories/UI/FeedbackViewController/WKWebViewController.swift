//
//  Created by onsissond.
//

import RxSwift
import WebKit

class WKWebViewController: UIViewController {

    private var _webViewNavigationHandler: ((WKNavigationActionPolicy) -> Void)?

    private lazy var _webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self
        return webView
    }()

    private lazy var _indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        _addSubviews()
    }

    private func _addSubviews() {
        _webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(_webView)
        NSLayoutConstraint.activate([
            _webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _webView.topAnchor.constraint(equalTo: view.topAnchor),
            _webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        _indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(_indicator)
        NSLayoutConstraint.activate([
            _indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            _indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension WKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _indicator.stopAnimating()
    }
}

extension WKWebViewController {
    func render(viewState: URL) {
        _webView.load(.init(url: viewState))
    }
}

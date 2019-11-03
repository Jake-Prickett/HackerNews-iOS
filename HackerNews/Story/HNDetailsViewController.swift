//
//  HNDetailsViewController.swift
//  HackerNewsCollectionView
//
//  Created by Prickett, Jacob (J.A.) on 10/23/19.
//  Copyright © 2019 Prickett, Jacob (J.A.). All rights reserved.
//

import UIKit
import WebKit
import SnapKit

final class HNDetailsViewController: UIViewController {

    private lazy var webView = WKWebView()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .yellow
        progressView.backgroundColor = .white
        progressView.sizeToFit()
        return progressView
    }()

    public init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        webView.load(URLRequest(url: url))


        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)


        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(0)
            make.height.equalTo(20)
        }
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress),
                                     animated: true)
            if webView.estimatedProgress > 0.9 {
                updateView()
            }
        }
    }

    func updateView() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.progressView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self?.view.layoutIfNeeded()
        }
    }
}

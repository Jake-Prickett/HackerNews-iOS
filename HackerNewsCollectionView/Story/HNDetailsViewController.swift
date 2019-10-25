//
//  HNDetailsViewController.swift
//  HackerNewsCollectionView
//
//  Created by Prickett, Jacob (J.A.) on 10/23/19.
//  Copyright © 2019 Prickett, Jacob (J.A.). All rights reserved.
//

import UIKit
import WebKit

final class HNDetailsViewController: UIViewController {

    private lazy var webView = WKWebView()

    public init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        webView.load(URLRequest(url: url))

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        return nil
    }

}

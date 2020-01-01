//
//  HackerRankStory.swift
//  HackerNewsApp
//
//  Created by Prickett, Jacob (J.A.) on 10/4/19.
//  Copyright © 2019 Prickett, Jacob (J.A.). All rights reserved.
//

import Foundation

public struct HackerRankStory: Decodable {
    var id: Int
    var score: Int
    var url: String?
    var title: String
    var by: String
}

extension HackerRankStory {
    var numberOfPoints: String {
        if score == 1 { return "1 point" }
        else {
            return "\(score) points"
        }
    }

    var urlString: String {
        guard
            let unwrappedURL = url,
            let url = URL(string: unwrappedURL),
            let base = url.host
            else {
            return ""
        }

        return "\(base)"
    }
}

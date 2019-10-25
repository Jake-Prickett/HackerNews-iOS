//
//  HackerRankService.swift
//  HackerNewsApp
//
//  Created by Prickett, Jacob (J.A.) on 10/4/19.
//  Copyright © 2019 Prickett, Jacob (J.A.). All rights reserved.
//

import Alamofire
import Foundation

enum HackerRankError: Error {
    case noData
}

protocol HackerRankServicable {
    func getTopStories(completion: @escaping ([Int], Error?) -> Void)
    func getStory(id: Int, completion: @escaping (HackerRankStory?, Error?) -> Void)
}

class HackerRankService: HackerRankServicable {

    func getTopStories(completion: @escaping ([Int], Error?) -> Void) {
        SessionManager.default
            .request("https://hacker-news.firebaseio.com/v0/topstories.json",
                     method: .get)
            .responseData { response in
                guard response.error == nil else {
                    return completion([], response.error)
                }

                guard let data = response.data else {
                    return completion([], HackerRankError.noData)
                }

                let decoder = JSONDecoder()
                let stories = (try? decoder.decode([Int].self, from: data)) ?? []
                return completion(stories, nil)
        }
    }

    func getStory(id: Int, completion: @escaping (HackerRankStory?, Error?) -> Void) {
        SessionManager.default
            .request("https://hacker-news.firebaseio.com/v0/item/\(id).json",
                     method: .get)
            .responseData { response in
                guard response.error == nil else {
                    return completion(nil, response.error)
                }

                guard let data = response.data else {
                    return completion(nil, HackerRankError.noData)
                }

                let decoder = JSONDecoder()
                let story = try? decoder.decode(HackerRankStory.self, from: data)
                return completion(story, nil)
        }
    }
}

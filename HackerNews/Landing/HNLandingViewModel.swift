//
//  HackerNewsLandingViewModel.swift
//  HackerNewsCollectionView
//
//  Created by Prickett, Jacob (J.A.) on 10/18/19.
//  Copyright © 2019 Prickett, Jacob (J.A.). All rights reserved.
//

import Foundation

public protocol HNLandingViewable: AnyObject {

    var topStoriesCount: Int { get }
    var storiesLoaded: Int { get }
    var topStories: [HackerRankStory?] { get }

    func setup(closure: @escaping () -> Void)
    func getStoryDetails(closure: @escaping () -> Void)
}

class HNLandingViewModel: HNLandingViewable {

    private let service: HackerRankServicable

    private var increment: Int = 15
    private var isFetching = false
    private var topStoryIds: [Int] = []

    var topStoriesCount: Int {
        topStories.count
    }

    var storiesLoaded: Int = 0

    var topStories: [HackerRankStory?] = []

    init(service: HackerRankServicable) {
        self.service = service
    }

    func setup(closure: @escaping () -> Void) {
        service.getTopStories { [weak self] (stories, error) in
            guard error == nil else {
                print("Something went wrong!! \(error?.localizedDescription ?? "")")
                return
            }

            self?.topStoryIds = stories
            self?.getStoryDetails(closure: closure)
        }
    }

    func getStoryDetails(closure: @escaping () -> Void) {
        guard
            !isFetching,
            storiesLoaded < topStoryIds.count else { return }

        if storiesLoaded + increment > topStoryIds.count {
            increment = topStoryIds.count - storiesLoaded
        }

        let dispatchGroup = DispatchGroup()
        isFetching = true

        for i in storiesLoaded..<(storiesLoaded + increment) {
            topStories.append(nil)
            dispatchGroup.enter()
            service.getStory(id: topStoryIds[i]) { [weak self] (story, error) in
                self?.topStories[i] = story
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.isFetching = false
            self?.storiesLoaded += self?.increment ?? 0
            closure()
        }
    }
}

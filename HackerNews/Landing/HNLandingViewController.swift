//
//  ViewController.swift
//  HackerNewsCollectionView
//
//  Created by Prickett, Jacob (J.A.) on 10/18/19.
//  Copyright © 2019 Prickett, Jacob (J.A.). All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

class HNLandingViewController: UIViewController {

    private var tableView: UITableView = UITableView()
    private var viewModel: HNLandingViewable

    init(viewModel: HNLandingViewable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        let vm = HNLandingViewModel(service: HackerRankService())
        self.init(viewModel: vm)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hacker News"

        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        viewModel.setup { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension HNLandingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.topStoriesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if viewModel.storiesLoaded-1 == indexPath.row {
            viewModel.getStoryDetails {
                tableView.reloadData()
            }
        }

        guard let story = viewModel.topStories[indexPath.row] else {
            fatalError("Shit not loaded at \(indexPath.row)")
        }

        let cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: "story-cell")

        cell.textLabel?.text = story.title
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = "\(story.numberOfPoints)(\(story.urlString))\(story.by)"
        
        return cell
    }

}

extension HNLandingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            let story = viewModel.topStories[indexPath.row],
            let url = URL(string: story.url ?? "") else {
                return
        }

        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .popover
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

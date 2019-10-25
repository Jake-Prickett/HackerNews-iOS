//
//  ViewController.swift
//  HackerNewsCollectionView
//
//  Created by Prickett, Jacob (J.A.) on 10/18/19.
//  Copyright © 2019 Prickett, Jacob (J.A.). All rights reserved.
//

import UIKit
import SnapKit

class HNLandingViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var viewModel: HNLandingViewable

    private lazy var layoutForCollectionView: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        var height: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize >= 21
            ? 220.0 : 180.0
        layout.itemSize = CGSize(width: self.view.frame.size.width * 0.42, height: height)
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 20.0)
        layout.footerReferenceSize = CGSize(width: self.view.frame.width, height: 20.0)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 20, bottom: 22, right: 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 23
        return layout
    }()

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

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layoutForCollectionView
        )

        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(HNStoryCell.self, forCellWithReuseIdentifier: HNStoryCell.reuseID)

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        viewModel.setup { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension HNLandingViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.topStoriesCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if viewModel.storiesLoaded-1 == indexPath.row {
            viewModel.getStoryDetails {
                collectionView.reloadData()
            }
        }

        guard let story = viewModel.topStories[indexPath.row] else {
            fatalError("Shit not loaded at \(indexPath.row)")
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HNStoryCell.reuseID,
                                                            for: indexPath) as? HNStoryCell else {
                                                                return UICollectionViewCell()
        }

        cell.textLabel.text = story.title
        cell.textLabel.numberOfLines = 0

//        cell.detailTextLabel?.text = "\(story.numberOfPoints) points (\(story.urlString))"
        return cell
    }

}

extension HNLandingViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let story = viewModel.topStories[indexPath.row],
            let url = URL(string: story.url ?? "") else {
                return
        }
        let vc = HNDetailsViewController(url: url)
        vc.title = story.urlString
        navigationController?.pushViewController(vc, animated: true)
    }
}

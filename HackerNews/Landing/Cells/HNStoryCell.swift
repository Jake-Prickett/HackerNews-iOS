//
//  HNStoryCell.swift
//  HackerNewsCollectionView
//
//  Created by Prickett, Jacob (J.A.) on 10/23/19.
//  Copyright © 2019 Prickett, Jacob (J.A.). All rights reserved.
//

import UIKit

class HNStoryCell: UICollectionViewCell {

    static let reuseID = "HNStoryCell"

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .lightGray

        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        fatalError("Interface Builder is not supported!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        fatalError("Interface Builder is not supported!")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        subTitleLabel.text = nil
    }

    private func layout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.right.equalTo(-10)
        }

        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.bottom.right.equalTo(-10)
        }
    }
}

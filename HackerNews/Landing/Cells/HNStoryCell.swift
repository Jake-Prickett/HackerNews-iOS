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

    lazy var textLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .lightGray
        self.textLabel.textAlignment = .center
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

        self.textLabel.text = nil
    }

    private func layout() {
        contentView.addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }
}

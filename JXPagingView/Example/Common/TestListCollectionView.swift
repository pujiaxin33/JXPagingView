//
//  TestListCollectionView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/10/9.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class TestListCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel = UILabel()
        titleLabel?.textAlignment = .center
        addSubview(titleLabel!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel?.frame = self.contentView.bounds
    }
}

class TestListCollectionView: UIView {
    var collectionView: UICollectionView?
    var listViewDidScrollCallback: ((UIScrollView) -> ())?

    deinit {
        listViewDidScrollCallback = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let itemMargin: CGFloat = 10
        let itemWidth = floor((UIScreen.main.bounds.size.width - itemMargin*4)/3)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets.init(top: itemMargin, left: itemMargin, bottom: itemMargin, right: itemMargin)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .white
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(TestListCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        addSubview(collectionView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        collectionView?.frame = self.bounds
    }
}

extension TestListCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestListCollectionViewCell
        cell.contentView.backgroundColor = .lightGray
        cell.titleLabel?.text = String(format: "%d", indexPath.item)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}

extension TestListCollectionView: JXPagingViewListViewDelegate {
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.collectionView!
    }
}

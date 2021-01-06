//
//  ListCollectionViewController.swift
//  JXPagingViewExample
//
//  Created by jiaxin on 2019/12/30.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPagingView

class ListCollectionViewController: UIViewController {
    let collectionView: UICollectionView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let itemMargin: CGFloat = 10
        let itemWidth = floor((UIScreen.main.bounds.size.width - itemMargin*4)/3)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets.init(top: itemMargin, left: itemMargin, bottom: itemMargin, right: itemMargin)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.alwaysBounceHorizontal = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        //列表的contentInsetAdjustmentBehavior失效，需要自己设置底部inset
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIApplication.shared.keyWindow!.jx_layoutInsets().bottom, right: 0)
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        collectionView.frame = view.bounds
    }
}

extension ListCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ListCollectionViewCell
        cell.contentView.backgroundColor = .lightGray
        cell.titleLabel.text = String(format: "%d", indexPath.item)
        return cell
    }
}

class ListCollectionViewCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = self.contentView.bounds
    }
}

extension ListCollectionViewController: JXPagingViewListViewDelegate {
    
    func listScrollView() -> UIScrollView { collectionView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
}

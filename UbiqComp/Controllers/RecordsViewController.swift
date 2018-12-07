//
//  HomeViewController.swift
//  UbiqComp
//
//  Created by Yassin Mziya on 11/26/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {

    var collectionView: UICollectionView!
    var data: [Int] = [1,2,3]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecordsCollectionViewCell.self, forCellWithReuseIdentifier: RecordsCollectionViewCell.identifier)
        view.addSubview(collectionView)
    }
    
//    func setupConstaints() {
//        collectionView.snp.makeConstraints { make in
//            make.leading.top.trailing.bottom.equalToSuperview()
//        }
//    }
}

extension RecordsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2) - 8, height: view.frame.height/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension RecordsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: RecordsCollectionViewCell.identifier, for: indexPath) as! RecordsCollectionViewCell
        cell.setNeedsUpdateConstraints()
        return cell
    }
}

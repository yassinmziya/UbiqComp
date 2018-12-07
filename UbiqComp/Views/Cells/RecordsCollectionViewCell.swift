//
//  HomeCollectionViewCell.swift
//  UbiqComp
//
//  Created by Yassin Mziya on 11/26/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
// import SnapKit

class RecordsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "recordsCvCell"
    
//    override var isSelected: Bool {
//        didSet {
//            layer.backgroundColor = isSelected ? UIColor.white.cgColor : UIColor.black.cgColor
//            bpmLabel.textColor = isSelected ? UIColor.black : UIColor.white
//            timeStampLabel.textColor = isSelected ? UIColor.black : UIColor.white
//        }
//    }
    
    var bpmLabel: UILabel!
    var timeStampLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.white.cgColor
        
        bpmLabel = UILabel()
        bpmLabel.textAlignment = .center
        bpmLabel.text = "68"
        bpmLabel.textColor = .white
        bpmLabel.font = UIFont.systemFont(ofSize: 72, weight: .bold)
        addSubview(bpmLabel)
        
        timeStampLabel = UILabel()
        timeStampLabel.text = "Mon, 26 Nov 2018 23:46:05"
        timeStampLabel.textColor = .white
        timeStampLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        timeStampLabel.textAlignment = .center
        addSubview(timeStampLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        bpmLabel.snp.makeConstraints { make in
//            make.left.trailing.top.equalToSuperview()
//            make.bottom.equalTo(contentView.snp.centerY).offset(20)
//        }
//        
//        timeStampLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(4)
//            make.trailing.equalToSuperview().offset(-4)
//            make.top.equalTo(bpmLabel.snp.bottom)
//        }
//    }
}

//
//  PlaylistsTableViewCell.swift
//  UbiqComp
//
//  Created by Yassin Mziya on 11/29/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {
    static let identifier = "pplaylist cell"
    
    var nameLabel: UILabel!
    var songCountLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        
        nameLabel = UILabel()
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        songCountLabel = UILabel()
        songCountLabel.textColor = .white
        songCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        songCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(songCountLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
            ])
        
        NSLayoutConstraint.activate([
            songCountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            songCountLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

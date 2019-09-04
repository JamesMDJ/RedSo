//
//  EmployeeTableViewCell.swift
//  RedSo
//
//  Created by 馬丹君 on 2019/9/3.
//  Copyright © 2019 MaJ. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var expertiseLabel: UILabel!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var descriptionSatckView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

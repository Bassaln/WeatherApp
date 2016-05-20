//
//  WeekCell.swift
//  LQWeather
//
//  Created by 大可立青 on 16/4/30.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit

class WeekCell: UITableViewCell {
    
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var isTodayLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

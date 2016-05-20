//
//  SubFoldingCell.swift
//  LQFoldCell
//
//  Created by 大可立青 on 16/5/11.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit

class SubFoldingCell: FoldingCell {
    
    @IBOutlet var cityNameLabels: [UILabel]!
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet var weatherImageViews: [UIImageView]!
    @IBOutlet var tempLabels: [UILabel]!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    
    @IBOutlet weak var highestTempLabel: UILabel!
    @IBOutlet weak var lowestTempLabel: UILabel!
    
    @IBOutlet weak var weeklyWeatherView:RotatedView!
    
    @IBOutlet weak var firstContainerView:RotatedView!
    
    @IBOutlet weak var indicatorView:UIActivityIndicatorView!
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .MediumStyle
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var rowData:DailyWeather?{
        didSet{
            guard let data = rowData else{
                return
            }
            windStr = data.wind+"\(data.winp)"
            humidStr = data.humidity
            timeStr = dateFormatter.stringFromDate(NSDate())
            cityName = data.citynm
            tempStr = data.temperatureCurr
            highestTempStr = data.tempHigh+"℃"
            lowestTempStr = data.tempLow+"℃"
            guard let image = UIImage(data: NSData(contentsOfURL: NSURL(string: data.weatherIcon)!)!) else{
                weatherImage = UIImage(named: "default")
                return
            }
            weatherImage = image
        }
    }
    
    var windStr:String?{
        didSet{
            windLabel.text = windStr
        }
    }
    
    var humidStr:String?{
        didSet{
            humidLabel.text = humidStr
        }
    }
    
    var timeStr:String?{
        didSet{
            for timeLabel in timeLabels{
                timeLabel.text = timeStr
            }
        }
    }
    var cityName:String?{
        didSet{
            for cityNameLabel in cityNameLabels{
                cityNameLabel.text = cityName
            }
        }
    }
    var weatherImage:UIImage?{
        didSet{
            for weatherImageView in weatherImageViews{
                weatherImageView.image = weatherImage
            }
        }
    }
    var tempStr:String?{
        didSet{
            for tempLabel in tempLabels{
                tempLabel.text = tempStr
            }
        }
    }
    
    var highestTempStr:String?{
        didSet{
            highestTempLabel.text = highestTempStr
        }
    }
    
    var lowestTempStr:String?{
        didSet{
            lowestTempLabel.text = lowestTempStr
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(itemIndex: NSInteger, type: AnimationType) -> NSTimeInterval {
        let durations = [0.26,0.2,0.2]
        return durations[itemIndex]
    }
    
}

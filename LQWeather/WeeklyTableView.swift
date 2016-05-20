//
//  WeeklyTableView.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/20.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit

class WeeklyTableView: UITableView {
    
    var viewModel = WeeklyTableViewModel()
    weak var controllerTarget:LQTableViewController?
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        let weekNib = UINib(nibName: "WeekCell", bundle: nil)
        self.registerNib(weekNib, forCellReuseIdentifier: "weekCell")
        self.separatorStyle = .None
        self.backgroundColor = UIColor.clearColor()
        self.scrollEnabled = false
        
        self.viewModel.target = self
        //self.controllerTarget?.weeklyTableView = self
        
        self.delegate = viewModel
        self.dataSource = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        
    }

}

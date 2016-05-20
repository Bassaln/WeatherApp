//
//  CityTableView.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/19.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit

let cellID = "SearchCityCell"
class CityTableView: UIView {
    
    var searchBar:UISearchBar?
    
    var tableView:UITableView!
    
    weak var controllerTarget:SearchCityController!
    
    var viewModel = CityTableViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame.size = frame.size
        
        let backImageView = UIImageView(frame: self.frame)
        backImageView.image = UIImage(named: "default")
        backImageView.addSubview(blurEffectView)
        backImageView.userInteractionEnabled = true
        
        viewModel.target = self
        
        self.addSubview(backImageView)
        
        self.tableView = UITableView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64))
        self.tableView.registerClass(UITableViewCell().classForCoder, forCellReuseIdentifier: cellID)
        self.tableView.dataSource = viewModel
        self.tableView.delegate = viewModel
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = .None
        backImageView.addSubview(self.tableView)
        
        let label = UILabel(frame: CGRectMake(0,5,SCREEN_WIDTH,25))
        label.text = "输入城市名"
        label.font = UIFont.italicSystemFontOfSize(16)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        backImageView.addSubview(label)
        
        searchBar = UISearchBar(frame: CGRectMake(10,30,SCREEN_WIDTH-20,32))
        searchBar?.barStyle = .BlackTranslucent
        searchBar?.searchBarStyle = .Minimal
        searchBar?.showsCancelButton = true
        searchBar?.tintColor = UIColor.whiteColor()
        searchBar?.delegate = viewModel
        backImageView.addSubview(searchBar!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
    
    }

}

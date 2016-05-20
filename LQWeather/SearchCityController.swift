//
//  SearchCityController.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/7.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit
import YYImage

class SearchCityController: UIViewController{
    
    let cityManager = CityManager.sharedInstance

    var cityListView: CityTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityListView = CityTableView(frame: self.view.frame)
        self.view.addSubview(cityListView)
        cityListView.controllerTarget = self
        
        loadAllCity()
        
    }
    
    func loadAllCity(){
        cityManager.loadAllData { (data) in
            dispatch_async(dispatch_get_main_queue(), { 
                if let cityData = data where cityData.count > 0 {
                    self.cityListView.viewModel.citys = data
                    print("城市数：\(self.cityListView.viewModel.citys.count)")
                }else{
                    NetworkHelper.CityList.getData({ (data, error) in
                        guard let lqData = data else{
                            return
                        }
                        guard case let LQData.CityData(citys?) = lqData else{
                            return
                        }
                        self.cityListView.viewModel.citys = citys
                        self.cityManager.saveData(citys,shouldUpdate:true,completionHandler: { (success) in
                            if success{
                                print("save success")
                            }else{
                                print("could not save data")
                            }
                        })
                    })
                }
            })
        }
    }
    
    func loadCityMatchingFilter(matchStr:String){
        cityManager.loadDataMatchingFilter(matchStr) { (data) in
            dispatch_async(dispatch_get_main_queue(), { 
                if let citys = data {
                    self.cityListView.viewModel.currentCityList = citys
                }
            })
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        cityListView.searchBar?.becomeFirstResponder()
        cityListView.searchBar?.text = ""
        cityListView.viewModel.currentCityList = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

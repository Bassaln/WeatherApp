//
//  CityTableViewModel.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/19.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit

class CityTableViewModel: NSObject,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    weak var target:CityTableView!
    
    var citys:[City]!
    
    var currentCityList:[City]?{
        didSet{
            guard let _ = currentCityList else{
                return
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.target.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
        }
    }
    //汉字转拼音
    func transformToLatin(str:String)->String{
        let cfmString = NSMutableString(string: str) as CFMutableString
        //汉字转拼音(拼音带音调)
        guard CFStringTransform(cfmString, nil, kCFStringTransformMandarinLatin, false) else{
            return ""
        }
        //除去拼音的音调
        guard CFStringTransform(cfmString, nil, kCFStringTransformStripDiacritics, false) else{
            return ""
        }
        let tempArray = String(cfmString).componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return tempArray.joinWithSeparator("")
    }
    
    var searchText:String = ""{
        didSet{
            guard searchText != "" else{
                self.currentCityList = nil
                return
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.target.controllerTarget.loadCityMatchingFilter(transformToLatin(searchText).lowercaseString)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.currentCityList?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        guard currentCityList != nil else{
            return UITableViewCell(frame: CGRectZero)
        }
        
        cell.textLabel?.text = currentCityList![indexPath.row].citynm
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let city = self.currentCityList![indexPath.row]
        print(city.citynm)
        let cityListVC = LQTableViewController()
        cityListVC.weaid = city.weaid
        target.controllerTarget.presentViewController(cityListVC, animated: true, completion: nil)
    }
    
    
    
    //MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        target.searchBar?.text = ""
        self.searchText = ""
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = target.searchBar?.text ?? ""
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        return true
    }

}

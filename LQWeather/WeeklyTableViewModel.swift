//
//  WeeklyTableViewModel.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/20.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit

class WeeklyTableViewModel: NSObject,UITableViewDataSource,UITableViewDelegate {
    
    weak var target:WeeklyTableView?
    
    var weeklyData = [WeeklyWeather](){
        didSet{
            dispatch_async(dispatch_get_main_queue(), {
                self.target?.reloadData()
            })
        }
    }
    
    var weaid:String?{
        didSet{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                self.getDataWithWeaid(self.weaid!)
            }
            
        }
    }
    
    private func getDataWithWeaid(weaid:String){
        NetworkHelper.Future(weaid: weaid).getData { (data, error) in
            if let lqdata = data{
                
                guard case let LQData.WeeklyWeatherData(weeklyData?) = lqdata else{
                    return
                }
                self.weeklyData = weeklyData
            }else{
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let alertController = UIAlertController(title: "网络错误", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.target?.controllerTarget?.presentViewController(alertController, animated: true, completion: {
                        
                    })
                })
            }
        }
    }

    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weeklyData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cellID = "weekCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WeekCell
        cell.backgroundColor = UIColor.clearColor()
        let result = weeklyData[indexPath.row]
        cell.weekLabel.text = result.week
        cell.isTodayLabel.text = indexPath.row == 0 ? "今天" : ""
        
        let data = NSData(contentsOfURL: NSURL(string: result.weatherIcon)!)!
        cell.weatherImageView.image = UIImage(data: data)
        cell.highTempLabel.text = "\(result.tempHigh)℃"
        cell.lowTempLabel.text = "\(result.tempLow)℃"
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 36
    }


}

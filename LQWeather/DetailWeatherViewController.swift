//
//  WeeklyWeatherViewController.swift
//
//
//  Created by 大可立青 on 16/5/10.
//
//

import UIKit

class DetailWeatherViewController: UITableViewController {
    
    var results = [WeeklyWeather]()
    var result = [WeeklyWeather](){
        didSet{
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.tableView.reloadData()
            })
        }
    }
    var weaid:String = ""{
        didSet{
            print("didSet:\(weaid)")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                self.getDataWithWeaid(self.weaid)
            }
        }
    }
    
    let sectionTitles = ["","天气周报","天气简报","其他数据"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        
        let backImageView = UIImageView(frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        backImageView.image = UIImage(named: "default")
        backImageView.addSubview(blurEffectView)
        backImageView.userInteractionEnabled = true
        
        let headerNib = UINib(nibName: "HeaderCell", bundle: nil)
        let weekNib = UINib(nibName: "WeekCell", bundle: nil)
        let attachNib = UINib(nibName: "AttachCell", bundle: nil)
        let briefNib = UINib(nibName: "BriefCell", bundle: nil)
        
        tableView.registerNib(headerNib, forCellReuseIdentifier: "headerCell")
        tableView.registerNib(weekNib, forCellReuseIdentifier: "weekCell")
        tableView.registerNib(attachNib, forCellReuseIdentifier: "attachCell")
        tableView.registerNib(briefNib, forCellReuseIdentifier: "briefCell")
        
        tableView.backgroundView = backImageView
        tableView.separatorColor = UIColor(white: 0.5, alpha: 1)
        
    }
    
    private func getDataWithWeaid(weaid:String){
        NetworkHelper.Future(weaid: weaid).getData { (data, error) in
            if let lqdata = data{
                
                    guard case let LQData.WeeklyWeatherData(weeklyData?) = lqdata else{
                        return
                    }
                    self.results = weeklyData
                    self.result = [weeklyData.first!]
            }else{
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let alertController = UIAlertController(title: "网络错误", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: {
                        
                    })
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}


// MARK: - Table view data source
extension DetailWeatherViewController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case 1:
            return results.count
        default:
            return result.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellID = ""
        let weather = result[0]
        
        switch indexPath.section{
        case 0:
            cellID = "headerCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! HeaderCell
            cell.cityLabel.text = weather.citynm
            cell.weatherLabel.text = weather.weather
            cell.tempLabel.text = "\(weather.temperature)°"
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            return cell
        case 1:
            cellID = "weekCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WeekCell
            let result = results[indexPath.row]
            cell.weekLabel.text = result.week
            cell.isTodayLabel.text = indexPath.row == 0 ? "今天" : ""
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            
            let data = NSData(contentsOfURL: NSURL(string: result.weatherIcon)!)!
            cell.weatherImageView.image = UIImage(data: data)
            cell.highTempLabel.text = "\(result.tempHigh)°"
            cell.lowTempLabel.text = "\(result.tempLow)°"
            return cell
        case 2:
            cellID = "briefCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! BriefCell
            cell.briefLabel.text = "\(weather.weather);最高温:\(weather.tempHigh),最低温:\(weather.tempLow)"
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            return cell
        case 3:
            cellID = "attachCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! AttachCell
            cell.humidLabel.text = weather.humidity
            cell.windLabel.text = weather.wind
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            return cell
        default:
            let cell = UITableViewCell(frame: CGRectZero)
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            return cell
        }
    }

}


//MARK: - UITableViewDelegate
extension DetailWeatherViewController{
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 150
        case 3:
            return 88
        default:
            return 44
        }
    }
}

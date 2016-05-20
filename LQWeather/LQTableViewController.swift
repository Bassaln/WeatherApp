//
//  LQTableViewController.swift
//  LQFoldCell
//
//  Created by 大可立青 on 16/5/11.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit




class LQTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private let cellID = "SubFoldingCell"
    
    var tableView:UITableView!

    var plusBtn:UIButton!
    var closeBtn:UIButton!
    
    var weatherData:[DailyWeather]?
    {
        didSet{
            guard let data = weatherData else{
                return
            }
            cellHeights = [CGFloat](count:data.count,repeatedValue:kCloseCellHeight)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    var currentData:DailyWeather?{
        didSet{
            guard let data = currentData else{
                return
            }
            
            //if ((self.weatherData?.map({$0.weaid}).contains(data.weaid)) == nil){
            
            self.dailyManager.saveData([data],shouldUpdate:true,completionHandler: { (success) in
                if success{
                    self.loadLocalDailyWeather()
                    print("save success")
                }else{
                    print("save failure")
                }
            })
            //}
        }
    }
    
    var lastIndexPath:NSIndexPath?
    
    let dailyManager = DailyManager.sharedInstance
    
    var weaid:String = ""{
        didSet{
            self.getDataWithWeaid(weaid)
        }
    }
    
    //let lqQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let lqQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let realmGroup = dispatch_group_create()
    let uiGroup = dispatch_group_create()
    
    let kCloseCellHeight:CGFloat = 85
    let kOpenCellHeight:CGFloat = 470
    
    var cellHeights = [CGFloat](){
        didSet{
            guard cellHeights.count>0 else{
                return
            }
            let currHeights = cellHeights.reduce(0,combine:+)
            if currHeights-CGFloat(cellHeights.count)*kCloseCellHeight > 0{
                self.closeBtn.enabled = true
            }else{
                self.closeBtn.enabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame.size = self.view.frame.size
        
        let backImageView = UIImageView(frame: self.view.frame)
        backImageView.image = UIImage(named: "default")
        backImageView.addSubview(blurEffectView)
        backImageView.userInteractionEnabled = true
        
        self.view.addSubview(backImageView)
        
        self.tableView = UITableView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64))
        let cellNib = UINib(nibName: "SubFoldingCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: cellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = .None
        backImageView.addSubview(self.tableView)
        
        let topBar = UIView(frame: CGRectMake(0,0,SCREEN_WIDTH,64))
        topBar.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        backImageView.addSubview(topBar)
        
        self.plusBtn = UIButton(frame: CGRectMake(SCREEN_WIDTH-40,24,30,30))
        self.plusBtn.setImage(UIImage(named: "plusIcon"), forState: UIControlState.Normal)
        topBar.addSubview(plusBtn)
        self.plusBtn.addTarget(self, action: #selector(LQTableViewController.addCity), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.closeBtn = UIButton(frame: CGRectMake(10,24,30,30))
        self.closeBtn.setImage(UIImage(named: "close-button"), forState: UIControlState.Normal)
        self.closeBtn.enabled = false
        topBar.addSubview(closeBtn)
        self.closeBtn.addTarget(self, action: #selector(LQTableViewController.closeCell), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.loadLocalDailyWeather()
    }
    
    
    func loadLocalDailyWeather(){
        dailyManager.loadAllData { (data) in
            if let dailyData = data where dailyData.count > 0{
                self.weatherData = dailyData
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func closeCell(){
        if lastIndexPath != nil{
            if cellHeights[lastIndexPath!.row]==kOpenCellHeight{
                self.tableView(self.tableView, didSelectRowAtIndexPath: lastIndexPath!)
            }
        }
    }
    
    func addCity() {
        self.presentViewController(SearchCityController(), animated: true) { 
            
        }
    }
    
    func getDataWithWeaid(weaid:String){
        NetworkHelper.Today(weaid: weaid).getData { (data, error) in
            guard let lqdata = data else{
                print(error)
                return
            }
            guard case let LQData.DailyWeatherData(dailyWeather?) = lqdata else{
                return
            }
            self.currentData = dailyWeather
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Table view data source
extension LQTableViewController{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.weatherData?.count ?? 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! SubFoldingCell
        guard let rowData = self.weatherData?[indexPath.row] else{
            return UITableViewCell(frame: CGRectZero)
        }
        cell.selectionStyle = .None
        cell.rowData = rowData
        
        return cell
    }

}

// MARK: - Table view delegate
extension LQTableViewController{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return cellHeights.count>0 ? cellHeights[indexPath.row] : 44
        return cellHeights[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? SubFoldingCell else{
            return
        }
        
        if cell.isAnimating(){
            return
        }
        
        var duration = 0.0
        if self.cellHeights[indexPath.row]==self.kCloseCellHeight{  //open cell
            self.cellHeights[indexPath.row]=self.kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
                }, completion: nil)
            cell.indicatorView.hidden = false
            cell.indicatorView.startAnimating()
            
            guard let rowData = self.weatherData?[indexPath.row] else{
                return
            }
            
            if cell.weeklyWeatherView.subviews.count > 1{
                guard let subView = cell.weeklyWeatherView?.subviews[1] else{
                    return
                }
                subView.removeFromSuperview()
            }

            let weeklyTableView = WeeklyTableView(frame: CGRectMake(0, 9, cell.weeklyWeatherView.bounds.size.width, cell.weeklyWeatherView.bounds.size.height-9), style: UITableViewStyle.Plain)
            weeklyTableView.controllerTarget = self
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                weeklyTableView.viewModel.weaid = rowData.weaid
                cell.indicatorView.hidden = true
                cell.indicatorView.stopAnimating()
                dispatch_async(dispatch_get_main_queue(), {
                    cell.weeklyWeatherView.addSubview(weeklyTableView)
                })
            })
            
        }else{ //close cell
            self.cellHeights[indexPath.row]=self.kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
                }, completion: nil)
            guard cell.weeklyWeatherView.subviews.count > 1 else{
                return
            }
            guard let subView = cell.weeklyWeatherView?.subviews[1] else{
                return
            }
            subView.removeFromSuperview()
        }
        
        if let lastPath = lastIndexPath where lastPath != indexPath{
            if cellHeights[lastPath.row]==kOpenCellHeight{
                self.tableView(tableView, didSelectRowAtIndexPath: lastPath)
            }
        }
        
        lastIndexPath = indexPath
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return cellHeights[indexPath.row]==kCloseCellHeight ? true : false
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let cellHeight = cellHeights[indexPath.row]
        guard  cellHeight == kCloseCellHeight else{
            return nil
        }
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title:"删除") { (action, indexPath) in
            
            let rowData = self.weatherData![indexPath.row]
            self.weatherData?.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            self.dailyManager.deleteData(rowData, completionHandler: { (success) in
                if success{
                    print("delete success")
                }else{
                    print("delete failure")
                }
            })
            
        }
        deleteAction.backgroundColor = UIColor.clearColor()
        
        let moreAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "更多") { (action, indexPath) in
            let rowData = self.weatherData![indexPath.row]
            let detailVC = DetailWeatherViewController()
            detailVC.weaid = rowData.weaid
            self.navigationController?.pushViewController(detailVC, animated: true)
            self.tableView.reloadData()
        }
        moreAction.backgroundColor = UIColor.clearColor()
        return [deleteAction,moreAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell is FoldingCell{
            let foldingCell = cell as! FoldingCell
            foldingCell.backgroundColor = UIColor.clearColor()
            if cellHeights[indexPath.row]==kCloseCellHeight{
                foldingCell.selectedAnimation(false, animated: false, completion: nil)
            }else{
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }

}


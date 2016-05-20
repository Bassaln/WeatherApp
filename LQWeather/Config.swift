//
//  Config.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/7.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit

let documentsPath:String = {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths.first!
}()

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height


protocol ContainerWithoutDelete {
    associatedtype ItemType
    func saveData(data:[ItemType],shouldUpdate:Bool,completionHandler:(success:Bool)->Void)
    func loadAllData(completionHanlder:(data:[ItemType]?)->Void)
    func loadDataMatchingFilter(searchText:String,completionHanlder:(data:[ItemType]!)->Void)
    //
}

protocol ContainerWithDelete:ContainerWithoutDelete{
    func deleteData(data:ItemType,completionHandler:(success:Bool)->Void)
}
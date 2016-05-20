//
//  DailyManager.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/19.
//  Copyright © 2016年 dklq. All rights reserved.
//

import Foundation
import SwiftyDB

class DailyManager:ContainerWithDelete{
    
    typealias ItemType = DailyWeather
    
    let database = SwiftyDB(databaseName: String(ItemType.self))
    
    private init() {
    }
    //创建单例
    static let sharedInstance = DailyManager()
    
    //保存数据
    func saveData(data:[ItemType],shouldUpdate:Bool,completionHandler:(success:Bool)->Void){
        database.asyncAddObjects(data, update: shouldUpdate) { (result) in
            if let error = result.error{
                print(error)
                completionHandler(success: false)
            }else{
                completionHandler(success: true)
            }
        }
    }
    
    //查询所有数据
    func loadAllData(completionHanlder:(data:[ItemType]?)->Void){
        database.asyncObjectsForType(ItemType.self) { (result) in
            if let data = result.value{
                completionHanlder(data: data)
            }else{
                completionHanlder(data: nil)
            }
        }
    }
    
    
    //根据条件查询数据
    func loadDataMatchingFilter(searchText:String,completionHanlder:(data:[ItemType]!)->Void){
        let filter = Filter.like("cityno", pattern: "\(searchText)%")
        database.asyncObjectsForType(ItemType.self, matchingFilter: filter) { (result) in
            if let data = result.value{
                completionHanlder(data: data)
            }else{
                completionHanlder(data: nil)
            }
        }
    }
    
    //删除数据
    func deleteData(data:ItemType,completionHandler:(success:Bool)->Void){
        let filter = Filter.equal("weaid", value: data.weaid)
        database.asyncDeleteObjectsForType(ItemType.self, matchingFilter: filter) { (result) in
            if let deleteOK = result.value{
                completionHandler(success: deleteOK)
            }
            if let error = result.error{
                print(error)
                completionHandler(success: false)
            }
        }
    }
}

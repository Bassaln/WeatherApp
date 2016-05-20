//
//  LQCacheManager.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/20.
//  Copyright © 2016年 dklq. All rights reserved.
//

import UIKit

class LQCacheManager:NSObject{
    //读取缓存大小
    static func returnCacheSize()->String{
        return String(format: "%.2f", LQCacheManager.folderSize(at: NSHomeDirectory()))
    }
    
    
    /**
     计算单个文件的大小，单位：MB
     
     - parameter path: 文件的路径
     
     - returns: 文件的大小
     */
    static func returnFileSize(at path:String)->Double{
        let manager = NSFileManager.defaultManager()
        var fileSize:Double = 0
        do{
            fileSize = try manager.attributesOfItemAtPath(path)["NSFileSize"] as! Double
        }catch{
            print(error)
        }
        
        return fileSize/1024/1024
    }
    
    /**
     遍历所有子目录，并计算文件大小
     
     - parameter folderPath: 目录路径
     
     - returns: 返回文件大小
     */
    static func folderSize(at folderPath:String)->Double{
        let manager = NSFileManager.defaultManager()
        if !manager.fileExistsAtPath(folderPath){
            return 0
        }
        let childFilePaths = manager.subpathsAtPath(folderPath)
        var fileSize:Double = 0
        for subPath in childFilePaths!{
            let fileAbsoluePath = folderPath + "/" + subPath
            fileSize += LQCacheManager.returnFileSize(at: fileAbsoluePath)
        }
        return fileSize
    }
    
    static func cleanCache(){
        LQCacheManager.deleteFolder(at: NSHomeDirectory()+"/Documents")
        LQCacheManager.deleteFolder(at: NSHomeDirectory()+"/Library")
        LQCacheManager.deleteFolder(at: NSHomeDirectory()+"/tmp")
    }
    
    static func deleteFile(at path:String){
        let manager = NSFileManager.defaultManager()
        do{
            try manager.removeItemAtPath(path)
        }catch{
            
        }
    }
    
    static func deleteFolder(at folderPath:String){
        let manager = NSFileManager.defaultManager()
        if !manager.fileExistsAtPath(folderPath){
            return
        }
        let childFilePaths = manager.subpathsAtPath(folderPath)
        for subPath in childFilePaths!{
            let fileAbsoluePath = folderPath + "/" + subPath
            LQCacheManager.deleteFile(at: fileAbsoluePath)
        }

    }
    
}

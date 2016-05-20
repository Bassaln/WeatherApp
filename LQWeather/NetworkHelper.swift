//
//  NetworkHelper.swift
//  LQWeather
//
//  Created by 大可立青 on 16/5/7.
//  Copyright © 2016年 dklq. All rights reserved.
//

import Foundation
import Just

class Manager{
    static let sharedInstance = Manager()
    private init(){}
}

enum LQData{
    case WeeklyWeatherData([WeeklyWeather]?)
    case DailyWeatherData(DailyWeather?)
    case AQIData(AQI?)
    case HistoryWeatherData([HistoryWeather]?)
    case CityData([City]?)
    //case WeatherTypeData([WeatherType]?)
}

enum NetworkHelper{
    case Future(weaid:String)
    case Today(weaid:String)
    case PM25(weaid:String)
    case History(date:String,weaid:String)
    case CityList
    case WType
    
    private static let baseUrl = "http://api.k780.com:88/"
    
    private static var params = ["appkey":"19079","sign":"63be8777f312b8fe12027c66a2d408bd","format":"json"]
    
    func getData(handler:(data:LQData?,error:String?)->Void){
        var data:LQData?
        var error:String?
        switch self{
        case .Future(weaid: let weaid):
            NetworkHelper.params["app"] = "weather.future"
            NetworkHelper.params["weaid"] = weaid
            Just.get(NetworkHelper.baseUrl, params: NetworkHelper.params, asyncCompletionHandler: { (r) in
                if r.ok{
                    guard let jsonDict = r.json as? NSDictionary else{
                        error = "返回的不是json数据"
                        return
                    }
                    
                    guard let success = jsonDict["success"] where success as! String == "1" else{
                        error = "返回数据有误，或者授权错误"
                        return
                    }
                    guard let resultDicts = jsonDict["result"] as? [NSDictionary] else{
                        return
                    }
                    
                    var weeklyData:[WeeklyWeather] = []
                    for dict in resultDicts{
                        let weeklyWeather = WeeklyWeather.fromDictionary(dict)
                        weeklyData.append(weeklyWeather)
                    }
                    data = LQData.WeeklyWeatherData(weeklyData)
                }else{
                    error = "服务器出错"
                }
                handler(data: data, error: error)
            })
        case .Today(weaid: let weaid):
            NetworkHelper.params["app"] = "weather.today"
            NetworkHelper.params["weaid"] = weaid
            Just.get(NetworkHelper.baseUrl, params: NetworkHelper.params, asyncCompletionHandler: { (r) in
                if r.ok{
                    guard let jsonDict = r.json as? NSDictionary else{
                        error = "返回的不是json数据"
                        return
                    }
                    
                    guard let success = jsonDict["success"] where success as! String == "1" else{
                        error = "返回数据有误，或者授权错误"
                        return
                    }
                    guard let result = jsonDict["result"] as? NSDictionary else{
                        return
                    }
                    
                    let dailyWeatherData = DailyWeather.fromDictionary(result)
                    data = LQData.DailyWeatherData(dailyWeatherData)
                }else{
                    error = "服务器出错"
                }
                handler(data: data, error: error)
            })
        case .PM25(weaid: let weaid):
            NetworkHelper.params["app"] = "weather.pm25"
            NetworkHelper.params["weaid"] = weaid
            Just.get(NetworkHelper.baseUrl, params: NetworkHelper.params, asyncCompletionHandler: { (r) in
                if r.ok{
                    guard let jsonDict = r.json as? NSDictionary else{
                        error = "返回的不是json数据"
                        return
                    }
                    
                    guard let success = jsonDict["success"] where success as! String == "1" else{
                        error = "返回数据有误，或者授权错误"
                        return
                    }
                    guard let aqiDict = jsonDict["result"] as? NSDictionary else{
                        return
                    }
                    let aqiData = AQI.fromDictionary(aqiDict)
                    data = LQData.AQIData(aqiData)
                }else{
                    error = "服务器出错"
                }
                handler(data: data, error: error)
            })
        case .History(date: let dateStr, weaid: let weaid):
            NetworkHelper.params["app"] = "weather.history"
            NetworkHelper.params["date"] = dateStr
            NetworkHelper.params["weaid"] = weaid
            Just.get(NetworkHelper.baseUrl, params: NetworkHelper.params, asyncCompletionHandler: { (r) in
                if r.ok{
                    guard let jsonDict = r.json as? NSDictionary else{
                        error = "返回的不是json数据"
                        return
                    }
                    
                    guard let success = jsonDict["success"] where success as! String == "1" else{
                        error = "返回数据有误，或者授权错误"
                        return
                    }
                    guard let resultDicts = jsonDict["result"] as? [NSDictionary] else{
                        return
                    }
                    
                    var historyData:[HistoryWeather] = []
                    for dict in resultDicts{
                        let history = HistoryWeather.fromDictionary(dict)
                        historyData.append(history)
                    }
                    data = LQData.HistoryWeatherData(historyData)
                }else{
                    error = "服务器出错"
                }
                handler(data: data, error: error)
            })
        case .CityList:
            NetworkHelper.params["app"] = "weather.city"
            Just.get(NetworkHelper.baseUrl, params: NetworkHelper.params, asyncCompletionHandler: { (r) in
                
                var cityData = [City]()
                if r.ok{
                    guard let jsonDict = r.json as? NSDictionary else{
                        error = "返回的不是json数据"
                        return
                    }
                    
                    guard let success = jsonDict["success"] where success as! String == "1" else{
                        error = "返回数据有误，或者授权错误"
                        return
                    }
                    if let cityDict = jsonDict["result"] as? [String:NSDictionary]{
                        for (_,dict) in cityDict{
                            let city = City.fromDictionary(dict)
                            cityData.append(city)
                        }
                    }
                    data = LQData.CityData(cityData)
                }else{
                    error = "服务器出错"
                }
                handler(data: data, error: error)
            })
        case .WType:
            break
        }
    }
}

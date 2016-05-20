//
//	HistoryWeather.swift
//	JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyDB

class HistoryWeather: NSObject,Storable {

	 var aqi: String!
	 var cityid: String!
	 var citynm: String!
	 var cityno: String!
	 var humidity: String!
	 var temp: String!
	 var temperature: String!
	 var uptime: String!
	 var weaid: String!
	 var weather: String!
	 var weatherIcon: String!
	 var weatid: String!
	 var week: String!
	 var wind: String!
	 var windid: String!
	 var winp: String!
	 var winpid: String!
    
    
    override required init() {
        super.init()
    }
}


//MARK: - 用字典来初始化一个实例并设置各个属性值
extension HistoryWeather{
    class func fromDictionary(dictionary: NSDictionary) -> HistoryWeather	{
        let this = HistoryWeather()
        if let aqiValue = dictionary["aqi"] as? String{
            this.aqi = aqiValue
        }
        if let cityidValue = dictionary["cityid"] as? String{
            this.cityid = cityidValue
        }
        if let citynmValue = dictionary["citynm"] as? String{
            this.citynm = citynmValue
        }
        if let citynoValue = dictionary["cityno"] as? String{
            this.cityno = citynoValue
        }
        if let humidityValue = dictionary["humidity"] as? String{
            this.humidity = humidityValue
        }
        if let tempValue = dictionary["temp"] as? String{
            this.temp = tempValue
        }
        if let temperatureValue = dictionary["temperature"] as? String{
            this.temperature = temperatureValue
        }
        if let uptimeValue = dictionary["uptime"] as? String{
            this.uptime = uptimeValue
        }
        if let weaidValue = dictionary["weaid"] as? String{
            this.weaid = weaidValue
        }
        if let weatherValue = dictionary["weather"] as? String{
            this.weather = weatherValue
        }
        if let weatherIconValue = dictionary["weather_icon"] as? String{
            this.weatherIcon = weatherIconValue
        }
        if let weatidValue = dictionary["weatid"] as? String{
            this.weatid = weatidValue
        }
        if let weekValue = dictionary["week"] as? String{
            this.week = weekValue
        }
        if let windValue = dictionary["wind"] as? String{
            this.wind = windValue
        }
        if let windidValue = dictionary["windid"] as? String{
            this.windid = windidValue
        }
        if let winpValue = dictionary["winp"] as? String{
            this.winp = winpValue
        }
        if let winpidValue = dictionary["winpid"] as? String{
            this.winpid = winpidValue
        }
        return this
    }
}

//MARK: - 设置主键
extension HistoryWeather:PrimaryKeys{
    static func primaryKeys() -> Set<String> {
        return ["weaid"]
    }
}
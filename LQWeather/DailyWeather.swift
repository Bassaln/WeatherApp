//
//	DailyWeather.swift
//	JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyDB

class DailyWeather: NSObject,Storable {

	 var cityid: String!
	 var citynm: String!
	 var cityno: String!
	 var days: String!
	 var humiHigh: String!
	 var humiLow: String!
	 var humidity: String!
	 var tempCurr: String!
	 var tempHigh: String!
	 var tempLow: String!
	 var temperature: String!
	 var temperatureCurr: String!
	 var weaid: String!
	 var weather: String!
	 var weatherIcon: String!
	 var weatherIcon1: String!
	 var weatid: String!
	 var weatid1: String!
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
extension DailyWeather{
    class func fromDictionary(dictionary: NSDictionary) -> DailyWeather	{
        let this = DailyWeather()
        if let cityidValue = dictionary["cityid"] as? String{
            this.cityid = cityidValue
        }
        if let citynmValue = dictionary["citynm"] as? String{
            this.citynm = citynmValue
        }
        if let citynoValue = dictionary["cityno"] as? String{
            this.cityno = citynoValue
        }
        if let daysValue = dictionary["days"] as? String{
            this.days = daysValue
        }
        if let humiHighValue = dictionary["humi_high"] as? String{
            this.humiHigh = humiHighValue
        }
        if let humiLowValue = dictionary["humi_low"] as? String{
            this.humiLow = humiLowValue
        }
        if let humidityValue = dictionary["humidity"] as? String{
            this.humidity = humidityValue
        }
        if let tempCurrValue = dictionary["temp_curr"] as? String{
            this.tempCurr = tempCurrValue
        }
        if let tempHighValue = dictionary["temp_high"] as? String{
            this.tempHigh = tempHighValue
        }
        if let tempLowValue = dictionary["temp_low"] as? String{
            this.tempLow = tempLowValue
        }
        if let temperatureValue = dictionary["temperature"] as? String{
            this.temperature = temperatureValue
        }
        if let temperatureCurrValue = dictionary["temperature_curr"] as? String{
            this.temperatureCurr = temperatureCurrValue
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
        if let weatherIcon1Value = dictionary["weather_icon1"] as? String{
            this.weatherIcon1 = weatherIcon1Value
        }
        if let weatidValue = dictionary["weatid"] as? String{
            this.weatid = weatidValue
        }
        if let weatid1Value = dictionary["weatid1"] as? String{
            this.weatid1 = weatid1Value
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
extension DailyWeather:PrimaryKeys{
    static func primaryKeys() -> Set<String> {
        return ["weaid"]
    }
}
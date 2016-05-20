//
//	WeatherType.swift
//	JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyDB

class WeatherType: NSObject,Storable {

	var weather: String!
	var weatherIcon: String!
	var weatid: String!
    
    
    override required init() {
        super.init()
    }
}


//MARK: - 用字典来初始化一个实例并设置各个属性值
extension WeatherType{

    class func fromDictionary(dictionary: NSDictionary) -> WeatherType	{
        let this = WeatherType()
        if let weatherValue = dictionary["weather"] as? String{
            this.weather = weatherValue
        }
        if let weatherIconValue = dictionary["weather_icon"] as? String{
            this.weatherIcon = weatherIconValue
        }
        if let weatidValue = dictionary["weatid"] as? String{
            this.weatid = weatidValue
        }
        return this
    }
}

//MARK: - 设置主键
extension WeatherType:PrimaryKeys{
    static func primaryKeys() -> Set<String> {
        return ["weatid"]
    }
}
//
//	AQI.swift
//	JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyDB

class AQI:NSObject,Storable{

	 var aqi: String!
	 var aqiLevid: String!
	 var aqiLevnm: String!
	 var aqiRemark: String!
	 var aqiScope: String!
	 var cityid: String!
	 var citynm: String!
	 var cityno: String!
	 var weaid: String!
    
    override required init() {
        super.init()
    }

	
}

//MARK: - 用字典来初始化一个实例并设置各个属性值
extension AQI{
    class func fromDictionary(dictionary: NSDictionary) -> AQI	{
        let this = AQI()
        if let aqiValue = dictionary["aqi"] as? String{
            this.aqi = aqiValue
        }
        if let aqiLevidValue = dictionary["aqi_levid"] as? String{
            this.aqiLevid = aqiLevidValue
        }
        if let aqiLevnmValue = dictionary["aqi_levnm"] as? String{
            this.aqiLevnm = aqiLevnmValue
        }
        if let aqiRemarkValue = dictionary["aqi_remark"] as? String{
            this.aqiRemark = aqiRemarkValue
        }
        if let aqiScopeValue = dictionary["aqi_scope"] as? String{
            this.aqiScope = aqiScopeValue
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
        if let weaidValue = dictionary["weaid"] as? String{
            this.weaid = weaidValue
        }
        return this
    }

}
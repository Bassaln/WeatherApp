//
//	City.swift
//	JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyDB
class City:NSObject,Storable{

	var cityid: String!
	var citynm: String!
	var cityno: String!
	var weaid: String!


    override required init() {
        super.init()
    }
}

//MARK: - 用字典来初始化一个实例并设置各个属性值
extension City{
    
    class func fromDictionary(dictionary: NSDictionary) -> City	{
        let this = City()
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


//MARK: - 设置主键
extension City:PrimaryKeys{
    static func primaryKeys() -> Set<String> {
        return ["cityid"]
    }
}
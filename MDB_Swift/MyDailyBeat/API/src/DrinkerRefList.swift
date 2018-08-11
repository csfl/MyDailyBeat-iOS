//
//  DrinkerRefList.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/28/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

public enum PrefType {
    case USER
    case MATCHING
}

private var s_list: DrinkerRefList = DrinkerRefList()
public class DrinkerRefList: NSObject {
    open fileprivate(set) var list: [Int: String] = [Int: String]()
    fileprivate var loaded: Bool = false
    override fileprivate init() {
        super.init()
    }
    
    public func getStringForIndex(_ index: Int, prefType: PrefType) -> String? {
        if index == 4 {
            return self.list[index]
        } else if index == 1 {
            if prefType == .USER {
                return "I don't drink"
            } else {
                return "Doesn't drink"
            }
        } else if index == 2 {
            if prefType == .USER {
                return "I seldom drink"
            } else {
                return "Seldom drinks"
            }
        } else {
            if prefType == .USER {
                return "I enjoy drinking regularly"
            } else {
                return "Enjoys drinking regularly"
            }
        }
    }
    
    public class func getInstance() -> DrinkerRefList {
        if !s_list.loaded {
            s_list.load()
        }
        return s_list
    }
    
    public func load() {
        let json = RestAPI.getInstance().getDrinkerRefList()
        let arr = json.arrayValue
        for value in arr {
            let id = value["drnkr_ref_id"].intValue
            let desc = value["drnkr_dsc"].stringValue
            list[id] = desc
        }
        self.loaded = true
    }
}

public class DrinkerValueTransformer: ValueTransformer {
    override public class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        let list = DrinkerRefList.getInstance().list
        let index = value as? Int ?? 0
        return list[index]
    }
    
    
}

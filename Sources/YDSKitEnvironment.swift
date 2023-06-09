//
//  YDSKitEnvironment.swift
//  
//
//  Created by 장진호(Jang, Jinho) on 2022/08/25.
//

import Foundation

internal class YDSKitEnvironment {
    static internal let shared: YDSKitEnvironment = YDSKitEnvironment()
    
    private init() {}
    
    var bundle: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: YDSColor.self)
        #endif
    }
}

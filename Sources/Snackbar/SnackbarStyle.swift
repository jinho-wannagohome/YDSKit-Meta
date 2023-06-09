//
//  SnackbarStyle.swift
//  
//
//  Created by 윤태민(Yun, Taemin) on 2022/12/21.
//

import UIKit

public struct SnackbarStyle {
    public enum Duration: CGFloat {
        case short
        case long
        case indefinite

        var value: CGFloat {
            switch self {
            case .short: return 1.5
            case .long: return 3.0
            case .indefinite: return .greatestFiniteMagnitude
            }
        }
    }
    
    public enum Direction {
        case upwards
        case downwards
        
        var reverse: Direction {
            switch self {
            case .upwards:      return .downwards
            case .downwards:    return .upwards
            }
        }
        
        func getSafeAreaInset(in view: UIView) -> CGFloat {
            switch self {
            case .upwards:      return view.safeAreaInsets.bottom
            case .downwards:    return view.safeAreaInsets.top
            }
        }
    }
    
    public internal(set) var duration: Duration
    
    public internal(set) var direction: Direction
    
    public init(duration: Duration = .short, direction: Direction = .upwards) {
        self.duration = duration
        self.direction = direction
    }
}

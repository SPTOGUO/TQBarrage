//
//  BarrageFactory.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/14.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit

class BarrageFactory {
    static func creatBarrage(descriptor: BarrageDescriptor, configuration: BarrageConfiguration) -> Barrage? {
        let type = BarrageType(rawValue: descriptor.type)
        guard let barrageType = type else { return nil }
        
        let barrage = createBarrage(type: barrageType)
        barrage.time = descriptor.time
        barrage.text = descriptor.text
        barrage.textColor = descriptor.color
        barrage.textSize = configuration.fontSize
        barrage.duration = configuration.duration
        
        return barrage
        
    }
    
    static func createBarrage(type: BarrageType) -> Barrage{
        switch type {
        case .rightToLeft:
            let barrage = BarrageRightHorizontal(type: type)
            return barrage
        case .leftToRight:
            let barrage = BarrageleftHorizontal(type: type)
            return barrage
        case .topToBottom:
            let barrage = BarrageTopVertical(type: type)
            return barrage
        case .bottomToTop:
            let barrage = BarrageBottomVertical(type: type)
            return barrage
        }
    }
}



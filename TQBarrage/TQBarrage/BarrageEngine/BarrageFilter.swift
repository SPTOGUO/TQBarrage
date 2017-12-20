//
//  BarrageFilter.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/16.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import Foundation

class BarrageFilter {
    static func filterBarrage(barrages: [Barrage], currentTime: Double) -> [Barrage]{
        guard barrages.count >= 1 else { return [Barrage]() }
        
        if !barrages.last!.isDraw(currentTime: currentTime) {
            return [Barrage]()
        }
        
        if barrages.first!.isLate(currentTime: currentTime) {
            return barrages
        }
        
        return cut(barrages: barrages, currentTime: currentTime)
    }
    
    static func cut(barrages: [Barrage], currentTime: Double) -> [Barrage] {
        var minIndex = 0
        var maxIndex = barrages.count - 1
        var index = 0
        var barrage: Barrage!
        while maxIndex - minIndex > 1 {
            index = (maxIndex + minIndex) / 2
            barrage = barrages[index]
            if barrage.isDraw(currentTime: currentTime) {
                maxIndex = index
            } else {
                minIndex = index
            }
        }
        var subIndex = 0
        return barrages.filter({ (_) -> Bool in
            let filter = subIndex >= maxIndex
            subIndex += 1
            return filter
        })
    }
}

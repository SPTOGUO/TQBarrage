//
//  BarrageRetainer.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/16.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit

class BarrageRetainer {
    private var hitBarrages = [Int :Barrage]()
    
    var configuration: BarrageConfiguration!
    fileprivate var canvasSize: CGSize!
    var maxPyIndex: Int = 0
    
    func setCanvasSize(canvasSize: CGSize) {
        self.canvasSize = canvasSize
        self.maxPyIndex = Int(canvasSize.height / self.configuration.height)
    }

    
    func clear() {
        hitBarrages.removeAll()
    }
    
    func clearVisible(barrage: Barrage) {
        let pyIndex = Int(barrage.originY / self.configuration.height)
        let hitBarrage = self.hitBarrages[pyIndex]
        if let hBarrage = hitBarrage, hBarrage === barrage {
            self.hitBarrages.removeValue(forKey: pyIndex)
        }
    }
    
    func layoutOriginY(barrage: Barrage) -> CGFloat {
        var originY = -configuration.height
        var tempBarrage: Barrage?
        
        for i in 0..<maxPyIndex {
            tempBarrage = self.hitBarrages[i]
            if tempBarrage == nil {
                hitBarrages[i] = barrage
                originY = getOriginY(index: i)
                break
            }
            
            if !checkIsWillHit(width: canvasSize.width, barrageLeft: tempBarrage!, barrageRight: barrage) {
                hitBarrages[i] = barrage
                originY = getOriginY(index: i)
                break
            }
        }
        return originY
    }
    
    func getOriginY(index: Int) -> CGFloat {
        return CGFloat(index) * configuration.height
    }
    
    func checkIsWillHit(width: CGFloat, barrageLeft: Barrage, barrageRight: Barrage) -> Bool {
        if barrageLeft.remainTime <= 0 {
            return false
        }
        //感觉这块不太对
        if barrageLeft.originX + barrageLeft.size.width > barrageRight.originX {
            return true
        }
        
        let minRemainTime = min(barrageLeft.remainTime, barrageRight.remainTime)
        let originX1 = barrageLeft.originX(screenWidth: width, remainTime: barrageLeft.remainTime - minRemainTime)
        let originX2 = barrageRight.originX(screenWidth: width, remainTime: barrageRight.remainTime - minRemainTime)
        if (originX1 + barrageLeft.size.width) > originX2 {
            return true
        }
        
        return false
    }

}

class BarrageFromTopRetainer: BarrageRetainer {
    
    override func setCanvasSize(canvasSize: CGSize) {
        super.setCanvasSize(canvasSize: canvasSize)
        maxPyIndex /= 2
    }
    
    override func checkIsWillHit(width: CGFloat, barrageLeft: Barrage, barrageRight: Barrage) -> Bool {
        if barrageLeft.remainTime <= 0 {
            return false
        }
        return true
    }
}

class BarrageFromBottomRetainer: BarrageFromTopRetainer {
    
    override func getOriginY(index: Int) -> CGFloat {
        return canvasSize.height - configuration.height * CGFloat(index + 1)
    }
}

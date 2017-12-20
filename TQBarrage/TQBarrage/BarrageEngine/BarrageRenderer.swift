//
//  BarrageRenderer.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/15.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit

let kTimeInterval = 0.5

class BarrageRenderer {
    fileprivate var barrageLRRetainer: BarrageRetainer
    fileprivate var barrageFTRetainer: BarrageRetainer
    fileprivate var barrageFBRetainer: BarrageRetainer
    fileprivate weak var canvas: BarrageContainer?
    fileprivate var drawArray = [Barrage]()
    fileprivate var chcheLabels = [UILabel]()
    var configuration: BarrageConfiguration!
    
    init(configuration: BarrageConfiguration, canvas: BarrageContainer) {
        barrageLRRetainer = BarrageRetainer()
        barrageFTRetainer = BarrageFromTopRetainer()
        barrageFBRetainer = BarrageFromBottomRetainer()
        self.canvas = canvas
        self.setConfiguration(configuration: configuration)
    }
    
    func setConfiguration(configuration: BarrageConfiguration) {
        self.stopRenderer()
        self.configuration = configuration
        barrageLRRetainer.configuration = configuration
        barrageFTRetainer.configuration = configuration
        barrageFBRetainer.configuration = configuration
    }
    
    func setCanvasFrameSize() {
        guard let canvas = self.canvas else { return }
        barrageLRRetainer.setCanvasSize(canvasSize: canvas.frame.size)
        barrageFTRetainer.setCanvasSize(canvasSize: canvas.frame.size)
        barrageFBRetainer.setCanvasSize(canvasSize: canvas.frame.size)
    }
    
    func updateCanvasFrame() {
        setCanvasFrameSize()
        
        barrageFTRetainer.clear()
        barrageFBRetainer.clear()
        
        for i in 0..<drawArray.count {
            let barrage = drawArray[i]
            if barrage.type != .rightToLeft {
                barrage.isShowing = false
                render(barrage: barrage)
            }
            
            if barrage.label!.frame.maxY > canvas!.frame.height {
                removeBarrage(barrage: barrage)
                drawArray.remove(at: i)
            } else {
                barrage.isShowing = true
            }
        }
    }
}

extension BarrageRenderer {
    func drawBarrage(barrages: [Barrage], time: TimeInterval, isBuffering: Bool) {
        
        var LRShowCount = 0
        var tempBarrages = [Barrage]()
        for barrage in drawArray {
            barrage.remainTime -= kTimeInterval
           // print("\(barrage.remainTime)+++++++")
            if barrage.remainTime < 0 {
                removeBarrage(barrage: barrage)
                continue
            }
            
            tempBarrages.append(barrage)
            if barrage.type == .rightToLeft {
                LRShowCount += 1
            }
            render(barrage: barrage)
        }
        drawArray = tempBarrages
        
        guard !isBuffering else { return }
        
        for barrage in barrages {
            if barrage.isLate(currentTime: time) {
                break
            }
            
            if drawArray.count >= configuration.maxShowCount && !barrage.isSelfSend {
                break
            }
            
            if barrage.isShowing {
                continue
            }
            
            if !barrage.isDraw(currentTime: time) {
                continue
            }
            
            if barrage.type == .rightToLeft {
                if LRShowCount > configuration.maxLRShowCount && !barrage.isSelfSend {
                    continue
                } else {
                    LRShowCount += 1
                }
            }
            
            createLabel(barrage: barrage)
            barrage.renderlabel(paintHeight: configuration.height)
            drawArray.append(barrage)
            barrage.remainTime = barrage.time - time + barrage.duration
            barrage.retainer = getHitType(type: barrage.type)
            render(barrage: barrage)
            if barrage.originY >= 0 {
                canvas?.addSubview(barrage.label!)
                barrage.isShowing = true
            }
        }
    }
    
    func getHitType(type: BarrageType) -> BarrageRetainer{
        switch type {
        case .rightToLeft:
            return barrageLRRetainer
        case .topToBottom:
            return barrageFTRetainer
        case .bottomToTop:
            return barrageFBRetainer
        default:
            return barrageLRRetainer
        }
    }
}

extension BarrageRenderer {
    func removeLabel(barrage: Barrage) {
        let chcheLabel = barrage.label
        if let chcheLabel = chcheLabel {
            chcheLabel.layer.removeAllAnimations()
            chcheLabels.append(chcheLabel)
            barrage.label = nil
        }
    }
    
    func createLabel(barrage: Barrage)  {
        guard  barrage.label == nil else { return }
        
        if chcheLabels.count < 1 {
            barrage.label = UILabel()
            barrage.label!.backgroundColor = .clear
        } else {
            barrage.label = chcheLabels.last
            chcheLabels.removeLast()
        }
    }
    
    func removeBarrage(barrage: Barrage) {
        if barrage.retainer != nil {
            barrage.retainer.clearVisible(barrage: barrage)
            barrage.retainer = nil
        }
        
        barrage.label?.removeFromSuperview()
        barrage.isShowing = false
        removeLabel(barrage: barrage)
    }
    
    
    func render(barrage: Barrage) {
        barrage.layoutWithScreenWidth(width: canvas!.frame.width)
        if !barrage.isShowing {
            var originY = barrage.retainer.layoutOriginY(barrage: barrage)
            if originY < 0 {
                if barrage.isSelfSend {
                    originY = barrage.type != .bottomToTop ? 0 : canvas!.frame.height - configuration.height
                } else {
                    barrage.remainTime = -1
                }
            }
            barrage.originY = originY
        } else if (barrage.type != .rightToLeft) {
            return
        }
        
        if barrage.isShowing {
//            print("\(barrage.remainTime) \(-barrage.size.width)------")
//            print("\(barrage.label!.frame)")
            UIView.animate(withDuration: barrage.remainTime, delay: 0, options: .curveLinear, animations: {
                
                barrage.label?.frame = CGRect(x: -barrage.size.width, y: barrage.originY, width: barrage.size.width, height: barrage.size.height)
            }, completion: { (_) in
            })
        } else {
            
            barrage.label?.frame = CGRect(x: barrage.originX, y: barrage.originY, width: barrage.size.width, height: barrage.size.height)
        }
    }
}

extension BarrageRenderer {
    func pauseRenderer() {
        for barrage in drawArray {
            if barrage.type != .rightToLeft {
                continue
            }
            
            let layer = barrage.label!.layer
            var rect = barrage.label!.frame
            if let layer = layer.presentation() {
                rect = layer.frame
                rect.origin.x -= 1
            }
            barrage.label?.frame = rect
            barrage.label?.layer.removeAllAnimations()
        }
    }
    
    func stopRenderer() {
        for barrage in drawArray {
            barrage.label!.removeFromSuperview()
            removeLabel(barrage: barrage)
            barrage.remainTime = -1
            barrage.isShowing = false
            barrage.retainer = nil
        }
        drawArray.removeAll()
        barrageLRRetainer.clear()
        barrageFTRetainer.clear()
        barrageFBRetainer.clear()
    }

}

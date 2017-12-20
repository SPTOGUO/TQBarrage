//
//  BarrageContainer.swift
//  BarrageDemo
//
//  Created by Guo Zhiqiang on 17/3/15.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import UIKit

protocol BarrageContainerDataSource: class {
    func getPlayTime() -> TimeInterval
}

class BarrageContainer:  UIView{
    private var renderer: BarrageRenderer!
    private let configuration: BarrageConfiguration!
    private var barrageTime: BarrageTime
    private var barrages = [Barrage]()
    private var currentBarrages = [Barrage]()
    private var timer: Timer?
    private var timeCount: Double = 0
    
    private var queue: OperationQueue
    
    var isPrepared = false
    private var isPlaying = false
    private var isPreFilter = false
    
    weak var dataSource: BarrageContainerDataSource?
    
    init(frame: CGRect, configuration: BarrageConfiguration) {
        self.configuration = configuration
        barrageTime = BarrageTime(time: 0, interval: kTimeInterval)
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        super.init(frame: frame)
        backgroundColor = .clear
        renderer = BarrageRenderer(configuration: configuration, canvas: self)
        renderer.updateCanvasFrame()
        self.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath else { return }
        
        if path == "frame" {
            renderer.updateCanvasFrame()
        }
    }
    
    func prepareBarrage(BarrageDescriptors: [BarrageDescriptor]) {
        isPrepared = false
        barrages.removeAll()
        currentBarrages.removeAll()
        
        for des in BarrageDescriptors {
            let barrage = BarrageFactory.creatBarrage(descriptor: des, configuration: configuration)
            if let barrage = barrage {
                barrages.append(barrage)
            }
        }
        
        barrages = barrages.sorted { $0.time < $1.time }
        isPrepared = true
        isPreFilter = true
    }
    
    func start() {
        resume()
    }
    
    func resume() {
        guard !isPlaying, isPrepared else { return }
        
        self.isPlaying = true
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: kTimeInterval, target: self, selector: #selector(self.drawContainer), userInfo: nil, repeats: true)
//            RunLoop.current.add(timer!, forMode: .commonModes)
//            timer!.fire()
        }
    }
    
    func pause() {
        guard isPlaying else { return }
        
        isPlaying = false
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        renderer.pauseRenderer()
    }
    
    func stop() {
        isPlaying = false
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        renderer.stopRenderer()
    }
    
    @objc func drawContainer() {
        self.drawBarrageContainer()
    }
    
    func drawBarrageContainer() {
        let playTime = dataSource?.getPlayTime()
        guard let currTime = playTime, currTime >= 0 else {
            return
        }
        
        let interval = currTime - barrageTime.time
        barrageTime.time = currTime
        
        if isPreFilter || interval < 0 || interval > 5 {
            isPreFilter = false
            currentBarrages = BarrageFilter.filterBarrage(barrages: barrages, currentTime: currTime)
        }
        renderer.drawBarrage(barrages: currentBarrages, time: currTime, isBuffering: false)
        
        timeCount += barrageTime.interval
        if timeCount > 5 {
            timeCount = 0
            currentBarrages = BarrageFilter.filterBarrage(barrages: barrages, currentTime: currTime)
        }
    }
    
    func sendBarrage(des: BarrageDescriptor) {
        let sendBarrage = BarrageFactory.creatBarrage(descriptor: des, configuration: configuration)
        
        guard let barrage = sendBarrage else { return }
        
        barrage.isSelfSend = true
        if barrages.count < 1 || barrage.time > barrages.last!.time {
            barrages.append(barrage)
        } else {
            var index = 0
            for ba in barrages {
                if barrage.time < ba.time {
                    barrages.insert(barrage, at: index)
                    break
                }
                index += 1
            }
        }
        isPreFilter = true
    
    }
}

struct BarrageTime {
    var time: TimeInterval
    var interval: Double
}

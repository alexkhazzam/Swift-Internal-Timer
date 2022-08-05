//
//  CircleTimerView.swift
//  PODTEST
//
//  Created by Fábio Maciel de Sousa on 07/06/20.
//  Copyright © 2020 Fábio Maciel de Sousa. All rights reserved.
//

import UIKit

///Class that handles timer's progression bar and it's animations
public class CircleTimerView: UIView {
    //MARK: - Atributes
    private static let animationDuration = CFTimeInterval(60)
    private let π = CGFloat.pi
    let startAngle = 1.5 * CGFloat.pi
    var circleStrokeWidth = CGFloat(2)
    var ringStrokeWidth = CGFloat(5)
    public var date = Date()
    var wentToBackground = false
    var canAdaptTimerFormat = true
    var proportion = CGFloat(0) {
        didSet {
            setNeedsLayout()
        }
    }
    var isRunning = false
    var totalTime: CGFloat = 0.0
    var timeTracker = TimeTracker()
    ///Circle path layer
    lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.strokeColor = #colorLiteral(red: 0.3490196078, green: 0.4941176471, blue: 0.4862745098, alpha: 1)
        circleLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        circleLayer.lineWidth = self.circleStrokeWidth
        self.layer.addSublayer(circleLayer)
        return circleLayer
    }()
    ///Ring layer that goes through the circle path
    lazy var ringLayer: CAShapeLayer = {
        let ringlayer = CAShapeLayer()
        ringlayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        ringlayer.strokeColor = #colorLiteral(red: 0.3490196078, green: 0.4941176471, blue: 0.4862745098, alpha: 1)
        ringlayer.lineCap = CAShapeLayerLineCap.round
        ringlayer.lineWidth = self.ringStrokeWidth
        self.layer.addSublayer(ringlayer)
        return ringlayer
    }()
    ///Pin layer that follows ring
    lazy var pinLayer: CAShapeLayer = {
        let pinlayer = CAShapeLayer()
        pinlayer.fillColor = #colorLiteral(red: 0.3490196078, green: 0.4941176471, blue: 0.4862745098, alpha: 1)
        self.layer.addSublayer(pinlayer)
        return pinlayer
    }()
    ///Circle background
    lazy var circleBackgroundLayer: CAShapeLayer = {
        let circleBackground = CAShapeLayer()
        circleBackground.fillColor = #colorLiteral(red: 0.8980392157, green: 0.9019607843, blue: 0.862745098, alpha: 1)
        self.layer.addSublayer(circleBackground)
        circleBackground.zPosition =  -100
        return circleBackground
    }()
    ///Timer Label
    lazy var timerLabel: UILabel = {
        let w: CGFloat = (107.33 * self.frame.width) / 208
        let h: CGFloat = (36.67 * self.frame.height) / 187
        let x = (self.frame.size.width / 2) - (w / 2)
        let y = (self.frame.size.height / 2) - (h / 2)
        let timerLabel = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
        timerLabel.font = UIFont(name: "GillSans-Light", size: 32.0)
        timerLabel.textAlignment = .center
        timerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addSubview(timerLabel)
        return timerLabel
    }()
    
    //MARK: - Methods
    /**
    Method called when view is set and presented. Set the timer to a default value
    */
    override public func willMove(toSuperview newSuperview: UIView?) {
        setTimerValue(60)
    }
    
    /**
     Method called when view is loaded. It draws the layers.
     */
    override public func layoutSubviews() {
        super.layoutSubviews()
        //Get the radius according to the custom view's size
        let radius = (min(frame.size.width, frame.size.height) - ringStrokeWidth - 2)/2

        //Setting elements' position and paths
        let size = self.frame.size
        let pos = CGPoint(x: size.width/2, y: size.height/2)
        let circlePath = UIBezierPath(arcCenter: pos, radius: radius, startAngle: startAngle, endAngle: startAngle + 2 * π, clockwise: true)
        circleLayer.path = circlePath.cgPath
        ringLayer.path = circlePath.cgPath
        ringLayer.strokeEnd = proportion
        pinLayer.position = pos
        circleBackgroundLayer.position = pos
        
        //Getting the formatter
        guard let f = timeTracker.timerFormatDelegate else {return}
        
        //Set timer label which will be customizable (can also be invisible)
        timerLabel.text = f.secondsToString(with: timeTracker.configTime)
    }
    
    /**
     Method that starts the progress animation
     - Parameter startProportion: point in percentage of where the animation will start in the circle.(0 to 1)
     - Parameter startPinPos: angle in which the pin will start in the circle. It ranges from 0 to 360 (pi * 2)
     - Parameter endProportion: point in percentage of where the animation will end in the circle.(0 to 1)
     - Parameter duratino: The duration in seconds for the animations. It comes with a default value.
     - Precondition: Animation can't be running already. Variable `isRunning` must be set to false.
     */
    func animateRing(FromStroke startProportion: CGFloat,FromAngle startPinPos: CGFloat, To endProportion: CGFloat, Duration duration: CFTimeInterval = animationDuration, timing: CAMediaTimingFunctionName? = .linear) {
        if self.isRunning{return}
        
        self.isRunning = true
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = startProportion
        animation.toValue = endProportion
        animation.timingFunction = CAMediaTimingFunction(name: timing!)
        ringLayer.strokeEnd = 1
        ringLayer.strokeStart = 0
        ringLayer.add(animation, forKey: "animateRing")
        //Pin animation settup
        let pinAnimation = CABasicAnimation(keyPath: "transform.rotation")
        pinAnimation.fromValue = startPinPos
        pinAnimation.toValue = 2 * CGFloat.pi
        pinAnimation.timingFunction = CAMediaTimingFunction(name: timing!)
        pinAnimation.duration = duration
        pinAnimation.isAdditive = true
                
        //Start animation
        pinLayer.add(pinAnimation, forKey: "animatePin")
    }
    /**
     Method for removing animation when finished or reseted
     */
    func removeAnimation(){
        pinLayer.removeAllAnimations()
        ringLayer.removeAllAnimations()
        proportion = 0
        isRunning = false
    }
    
    /**
     Method that sets up timer's value.
     - Parameter value: value which will be used on the timer``
     */
    public func setTimerValue(_ value: Int){
        timeTracker.configTime = value
        timeTracker.defaultTime = value
        if !canAdaptTimerFormat {return}
        if value >= 60, value < 3600{
            timeTracker.timerFormatDelegate = Minute()
        }else if value >= 3600{
            timeTracker.timerFormatDelegate = Hour()
        }else{
            timeTracker.timerFormatDelegate = Second()
        }
    }
}

/// Extension for the methods regarding counting on background
extension CircleTimerView: BackgroundCountable{
    
    public var isValid: Bool{
        get{
            return timeTracker.timer.isValid
        }
    }
    ///Call the timer's to start closure and update view
    public func startTimer(){
        timeTracker.startTimer { (countDown, hasEnded) in
            self.timerLabel.text = countDown
            if hasEnded{
                self.isRunning = false
                self.stopTimer()
            }
        }
        if !isRunning {
          animateRing(FromStroke: 0, FromAngle: 0, To: 1, Duration: CFTimeInterval(timeTracker.configTime))
            timeTracker.defaultTime = timeTracker.configTime
        }else if layer.speed == 0.0{
            resumeAnimation()
        }
    }
    ///Call the timer to stop and update view
    public func stopTimer(){
        resumeAnimation()
        timeTracker.timer.invalidate()
        timeTracker.configTime = timeTracker.defaultTime
        removeAnimation()
    }
    ///Call the timer to pause and update view
    public func pauseTimer(){
        timeTracker.configTime = timeTracker.countDown
        timeTracker.timer.invalidate()
        pauseAnimation()
    }
    ///Update the view by starting paused animation
    func pauseAnimation(){
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    ///Call the timer to resume and update the view
    func resumeAnimation(){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    /**
     Enter background and keep counting.
     This method should be used in the SceneDelegate when it goes to the background so it gets the time which you entered Background.
     */
    public func enterBackground(){
        date = Date()
        totalTime = CGFloat(timeTracker.defaultTime)
        wentToBackground = true
    }
    /**
    Enter Foreground and update View.
    This method should be used in the SceneDelegate when it goes to the Foreground so it gets the current time and update the view.
    */
    public func enterForeground(){
        if !wentToBackground{return}
        self.isRunning = false
        self.wentToBackground = false
        let seconds = Int(date.distance(to: Date()))
        if isValid{timeTracker.countDown -= seconds}
        let startValue = calculateStartingPoint(By: CGFloat(timeTracker.countDown), To: 1)
        let startAngle = calculateStartingPoint(By: CGFloat(timeTracker.countDown), To: (2 * CGFloat.pi))
        animateRing(FromStroke: startValue, FromAngle: startAngle, To: 1, Duration: CFTimeInterval(timeTracker.countDown))
        if layer.speed == 0.0{
            pauseAnimation()
        }
    }
    
    /**
     Method that calculates the starting point for when app went to background.
     ```
     func calculateStartingPoint(By: 2, To: 1) // totalTime = 10, returns 0.8
     ```
     - Parameter currTime: current time after coming from background.
     - Parameter toValue: Value when circle is filled. It can be endStroke or an angle.
     - returns: The new position that the circle should be according to new updated time value coming from background.
     */
    func calculateStartingPoint(By currTime: CGFloat, To newValue: CGFloat) -> CGFloat{
        if currTime <= 0 {return newValue}
        let newPos = newValue - ((currTime * newValue) / totalTime)
        return newPos
    }
    
}

// MARK: - Designable
@IBDesignable public extension CircleTimerView{
    // MARK: - Timer
    @IBInspectable
    var fontSize: CGFloat{
        get{
            32.0
        }
        set{
            timerLabel.font = timerLabel.font.withSize(newValue)
        }
    }
    
    @IBInspectable
    var enableTimer: Bool{
        get{
            true
        }
        set{
            timerLabel.isHidden = !newValue
        }
    }
    
    @IBInspectable
    var fontColor: UIColor{
        get{
            timerLabel.textColor
        }
        set{
            timerLabel.textColor = newValue
        }
    }
    
    @IBInspectable
    var canAdaptTimer: Bool{
        get{
            true
        }
        set{
            canAdaptTimerFormat = newValue
            if !newValue{
                timeTracker.timerFormatDelegate = Hour()
            }
        }
    }

    //MARK: - Background Circle
    
    @IBInspectable
    var backgroundCircleRadius: CGFloat{
        get{
            0.0
        }
        set{
            let radius = (min(frame.size.width, frame.size.height) - ringStrokeWidth - 2)/2
            
            let circlebackgroundRadius = (newValue*radius)/90
            
            let circleBackgroundPath = CGPath(ellipseIn: CGRect(x: -CGFloat(circlebackgroundRadius), y: -CGFloat(circlebackgroundRadius), width: CGFloat(2 * circlebackgroundRadius), height: CGFloat(2 * circlebackgroundRadius)), transform: nil)
            
            circleBackgroundLayer.path = circleBackgroundPath
        }
    }
    
    @IBInspectable
    var backgroundCircleColor: UIColor{
        get{
            UIColor.init(cgColor: circleBackgroundLayer.fillColor!)
        }
        set{
            circleBackgroundLayer.fillColor = newValue.cgColor
        }
    }

    //MARK: - Timer Circle
    @IBInspectable
    var stroke: CGFloat{
        get{0.0}
        set{
            proportion = newValue/100
        }
    }
    
    @IBInspectable
    var strokeWidth: CGFloat{
        get{0.0}
        set{
            circleStrokeWidth = newValue
        }
    }
    
    @IBInspectable
    var completedStrokeWidth: CGFloat{
        get{0.0}
        set{
            ringStrokeWidth = newValue
        }
    }
    
    @IBInspectable
    var strokeColor: UIColor{
        get{
            UIColor.init(cgColor: circleLayer.fillColor!)
        }
        set{
            circleLayer.strokeColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var completedStrokeColor: UIColor{
        get{
            UIColor.init(cgColor: ringLayer.fillColor!)
        }
        set{
            ringLayer.strokeColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var pinColor: UIColor{
        get{
            UIColor.init(cgColor: pinLayer.fillColor!)
        }
        set{
            pinLayer.fillColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var pinRadius: CGFloat{
        get{
            7
        }set{
            let radius = (min(frame.size.width, frame.size.height) - ringStrokeWidth - 2)/2
            let pinPath = CGPath(ellipseIn: CGRect(x: -newValue, y: CGFloat(Int(-radius)) - newValue, width: 2 * newValue, height: 2 * newValue), transform: nil)
            pinLayer.path = pinPath
        }
    }
}

/// Protocol used to update the view in relation to the timer when the phone goes to background
public protocol BackgroundCountable {
    var date: Date{set get}
    var isValid: Bool{get}
    func enterBackground()
    func enterForeground()
}

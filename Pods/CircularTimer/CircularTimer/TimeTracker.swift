//
//  TimeTracker.swift
//  PODTEST
//
//  Created by Fábio Maciel de Sousa on 07/06/20.
//  Copyright © 2020 Fábio Maciel de Sousa. All rights reserved.
//

import Foundation

///Class created for handling the count down
class TimeTracker{
    
    //MARK:Atributes
    var timer = Timer()
    var configTime = 60 ///Timer which will be configured
    var defaultTime = 60 ///Time that will go back to when it ends
    var hasEnded = false /// Boolean used when timer ends so it goes back to the default settings
    var timeInterval : TimeInterval = 1 ///seconds at a time
    var date: Date? ///Date used when it goes to background
    var timerFormatDelegate: TimeFormattable?
    
    ///Ends when value gets to zero
    var countDown = 0{
        willSet{
            if newValue <= 0{
                hasEnded = true
            }
        }
    }
    
    //MARK: Methods
    /**
     Method for starting the count down from an initial value, and also handling view updates.
     
     If another countDown has already started, a new one won't start.The initial value must be greater than 0
     
     - Parameter minutes: the initial value in minutes which the countDown will start from.
     - Parameter updateView: a closure called each time the timer is updated for handling view updates.
     */
    func startTimer(updateView: @escaping (String, Bool) -> Void){
        if timer.isValid{return}
        countDown = configTime
        hasEnded = false
        
        //Getting the right formatter
        guard let f = timerFormatDelegate else {return}
        
        //Runs timer and updates each second
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            self.countDown -= 1 //Decreases time
            var convertedTimeText = f.secondsToString(with: self.countDown)
            
            if self.hasEnded{ //It changes state, cancels timer and updates view with default value
                self.timer.invalidate()
                let defaultTimeText = f.secondsToString(with: self.defaultTime)
                convertedTimeText = defaultTimeText
            }
            
            updateView(convertedTimeText,self.hasEnded)
        })
    }
    
    /**
     Method for stopping the count down.
     
     if the count down was running it pop up a message to the user.
     - Parameter updateView: A closure that is called to update the view.
     */
    func stopTimer(updateView: @escaping () -> Void){
        timer.invalidate()
        updateView()
    }
    
}


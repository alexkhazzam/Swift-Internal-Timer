//
//  Hour+Minute+Second.swift
//  PODTEST
//
//  Created by Fábio Maciel de Sousa on 16/07/20.
//  Copyright © 2020 Fábio Maciel de Sousa. All rights reserved.
//

import Foundation
//Protocol used to format time accordingly.
public protocol TimeFormattable{
    func secondsToString(with seconds: Int) -> String
    func stringToSeconds(from text: String) -> Int
}
//MARK: Hour
//Class that formats timer to hours settings. "01:00:00"
public class Hour: TimeFormattable{
    /**
     Method for converting seconds to the formatted string to be displayed on the view
     - Parameter seconds: the current unformatted second from the count down
     - Returns: formatted string of the current time in minutes and seconds
     */
    public func secondsToString(with seconds: Int) -> String{
        if seconds < 0 {return ""} //TODO: send error
        var min = (seconds / 60)
        let hour = (min / 60) % 60
        min %= 60
        let sec = seconds % 60
        return String(format:"%02i:%02i:%02i",hour, min, sec)
    }
    
    /**
     Method for converting strings to seconds
     - Parameter text: the text from the label in the view
     - Returns: the amount of seconds for the count down
     */
    public func stringToSeconds(from text: String) -> Int{
        if text.contains("-") { return 0}
        if !text.contains(":") { return 0}
        let numbers = text.split(separator: ":")
        if numbers.count != 3 { return 0}
        guard let hour = Int(numbers[0]) else {return 0}
        guard var min = Int(numbers[1]) else {return 0}
        min += hour * 60
        let sec = min * 60
        return sec
    }
}
//MARK: - Minute
//Class that formats timer to minutes settings. "01:00"
public class Minute: TimeFormattable{
    /**
     Method for converting seconds to the formatted string to be displayed on the view
     - Parameter seconds: the current unformatted second from the count down
     - Returns: formatted string of the current time in minutes and seconds
     */
    public func secondsToString(with seconds: Int) -> String{
        if seconds < 0 {return ""} //TODO: send error
        var min = (seconds / 60)
        min %= 60
        let sec = seconds % 60
        return String(format:"%02i:%02i", min, sec)
    }
    
    /**
     Method for converting strings to seconds
     - Parameter text: the text from the label in the view
     - Returns: the amount of seconds for the count down
     */
    public func stringToSeconds(from text: String) -> Int{
        if text.contains("-") { return 0}
        if !text.contains(":") { return 0}
        let numbers = text.split(separator: ":")
        if numbers.count != 2 { return 0}
        guard let min = Int(numbers[0]) else {return 0}
        let sec = min * 60
        return sec
    }
}
//MARK: - Second
//Class that formats timer to seconds settings. "59"
public class Second: TimeFormattable{
    /**
     Method for converting seconds to the formatted string to be displayed on the view
     - Parameter seconds: the current unformatted second from the count down
     - Returns: formatted string of the current time in minutes and seconds
     */
    public func secondsToString(with seconds: Int) -> String{
        if seconds < 0 {return ""} //TODO: send error
        let sec = seconds % 60
        return String(format:"%02i", sec)
    }
    
    /**
     Method for converting strings to seconds
     - Parameter text: the text from the label in the view
     - Returns: the amount of seconds for the count down
     */
    public func stringToSeconds(from text: String) -> Int{
        if text.contains("-") { return 0}
        let sec = Int(text) ?? 0
        return sec
    }
}

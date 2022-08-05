//
//  ViewController.swift
//  WorkoutTimer
//
//  Created by Alexander Khazzam on 8/4/22.
//

import UIKit
import CircularTimer

class ViewController: UIViewController {
    
    var timer: Timer? = nil
    var totalSeconds = 0
    
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var repeatsSwitch: UISwitch!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

//MARK: - Timer Handlers

extension ViewController {
    
    @IBAction func startBtnClicked(_ sender: UIButton) {
        if startBtn.title(for: .normal) == K.stopBtnTitle {
            return stopTimer()
        }
        
        totalSeconds = secondsTextField.convertToInt() + minutesTextField.convertToInt() * 60 + hoursTextField.convertToInt() * 3600
        
        if totalSeconds != 0 {
            condenseTimes()
            startTimer()
            
            startBtn.setTitle(K.stopBtnTitle, for: .normal)
            startBtn.backgroundColor = UIColor(named: K.stopBtnBackgroundColor)
            startBtn.setTitleColor(UIColor.init(named: K.stopBtnForegroundColor), for: .normal)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timeLeftLabel.text = "00:00:00"
        startBtn.setTitle(K.startBtnTitle, for: .normal)
        startBtn.backgroundColor = UIColor(named: K.startBtnBackgroundColor)
        startBtn.setTitleColor(UIColor.init(named: K.startBtnForegroundColor), for: .normal)
        
        secondsTextField.clear()
        minutesTextField.clear()
        hoursTextField.clear()
    }
    
    func startTimer() {
        var totalSecondsCopy = totalSeconds
        updateCountdown(totalSecondsCopy)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
            if totalSecondsCopy == 0 {
                if self.repeatsSwitch.isOn {
                    self.timer?.invalidate()
                    self.startTimer()
                } else {
                    self.stopTimer()
                }
            } else {
                totalSecondsCopy -= 1
                self.updateCountdown(totalSecondsCopy)
            }
        }
    }
    
    func updateCountdown(_ totalSecondsCopy: Int) {
        let hours = totalSecondsCopy / 3600
        let minutes = (totalSecondsCopy - hours * 3600) / 60
        let seconds = totalSecondsCopy - (hours * 3600 + minutes * 60)
        
        self.timeLeftLabel.text = "\(hours > 9 ? "\(hours)" : "0\(hours)"):\(minutes > 9 ? "\(minutes)" : "0\(minutes)"):\(seconds > 9 ? "\(seconds)" : "0\(seconds)")"
    }
    
    func condenseTimes() {
        minutesTextField.text = String(minutesTextField.convertToInt() + secondsTextField.convertToInt() / 60)
        secondsTextField.text = String(secondsTextField.convertToInt() % 60)
        hoursTextField.text = String(hoursTextField.convertToInt() + minutesTextField.convertToInt() / 60)
        minutesTextField.text = String(minutesTextField.convertToInt() % 60)
    }
    
}

//MARK: - UITextField

extension UITextField {
    
    func convertToInt() -> Int {
        return Int(self.text!) ?? 0
    }
    
    func clear() {
        self.text = ""
    }
    
}


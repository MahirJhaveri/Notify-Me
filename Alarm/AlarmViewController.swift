//
//  ViewController.swift
//  Alarm
//
//  Created by Mahir Jhaveri  on 1/12/19.
//  Copyright © 2019 Mahir Jhaveri . All rights reserved.
//

import UIKit
import UserNotifications

// TODO -
// 0.5) Make date to update day based on time of day
// 2) Add sound to notification
// 3) Mechanism to delete alarm after one play

class AlarmViewController: UIViewController {

    private var alarm = Alarm()
    private var alarmNotificationIdentifier: String? = nil
    private var timer = Timer()
    
    // Don't modify these directly
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmDeleteButton: UIButton!
    @IBOutlet weak var horizontalRule: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Hides the current alarm once it is deleted
    private func hideAlarm() {
        alarmTimeLabel.text = ""
        alarmDeleteButton.isEnabled = false
        alarmDeleteButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        horizontalRule.isHidden = true
    }
    
    // Displays current alarm once added
    private func showAlarm(to time: Date) {
        let timeString = getTimeString(time) // Gets timeString in correct format
        
        alarmTimeLabel.text = timeString
        alarmDeleteButton.isEnabled = true
        alarmDeleteButton.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: UIControl.State.normal)
        horizontalRule.isHidden = false
    }
    
    // Returns time as string in correct format
    private func getTimeString(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // "a" prints "pm" or "am"
        return formatter.string(from: time) // "12 AM"
    }
    
    // Used as a pre-processing step to adjust date once
    // its recieved from the date picker
    private func adjustDate(date: Date) -> Date {
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        component.second = 0
        return Calendar.current.date(from: component)!
    }
    
    // Trigger Segue to the alert page
    @objc func triggerAlarm() {
        performSegue(withIdentifier: "segue1", sender: nil)
    }
    
    // Removes the looping timer
    private func removeTimer() {
        timer.invalidate()
    }
    
    // Method to check if current time equals the alarm time
    @objc private func checkTime() {
        let alarmTime = alarm.getAlarmTime()
        if alarmTime != nil {
            let currentTime = Date()
            print("diff = \(currentTime.timeIntervalSince(alarmTime!))")
            if currentTime.timeIntervalSince(alarmTime!) <= 120 && currentTime.timeIntervalSince(alarmTime!) >= 0 {
                removeTimer()
                // Remove alarm
                triggerAlarm()
            }
            else if currentTime.timeIntervalSince(alarmTime!) > 120 {
                removeTimer()
            }
        }
        else {
            removeTimer()
        }
    }
    
    // Adds a looping timer that executes the checkTime function
    // every second. Sole purpose is to alert user when app is
    // in foreground
    private func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkTime), userInfo: nil, repeats: true)
        print("Time checking timer set!!!")
    }
    
    // Adds alarm notification at given time
    private func addNotification(at time: Date) {
        alarmNotificationIdentifier = "alarmNotification"
        
        // get the notification center
        let center = UNUserNotificationCenter.current()
        
        // create the content of notification
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.subtitle = getTimeString(time)
        content.sound = UNNotificationSound.default
        
        let dateComp = Calendar.current.dateComponents([.hour, .minute], from: time)
        //notification trigger can be based on time, calendar or location
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        
        //create request to display
        let request = UNNotificationRequest(identifier: alarmNotificationIdentifier!, content: content, trigger: trigger)
        
        //add request to notification center
        center.add(request) { (error) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        
    }
    
    // Removes scheduled notifications
    private func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [alarmNotificationIdentifier!])
        alarmNotificationIdentifier = nil
    }
    
    // Action triggered when Add button is pressed
    @IBAction func addAlarmButton(_ sender: UIButton) {
        
        // In case previous alarm is set, clear it
        if alarmNotificationIdentifier != nil {
            let temp = alarm.getAlarmTime()!
            removeNotification()
            removeTimer()
            alarm.removeAlarm()
            
            print("Removed alarm at \(temp)")
        }
        
        // Adding the new alarm
        let time = adjustDate(date: datePicker.date)
        alarm.setAlarmTime(to: time)
        updateView()
        addNotification(at: time)
        addTimer()
        
        print("New alarm added at \(getTimeString(time))")
    }
    
    // Action triggered when Delete Button is pressed
    @IBAction func deleteButton(_ sender: UIButton) {
        let temp = alarm.getAlarmTime()!
        alarm.removeAlarm()
        removeNotification()
        removeTimer()
        updateView()
        
        print("Removed Alarm at \(getTimeString(temp))")
    }
    
    func updateView() {
        if alarm.alarmPresent() {
            showAlarm(to: alarm.getAlarmTime()!)
        }
        else {
            hideAlarm()
        }
    }
    
    // TODO - Deal with notifications disabled setting
    override func viewDidLoad() {
        // Request permission to display alerts and play sounds.
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in print("Notifications permission granted: \(granted)")
        }
        
        // Hiding the current alarm block
        hideAlarm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hiding the navigation bar
        self.navigationController?.isNavigationBarHidden = true  //Hide
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // displaying navigation bar
        self.navigationController?.isNavigationBarHidden = false  //Show
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        sender.setDate(sender.date, animated: false)
    }
    
}


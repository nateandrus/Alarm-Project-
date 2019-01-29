//
//  AlarmDetailTableViewController.swift
//  ALarm Project
//
//  Created by Nathan Andrus on 1/28/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmTextField: UITextField!
    @IBOutlet weak var alarmButton: UIButton!
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUpAlarmButton() {
        switch alarmIsOn {
        case true:
            alarmButton.backgroundColor = UIColor.white
            alarmButton.setTitle("Off", for: .normal)
            alarmButton.setTitleColor(UIColor.black, for: .normal)
        case false:
            alarmButton.backgroundColor = UIColor.black
            alarmButton.setTitle("On", for: .normal)
            alarmButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    
    
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        if let alarm = alarm {
            AlarmController.shared.enableToggle(for: alarm)
            alarmIsOn = !alarmIsOn
        } else {
            alarmIsOn = !alarmIsOn
        }
        setUpAlarmButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let alarmText = alarmTextField.text else {return}
        guard alarmText != "" else {return}
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: datePicker.date, name: alarmText, enabled: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: alarmText, enabled: alarmIsOn)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard let alarm = alarm else {return}
        alarmIsOn = alarm.enabled
        datePicker.date = alarm.fireDate
        alarmTextField.text = alarm.name
        self.title = alarm.name
        setUpAlarmButton()
    }
    
}

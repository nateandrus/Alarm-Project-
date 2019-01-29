//
//  SwitchTableViewCell.swift
//  ALarm Project
//
//  Created by Nathan Andrus on 1/28/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func alarmSwitchTapped(_ sender: UISwitch) {
        delegate?.switchCellSwitchedValue(self, selected: alarmSwitch.isOn)
    }
    
    func updateViews() {
        guard let alarm = alarm else { return }
        nameLabel.text = alarm.name
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }
}

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchedValue(_ cell: SwitchTableViewCell, selected: Bool)
}

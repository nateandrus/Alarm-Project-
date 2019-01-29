//
//  AlarmListTableViewController.swift
//  ALarm Project
//
//  Created by Nathan Andrus on 1/28/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        AlarmController.shared.loadFromPersistentStore()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath)
            as? SwitchTableViewCell else { return UITableViewCell()}
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell.alarm = alarm
        cell.delegate = self
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            let alarm = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
            default: return
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetailVC" {
            guard let alarmIndex = tableView.indexPathForSelectedRow else {return}
            let alarm = AlarmController.shared.alarms[alarmIndex.row]
            let destinationVC = segue.destination as? AlarmDetailTableViewController
            destinationVC?.alarm = alarm
        }
    }
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchedValue(_ cell: SwitchTableViewCell, selected: Bool) {
        guard let alarm = cell.alarm,
           let cellIndexPath = tableView.indexPath(for: cell) else { return }
        tableView.beginUpdates()
//        alarm.enabled = selected
        AlarmController.shared.enableToggle(for: alarm)
        tableView.reloadRows(at: [cellIndexPath], with: .fade)
        tableView.endUpdates()
    }
}

//
//  MasterTableViewController.swift
//  SettingsSplitViewController
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    let items = [(title: "General",    storyboardID: "Item 1"),
                 (title: "Additional", storyboardID: "Item 2")]
    
    var currentIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIScreen.isSplit {
            tableView.selectRow(at: currentIndexPath, animated: true, scrollPosition: .none)
        } else {
            tableView.deselectRow(at: currentIndexPath, animated: true)
        }
    }
    
    // MARK: - Interface orientations
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        tableView.selectRow(at: currentIndexPath, animated: true, scrollPosition: .none)
    }
    
    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = items[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !(UIScreen.isSplit && currentIndexPath == indexPath) else { return }
        
        currentIndexPath.row = indexPath.row
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: items[indexPath.row].storyboardID)
        showDetailViewController(controller, sender: nil)
    }
    
}

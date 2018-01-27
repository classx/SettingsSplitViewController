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
        
        selectCurrentRowIfNeeded(orDeselect: true)
    }
    
    // MARK: - Interface orientations
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let count = navigationController?.viewControllers.count, UIDevice.isIPhonePlus && !UIDevice.isLandscape && count == 1 {
            showItemController(0)
        }
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.selectCurrentRowIfNeeded()
        })
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
        if UIScreen.isSplit && currentIndexPath == indexPath { return }
        
        showItemController(indexPath.row)
    }
    
    func selectCurrentRowIfNeeded(orDeselect: Bool = false) {
        if UIScreen.isSplit {
            tableView.selectRow(at: currentIndexPath, animated: true, scrollPosition: .none)
        } else if orDeselect {
            tableView.deselectRow(at: currentIndexPath, animated: true)
        }
    }
    
    // MARK: - Item controller
    
    func showItemController(_ index: Int) {
        guard index < items.count else { return }
        
        currentIndexPath.row = index

        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: items[index].storyboardID)
        showDetailViewController(controller, sender: nil)
    }
    
}

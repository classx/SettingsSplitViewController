//
//  RootSplitViewController.swift
//  SettingsSplitViewController
//

import UIKit

class RootSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch UIDevice.model {
        case .iPad_9_7, .iPad_10_5, .iPad_12_9:
            preferredDisplayMode = .allVisible
        default:
            break
        }
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setMasterWidth(size: view.bounds.size)
    }
    
    // MARK: - SplitViewController
    
    var showMasterIfStartAsPortrait = true
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        if showMasterIfStartAsPortrait {
            showMasterIfStartAsPortrait = false
            
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Interface orientations
    
    override var shouldAutorotate: Bool {
        switch UIDevice.model {
        case .iPhone:
            return false
        case .iPhonePlus, .iPad_9_7, .iPad_10_5, .iPad_12_9:
            return true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch UIDevice.model {
        case .iPhone:
            return .portrait
        case .iPhonePlus:
            return .allButUpsideDown
        case .iPad_9_7, .iPad_10_5, .iPad_12_9:
            return .all
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        showMasterIfStartAsPortrait = false
        
        setMasterWidth(size: size)
    }
    
    // MARK: - Master controller width
    
    func setMasterWidth(size: CGSize) {
        let width = size.width > size.height ? UIScreen.splitMasterWidth.landscape : UIScreen.splitMasterWidth.portrait
        
        minimumPrimaryColumnWidth = width
        maximumPrimaryColumnWidth = width
    }
    
}

extension UIScreen {
    
    static let width = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    
    static let splitMasterWidth: (portrait: CGFloat, landscape: CGFloat) = {
        switch UIDevice.model {
        case .iPhone:
            return (portrait: width, landscape: width)
        case .iPhonePlus:
            return (portrait: width, landscape: 295)
        case .iPad_9_7:
            return (portrait: 320, landscape: 389)
        case .iPad_10_5:
            return (portrait: 320, landscape: 423)
        case .iPad_12_9:
            return (portrait: 375, landscape: 519)
        }
    }()
    
    class var isSplit: Bool {
        switch UIDevice.model {
        case .iPad_9_7, .iPad_10_5, .iPad_12_9:
            return true
        default:
            return UIDevice.isLandscape
        }
    }
    
}

extension UIDevice {
    
    enum Model: String {
        case iPhone
        case iPhonePlus
        case iPad_9_7
        case iPad_10_5
        case iPad_12_9
    }
    
    static var model: Model = {
        switch UIScreen.width {
        case 0..<414:
            return .iPhone
        case 414..<768:
            return .iPhonePlus
        case 768..<834:
            return .iPad_9_7
        case 834..<1024:
            return .iPad_10_5
        default:
            return .iPad_12_9
        }
    }()
    
    class var isLandscape: Bool {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        
        return statusBarOrientation == .landscapeLeft || statusBarOrientation == .landscapeRight
    }
    
}

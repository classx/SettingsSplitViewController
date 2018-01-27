//
//  RootSplitViewController.swift
//  SettingsSplitViewController
//

import UIKit

class RootSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    var showMasterIfStartAsPortrait = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.isIPad {
            preferredDisplayMode = .allVisible
        }
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setMasterWidth(size: view.bounds.size)
    }
    
    // MARK: - SplitViewController
    
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
        return UIDevice.isIPadOrIPhonePlus
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.isIPad {
            return .all
        }
        
        if UIDevice.isIPhonePlus {
            return .allButUpsideDown
        }
        
        return .portrait
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        showMasterIfStartAsPortrait = false
        
        setMasterWidth(size: size)
    }
    
    // MARK: - Master controller width
    
    func setMasterWidth(size: CGSize) {
        let width = UIScreen.splitMasterWidth(isLandscape: size.width > size.height)
        minimumPrimaryColumnWidth = width
        maximumPrimaryColumnWidth = width
    }
    
}

extension UIScreen {
    
    static let minSize: CGFloat = { return min(main.bounds.size.width, main.bounds.size.height) }()
    static let maxSize: CGFloat = { return max(main.bounds.size.width, main.bounds.size.height) }()
    
    static let minSizeIPhone4:    CGFloat = { return  320 }()
    static let minSizeIPhone5:    CGFloat = { return  320 }()
    static let minSizeIPhone6:    CGFloat = { return  375 }()
    static let minSizeIPhoneX:    CGFloat = { return  375 }()
    static let minSizeIPhonePlus: CGFloat = { return  414 }()
    static let minSizeIPad_9_7:   CGFloat = { return  768 }()
    static let minSizeIPad_10_5:  CGFloat = { return  834 }()
    static let minSizeIPad_12_9:  CGFloat = { return 1024 }()
    
    static let maxSizeIPhone4:    CGFloat = { return  480 }()
    static let maxSizeIPhone5:    CGFloat = { return  568 }()
    static let maxSizeIPhone6:    CGFloat = { return  667 }()
    static let maxSizeIPhonePlus: CGFloat = { return  736 }()
    static let maxSizeIPhoneX:    CGFloat = { return  812 }()
    static let maxSizeIPad_9_7:   CGFloat = { return 1024 }()
    static let maxSizeIPad_10_5:  CGFloat = { return 1112 }()
    static let maxSizeIPad_12_9:  CGFloat = { return 1366 }()
    
    // MARK: - Split master width
    
    static let splitMasterWidthByDeviceOrientation: (portrait: CGFloat, landscape: CGFloat) = {
        switch UIDevice.model {
        case .iPhone4, .iPhone5, .iPhone6, .iPhoneX:
            return (portrait: minSize, landscape: maxSize)
        case .iPhonePlus: return (portrait: minSize, landscape: 295)
        case .iPad_9_7:   return (portrait:     320, landscape: 389)
        case .iPad_10_5:  return (portrait:     320, landscape: 423)
        case .iPad_12_9:  return (portrait:     375, landscape: 519)
        }
    }()
    
    class func splitMasterWidth(isLandscape: Bool) -> CGFloat {
        return isLandscape ? splitMasterWidthByDeviceOrientation.landscape : splitMasterWidthByDeviceOrientation.portrait
    }
    
    class var isSplit: Bool {
        return UIDevice.isIPad || UIDevice.isLandscape
    }
    
}

extension UIDevice {
    
    static let isIPad:       Bool = current.userInterfaceIdiom == .pad
    static let isIPhone:     Bool = current.userInterfaceIdiom == .phone
    static let isIPhonePlus: Bool = isIPhone && UIScreen.minSize == UIScreen.minSizeIPhonePlus
    
    static let isIPadOrIPhone:     Bool = isIPad || isIPhone
    static let isIPadOrIPhonePlus: Bool = isIPad || isIPhonePlus
    
    class var isLandscape: Bool {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        return statusBarOrientation == .landscapeLeft || statusBarOrientation == .landscapeRight
    }
    
    // MARK: - Model
    
    enum Model: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhoneX
        case iPhonePlus
        case iPad_9_7
        case iPad_10_5
        case iPad_12_9
    }
    
    static var model: Model = {
        let minSize = UIScreen.minSize
        let maxSize = UIScreen.maxSize
        
        if minSize <= UIScreen.minSizeIPhone5 {
            if maxSize <= UIScreen.maxSizeIPhone4       { return .iPhone4    }
            else                                        { return .iPhone5    }
        } else if minSize <= UIScreen.minSizeIPhoneX {
            if maxSize <= UIScreen.maxSizeIPhone6       { return .iPhone6    }
            else                                        { return .iPhoneX    }
        } else if minSize <= UIScreen.minSizeIPhonePlus { return .iPhonePlus }
        else if minSize <= UIScreen.minSizeIPad_9_7   { return .iPad_9_7   }
        else if minSize <= UIScreen.minSizeIPad_10_5  { return .iPad_10_5  }
        else                                          { return .iPad_12_9  }
    }()
    
}

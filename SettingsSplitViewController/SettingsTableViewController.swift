//
//  SettingsTableViewController.swift
//  SettingsSplitViewController
//

import UIKit

class SettingsSplitViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SettingsTableViewHeaderFooterView()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return SettingsTableViewHeaderFooterView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == self.tableView(tableView, numberOfRowsInSection: indexPath.section) - 1
        
        return SettingsTableViewCell(isFirst: isFirst, isLast: isLast)
    }
    
}

class SettingsTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set(newFrame) {
            var frame = newFrame
            
            if UIScreen.isSplit {
                let indent = UIDevice.isLandscape ? UITableView.indent.landscape : UITableView.indent.portrait
                
                frame.origin.x += indent
                frame.size.width -= indent * 2
            }
            
            super.frame = frame
        }
    }
    
}

class SettingsTableViewCell: UITableViewCell {
    
    var isFirst: Bool = false
    var isLast: Bool = false
    
    init(isFirst: Bool, isLast: Bool) {
        super.init(style: .value1, reuseIdentifier: nil)
        
        self.isFirst = isFirst
        self.isLast = isLast
        
        drawSeparators(size: frame.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var topLayer: CALayer?
    weak var bottomLayer: CALayer?
    
    func drawSeparators(size: CGSize) {
        topLayer?.removeFromSuperlayer()
        bottomLayer?.removeFromSuperlayer()
        
        if UIScreen.isSplit {
            addRounding(isFirst: isFirst, isLast: isLast, size: size)
        } else {
            if isFirst {
                addSeparator(&topLayer, type: .first, size: size)
            }
            
            if isLast {
                addSeparator(&bottomLayer, type: .last,  size: size)
            }
        }
        
        if !isLast {
            addSeparator(&bottomLayer, type: .middle, size: size)
        }
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set(newFrame) {
            var frame = newFrame
            
            if UIScreen.isSplit {
                let indent = UIDevice.isLandscape ? UITableView.indent.landscape : UITableView.indent.portrait
                
                frame.origin.x += indent
                frame.size.width -= indent * 2
            } else {
                layer.mask = nil
            }
            
            drawSeparators(size: frame.size)
            
            super.frame = frame
        }
    }
    
}

extension UITableViewCell {
    
    // MARK: - Separator
    
    enum SeparatorType {
        case first
        case middle
        case last
    }
    
    func addSeparator(_ layer: inout CALayer?, type: SeparatorType, size: CGSize) {
        let tableSeparatorHeight: CGFloat = 1 / UIScreen.main.scale
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        if type == .middle {
            x = UITableViewCell.leftInset
        }
        
        if type == .middle || type == .last {
            y = size.height - tableSeparatorHeight
        }
        
        let newLayer = CALayer()
        newLayer.frame = CGRect(x: x, y: y, width: size.width - x, height: tableSeparatorHeight)
        newLayer.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 1).cgColor
        
        self.layer.addSublayer(newLayer)
        
        layer = newLayer
    }
    
    // MARK: - Rounding
    
    func addRounding(isFirst: Bool, isLast: Bool, size: CGSize) {
        var mask: CAShapeLayer?
        
        if isFirst || isLast {
            var byRoundingCorners = UIRectCorner()
            
            if isFirst && isLast {
                byRoundingCorners = [.allCorners]
            } else if isFirst {
                byRoundingCorners = [.topLeft, .topRight]
            } else if isLast {
                byRoundingCorners = [.bottomLeft, .bottomRight]
            }
            
            var y: CGFloat = 0
            
            if isFirst && !isLast {
                y = 1
            } else if !isFirst && isLast {
                y = -1
            }
            
            let cornerRadius: CGFloat = 6
            
            mask = CAShapeLayer()
            mask!.path = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: y), size: size),
                                      byRoundingCorners: byRoundingCorners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        }
        
        layer.mask = mask
    }
    
    // MARK: - Left inset
    
    static let leftInset: CGFloat = {
        switch UIDevice.model {
        case .iPhone:
            return 16
        case .iPhonePlus:
            return 20
        case .iPad_9_7, .iPad_10_5, .iPad_12_9:
            return 15
        }
    }()
    
}

extension UITableView {
    
    static let indent: (portrait: CGFloat, landscape: CGFloat) = {
        switch UIDevice.model {
        case .iPhone:
            return (portrait: 0, landscape: 0)
        case .iPhonePlus:
            return (portrait: 0, landscape: 20)
        case .iPad_9_7:
            return (portrait: 20, landscape: 20)
        case .iPad_10_5:
            return (portrait: 20, landscape: 20)
        case .iPad_12_9:
            return (portrait: 20, landscape: 87)
        }
    }()
    
}

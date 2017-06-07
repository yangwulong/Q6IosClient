//
//  DropDownmenu.swift
//  Dropmenu
//
//  Created by admin on 2017/5/24.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit

public protocol DropDownmenuDelegate: NSObjectProtocol {
    
    func dropDownmenuSelected(text: String)
}

public enum DircetionType {
    case up
    case down
}

class DropDownmenu: UIView, UITableViewDataSource, UITableViewDelegate {
    
    public weak var delegate: DropDownmenuDelegate?
    
    private var animationDirection = DircetionType.up
    private lazy var tableView = UITableView()
    private lazy var viewSender = UIView()
    private lazy var list = [Any]()
    
    init() { super.init(frame: CGRect.zero) }
    
    init(viewS: UIView, height: CGFloat, array: [Any], direction: DircetionType) {
        super.init(frame: CGRect.zero)
        
        viewSender = viewS
        animationDirection = direction
        
        let viewFrame = viewS.frame
        
        list = array
        
        switch direction {
        case .up:
            self.frame = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y, width: viewFrame.width, height: 0)
            self.layer.shadowOffset = CGSize(width: -5, height: -5)
        case .down:
            self.frame = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y + viewFrame.height, width: viewFrame.width, height: 0)
            self.layer.shadowOffset = CGSize(width: -5, height: -5)
        }
        
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.1
        self.layer.cornerRadius = 5
        
        tableView .frame = CGRect(x: 0, y: 0, width: viewFrame.width, height: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5
        tableView.rowHeight = 44
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        switch direction {
        case .up:
            self.frame = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y - height, width: viewFrame.width, height: height)
        default:
            self.frame = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y + viewFrame.height, width: viewFrame.width, height: height)
        }
        
        tableView.frame = CGRect(x: 0, y: 0, width: viewFrame.width, height: height)
        UIView.commitAnimations()
        viewS.superview?.addSubview(self)
        self.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func hideDropDownmenu(viewS: UIView){
        
        let viewFrame = viewS.frame
        
        UIView.animate(withDuration: 0.5, animations: {
            
            switch self.animationDirection {
            case .up:
                self.frame = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y, width: viewFrame.width, height: 0)
            case .down:
                self.frame = CGRect(x: viewFrame.origin.x, y: viewFrame.origin.y + viewFrame.height, width: viewFrame.width, height: 0)
            }
            self.tableView.frame = CGRect(x: 0, y: 0, width: viewFrame.width, height: 0)
            
        }) { (_) in
            
            self.removeFromSuperview()
        }
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.adjustsFontSizeToFitWidth = true
            cell?.textLabel?.numberOfLines = 0
        }
        
        cell?.textLabel?.textColor = UIColor.gray
        cell?.textLabel?.text = list[indexPath.row] as? String
        
        return cell!
    }
    
    // MARK: Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        hideDropDownmenu(viewS: viewSender)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let delegate = self.delegate {
            
            delegate.dropDownmenuSelected(text: cell?.textLabel?.text ?? "")
        }
    }
}

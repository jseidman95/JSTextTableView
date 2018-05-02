//
//  Cells.swift
//  JSTextTableView
//
//  Created by Jesse Seidman on 4/13/18.
//  Copyright © 2018 Jesse Seidman. All rights reserved.
//

import UIKit
import RotatingArrowView

internal class TextCell:UITableViewCell
{
  // lets
  internal let label = InsetLabel()

  // vars
  internal var isExpanded = true
  
  // inits
  override internal init(style: UITableViewCellStyle,
                         reuseIdentifier: String?)
  {
    super.init(style: style,
               reuseIdentifier: reuseIdentifier)
    
    // set TextCell data
    self.addTextLabel()
    self.selectionStyle = .none
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  // funcs
  public func addTextLabel()
  {
    // set label data
    label.numberOfLines = 0
    
    // constraints
    self.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.leftAnchor.constraint(equalTo:   self.leftAnchor).isActive   = true
    label.rightAnchor.constraint(equalTo:  self.rightAnchor).isActive  = true
    label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    label.topAnchor.constraint(equalTo:    self.topAnchor).isActive    = true
  }
}

class InsetLabel:UILabel
{
  override func drawText(in rect: CGRect)
  {
    let insets = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
}

internal class ExpandingTriggerCell:UITableViewCell
{
  // lets
  // internal
  internal var mainView = UIView()
  internal var arrowView:RotatingArrowView? = nil
  internal var titleLabel = UILabel()
  
  // inits
  internal override init(style: UITableViewCellStyle,
                         reuseIdentifier: String?)
  {
    super.init(style: style,
               reuseIdentifier: reuseIdentifier)
    
    self.startUp()
  }
  
  internal required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  // funcs
  // private
  private func startUp()
  {
    makeMainView()
    addCenterView()
    
    self.selectionStyle = .none
  }
  
  private func makeMainView()
  {
    mainView.backgroundColor = UIColor.groupTableViewBackground
    
    // constraints
    self.addSubview(mainView)
    mainView.translatesAutoresizingMaskIntoConstraints = false
    mainView.leftAnchor.constraint(equalTo:   self.leftAnchor).isActive   = true
    mainView.rightAnchor.constraint(equalTo:  self.rightAnchor).isActive  = true
    mainView.topAnchor.constraint(equalTo:    self.topAnchor).isActive    = true
    mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
  
  private func addCenterView()
  {
    // make arrow view
    arrowView = RotatingArrowView(frame: CGRect(x: 0.0,
                                                y: 0.0,
                                                width: self.frame.width/10,
                                                height: self.frame.height))
    
    // make center view
    let centerView = UIView()
    
    // add views to stackview
    centerView.addSubview(arrowView!)
    centerView.addSubview(titleLabel)
    
    // add arrow view constraints
    arrowView?.translatesAutoresizingMaskIntoConstraints = false
    arrowView?.leftAnchor.constraint(equalTo: centerView.leftAnchor).isActive     = true
    arrowView?.topAnchor.constraint(equalTo: centerView.topAnchor).isActive       = true
    arrowView?.bottomAnchor.constraint(equalTo: centerView.bottomAnchor).isActive = true
    arrowView?.widthAnchor.constraint(equalToConstant: self.frame.width/10).isActive = true
    arrowView?.rightAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: -10.0).isActive = true
    
    // set title label data
    titleLabel.font = UIFont.systemFont(ofSize: 20.0)
    
    // add title label constraints
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.rightAnchor.constraint(equalTo: centerView.rightAnchor).isActive = true
    titleLabel.topAnchor.constraint(equalTo: centerView.topAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: centerView.bottomAnchor).isActive = true
    
    // add stack view
    self.addSubview(centerView)
    
    // make stack view constraints
    centerView.translatesAutoresizingMaskIntoConstraints = false
    centerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    centerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  }
}

//
//  Cells.swift
//  JSTextTableView
//
//  Created by Jesse Seidman on 4/13/18.
//  Copyright © 2018 Jesse Seidman. All rights reserved.
//

import UIKit

internal class TextSuperCell:UITableViewCell
{
  // lets
  internal let label = UILabel()
  
  // inits
  override internal init(style: UITableViewCellStyle,
                         reuseIdentifier: String?)
  {
    super.init(style: style,
               reuseIdentifier: reuseIdentifier)
    
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
    label.numberOfLines = 0
    
    self.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.leftAnchor.constraint(equalTo:   self.leftAnchor).isActive   = true
    label.rightAnchor.constraint(equalTo:  self.rightAnchor).isActive  = true
    label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
}

internal class TextCell:TextSuperCell
{
  // inits
  internal override init(style: UITableViewCellStyle,
                         reuseIdentifier: String?)
  {
    super.init(style: style,
               reuseIdentifier: reuseIdentifier)
    
    self.anchorLabelToTop()
  }
  
  internal required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  // funcs
  private func anchorLabelToTop()
  {
    self.label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
  }
}

internal class ExpandableTextCell:TextSuperCell
{
  // lets
  internal let expandView  = UIView()
  internal let expandLabel = UILabel()
  
  // vars
  // private
  private var labelHeightConstraint = NSLayoutConstraint()
  // internal static
  internal static var expandViewHeight:CGFloat = 100.0
  // public
  public var isExpanded = false
  {
    didSet
    {
      labelHeightConstraint.isActive = !isExpanded
      self.label.sizeToFit()
    }
  }
  
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
    makeExpandView()
    makeExpandLabel()
    makeTextLabelConstraints()
  }
  
  private func makeExpandView()
  {
    expandView.backgroundColor = UIColor.yellow
    
    self.addSubview(expandView)
    expandView.translatesAutoresizingMaskIntoConstraints = false
    expandView.leftAnchor.constraint(equalTo:  self.leftAnchor).isActive  = true
    expandView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    expandView.topAnchor.constraint(equalTo:   self.topAnchor).isActive   = true
    
    // set the priority of the height lower to avoid layout issues
    let heightConstraint = expandView.heightAnchor.constraint(equalToConstant: ExpandableTextCell.expandViewHeight)
    heightConstraint.priority = UILayoutPriority(rawValue: 999.0)
    heightConstraint.isActive = true
  }
  
  private func makeExpandLabel()
  {
    expandLabel.backgroundColor = UIColor.blue
    expandLabel.text = "Expand"
    expandLabel.sizeToFit()
   
    self.addSubview(expandLabel)
    expandLabel.translatesAutoresizingMaskIntoConstraints = false
    expandLabel.centerXAnchor.constraint(equalTo: expandView.centerXAnchor).isActive = true
    expandLabel.centerYAnchor.constraint(equalTo: expandView.centerYAnchor).isActive = true
    
    
  }
  
  private func makeTextLabelConstraints()
  {
    self.label.topAnchor.constraint(equalTo: expandView.bottomAnchor).isActive = true
    
    labelHeightConstraint = NSLayoutConstraint(item: self.label,
                                               attribute: .height,
                                               relatedBy: .equal,
                                               toItem: nil,
                                               attribute: .notAnAttribute,
                                               multiplier: 1.0,
                                               constant: 0.0)

    labelHeightConstraint.isActive = true
  }
  
  // public
  public func expandCell()
  {
    isExpanded = true
  }
  public func collapseCell()
  {
    isExpanded = false
  }
}

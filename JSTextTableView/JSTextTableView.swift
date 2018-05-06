//
//  JSTextTableView.swift
//  JSTextTableView
//
//  Created by Jesse Seidman on 4/13/18.
//  Copyright © 2018 Jesse Seidman. All rights reserved.
//

import UIKit

open class JSTextTableView: UITableView
{
  // lets
  // private final let
  private final let TEXT_CELL_IDENTIFIER = "textCell"
  private final let EXPANDABLE_TRIGGER_CELL_IDENTIFIER = "expandableTriggerCell"
  
  // vars
  // private
  private var lastOrientation:UIDeviceOrientation = .portrait
  
  // public
  public var fontSize:CGFloat = 15.0
  public var defaultFont:UIFont = UIFont.systemFont(ofSize: 15.0)
  
  // public get private set
  public private(set) var dataArray = [CellData]()
  public private(set) var cellHeightDictionary:[IndexPath:CGFloat] = [:]
  // public static
  public static var arrowColor:UIColor = UIColor.blue
  
  // inits
  public override init(frame: CGRect, style: UITableViewStyle)
  {
    super.init(frame: frame, style: style)
    
    startUp()
  }
  
  public required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    
    startUp()
  }
  
  private func startUp()
  {
    // set delegate and datasourse
    self.dataSource = self
    self.delegate   = self
    
    // registers cells
    self.register(TextCell.self,
                  forCellReuseIdentifier: TEXT_CELL_IDENTIFIER)
    self.register(ExpandingTriggerCell.self,
                  forCellReuseIdentifier: EXPANDABLE_TRIGGER_CELL_IDENTIFIER)
    
    // set initial orientation
    lastOrientation = UIDevice.current.orientation
  }
  
  // methods to add data to text tableview
  public func addExpandableRegularText(text:String,
                                       isExpanded:Bool,
                                       title:String)
  {
    dataArray.append(ExpandingTriggerData(title: title))
    dataArray.append(RegularTextData(isExpanded: isExpanded,
                                     text: text,
                                     title: title))
  }
  
  public func addExpandableAttributedText(attributedText:NSAttributedString,
                                          isExpanded:Bool,
                                          title:String)
  {
    dataArray.append(ExpandingTriggerData(title: title))
    dataArray.append(AttributedTextData(isExpanded: isExpanded,
                                        attributedText: attributedText,
                                        title: title))
  }
  
  public func addNonExpandableRegularText(text:String,
                                          title:String)
  {
    // make data
    var data = RegularTextData(isExpanded: true,
                               text: text,
                               title: title)
    data.title = title
    
    // append data
    dataArray.append(data)
  }
  
  public func addNonExpandableAttributedText(attributedText:NSAttributedString,
                                             title:String)
  {
    // make data
    var data = AttributedTextData(isExpanded: true,
                                  attributedText: attributedText,
                                  title: title)
    data.title = title
    
    // append data
    dataArray.append(data)
  }
}

// deal with orientation
extension JSTextTableView
{
  open override func layoutSubviews()
  {
    if UIDevice.current.orientation != lastOrientation
    {
      // update orientation
      lastOrientation = UIDevice.current.orientation
      
      // update cells
      cellHeightDictionary   = [:]
      
      self.reloadData()
    }
    
    super.layoutSubviews()
  }
  
  // ensure separator is hidden
  open override func didMoveToSuperview()
  {
    self.separatorStyle = .none
  }
}

extension JSTextTableView: UITableViewDataSource
{
  public func tableView(_ tableView: UITableView,
                      numberOfRowsInSection section: Int) -> Int
  {
    return self.dataArray.count
  }
  
  public func tableView(_ tableView: UITableView,
                      cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    if dataArray[indexPath.row] is ExpandingTriggerData
    {
      let cell = tableView.dequeueReusableCell(withIdentifier: EXPANDABLE_TRIGGER_CELL_IDENTIFIER) as? ExpandingTriggerCell
      
      // set arrow
      if dataArray[indexPath.row + 1].isExpanded
      {
        cell?.arrowView?.setArrowDown()
        cell?.arrowView?.layoutIfNeeded()
      }
      else
      {
        cell?.arrowView?.setArrowUp()
        cell?.arrowView?.layoutIfNeeded()
      }
      
      // set label
      cell?.titleLabel.text = dataArray[indexPath.row].title
      
      return cell!
    }
    else if let data = dataArray[indexPath.row] as? RegularTextData
    {
      let cell = tableView.dequeueReusableCell(withIdentifier: TEXT_CELL_IDENTIFIER) as? TextCell
      
      cell?.label.text = data.text
      cell?.label.font = defaultFont.withSize(fontSize)
      cell?.isExpanded = data.isExpanded
      
      if indexPath.row - 1 >= 0 && dataArray[indexPath.row - 1] is ExpandingTriggerData
      {
        cell?.backgroundColor = UIColor.groupTableViewBackground
      }
      else
      {
        cell?.backgroundColor = UIColor.white
      }
      
      return cell!
    }
    else if let data = dataArray[indexPath.row] as? AttributedTextData
    {
      let cell = tableView.dequeueReusableCell(withIdentifier: TEXT_CELL_IDENTIFIER) as? TextCell
      
      let mutableString = NSMutableAttributedString(attributedString: data.attributedText)
      mutableString.addAttributes([NSAttributedStringKey.font:defaultFont.withSize(fontSize)], range: NSMakeRange(0, mutableString.length))
      cell?.label.attributedText = mutableString
      cell?.isExpanded = data.isExpanded

      if indexPath.row - 1 >= 0 && dataArray[indexPath.row - 1] is ExpandingTriggerData
      {
        cell?.backgroundColor = UIColor.groupTableViewBackground
      }
      else
      {
        cell?.backgroundColor = UIColor.white
      }
      
      return cell!
    }
    else { fatalError() }
  }
}

extension JSTextTableView: UITableViewDelegate
{
  public func tableView(_ tableView: UITableView,
                        heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return getHeightForCell(tableView, indexPath: indexPath)
  }
  
  public func tableView(_ tableView: UITableView,
                        estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return getHeightForCell(tableView, indexPath: indexPath)
  }
  
  public func tableView(_ tableView: UITableView,
                        willDisplay cell: UITableViewCell,
                        forRowAt indexPath: IndexPath)
  {
    if dataArray[indexPath.row] is ExpandingTriggerData
    {
      cellHeightDictionary[indexPath] = cell.frame.height
    }
    else if dataArray[indexPath.row].isExpanded
    {
      cellHeightDictionary[indexPath]   = cell.frame.height
    }
  }
  
  public func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath)
  {
    if dataArray[indexPath.row] is ExpandingTriggerData
    {
      // this is done to prevent simultaneous access error, tbh dont really understand that
      let expanded = dataArray[indexPath.row + 1].isExpanded
      dataArray[indexPath.row + 1].isExpanded = !expanded
      
      // get cell to trigger its arrow movement
      let cell = tableView.cellForRow(at: indexPath) as! ExpandingTriggerCell
      
      // animate expanding/contracting and arrow movement
      cell.arrowView?.spinArrow()
      tableView.performBatchUpdates(nil)
    }
  }
  
  private func getHeightForCell(_ tableView: UITableView,
                                indexPath: IndexPath) -> CGFloat
  {
    if !dataArray[indexPath.row].isExpanded
    {
      return 0.0
    }
    else if let height = cellHeightDictionary[indexPath]
    {
      return height
    }
    else
    {
      if dataArray[indexPath.row] is ExpandingTriggerData
      {
        return 75.0
      }
      else
      {
        return UITableViewAutomaticDimension
      }
    }
  }
}

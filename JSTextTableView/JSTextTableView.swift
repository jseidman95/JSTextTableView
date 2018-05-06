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
  private final let defaultFontSize:CGFloat = 15.0
  
  // vars
  // private
  private var cellHeightDictionary:[IndexPath:CGFloat] = [:]
  private var dataArray = [CellData]()
  private var lastOrientation:UIDeviceOrientation = .portrait
  private var fontPinchGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer()
  private var fontSize:CGFloat = 15.0
  
  // open static
  open static var arrowColor:UIColor = UIColor.blue
  
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
    
    // set table view data
    self.separatorStyle = .none
    
    // set initial orientation
    lastOrientation = UIDevice.current.orientation
    
    // make pinch gesture
    fontPinchGesture.addTarget(self, action: #selector(pinchToZoomText(pinchRecog:)))
    self.addGestureRecognizer(fontPinchGesture)
    
    // add test data
    addTestData()
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
}

extension JSTextTableView: UITableViewDataSource
{
  open func tableView(_ tableView: UITableView,
                      numberOfRowsInSection section: Int) -> Int
  {
    return self.dataArray.count
  }
  
  open func tableView(_ tableView: UITableView,
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
      
      cell?.isExpanded = data.isExpanded
      
      return cell!
    }
    else if let data = dataArray[indexPath.row] as? AttributedTextData
    {
      let cell = tableView.dequeueReusableCell(withIdentifier: TEXT_CELL_IDENTIFIER) as? TextCell
      
      let mutableString = NSMutableAttributedString(attributedString: data.attributedText)
      mutableString.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize)], range: NSMakeRange(0, mutableString.length))
      cell?.label.attributedText = mutableString
      
      cell?.isExpanded = data.isExpanded
      
      return cell!
    }
    else { fatalError() }
  }
}

extension JSTextTableView: UITableViewDelegate
{
  open func tableView(_ tableView: UITableView,
                      heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return getHeightForCell(tableView, indexPath: indexPath)
  }
  
  open func tableView(_ tableView: UITableView,
                      estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return getHeightForCell(tableView, indexPath: indexPath)
  }
  
  open func tableView(_ tableView: UITableView,
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
  
  open func tableView(_ tableView: UITableView,
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
  
  private func addTestData()
  {
    if let rtfPath = Bundle.main.url(forResource: "testShacharit", withExtension: "rtf")
    {
      
      let attributedStringWithRtf: NSAttributedString = try! NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
      
      for _ in (0...24)
      {
        self.addNonExpandableAttributedText(attributedText: attributedStringWithRtf,
                                            title: "HEYO")
      }
      self.reloadData()
    }
  }
}

// pinch
extension JSTextTableView
{
  @objc fileprivate func pinchToZoomText(pinchRecog: UIPinchGestureRecognizer)
  {
    
    if(pinchRecog.state == .began)
    {
    }
    else if(pinchRecog.state == .changed)
    {
      
      let newSize = (pinchRecog.velocity > 0 ? 1 : -1) * 1 + fontSize
      
      if newSize < 70.0 && newSize > 8.0
      {
        fontSize = newSize
        updateVisibleCells()
      }
      
    }
    else
    {
      print("END")
    }
    
  }
  
  private func updateVisibleCells()
  {
    
    UIView.performWithoutAnimation {
      for cell in self.visibleCells
      {
        if let textCell = cell as? TextCell
        {
          if let indexPath = self.indexPath(for: textCell), let data = self.dataArray[(indexPath.row)] as? AttributedTextData
          {
            let mutableString = NSMutableAttributedString(attributedString: data.attributedText)
            mutableString.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: fontSize)], range: NSMakeRange(0, mutableString.length))
            textCell.label.attributedText = mutableString
            
            self.beginUpdates()
            cellHeightDictionary[indexPath] = textCell.label.attributedText?.height(withConstrainedWidth: self.frame.width)
            self.endUpdates()
          }
        }
      }
    }
  }
}
extension NSAttributedString {
  func height(withConstrainedWidth width: CGFloat) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
    return ceil(boundingBox.height)
  }
}

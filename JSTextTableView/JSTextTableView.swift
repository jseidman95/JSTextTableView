//
//  JSTextTableView.swift
//  JSTextTableView
//
//  Created by Jesse Seidman on 4/13/18.
//  Copyright © 2018 Jesse Seidman. All rights reserved.
//

import UIKit

public class JSTextTableView: UITableView
{
  // vars
  private var dataArray = [CellData]()
  
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
    dataSource = self
    delegate   = self
    
    self.register(TextCell.self,
                  forCellReuseIdentifier: "textCell")
    self.register(ExpandableTextCell.self,
                  forCellReuseIdentifier: "expandableTextCell")

    self.separatorStyle = .none
    
    if let rtfPath = Bundle.main.url(forResource: "shachritAshkinaz", withExtension: "rtf")
    {
      do
      {
        let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
        let string = attributedStringWithRtf
        for i in (0...23)
        {
          dataArray.append(CellData(text: string,
                                    isExpandable: true,
                                    isExpanded: i%2==0))
        }
      }
      catch let error
      {
        print("Got an error \(error)")
      }
    }
  }
}

extension JSTextTableView: UITableViewDataSource
{
  public func tableView(_ tableView: UITableView,
                        numberOfRowsInSection section: Int) -> Int
  {
    return dataArray.count
  }
  
  public func tableView(_ tableView: UITableView,
                        cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "expandableTextCell") as? ExpandableTextCell

    cell?.label.attributedText = dataArray[indexPath.row].text
    cell?.isExpanded = dataArray[indexPath.row].isExpanded

    return cell!
  }
}

extension JSTextTableView: UITableViewDelegate
{
  public func tableView(_ tableView: UITableView,
                        heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return UITableViewAutomaticDimension
  }

  public func tableView(_ tableView: UITableView,
                        estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return UITableViewAutomaticDimension
  }
  
  public func tableView(_ tableView: UITableView,
                        didSelectRowAt indexPath: IndexPath)
  {
    dataArray[indexPath.row].isExpanded = !dataArray[indexPath.row].isExpanded
    tableView.reloadRows(at: [indexPath], with: .fade)
  }
}

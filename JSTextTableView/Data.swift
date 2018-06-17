//
//  Data.swift
//  JSTextTableView
//
//  Created by Jesse Seidman on 4/13/18.
//  Copyright © 2018 Jesse Seidman. All rights reserved.
//

import UIKit

// super protocols
public protocol CellData
{
  var isExpanded: Bool { get set }
  var title: String    { get set }
  var isGray: Bool     { get set }
  var alignment:NSTextAlignment { get set }
}

// we do this so when the [CellData] is accessed the values can be changed without downcasting
extension CellData
{
  public var isExpanded: Bool
  {
    get { return true }
    set {}
  }
  
  public var title: String
  {
    get { return "" }
    set {}
  }
  
  public var isGray: Bool
  {
    get { return false }
    set {}
  }
  
  public var alignment: NSTextAlignment
  {
    get { return .right }
    set {}
  }
}

// usable structs
public struct ExpandingTriggerData:CellData
{
  public var title: String
  public var expandingCellCount: Int
}

public struct AttributedTextData:CellData
{
  public var isExpanded: Bool
  public var attributedText: NSAttributedString
  public var title: String
  public var isGray: Bool
  public var alignment: NSTextAlignment
}

public struct RegularTextData:CellData
{
  public var isExpanded: Bool
  public var text: String
  public var title: String
  public var isGray: Bool
  public var alignment: NSTextAlignment
}

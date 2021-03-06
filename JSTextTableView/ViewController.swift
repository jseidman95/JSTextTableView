//
//  ViewController.swift
//  JSTextTableView
//
//  Created by Jesse Seidman on 4/13/18.
//  Copyright © 2018 Jesse Seidman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
  private let jstv = JSTextTableView()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    jstv.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(jstv)
    jstv.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    jstv.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    jstv.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    jstv.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    
    addTestData()
  }
  
  private func addTestData()
  {
    if let rtfPath = Bundle.main.url(forResource: "test2", withExtension: "rtf"),
       let rtfPath2 = Bundle.main.url(forResource: "test", withExtension: "rtf")
    {
      
      let attributedStringWithRtf: NSAttributedString = try! NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
      let attributedStringWithRtf2: NSAttributedString = try! NSAttributedString(url: rtfPath2, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
      
      for _ in (0...24)
      {
        jstv.addNonExpandableAttributedText(attributedText: attributedStringWithRtf2, title: "Expand",
                                            alignment: .right)
        jstv.addExpandableAttributedText(attributedText: [attributedStringWithRtf,
                                                          attributedStringWithRtf,
                                                          attributedStringWithRtf,
                                                          attributedStringWithRtf,
                                                          attributedStringWithRtf],
                                         isExpanded: true,
                                         title: "Expand",
                                         alignment: .right)
      }
      jstv.reloadData()
    }
  }
}


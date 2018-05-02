//
//  RotatingArrowView.swift
//  RotatingArrowView
//
//  Created by Jesse Seidman on 4/24/18.
//  Copyright © 2018 Jesse Seidman. All rights reserved.
//

import UIKit

// initialization code
public class RotatingArrowView: UIView
{
  // vars
  // internal
  internal var circle:CircleView?
  internal var triangle:TriangleView?
  // public private(set)
  public private(set) var isFacingDown = false
  
  override public init(frame: CGRect)
  {
    super.init(frame: frame)
    
    startUp(frame:frame)
  }
  
  required public init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    
    startUp(frame: self.frame)
  }
  
  private func startUp(frame:CGRect)
  {
    // set data
    self.backgroundColor = UIColor.clear
    
    // makes views
    circle   = CircleView(frame: frame)
    triangle = TriangleView(frame: frame)
    
    // clear backgrounds
    circle?.backgroundColor   = UIColor.clear
    triangle?.backgroundColor = UIColor.clear
    
    // add views
    self.addSubview(circle!)
    self.addSubview(triangle!)
    
    // set constraints
    circle?.translatesAutoresizingMaskIntoConstraints = false
    circle?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    circle?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    circle?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive     = true
    circle?.heightAnchor.constraint(equalTo: self.heightAnchor).isActive   = true
    
    triangle?.translatesAutoresizingMaskIntoConstraints = false
    triangle?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    triangle?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    triangle?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive     = true
    triangle?.heightAnchor.constraint(equalTo: self.heightAnchor).isActive   = true
  }
}

// contains spin arrow method
extension RotatingArrowView
{
  public func spinArrow()
  {
    UIView.animate(withDuration: 0.3,
                   delay: 0.0,
                   options: .curveEaseIn,
                   animations: {
                    self.isFacingDown ? self.setArrowUp() : self.setArrowDown()
    },
                   completion: nil)
  }
  
  public func setArrowDown()
  {
    self.triangle?.transform = CGAffineTransform(rotationAngle: CGFloat(-2 * Double.pi))
    self.isFacingDown = true
  }
  
  public func setArrowUp()
  {
    self.triangle?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    self.isFacingDown = false
  }
}

class CircleView:UIView
{
  private var didDraw = false
  
  override func draw(_ rect: CGRect)
  {
    if !didDraw
    {
      // make path
      let radius = min(self.frame.width/2,self.frame.height/2)
      let path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2),
                              radius: radius,
                              startAngle: 0.0,
                              endAngle: CGFloat(Double.pi*2),
                              clockwise: true)
      
      // make layer
      let circleLayer = CAShapeLayer()
      circleLayer.fillColor = UIColor.white.cgColor
      circleLayer.path = path.cgPath
      
      // make shadow
      let shadowCircleLayer = CAShapeLayer()
      let shadowPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2),
                                    radius: radius,
                                    startAngle: 0.0,
                                    endAngle: CGFloat(Double.pi*2),
                                    clockwise: true)
      shadowCircleLayer.shadowPath    = shadowPath.cgPath
      shadowCircleLayer.shadowColor   = UIColor.black.cgColor
      shadowCircleLayer.shadowOpacity = 0.75
      shadowCircleLayer.shadowOffset  = CGSize.zero
      shadowCircleLayer.shadowRadius  = 2.0
      shadowCircleLayer.shouldRasterize = true
      
      // add them to the view
      self.layer.addSublayer(shadowCircleLayer)
      self.layer.addSublayer(circleLayer)
      
      // notify of drawing
      didDraw = true
    }
  }
}

class TriangleView:UIView
{
  private var didDraw = false
  
  override func draw(_ rect: CGRect)
  {
    if !didDraw
    {
      // make path
      let path = UIBezierPath()
      
      // find triangle data
      let angle = 60.0
      let circleRadius   = min(self.frame.width/2,self.frame.height/2)
      let circleCenter   = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
      let triangleHeight = (7/18.0) * (circleRadius * 2)
      let sideLength     = triangleHeight / sin(angle.toDegrees())
      let triangleOrigin = CGPoint(x: circleCenter.x, y: circleCenter.y - triangleHeight * 7 / 12)
      path.move(to: triangleOrigin)
      
      let leftAnglePoint  = CGPoint(x: triangleOrigin.x - sideLength/2,
                                    y: triangleOrigin.y + triangleHeight)
      let rightAnglePoint = CGPoint(x: triangleOrigin.x + sideLength/2,
                                    y: triangleOrigin.y + triangleHeight)
      
      // draw path to points
      path.addLine(to: leftAnglePoint)
      path.addLine(to: rightAnglePoint)
      path.addLine(to: triangleOrigin)
      
      // make shape layer
      let triangleLayer = CAShapeLayer()
      triangleLayer.path = path.cgPath
      triangleLayer.fillColor = UIColor.blue.cgColor
      triangleLayer.shouldRasterize = true
      
      // add layer
      self.layer.addSublayer(triangleLayer)
      
      // notify drawing
      didDraw = true
    }
  }
}

extension Double
{
  func toDegrees() -> CGFloat
  {
    return CGFloat(self * 180 / Double.pi)
  }
}

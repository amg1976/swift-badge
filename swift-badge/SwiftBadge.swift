//
//  SwiftBadge.swift
//  swift-badge
//
//  Created by Evgenii Neumerzhitckii on 1/10/2014.
//  Copyright (c) 2014 The Exchange Group Pty Ltd. All rights reserved.
//

import UIKit

class SwiftBadge: UILabel {
  
  var defaultInsets = CGSize(width: 2, height: 2) {
    didSet {
      actualInsets = defaultInsets
      invalidateIntrinsicContentSize()
    }
  }
  
  var borderWidth: CGFloat = 0 {
    didSet {
      invalidateIntrinsicContentSize()
      setNeedsDisplay()
    }
  }
  
  lazy var borderColor: UIColor = UIColor.whiteColor()
  
  convenience init() {
    self.init(frame: CGRect())
  }

  //MARK: UILabel
  
  override var backgroundColor: UIColor? {
    get { return fillColor }
    set {
      if let color = newValue {
        fillColor = color
      } else {
        fillColor = UIColor.clearColor()
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setup()
  }
  
  // Add custom insets
  // --------------------
  override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    let rect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)

    var insetsWithBorder = actualInsetsWithBorder()
    let rectWithDefaultInsets = CGRectInset(rect, -insetsWithBorder.width, -insetsWithBorder.height)
    
    // If width is less than height
    // Adjust the width insets to make it look round
    if rectWithDefaultInsets.width < rectWithDefaultInsets.height {
      insetsWithBorder.width = (rectWithDefaultInsets.height - rect.width) / 2
    }
    let result = CGRectInset(rect, -insetsWithBorder.width, -insetsWithBorder.height)

    return result
  }
  
  override func drawTextInRect(rect: CGRect) {
    
    layer.cornerRadius = rect.height / 2
    
    let insetsWithBorder = actualInsetsWithBorder()
    let insets = UIEdgeInsets(
      top: insetsWithBorder.height,
      left: insetsWithBorder.width,
      bottom: insetsWithBorder.height,
      right: insetsWithBorder.width)
    
    let rectWithoutInsets = UIEdgeInsetsInsetRect(rect, insets)

    super.drawTextInRect(rectWithoutInsets)
  }
  
  override func drawRect(rect: CGRect) {

    if let _ = UIGraphicsGetCurrentContext() {
      
      let rectInset = CGRectInset(rect, borderWidth/2, borderWidth/2)
      let path = UIBezierPath(roundedRect: rectInset, cornerRadius: rect.height/2)
      
      fillColor.setFill()
      path.fill()
      
      if borderWidth > 0 {
        borderColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
      }
      
    }
    
    super.drawRect(rect)
  }
  
  //MARK: private
  
  private var fillColor: UIColor = UIColor.redColor()
  private var actualInsets: CGSize = CGSize()

  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    
    textColor = UIColor.whiteColor()
    textAlignment = NSTextAlignment.Center
    
    // Shadow
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = 0.5
    layer.shadowColor = UIColor.blackColor().CGColor
  }
  
  private func actualInsetsWithBorder() -> CGSize {
    return CGSize(width: actualInsets.width+borderWidth, height: actualInsets.height+borderWidth)
  }
  
}

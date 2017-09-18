//
//  KWVerificationCodeView.swift
//  Pods
//
//  Created by KeepWorks on 11/01/17.
//  Copyright © 2017 KeepWorks Technologies Pvt Ltd. All rights reserved.
//

import UIKit

public protocol KWVerificationCodeViewDelegate: class {
  func didChangeVerificationCode()
}

@IBDesignable open class KWVerificationCodeView: UIView {
  
  // MARK: - Constants
  static let maxCharactersLength = 1
  
  // MARK: - IBInspectables
  @IBInspectable open var underlineColor: UIColor = UIColor.darkGray {
    didSet {
      for textFieldView in textFieldViews {
        textFieldView.underlineColor = underlineColor
      }
    }
  }
  
  @IBInspectable var underlineSelectedColor: UIColor = UIColor.black {
    didSet {
      for textFieldView in textFieldViews {
        textFieldView.underlineSelectedColor = underlineSelectedColor
      }
    }
  }
  
  @IBInspectable var textColor: UIColor = UIColor.darkText {
    didSet {
      for textFieldView in textFieldViews {
        textFieldView.numberTextField.textColor = textColor
      }
    }
  }
  
  @IBInspectable var textSize: CGFloat = 24.0 {
    didSet {
      for textFieldView in textFieldViews {
        textFieldView.numberTextField.font = UIFont.systemFont(ofSize: textSize)
      }
    }
  }
  
  @IBInspectable var textFont: String = "" {
    didSet {
      if let font = UIFont(name: textFont.trim(), size: textSize) {
        textFieldFont = font
      } else {
        textFieldFont = UIFont.systemFont(ofSize: textSize)
      }
      
      for textFieldView in textFieldViews {
        textFieldView.numberTextField.font = textFieldFont
      }
    }
  }
  
  @IBInspectable var textFieldBackgroundColor: UIColor = UIColor.clear {
    didSet {
      for textFieldView in textFieldViews {
        textFieldView.numberTextField.backgroundColor = textFieldBackgroundColor
      }
    }
  }
  
  @IBInspectable var textFieldTintColor: UIColor = UIColor.blue {
    didSet {
      for textFieldView in textFieldViews {
        textFieldView.numberTextField.tintColor = textFieldTintColor
      }
    }
  }
  
  @IBInspectable var darkKeyboard: Bool = false {
    didSet {
      keyboardAppearance = darkKeyboard ? .dark : .light
      for textFieldView in textFieldViews {
        textFieldView.numberTextField.keyboardAppearance = keyboardAppearance
      }
    }
  }
  
  // MARK: - IBOutlets
  @IBOutlet weak private var textFieldView1: KWTextFieldView!
  @IBOutlet weak private var textFieldView2: KWTextFieldView!
  @IBOutlet weak private var textFieldView3: KWTextFieldView!
  @IBOutlet weak private var textFieldView4: KWTextFieldView!
  @IBOutlet var view: UIView!
  
  // MARK: - Variables
  public var isTappable: Bool = false {
    didSet {
      view.isUserInteractionEnabled = isTappable
    }
  }

  private var keyboardAppearance = UIKeyboardAppearance.default
  private var textFieldFont = UIFont.systemFont(ofSize: 24.0)
  
  lazy var textFieldViews: [KWTextFieldView] = {
    [unowned self] in
    
    return [self.textFieldView1, self.textFieldView2, self.textFieldView3, self.textFieldView4]
    }()
  
  weak public var delegate: KWVerificationCodeViewDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loadViewFromNib()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    loadViewFromNib()
    setupVerificationCodeViews()
  }
  
  // MARK: - Public Methods
  public func getVerificationCode() -> String {
    var verificationCode = ""
    for textFieldView in textFieldViews {
      verificationCode += textFieldView.numberTextField.text!
    }
    
    return verificationCode
  }
  
  public func hasValidCode() -> Bool {
    for textFieldView in textFieldViews {
      if Int(textFieldView.numberTextField.text!) == nil {
        return false
      }
    }
    
    return true
  }

    public func setColorsImmediately(borderColor: UIColor?, backgroundColor: UIColor?, fontColor: UIColor?) {
        for textFieldView in textFieldViews {
            if let borderColor = borderColor {
                textFieldView.layer.borderColor = borderColor.cgColor
            }
            if let backgroundColor = backgroundColor {
                textFieldView.backgroundColor = backgroundColor
            }
            if let fontColor = fontColor {
                textFieldView.textColor = fontColor
            }
        }
    }
  
  // MARK: - Private Methods
  private func setupVerificationCodeViews() {
    for textFieldView in textFieldViews {
      textFieldView.delegate = self
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldView.layer.cornerRadius = 8
        textFieldView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    }
    
    textFieldViews.first?.activate()
  }
}

// MARK: - KWTextFieldDelegate
extension KWVerificationCodeView: KWTextFieldDelegate {
  func moveToNext(_ textFieldView: KWTextFieldView) {
    let validIndex = textFieldViews.index(of: textFieldView) == textFieldViews.count - 1 ? textFieldViews.index(of: textFieldView)! : textFieldViews.index(of: textFieldView)! + 1
    textFieldViews[validIndex].activate()
  }
  
  func moveToPrevious(_ textFieldView: KWTextFieldView, oldCode: String) {
    if textFieldViews.last == textFieldView && oldCode != " " {
      return
    }
    textFieldView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    textFieldView.layer.borderColor = UIColor.lightGray.cgColor

    if textFieldView.code == " " {
      let validIndex = textFieldViews.index(of: textFieldView)! == 0 ? 0 : textFieldViews.index(of: textFieldView)! - 1
      textFieldViews[validIndex].activate()
      textFieldViews[validIndex].reset()
    }
  }
  
  func didChangeCharacters() {
    delegate?.didChangeVerificationCode()
  }
}

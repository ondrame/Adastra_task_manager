//
//  ColorPicker.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 08.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit


class ColorPicker: UIView {

    private var redButton:UIButton!
    private var blueButton:UIButton!
    private var greenButton:UIButton!
    private var yellowButton:UIButton!
    private var pinkButton:UIButton!
    

    var delegate:ColorPickerDelegate?
    
    init(frame: CGRect, delegate:ColorPickerDelegate, defaultColor:UIColor) {
        super.init(frame: frame)
        
       
        redButton = makeColorButton(x: frame.width / 2 - getButtonSize() / 2, color: UIColor.red)
        blueButton = makeColorButton(x: redButton.frame.minX - 15 - getButtonSize() , color: UIColor.blue)
        greenButton = makeColorButton(x: blueButton.frame.minX - 15 - getButtonSize() , color: UIColor.green)
        yellowButton = makeColorButton(x: redButton.frame.minX + 15 + getButtonSize() , color: UIColor.yellow)
        pinkButton = makeColorButton(x: yellowButton.frame.minX + 15 + getButtonSize() , color: UIColor.purple)
        
        switch defaultColor {
        case UIColor.green:setBorder(button: greenButton)
        case UIColor.blue:setBorder(button: blueButton)
        case UIColor.red:setBorder(button: redButton)
        case UIColor.yellow:setBorder(button: yellowButton)
        case UIColor.purple:setBorder(button: pinkButton)
        default:break
        }
    
        
        self.delegate = delegate

        self.addSubview(redButton)
        self.addSubview(blueButton)
        self.addSubview(greenButton)
        self.addSubview(yellowButton)
        self.addSubview(pinkButton)

    } // end of init method
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // get button size
    private func getButtonSize() -> CGFloat{
        return frame.height - 20
    }
    
    // make color select button
    private func makeColorButton(x:CGFloat, color:UIColor) -> UIButton{
        let button:UIButton = UIButton(frame: CGRect(x: x, y: 10, width: getButtonSize(), height: getButtonSize()))
        button.backgroundColor = color
        button.addTarget(self, action: Selector(("colorChange:")), for: .touchUpInside)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        
        return button
    }
    
    
    // change selected color
    @objc func colorChange(_ sender:UIButton){
        delegate?.setColor(color: sender.backgroundColor!)
        setBorder(button: sender)
     
    }
    
    // set border of selected color button
    private func setBorder(button:UIButton){
        for i in self.subviews{
            i.layer.borderWidth = 0
        }
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.white.cgColor
    }
} // end of class





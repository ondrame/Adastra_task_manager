//
//  CreateCategoryView.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 08.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//

import UIKit



class CreateCategoryView: UIViewController, ColorPickerDelegate {
 

    var colorPicker:ColorPicker!
    
    private var selectedColor:UIColor!
    private var nameText:String!
    
    private var delegate:CreateCategoryDelegate!
    var del:CreateCategoryDelegate!
    
    var adding:Bool!
    
    var category:Category!

    var identifier_generator:IDGenerator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default values
        identifier_generator = IDGenerator()
        
        if adding!{
            self.selectedColor = UIColor.green
            self.nameText = ""
        }else{
            self.selectedColor = category.color
            self.nameText = category.name
        }
       
        self.delegate = del
     
        self.view.addSubview(makeContentView())
    } // end of viewDidLoad

    
    
    private func makeContentView() -> UIView{
        var contentView:UIView!
        var nameTextfield:UITextField!
        var confirmButton:UIButton!
        var cancelButton:UIButton!
        
        
        var colorPicker:ColorPicker!
        
        // contentView body
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height  / 2))
        contentView.backgroundColor = UIColor.gray
        contentView.center.x = self.view.center.x
        contentView.layer.cornerRadius = 50
        contentView.clipsToBounds = true
        contentView.center.y = self.view.center.y - 80
        
        // name textField
        nameTextfield = UITextField(frame: CGRect(x: 0, y: getDividedSize(view: contentView) * 2, width: contentView.frame.width, height: getDividedSize(view: contentView)))
        nameTextfield.backgroundColor = UIColor.white
        
        if !adding!{nameTextfield.text = self.category.name}
        
        nameTextfield.placeholder = "Enter a name"
        nameTextfield.textAlignment = .center
        nameTextfield.addTarget(self, action: #selector(nameTextFieldChanged(_:)), for: .editingChanged)
        
        // color picker
        colorPicker = ColorPicker(frame: CGRect(x: 0, y: getDividedSize(view: contentView) * 4, width: contentView.frame.width, height: getDividedSize(view: contentView)), delegate: self, defaultColor: selectedColor)
        colorPicker.backgroundColor = UIColor.black
        
        // confirm button
        confirmButton = UIButton(frame: CGRect(x: 0, y: getDividedSize(view: contentView) *  5, width: contentView.frame.width / 2, height: getDividedSize(view: contentView)))
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.backgroundColor = UIColor(red: 0.0196078431372549, green: 0.462745098039216, blue: 1.0, alpha: 1.0)
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        
        // cancel button
        cancelButton = UIButton(frame: CGRect(x: confirmButton.frame.width, y: getDividedSize(view: contentView) * 5, width: contentView.frame.width / 2, height: getDividedSize(view: contentView)))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = UIColor(red: 0.0196078431372549, green: 0.462745098039216, blue: 1.0, alpha: 1.0)
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
     
        // add all subviews to contentView
        if adding!{  contentView.addSubview(makeLabel(y: 0, contentView: contentView, text: "Make new category", fontSize: 20))}else{contentView.addSubview(makeLabel(y: 0, contentView: contentView, text: "Edit category : ", fontSize: 20))}
      
        contentView.addSubview(makeLabel(y: getDividedSize(view: contentView), contentView: contentView, text: "Enter a name : ", fontSize: 17))
        contentView.addSubview(nameTextfield)
        contentView.addSubview(makeLabel(y: getDividedSize(view: contentView) * 3, contentView: contentView, text: "Select a color : ", fontSize: 17))
        contentView.addSubview(colorPicker)
        contentView.addSubview(confirmButton)
        contentView.addSubview(cancelButton)
     
     
        return contentView
    }
    
    // get height of element in contentView
    private func getDividedSize(view:UIView) -> CGFloat{
        return view.frame.height / 6
    }
    
    // detect if nameTextField name changed
    @objc func nameTextFieldChanged(_ sender:UITextField){
        self.nameText = sender.text
    }
    
    
  @objc func cancelAction(){
    delegate.didCancel()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @objc func confirmAction(){
        
       if adding!{
             addCategory(name: self.nameText, color: self.selectedColor)
        }else{
            delegate.didUpdate(id: self.category.id!)
            addCategoryByID(id: self.category.id!, name: self.nameText, color: self.selectedColor)
        }
         delegate.didConfirm()
        self.dismiss(animated: true, completion: nil)
    }
    

    private func makeLabel(y:CGFloat, contentView:UIView, text:String, fontSize:CGFloat) -> UILabel{
        let view = UILabel(frame: CGRect(x: 0, y: y, width: contentView.frame.width, height: getDividedSize(view: contentView)))
        view.textAlignment = .center
        view.font = view.font.withSize(fontSize)
        view.text = text
        view.textColor = UIColor.white
        view.backgroundColor = UIColor(red: 0.0196078431372549, green: 0.462745098039216, blue: 1.0, alpha: 1.0)
        return view
    }
    
    // ColorPickerDelegate method
    func setColor(color: UIColor) {
       self.selectedColor = color
    }
    
} // end of class

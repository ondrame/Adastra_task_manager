//
//  CreateCategoryDelegate.swift
//  Adastra_test
//
//  Created by Ondřej Měchura on 12.07.18.
//  Copyright © 2018 Ondřej Měchura. All rights reserved.
//


protocol CreateCategoryDelegate{
    func didCancel()
    func didConfirm()
    func didUpdate(id:String)
}

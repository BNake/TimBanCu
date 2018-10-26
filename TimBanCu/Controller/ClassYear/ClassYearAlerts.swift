//
//  ClassYearAlert.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/4/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit

class ClassYearAlerts{
    private weak var viewcontroller:ClassYearViewController!
    private var addNewClassCompletedAlert:InfoAlert!
    private var classAlreadyExistAlert:InfoAlert!
    private var classOrMajor:ClassAndMajorProtocol!
    
    init(viewcontroller:ClassYearViewController, classOrMajor:ClassAndMajorProtocol){
        self.viewcontroller = viewcontroller
        self.classOrMajor = classOrMajor
        setupAlerts()
    }
    
    func setupAlerts(){
        setupClassAlreadyExistAlert()
        setupAddNewClassCompleteAlert()
    }
    
    func showAddNewClassCompleteAlert(){
        addNewClassCompletedAlert.show(viewcontroller: viewcontroller)
    }
    func showAddNewClassCompleteAlertWithHandler(showAlertCompleteHandler: (()->Void)?){
        addNewClassCompletedAlert.show(viewcontroller: viewcontroller, showAlertCompleteHandler: showAlertCompleteHandler)
    }
    
    
    
    func showClassAlreadyExistAlert(){
        classAlreadyExistAlert.show(viewcontroller: viewcontroller)
    }
    
    func showAlert(title:String,message:String){
        let generalAlert = InfoAlert(title: title, message: message, alertType: .Error)
        generalAlert.show(viewcontroller: viewcontroller)
    }
    
    private func setupAddNewClassCompleteAlert(){
        var title:String!
        
        if(classOrMajor is Class){
            title = "Lớp của bạn đã được thêm!"
        }
        else{
            title = "Khoa của bạn đã được thêm!"
        }
        
        let message = "Bước Tiếp Theo: Thêm Bạn Vào Danh Sách"
        
        addNewClassCompletedAlert = InfoAlert(title: title, message: message, alertType: .Success)
    }
    private func setupClassAlreadyExistAlert(){
        var title:String!
        var message:String!
        
        if(classOrMajor is Class){
            title = "Lớp của bạn đã có trong danh sách!"
            message = "Vui Lòng Chọn Lớp Trong Danh Sách Chúng Tôi Hoặc Thêm Lớp Mới"
        }
        else{
            title = "Khoa của bạn đã có trong danh sách!"
            message = "Vui Lòng Chọn Khoa Trong Danh Sách Chúng Tôi Hoặc Thêm Khoa Mới"
        }
        classAlreadyExistAlert = InfoAlert(title: title, message: message, alertType: .AlreadyExist)
    }
    
}

//
//  SignInUIController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 8/28/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import Foundation
import UIKit
import RevealingSplashView
import FacebookCore
import FacebookLogin
import GoogleSignIn
import FBSDKLoginKit

final class SignInUIController {
    
    var state: UIState = .Loading {
        willSet(newState) {
            update(newState: newState)
        }
    }
    
    private weak var viewcontroller:SignInViewController!
    
    private var revealingSplashView: RevealingSplashView! = nil
    
    private var facebookBtn:LoginButton!
    private var googleBtn:GIDSignInButton!
    
    private var errorAlert:InfoAlert!
    private var appNameView: AnimateAppNameView!

    init(viewController: SignInViewController, facebookBtn:LoginButton, googleBtn:GIDSignInButton) {
        
        self.viewcontroller = viewController
        self.facebookBtn = facebookBtn
        self.googleBtn = googleBtn
        
        setupInitialLoadingScreen()
        setupFacebookBtn()
        setupGoogleButton()
        
        errorAlert = InfoAlert(title: "Đăng Nhập Không Thành Công", message: "", alertType: .Error)
    }
    
    func viewWillAppear(){
        self.appNameView = AnimateAppNameView(viewController: viewcontroller)
        self.appNameView.animate()
        viewcontroller.view.bringSubview(toFront: appNameView)
        
    }
    
    func viewDidDisappear() {
        appNameView.remove()
    }

    private func update(newState: UIState) {
        switch(state, newState) {
            
        case (.Loading, .Success( _ )),(.Failure, .Success),(.Success( _ ), .Success( _ )): goToNextScreen()
        case (.Loading, .Failure(let errorStr)),
             (.Failure(_),.Failure(let errorStr)),
             (.Success(_),.Failure(let errorStr))
             : createErrorAlert(errorStr: errorStr)
        // after login silently failed, aka, when the user is not log in google account
            
        default: fatalError("Not yet implemented \(state) to \(newState)")
        }
    }
    
    private func createErrorAlert(errorStr:String){
        errorAlert.changeMessage(message: errorStr)
        errorAlert.show(viewcontroller: viewcontroller)
    }
    
    private func goToNextScreen(){
        if(FirstTimeLaunch.getBool()){
            FirstTimeLaunch.setFalse()
            viewcontroller.performSegue(withIdentifier: "SignInToEULASegue", sender: viewcontroller)
        }
        else{
            viewcontroller.performSegue(withIdentifier: "SignInToSelectSchoolTypeSegue", sender: self)
        }
    }
}

// MARK: Initialize

extension SignInUIController{
    
    
    private func setupInitialLoadingScreen() {
        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Logo")!, iconInitialSize: CGSize(width: 140, height: 140), backgroundColor: UIColor(red:255/255, green:158/255, blue: 0, alpha:1.0))
        viewcontroller.view.addSubview(revealingSplashView!)
        revealingSplashView?.animationType = SplashAnimationType.popAndZoomOut
        revealingSplashView?.startAnimation()
    }
    
    private func setupFacebookBtn(){
        viewcontroller.view.addSubview(facebookBtn)
        viewcontroller.view.sendSubview(toBack: facebookBtn)
        
        facebookBtn.translatesAutoresizingMaskIntoConstraints = false
        facebookBtn.bottomAnchor.constraint(equalTo: googleBtn.topAnchor, constant: -10).isActive = true
        facebookBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        facebookBtn.leftAnchor.constraint(equalTo: viewcontroller.view.leftAnchor, constant: 40).isActive = true
        facebookBtn.rightAnchor.constraint(equalTo: viewcontroller.view.rightAnchor, constant: -40).isActive = true
    }
    
    private func setupGoogleButton(){
        googleBtn.style = GIDSignInButtonStyle.wide
    }
}

//
//  AddYourInfoViewController.swift
//  TimBanCu
//
//  Created by Duy Le 2 on 7/17/18.
//  Copyright © 2018 Duy Le 2. All rights reserved.
//

import UIKit
import DropDown
import FirebaseDatabase
import ImageSlideshow
import FirebaseStorage
import DKImagePickerController

class AddYourInfoViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var birthYearTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phonePrivacyDropDownBtn: UIButton!
    @IBOutlet weak var emailPrivacyDropDownBtn: UIButton!
    @IBOutlet weak var imageSlideShow: Slideshow!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var addInfoBtn: UIButton!
    
    @IBOutlet weak var addInfoButtonBottomContraint: NSLayoutConstraint!
    @IBAction func unwindToAddYourInfoController(segue:UIStoryboardSegue) { }
    
    
    private var controller:AddYourInfoController!
    private var uiController:AddYourInfoUIController!
    
    private var slideshowDidTapOnImageAtIndex:IndexOfImageClosure!
    private var imagePickerDidSelectAssets:ImageAssetSelectionClosure!
    
    // from previous class
    var classProtocol:ClassProtocol!
    
    // this class
    var userImages = [Image]()
    var imageForSegue:Image!
    var keyboardIsShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupClosures()
    
        controller = AddYourInfoController(viewcontroller: self)
        uiController = AddYourInfoUIController(viewcontroller: self, slideshowDidTapOnImageAtIndex: slideshowDidTapOnImageAtIndex, imagePickerDidSelectAssets: imagePickerDidSelectAssets)
    }
    
    private func setupClosures(){
        slideshowDidTapOnImageAtIndex = { (tappedImageIndex) in
            // user tapped on add new image button
            if(tappedImageIndex > self.userImages.count-1){
                self.uiController.showPickerController()
            }
            else{
                let image = self.userImages[tappedImageIndex]
                
                if(image.year == nil){
                    self.imageForSegue = image
                    self.performSegue(withIdentifier: "AddYourInfoToUpdateYearSegue", sender: self)
                }
                else{
                    self.performSegue(withIdentifier: "AddYourInfoToImageDetail", sender: self)
                }
            }
        }
        
        imagePickerDidSelectAssets = { (assets: [DKAsset]) in
            var fetchCount = 0
            let currentTime = Int(Date().timeIntervalSince1970.binade)
            
            if(assets.count == 0){
                self.uiController.hidePickerController()
            }
            
            for asset in assets{
                if(asset.fileName == nil){
                    asset.fetchOriginalImage(completeBlock: { (uiimage, something) in
                        
                        let imageName = "\((currentTime + fetchCount))"
                        asset.fileName = imageName
                        
                        let image = Image(image: uiimage!, imageName: imageName, uid:CurrentUser.getUid())
                        
                        self.userImages.append(image)
                        
                        fetchCount = fetchCount + 1
                        
                        if(fetchCount == assets.count){
                            self.uiController.hidePickerController()
                            self.uiController.reloadSlideShow()
                        }
                    })
                }
                else{
                    fetchCount = fetchCount + 1
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        uiController.viewDidLayoutSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiController.reloadSlideShow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        uiController.animateSlideShow()
    }
    
    @IBAction func phoneDropDownBtnPressed(_ sender: Any) {
        uiController.showPhonePrivacyDownDown()
    }
    
    @IBAction func emailDropDownBtnPressed(_ sender: Any) {
        uiController.showEmailPrivacyDownDown()
    }
    
    
    @IBAction func addInfoBtnPressed(_ sender: Any) {
        if(userImages.count == 0){
            uiController.showNoProfileImageAlert()
        }
        else{            
            controller.updateUserInfo(images: userImages, completeUploadClosure: {uiState in
                
                switch(uiState){
                case .Success():
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "AddYourInfoToClassDetailSegue", sender: self)
                    }
                    break
                case .Failure(let errMsg):
                    self.uiController.showUploadErrorAlert(errMsg: errMsg)
                default:
                    break
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    @IBAction func showPrivacyAlertBtnPressed(_ sender: Any) {
        uiController.showPrivacyAlert()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserImageViewController{
            destination.image = userImages[imageSlideShow.currentPage]
            destination.userImages = userImages
        }
        if let destination = segue.destination as? AddImagesViewController{
            destination.currentImages = userImages
        }
        if let destination = segue.destination as? UpdateImageYearViewController{
            destination.selectedImage = imageForSegue
        }

    }
}





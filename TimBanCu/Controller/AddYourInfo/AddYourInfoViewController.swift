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

class AddYourInfoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var birthYearTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phonePrivacyDropDownBtn: UIButton!
    @IBOutlet weak var emailPrivacyDropDownBtn: UIButton!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var yearLabel: UILabel!
    @IBAction func unwindToAddYourInfoController(segue:UIStoryboardSegue) { }
    
    let selectPhotoButton = SelectPhotoButton()
    
    var phonePrivacyDropDown = DropDown()
    var emailPrivacyDropDown = DropDown()
    
    var userImages = [UIImage]()
    var yearOfUserImage = [UIImage:Int]()
    var selectedImage:UIImage!
    
    var addImageYearAlert:UIAlertController!
    var privacyAlert:UIAlertController!
    
    let privateUserProfileRef = Database.database().reference().child("privateUserProfile")
    let publicUserProfileRef = Database.database().reference().child("publicUserProfile")
    
    // from previous class
    var classDetail:ClassDetail!
    
    var keyboardIsShowing = false

    @IBOutlet weak var addInfoButtonBottomContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPrivacyDropDowns()
        setupAlerts()
        setupImageSlideShow()
        setUpSelectPhotoButton()
        reloadImageSlideShow()
        observeKeyboardNotifications()
        
        fullNameTF.delegate = self
        phoneTF.delegate = self
        emailTF.delegate = self
        birthYearTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateImageSlideShow(count: 0)
        
        if(userImages.count == 0){
            userImages.append(#imageLiteral(resourceName: "addImage"))
            imageSlideShow.backgroundColor = themeColor
        }
        
        if(userImages.count>1){
           reloadYearLabel(page: imageSlideShow.currentPage)
        }
        reloadImageSlideShow()
        
        imageSlideShow.currentPageChanged = { page in
            
            if(page == self.userImages.count-1){
                self.yearLabel.isHidden = true
            }
            else{
                self.yearLabel.isHidden = false
            }
        }
    }
    
    @IBAction func phoneDropDownBtnPressed(_ sender: Any) {
        phonePrivacyDropDown.show()
    }
    
    @IBAction func emailDropDownBtnPressed(_ sender: Any) {
        emailPrivacyDropDown.show()
    }
    
    @IBAction func addInfoBtnPressed(_ sender: Any) {

        var filenames = [UIImage:String]()
        let time = Date().timeIntervalSince1970.binade
        
        removeThePlusIconPictureThatIsUsedToAddNewPicture()
        
        for x in 0...(self.userImages.count-1){
            let str = "\(String(Int(time)+x))"
            filenames[userImages[x]] = str
        }
        
        uploadPublicData(imageFileNames: filenames)
        uploadPrivateData()
        
        updateCurrentStudentInfo()
        
        uploadUserInfoToSelectedClass()
        
        uploadUserImages(imageFileNames: filenames, completionHandler: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "AddYourInfoToClassDetailSegue", sender: self)
            }
        })
    }
    
    func removeThePlusIconPictureThatIsUsedToAddNewPicture(){
        userImages.removeLast()
    }
    
    func updateCurrentStudentInfo(){
        let student = Student(fullname: self.fullNameTF.text!, birthYear: self.birthYearTF.text!, phoneNumber: self.phoneTF.text!, email: self.emailTF.text!, uid: CurrentUserHelper.getUid())
        CurrentUserHelper.setStudent(student: student)
    }
    
    func uploadUserInfoToSelectedClass(){
         Database.database().reference().child(classDetail.getFirebasePathWithSchoolYear()).child(CurrentUserHelper.getUid()).setValue(CurrentUserHelper.getFullname())
    }
    
    func uploadPublicData(imageFileNames:[UIImage:String]){
        var publicDic = [String:Any]()
        
        if(phonePrivacyDropDownBtn.currentTitle == "Công Khai"){
            publicDic["phoneNumber"] = phoneTF.text
        }
        
        if(emailPrivacyDropDownBtn.currentTitle == "Công Khai"){
            publicDic["email"] = emailTF.text
        }
        
        publicDic["birthYear"] = birthYearTF.text
        publicDic["fullName"] = fullNameTF.text
        
        var dic = [String:Int]()
        
        for image in userImages{
            if(yearOfUserImage[image] == nil){
                dic[imageFileNames[image]!] = -1
            }
            else{
                 dic[imageFileNames[image]!] = yearOfUserImage[image]
            }
        }
        
        publicDic["images"] = dic
        
        publicUserProfileRef.child(CurrentUserHelper.getUid()).setValue(publicDic)
    }
    
    func uploadPrivateData(){
        var privateDic = [String:Any]()
        
        if(phonePrivacyDropDownBtn.currentTitle == "Chỉ Riêng Tôi"){
            privateDic["phoneNumber"] = phoneTF.text
        }
        
        if(emailPrivacyDropDownBtn.currentTitle == "Chỉ Riêng Tôi"){
            privateDic["email"] = emailTF.text
        }
        
        privateUserProfileRef.child(CurrentUserHelper.getUid()).setValue(privateDic)
    }
    
    func uploadUserImages(imageFileNames:[UIImage:String], completionHandler: @escaping () -> Void){
        
        let storage = Storage.storage()
        
        var imageUploaded = 0
        
  
        
        for image in userImages{
            let name = imageFileNames[image]
            let imageRef = storage.reference().child("users").child("\(CurrentUserHelper.getUid())/\(name!)")
            
            let data = image.jpeg(UIImage.JPEGQuality(rawValue: 0.5)!)
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print()
                    return
                }
                imageUploaded = imageUploaded + 1
                
                if(imageUploaded == imageFileNames.count){
                    completionHandler()
                }
            }
        }
    }
    
    @IBAction func showPrivacyAlertBtnPressed(_ sender: Any) {
        present(privacyAlert, animated: true, completion: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddInfoImageDetailViewController{
            destination.indexForDeletion = imageSlideShow.currentPage
            destination.userImages = userImages
            destination.yearOfUserImage = yearOfUserImage
        }
        if let destination = segue.destination as? AddImagesViewController{
            destination.currentImages = userImages
        }

    }
}


